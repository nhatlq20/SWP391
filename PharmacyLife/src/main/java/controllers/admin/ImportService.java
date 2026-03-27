package controllers.admin;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.ImportDAO;
import dao.MedicineDAO;
import dao.MedicineUnitDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import models.Import;
import models.ImportDetail;

/**
 * Service class for handling Business Logic related to Pharmacy Imports.
 * This class takes the logic weight off the AdminImportController.
 */
public class ImportService {

    private final ImportDAO importDAO;
    private final MedicineDAO medicineDAO;
    private final MedicineUnitDAO medicineUnitDAO;

    public ImportService() {
        this.importDAO = new ImportDAO();
        this.medicineDAO = new MedicineDAO();
        this.medicineUnitDAO = new MedicineUnitDAO();
    }

    /**
     * Logic to create a new Pharmacy Import with multiple medicine details.
     */
    public boolean processCreateImport(HttpServletRequest request) throws Exception {
        Import imp = new Import();

        // 1. Resolve Supplier
        String supplierInput = request.getParameter("supplierId");
        int supplierId = parseOrLookupSupplierId(supplierInput);
        if (supplierId == 0) {
            request.setAttribute("error", "Không tìm thấy nhà cung cấp: " + supplierInput);
            return false;
        }
        imp.setSupplierId(supplierId);
        imp.setImportDate(parseDate(request.getParameter("importDate")));

        // 2. Resolve Staff
        HttpSession session = request.getSession();
        int staffId = getStaffIdFromSessionOrRequest(session, request.getParameter("importerId"));
        if (staffId == 0) {
            request.setAttribute("error", "Vui lòng nhập thông tin người nhập hợp lệ");
            return false;
        }
        imp.setStaffId(staffId);
        imp.setTotalAmount(0);
        imp.setImportCode("TEMP" + System.currentTimeMillis() % 100000);

        String status = request.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "Đang chờ";
        }
        imp.setStatus(status);

        // 3. Create Import Header
        if (importDAO.createImport(imp)) {
            int newImportId = imp.getImportId();
            int itemsAdded = 0;
            StringBuilder detailErrors = new StringBuilder();

            Map<Integer, Map<String, String>> medicinesMap = parseMedicinesFromRequest(request, "medicines[");

            for (Map<String, String> medicineData : medicinesMap.values()) {
                if (processSingleImportDetail(newImportId, medicineData, detailErrors)) {
                    itemsAdded++;
                }
            }

            if (itemsAdded == 0) {
                importDAO.deleteImport(newImportId);
                request.setAttribute("error", "Lưu thất bại: " + (detailErrors.length() > 0 ? detailErrors.toString()
                        : "Vui lòng thêm ít nhất 1 loại thuốc hợp lệ"));
                return false;
            }

            // 4. Update total and sync stock if approved
            double total = importDAO.calculateTotalAmount(newImportId);
            imp.setTotalAmount(total);
            importDAO.updateImport(imp);

            if ("Đã duyệt".equals(status)) {
                syncStockForImport(newImportId);
            }

            if (detailErrors.length() > 0) {
                session.setAttribute("message",
                        "Phiếu nhập đã được tạo nhưng có một số mục lỗi: " + detailErrors.toString());
            }
            return true;
        }
        return false;
    }

    /**
     * Logic to update an existing Pharmacy Import and its details.
     */
    public boolean processUpdateImport(HttpServletRequest request) throws Exception {
        int importId = parseId(request.getParameter("id"));
        if (importId == 0)
            importId = parseId(request.getParameter("importId"));

        if (importId == 0)
            return false;

        Import imp = importDAO.getImportById(importId);
        if (imp == null) {
            request.setAttribute("error", "Không tìm thấy phiếu nhập");
            return false;
        }

        String oldStatus = imp.getStatus();

        // 1. Update basic info
        imp.setSupplierId(parseOrLookupSupplierId(request.getParameter("supplierId")));
        imp.setStaffId(parseStaffId(request.getParameter("importerId")));
        imp.setImportDate(parseDate(request.getParameter("importDate")));

        String newStatus = request.getParameter("status");
        if (newStatus != null && !newStatus.isEmpty()) {
            imp.setStatus(newStatus);
        }

        // 2. Process existing details update & new details addition
        Map<Integer, Map<String, String>> existingDetailsMap = parseMedicinesFromRequest(request, "existingDetails[");
        Map<Integer, Map<String, String>> newMedicinesMap = parseMedicinesFromRequest(request, "newMedicines[");

        updateExistingDetails(importId, oldStatus, existingDetailsMap);

        StringBuilder detailErrors = new StringBuilder();
        for (Map<String, String> medicineData : newMedicinesMap.values()) {
            processSingleImportDetail(importId, medicineData, detailErrors);
        }

        // 3. Recalculate and Save
        double total = importDAO.calculateTotalAmount(importId);
        imp.setTotalAmount(total);

        if (importDAO.updateImport(imp)) {
            handleStatusChangeStockSync(importId, oldStatus, imp.getStatus());
            return true;
        }
        return false;
    }

    // --- Private Helper Methods (Extracted Logic) ---

    private boolean processSingleImportDetail(int importId, Map<String, String> medicineData, StringBuilder errors) {
        try {
            int medicineId = parseId(medicineData.get("medicineId"));
            int unitId = parseId(medicineData.getOrDefault("unitId", "0"));
            int quantity = (int) Double.parseDouble(medicineData.getOrDefault("quantity", "0"));
            double price = Double.parseDouble(medicineData.getOrDefault("price", "0"));

            if (medicineId <= 0 || quantity <= 0 || price <= 0)
                return false;

            int medicineUnitId = medicineUnitDAO.getMedicineUnitId(medicineId, unitId);
            if (medicineUnitId <= 0) {
                models.MedicineUnit bu = medicineUnitDAO.getBaseUnit(medicineId);
                if (bu != null)
                    medicineUnitId = bu.getMedicineUnitId();
            }

            if (medicineUnitId > 0) {
                ImportDetail detail = new ImportDetail(importId, medicineUnitId, quantity, price);
                return importDAO.addImportDetail(detail);
            }
        } catch (Exception e) {
            errors.append("Lỗi xử lý mục thuốc. ");
        }
        return false;
    }

    private void updateExistingDetails(int importId, String oldStatus, Map<Integer, Map<String, String>> existingMap) {
        List<ImportDetail> currentDetails = importDAO.getImportDetails(importId);
        for (Map.Entry<Integer, Map<String, String>> entry : existingMap.entrySet()) {
            int detailId = entry.getKey();
            Map<String, String> data = entry.getValue();
            try {
                int newQty = (int) Double.parseDouble(data.get("quantity"));
                double newPrice = Double.parseDouble(data.get("price"));

                for (ImportDetail oldDetail : currentDetails) {
                    if (oldDetail.getDetailId() == detailId) {
                        if (oldDetail.getQuantity() != newQty || oldDetail.getUnitPrice() != newPrice) {
                            if ("Đã duyệt".equals(oldStatus)) {
                                int diff = newQty - oldDetail.getQuantity();
                                if (diff != 0)
                                    applyStockChange(oldDetail.getMedicineUnitId(), diff, 0, false);
                                if (Math.abs(newPrice - oldDetail.getUnitPrice()) > 0.0001)
                                    applyStockChange(oldDetail.getMedicineUnitId(), 0, newPrice, true);
                            }
                            oldDetail.setQuantity(newQty);
                            oldDetail.setUnitPrice(newPrice);
                            importDAO.updateImportDetail(oldDetail);
                        }
                        break;
                    }
                }
            } catch (Exception ignored) {
            }
        }
    }

    private void handleStatusChangeStockSync(int importId, String oldStatus, String newStatus) {
        if (!"Đã duyệt".equals(oldStatus) && "Đã duyệt".equals(newStatus)) {
            syncStockForImport(importId);
        } else if ("Đã duyệt".equals(oldStatus) && !"Đã duyệt".equals(newStatus)) {
            List<ImportDetail> details = importDAO.getImportDetails(importId);
            for (ImportDetail d : details) {
                applyStockChange(d.getMedicineUnitId(), -d.getQuantity(), 0, false);
            }
        }
    }

    private void syncStockForImport(int importId) {
        List<ImportDetail> details = importDAO.getImportDetails(importId);
        if (details != null) {
            for (ImportDetail d : details) {
                applyStockChange(d.getMedicineUnitId(), d.getQuantity(), d.getUnitPrice(), true);
            }
        }
    }

    public void applyStockChange(int medicineUnitId, int quantity, double pricePerUnit, boolean isSetPrice) {
        models.MedicineUnit mu = medicineUnitDAO.getUnitById(medicineUnitId);
        if (mu == null)
            return;

        int medicineId = mu.getMedicineId();
        int convertedQty = quantity * mu.getConversionRate();
        models.MedicineUnit baseUnit = medicineUnitDAO.getBaseUnit(medicineId);
        int baseUnitId = (baseUnit != null) ? baseUnit.getUnitId() : 0;

        if (isSetPrice) {
            medicineDAO.addQuantityAndSetOriginalPrice(medicineId, baseUnitId, convertedQty, pricePerUnit);
        } else {
            medicineDAO.updateStockQuantity(medicineId, baseUnitId, convertedQty);
        }
    }

    private Map<Integer, Map<String, String>> parseMedicinesFromRequest(HttpServletRequest request, String prefix) {
        Map<Integer, Map<String, String>> result = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (name.startsWith(prefix)) {
                int start = name.indexOf('[') + 1;
                int end = name.indexOf(']');
                try {
                    int index = Integer.parseInt(name.substring(start, end));
                    String field = name.substring(end + 2);
                    result.putIfAbsent(index, new HashMap<>());
                    result.get(index).put(field, request.getParameter(name));
                } catch (Exception ignored) {
                }
            }
        }
        return result;
    }

    private int getStaffIdFromSessionOrRequest(HttpSession session, String requestImporterId) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj != null) {
            try {
                return Integer.parseInt(userIdObj.toString());
            } catch (Exception ignored) {
            }
        }
        return parseStaffId(requestImporterId);
    }

    private int parseOrLookupSupplierId(String input) {
        int id = parseId(input);
        return id > 0 ? id : importDAO.getSupplierIdByName(input);
    }

    private int parseStaffId(String input) {
        int id = parseId(input);
        return id > 0 ? id : importDAO.getStaffIdByCode(input);
    }

    private int parseId(String input) {
        if (input == null || input.isEmpty())
            return 0;
        try {
            return Integer.parseInt(input);
        } catch (Exception e) {
            return 0;
        }
    }

    private Date parseDate(String dateStr) throws ParseException {
        if (dateStr == null || dateStr.isEmpty())
            return new Date(System.currentTimeMillis());
        return new Date(new SimpleDateFormat("yyyy-MM-dd").parse(dateStr).getTime());
    }
}

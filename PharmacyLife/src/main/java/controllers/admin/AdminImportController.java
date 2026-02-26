package controllers.admin;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.ImportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Import;
import models.ImportDetail;
import models.Medicine;

public class AdminImportController extends HttpServlet {

    private ImportDAO importDAO;

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String roleName = (session != null) ? (String) session.getAttribute("roleName") : null;
        return roleName != null && roleName.equalsIgnoreCase("admin");
    }

    private String getImportView(String name, HttpServletRequest request) {
        // name: list, view, create, edit, details
        switch (name) {
            case "list":
                return "/view/admin/import-list-for-dashboard.jsp";
            case "view":
                return "/view/admin/import-view-for-dashboard.jsp";
            case "create":
                return "/view/admin/import-create-for-dashboard.jsp";
            case "edit":
                return "/view/admin/import-edit-for-dashboard.jsp";
            case "details":
                return "/view/admin/import-details-for-dashboard.jsp";
            default:
                return "/view/admin/import-list-for-dashboard.jsp";
        }
    }

    @Override
    public void init() throws ServletException {
        importDAO = new ImportDAO();
    }

    // Kiểm tra quyền admin
    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String roleName = (session != null) ? (String) session.getAttribute("roleName") : null;

        if (roleName == null || !roleName.equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminPermission(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listImports(request, response);
                    break;
                case "view":
                    viewImport(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteImport(request, response);
                    break;
                case "details":
                    getImportDetails(request, response);
                    break;
                default:
                    listImports(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher(getImportView("list", request)).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminPermission(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create":
                    createImport(request, response);
                    break;
                case "update":
                    updateImport(request, response);
                    break;
                case "addDetail":
                    addImportDetail(request, response);
                    break;
                case "deleteDetail":
                    deleteImportDetail(request, response);
                    break;
                case "search":
                    searchImports(request, response);
                    break;
                default:
                    listImports(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher(getImportView("list", request)).forward(request, response);
        }
    }

    // Hiển thị danh sách phiếu nhập
    private void listImports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Import> imports = importDAO.getAllImports();
        request.setAttribute("imports", imports);
        request.getRequestDispatcher(getImportView("list", request)).forward(request, response);
    }

    // Tìm kiếm phiếu nhập
    private void searchImports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Import> imports;

        if (keyword != null && !keyword.trim().isEmpty()) {
            imports = importDAO.searchImports(keyword);
        } else {
            imports = importDAO.getAllImports();
        }

        request.setAttribute("imports", imports);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher(getImportView("list", request)).forward(request, response);
    }

    // Xem chi tiết phiếu nhập
    private void viewImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int importId = getImportIdFromRequest(request);

        if (importId > 0) {
            Import imp = importDAO.getImportById(importId);
            if (imp == null) {
                request.setAttribute("error", "Không tìm thấy phiếu nhập");
                listImports(request, response);
                return;
            }

            List<ImportDetail> details = importDAO.getImportDetails(importId);
            request.setAttribute("importRecord", imp);
            request.setAttribute("details", details);
            request.getRequestDispatcher(getImportView("view", request)).forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã phiếu nhập không hợp lệ");
        }
    }

    // Hiển thị form tạo mới
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newCode = importDAO.generateImportCode();
        request.setAttribute("newCode", newCode);

        List<Medicine> medicines = importDAO.getAllMedicines();
        request.setAttribute("medicines", medicines);

        List<Object[]> suppliers = importDAO.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);

        request.getRequestDispatcher(getImportView("create", request)).forward(request, response);
    }

    // Hiển thị form chỉnh sửa
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int importId = getImportIdFromRequest(request);

        if (importId > 0) {
            Import imp = importDAO.getImportById(importId);
            if (imp == null) {
                request.setAttribute("error", "Không tìm thấy phiếu nhập");
                listImports(request, response);
                return;
            }

            List<ImportDetail> details = importDAO.getImportDetails(importId);
            request.setAttribute("importRecord", imp);
            request.setAttribute("details", details);

            List<Medicine> medicines = importDAO.getAllMedicines();
            request.setAttribute("medicines", medicines);

            List<Object[]> suppliers = importDAO.getAllSuppliers();
            request.setAttribute("suppliers", suppliers);

            request.getRequestDispatcher(getImportView("edit", request)).forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã phiếu nhập không hợp lệ");
        }
    }

    // Tạo phiếu nhập mới
    private void createImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Import imp = new Import();

            // Resolve Supplier
            String supplierInput = request.getParameter("supplierId");
            int supplierId = parseOrLookupSupplierId(supplierInput);
            if (supplierId == 0) {
                request.setAttribute("error", "Không tìm thấy nhà cung cấp: " + supplierInput);
                showCreateForm(request, response);
                return;
            }
            imp.setSupplierId(supplierId);

            imp.setImportDate(parseDate(request.getParameter("importDate")));

            // Resolve Staff
            HttpSession session = request.getSession();
            Object userIdObj = session.getAttribute("userId");
            int staffId = 0;

            if (userIdObj != null) {
                try {
                    staffId = Integer.parseInt(userIdObj.toString());
                } catch (NumberFormatException e) {
                }
            }
            if (staffId == 0) {
                staffId = parseStaffId(request.getParameter("importerId"));
            }

            if (staffId == 0) {
                request.setAttribute("error", "Vui lòng nhập thông tin người nhập hợp lệ (Mã hoặc ID)");
                showCreateForm(request, response);
                return;
            }
            imp.setStaffId(staffId);
            imp.setTotalAmount(0);

            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "Đang chờ";
            }
            imp.setStatus(status);

            if (importDAO.createImport(imp)) {
                int newImportId = imp.getImportId();

                Map<Integer, Map<String, String>> medicinesMap = new HashMap<>();
                Enumeration<String> paramNames = request.getParameterNames();

                while (paramNames.hasMoreElements()) {
                    String paramName = paramNames.nextElement();
                    if (paramName.startsWith("medicines[")) {
                        int startIdx = paramName.indexOf('[') + 1;
                        int endIdx = paramName.indexOf(']');
                        if (startIdx > 0 && endIdx > startIdx) {
                            try {
                                int index = Integer.parseInt(paramName.substring(startIdx, endIdx));
                                String fieldName = paramName.substring(endIdx + 2);
                                String value = request.getParameter(paramName);

                                medicinesMap.putIfAbsent(index, new HashMap<>());
                                medicinesMap.get(index).put(fieldName, value);
                            } catch (NumberFormatException e) {
                            }
                        }
                    }
                }

                // Check if medicines list is empty
                if (medicinesMap.isEmpty()) {
                    importDAO.deleteImport(newImportId);
                    request.setAttribute("error", "Vui lòng thêm ít nhất 1 loại thuốc vào phiếu nhập");
                    showCreateForm(request, response);
                    return;
                }

                for (Map<String, String> medicineData : medicinesMap.values()) {
                    String medicineIdStr = medicineData.get("medicineId");
                    String quantityStr = medicineData.get("quantity");
                    String priceStr = medicineData.get("price");

                    if (medicineIdStr != null && quantityStr != null && priceStr != null) {
                        try {
                            int medicineId = Integer.parseInt(medicineIdStr);
                            int quantity = Integer.parseInt(quantityStr);
                            double price = Double.parseDouble(priceStr);

                            if (quantity <= 0) {
                                request.setAttribute("error", "Quantity must be greater than 0.");
                                showCreateForm(request, response);
                                return;
                            } else if (quantity > 1000) {
                                request.setAttribute("error", "Quantity cannot exceed 1000 units per import item.");
                                showCreateForm(request, response);
                                return;
                            }

                            if (medicineId > 0) {
                                ImportDetail detail = new ImportDetail(newImportId, medicineId, quantity, price);
                                detail.recalculateTotal();
                                importDAO.addImportDetail(detail);
                            }
                        } catch (NumberFormatException e) {
                        }
                    }
                }

                double total = importDAO.calculateTotalAmount(newImportId);
                if (total > 0) {
                    imp.setTotalAmount(total);
                    importDAO.updateImport(imp);
                }

                response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + newImportId);
            } else {
                request.setAttribute("error", "Không thể tạo phiếu nhập");
                showCreateForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tạo phiếu nhập: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    // Cập nhật phiếu nhập
    private void updateImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int importId = getImportIdFromRequest(request);
            if (importId == 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing Import ID");
                return;
            }

            Import imp = importDAO.getImportById(importId);
            if (imp == null) {
                request.setAttribute("error", "Không tìm thấy phiếu nhập");
                listImports(request, response);
                return;
            }

            String supplierInput = request.getParameter("supplierId");
            int supplierId = parseOrLookupSupplierId(supplierInput);
            if (supplierId > 0) {
                imp.setSupplierId(supplierId);
            }

            String importerInput = request.getParameter("importerId");
            int staffId = parseStaffId(importerInput);
            if (staffId > 0) {
                imp.setStaffId(staffId);
            }

            imp.setImportDate(parseDate(request.getParameter("importDate")));

            String status = request.getParameter("status");
            if (status != null && !status.isEmpty()) {
                imp.setStatus(status);
            }

            Map<Integer, Map<String, String>> newMedicinesMap = new HashMap<>();
            Enumeration<String> paramNames = request.getParameterNames();

            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("newMedicines[")) {
                    int startIdx = paramName.indexOf('[') + 1;
                    int endIdx = paramName.indexOf(']');
                    if (startIdx > 0 && endIdx > startIdx) {
                        try {
                            int index = Integer.parseInt(paramName.substring(startIdx, endIdx));
                            String fieldName = paramName.substring(endIdx + 2);
                            String value = request.getParameter(paramName);

                            newMedicinesMap.putIfAbsent(index, new HashMap<>());
                            newMedicinesMap.get(index).put(fieldName, value);
                        } catch (NumberFormatException e) {
                        }
                    }
                }
            }

            for (Map<String, String> medicineData : newMedicinesMap.values()) {
                String medicineIdStr = medicineData.get("medicineId");
                String quantityStr = medicineData.get("quantity");
                String priceStr = medicineData.get("price");

                if (medicineIdStr != null && quantityStr != null && priceStr != null) {
                    try {
                        int medicineId = Integer.parseInt(medicineIdStr);
                        int quantity = Integer.parseInt(quantityStr);
                        double price = Double.parseDouble(priceStr);

                        if (quantity <= 0) {
                            request.setAttribute("error", "Quantity must be greater than 0.");
                            showEditForm(request, response);
                            return;
                        } else if (quantity > 1000) {
                            request.setAttribute("error", "Quantity cannot exceed 1000 units per import item.");
                            showEditForm(request, response);
                            return;
                        }

                        if (medicineId > 0) {
                            ImportDetail detail = new ImportDetail(importId, medicineId, quantity, price);
                            detail.recalculateTotal();
                            importDAO.addImportDetail(detail);
                        }
                    } catch (NumberFormatException e) {
                    }
                }
            }

            double total = importDAO.calculateTotalAmount(importId);
            imp.setTotalAmount(total);

            // Check if the import has at least 1 medicine
            List<ImportDetail> updatedDetails = importDAO.getImportDetails(importId);
            if (updatedDetails == null || updatedDetails.isEmpty()) {
                request.setAttribute("error", "Phiếu nhập phải có ít nhất 1 loại thuốc");
                request.setAttribute("importRecord", imp);
                request.setAttribute("details", updatedDetails);
                List<Medicine> medicines = importDAO.getAllMedicines();
                request.setAttribute("medicines", medicines);
                List<Object[]> suppliers = importDAO.getAllSuppliers();
                request.setAttribute("suppliers", suppliers);
                request.getRequestDispatcher(getImportView("edit", request)).forward(request, response);
                return;
            }

            if (importDAO.updateImport(imp)) {
                response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
            } else {
                request.setAttribute("error", "Không thể cập nhật phiếu nhập");
                request.setAttribute("importRecord", imp);
                request.setAttribute("details", updatedDetails);
                request.getRequestDispatcher(getImportView("edit", request)).forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật: " + e.getMessage());
            listImports(request, response);
        }
    }

    // Xóa phiếu nhập
    private void deleteImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int importId = getImportIdFromRequest(request);
        if (importId > 0 && importDAO.deleteImport(importId)) {
            response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
        } else {
            request.setAttribute("error", "Không thể xóa phiếu nhập");
            listImports(request, response);
        }
    }

    // Thêm chi tiết thuốc
    private void addImportDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int importId = getImportIdFromRequest(request);
            if (importId == 0) {
                response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
                return;
            }

            String medInput = request.getParameter("medicineCode");
            int medicineId = parseOrLookupMedicineId(medInput);

            if (medicineId == 0) {
                request.setAttribute("error", "Mã thuốc không hợp lệ: " + medInput);
                response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + importId);
                return;
            }

            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));

            ImportDetail detail = new ImportDetail(importId, medicineId, quantity, price);
            detail.recalculateTotal();

            if (importDAO.addImportDetail(detail)) {
                Import imp = importDAO.getImportById(importId);
                double total = importDAO.calculateTotalAmount(importId);
                imp.setTotalAmount(total);
                importDAO.updateImport(imp);
            }
            response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + importId);

        } catch (Exception e) {
            e.printStackTrace();
            int importId = getImportIdFromRequest(request);
            if (importId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + importId);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
            }
        }
    }

    // Xóa chi tiết thuốc
    private void deleteImportDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            int importId = getImportIdFromRequest(request);

            if (importId > 0) {
                // Check if this is the last detail
                List<ImportDetail> details = importDAO.getImportDetails(importId);
                if (details != null && details.size() <= 1) {
                    // Cannot delete if it's the last item
                    request.setAttribute("error", "Phiếu nhập phải có ít nhất 1 loại thuốc. Không thể xóa chi tiết cuối cùng.");
                    showEditForm(request, response);
                    return;
                } else if (details == null) {
                    // DAO error
                    request.setAttribute("error", "Lỗi khi lấy danh sách thuốc");
                    showEditForm(request, response);
                    return;
                }
            }

            if (importDAO.deleteImportDetail(detailId)) {
                if (importId > 0) {
                    Import imp = importDAO.getImportById(importId);
                    double total = importDAO.calculateTotalAmount(importId);
                    imp.setTotalAmount(total);
                    importDAO.updateImport(imp);
                    response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + importId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
                }
            } else {
                if (importId > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + importId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
        }
    }

    // Lấy danh sách chi tiết (AJAX)
    private void getImportDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int importId = getImportIdFromRequest(request);
        if (importId > 0) {
            List<ImportDetail> details = importDAO.getImportDetails(importId);
            request.setAttribute("details", details);
            request.getRequestDispatcher(getImportView("details", request)).forward(request, response);
        }
    }

    // ================= HELPER METHODS ===============
    private int getImportIdFromRequest(HttpServletRequest request) {
        String[] params = { "id", "code", "importCode", "importId" };
        for (String param : params) {
            String val = request.getParameter(param);
            if (val != null && !val.isEmpty()) {
                try {
                    return Integer.parseInt(val);
                } catch (NumberFormatException e) {
                    if (val.toUpperCase().startsWith("IP")) {
                        try {
                            return Integer.parseInt(val.substring(2));
                        } catch (NumberFormatException ex) {
                        }
                    }
                }
            }
        }
        return 0;
    }

    private int parseOrLookupSupplierId(String input) {
        if (input == null || input.isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return importDAO.getSupplierIdByName(input);
        }
    }

    private int parseOrLookupMedicineId(String input) {
        if (input == null || input.isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return importDAO.getMedicineIdByCode(input);
        }
    }

    private int parseStaffId(String input) {
        if (input == null || input.isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return importDAO.getStaffIdByCode(input);
        }
    }

    private Date parseDate(String dateStr) throws ParseException {
        if (dateStr == null || dateStr.isEmpty()) {
            return new Date(System.currentTimeMillis());
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = sdf.parse(dateStr);
        return new Date(date.getTime());
    }
}

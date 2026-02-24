package controllers;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import dao.ImportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Import;
import models.ImportDetail;
import models.Medicine;

public class ImportController extends HttpServlet {

    private ImportDAO importDAO;

    @Override
    public void init() throws ServletException {
        importDAO = new ImportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            request.getRequestDispatcher("/view/imports/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            request.getRequestDispatcher("/view/imports/list.jsp").forward(request, response);
        }
    }

    // Hiển thị danh sách phiếu nhập
    private void listImports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Import> imports = importDAO.getAllImports();
        request.setAttribute("imports", imports);
        request.getRequestDispatcher("/view/imports/list.jsp").forward(request, response);
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
        request.getRequestDispatcher("/view/imports/list.jsp").forward(request, response);
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
            request.setAttribute("import", imp);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/view/imports/view.jsp").forward(request, response);
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

        request.getRequestDispatcher("/view/imports/create.jsp").forward(request, response);
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
            request.setAttribute("import", imp);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/view/imports/edit.jsp").forward(request, response);
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
                // If session stores int
                try {
                    staffId = Integer.parseInt(userIdObj.toString());
                } catch (NumberFormatException e) {
                    // If session stores obj with toString? Or handle logic.
                }
            }
            // If session fail or not set, look at 'importerId' input
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

                // Add details
                // View sends 'medicines[i].medicineCode' typically
                String[] medicineInputs = request.getParameterValues("medicines[].medicineCode");
                if (medicineInputs == null) {
                    medicineInputs = request.getParameterValues("medicines[].medicineId");
                }

                if (medicineInputs != null && medicineInputs.length > 0) {
                    for (int i = 0; i < medicineInputs.length; i++) {
                        String medInput = medicineInputs[i];
                        String quantityStr = request.getParameter("medicines[" + i + "].quantity");
                        String priceStr = request.getParameter("medicines[" + i + "].price");

                        if (medInput != null && quantityStr != null && priceStr != null) {
                            try {
                                int medicineId = parseOrLookupMedicineId(medInput);
                                if (medicineId > 0) {
                                    int quantity = Integer.parseInt(quantityStr);
                                    double price = Double.parseDouble(priceStr);

                                    ImportDetail detail = new ImportDetail(newImportId, medicineId, quantity, price);
                                    detail.recalculateTotal();
                                    importDAO.addImportDetail(detail);
                                }
                            } catch (NumberFormatException e) {
                            }
                        }
                    }
                }

                double total = importDAO.calculateTotalAmount(newImportId);
                if (total > 0) {
                    imp.setTotalAmount(total);
                    importDAO.updateImport(imp);
                }

                response.sendRedirect(request.getContextPath() + "/import?action=edit&id=" + newImportId);
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

            // Resolve Staff (Importer)
            String importerInput = request.getParameter("importerId");
            int staffId = parseStaffId(importerInput);
            if (staffId > 0) {
                imp.setStaffId(staffId);
            }

            imp.setImportDate(parseDate(request.getParameter("importDate")));

            // Set Status
            String status = request.getParameter("status");
            if (status != null && !status.isEmpty()) {
                imp.setStatus(status);
            }

            double total = importDAO.calculateTotalAmount(importId);
            imp.setTotalAmount(total);

            if (importDAO.updateImport(imp)) {
                // Redirect to edit page to see changes or list page
                response.sendRedirect(request.getContextPath() + "/import?action=list");
            } else {
                request.setAttribute("error", "Không thể cập nhật phiếu nhập");
                request.setAttribute("import", imp);
                List<ImportDetail> details = importDAO.getImportDetails(importId);
                request.setAttribute("details", details);
                request.getRequestDispatcher("/view/imports/edit.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/import?action=list");
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
                response.sendRedirect(request.getContextPath() + "/import?action=list");
                return;
            }

            String medInput = request.getParameter("medicineCode");
            int medicineId = parseOrLookupMedicineId(medInput);

            if (medicineId == 0) {
                request.setAttribute("error", "Mã thuốc không hợp lệ: " + medInput);
                response.sendRedirect(request.getContextPath() + "/import?action=edit&id=" + importId);
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
            response.sendRedirect(request.getContextPath() + "/import?action=edit&id=" + importId);

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to list or edit?
            // Try to find context from params
            int importId = getImportIdFromRequest(request);
            if (importId > 0) {
                response.sendRedirect(request.getContextPath() + "/import?action=edit&id=" + importId);
            } else {
                response.sendRedirect(request.getContextPath() + "/import?action=list");
            }
        }
    }

    // Xóa chi tiết thuốc
    private void deleteImportDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            int importId = getImportIdFromRequest(request);

            if (importDAO.deleteImportDetail(detailId)) {
                if (importId > 0) {
                    Import imp = importDAO.getImportById(importId);
                    double total = importDAO.calculateTotalAmount(importId);
                    imp.setTotalAmount(total);
                    importDAO.updateImport(imp);
                    response.sendRedirect(request.getContextPath() + "/import?action=edit&id=" + importId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/import?action=list");
                }
            } else {
                if (importId > 0) {
                    response.sendRedirect(request.getContextPath() + "/import?action=edit&id=" + importId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/import?action=list");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/import?action=list");
        }
    }

    // Lấy danh sách chi tiết (AJAX)
    private void getImportDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int importId = getImportIdFromRequest(request);
        if (importId > 0) {
            List<ImportDetail> details = importDAO.getImportDetails(importId);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/view/imports/details.jsp").forward(request, response);
        }
    }

    // ================= HELPER METHODS ===============
    // Lấy Import ID từ request (param 'id' hoặc 'code' hoặc 'importCode')
    private int getImportIdFromRequest(HttpServletRequest request) {
        String[] params = { "id", "code", "importCode", "importId" };
        for (String param : params) {
            String val = request.getParameter(param);
            if (val != null && !val.isEmpty()) {
                // Try parse pure int
                try {
                    return Integer.parseInt(val);
                } catch (NumberFormatException e) {
                    // Try parse IPxxx
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

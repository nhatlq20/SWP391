package controllers.admin;

import java.io.IOException;
import dao.ImportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Import;

public class AdminImportController extends HttpServlet {

    private ImportDAO importDAO;
    private dao.SupplierDAO supplierDAO;
    private dao.CategoryDAO categoryDAO;
    private ImportService importService;

    private String getImportView(String name, HttpServletRequest request) {
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

    public void init() throws ServletException {
        importDAO = new ImportDAO();
        supplierDAO = new dao.SupplierDAO();
        categoryDAO = new dao.CategoryDAO();
        importService = new ImportService();
    }

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
        if (!checkAdminPermission(request, response))
            return;

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

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
            handleException(e, request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!checkAdminPermission(request, response))
            return;

        String action = request.getParameter("action");
        try {
            switch (action) {
                case "create":
                    handleCreate(request, response);
                    break;
                case "update":
                    handleUpdate(request, response);
                    break;
                case "delete":
                    deleteImport(request, response);
                    break;
                case "deleteDetail":
                    handleDeleteDetail(request, response);
                    break;
                case "search":
                    searchImports(request, response);
                    break;
                case "createSupplier":
                    createSupplierAjax(request, response);
                    break;
                default:
                    listImports(request, response);
                    break;
            }
        } catch (Exception e) {
            handleException(e, request, response);
        }
    }

    // --- Action Handlers (Delegating to Service) ---

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (importService.processCreateImport(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
        } else {
            showCreateForm(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (importService.processUpdateImport(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/imports?action=list");
        } else {
            showEditForm(request, response);
        }
    }

    private void handleDeleteDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int detailId = Integer.parseInt(request.getParameter("detailId"));
        int importId = getImportIdFromRequest(request);
        if (importDAO.deleteImportDetail(detailId)) {
            importDAO.updateImport(importDAO.getImportById(importId)); // Update total
        }
        response.sendRedirect(request.getContextPath() + "/admin/imports?action=edit&id=" + importId);
    }

    private void deleteImport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int importId = getImportIdFromRequest(request);
        Import imp = importDAO.getImportById(importId);
        if (imp != null && !"Đã duyệt".equals(imp.getStatus())) {
            importDAO.deleteImport(importId);
        } else {
            request.setAttribute("error", "Không thể xóa phiếu đã duyệt");
        }
        listImports(request, response);
    }

    // --- View Rendering ---

    private void listImports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("imports", importDAO.getAllImports());
        request.getRequestDispatcher(getImportView("list", request)).forward(request, response);
    }

    private void viewImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = getImportIdFromRequest(request);
        request.setAttribute("importRecord", importDAO.getImportById(id));
        request.setAttribute("details", importDAO.getImportDetails(id));
        request.getRequestDispatcher(getImportView("view", request)).forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("newCode", importDAO.generateImportCode());
        request.setAttribute("medicines", importDAO.getAllMedicines());
        request.setAttribute("suppliers", importDAO.getAllSuppliers());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher(getImportView("create", request)).forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = getImportIdFromRequest(request);
        Import imp = importDAO.getImportById(id);
        if (imp == null || "Đã duyệt".equals(imp.getStatus())) {
            listImports(request, response);
            return;
        }
        request.setAttribute("importRecord", imp);
        request.setAttribute("details", importDAO.getImportDetails(id));
        request.setAttribute("medicines", importDAO.getAllMedicines());
        request.setAttribute("suppliers", importDAO.getAllSuppliers());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher(getImportView("edit", request)).forward(request, response);
    }

    private void searchImports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("imports", importDAO.searchImports(keyword));
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher(getImportView("list", request)).forward(request, response);
    }

    private void getImportDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = getImportIdFromRequest(request);
        request.setAttribute("details", importDAO.getImportDetails(id));
        request.getRequestDispatcher(getImportView("details", request)).forward(request, response);
    }

    private void createSupplierAjax(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            String name = request.getParameter("supplierName");
            models.Supplier s = new models.Supplier();
            s.setSupplierName(name);
            s.setSupplierAddress(request.getParameter("supplierAddress"));
            s.setContactInfo(request.getParameter("contactInfo"));
            if (supplierDAO.createSupplier(s)) {
                response.getWriter().write("{\"success\": true, \"supplierId\": " + s.getSupplierId()
                        + ", \"supplierName\": \"" + s.getSupplierName() + "\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi DB\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private int getImportIdFromRequest(HttpServletRequest request) {
        String[] params = { "id", "importId", "code" };
        for (String p : params) {
            String v = request.getParameter(p);
            if (v != null && !v.isEmpty()) {
                try {
                    return Integer.parseInt(v);
                } catch (Exception e) {
                    if (v.toUpperCase().startsWith("IP")) {
                        try {
                            return Integer.parseInt(v.substring(2));
                        } catch (Exception ex) {
                        }
                    }
                }
            }
        }
        return 0;
    }

    private void handleException(Exception e, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        e.printStackTrace();
        req.setAttribute("error", "Lỗi: " + e.getMessage());
        listImports(req, resp);
    }
}

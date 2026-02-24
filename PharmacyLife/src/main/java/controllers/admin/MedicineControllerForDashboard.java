package controllers.admin;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.MedicineDAO;
import dao.CategoryDAO;
import models.Medicine;
import models.Category;

@WebServlet(name = "MedicineControllerForDashboard", urlPatterns = {
        "/admin/medicines-dashboard",
        "/admin/medicine-add-dashboard",
        "/admin/medicine-edit-dashboard",
        "/admin/medicine-detail-dashboard",
        "/admin/medicine-delete-dashboard"
})
public class MedicineControllerForDashboard extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/medicines-dashboard":
                showMedicineList(request, response);
                break;
            case "/admin/medicine-add-dashboard":
                showAddForm(request, response);
                break;
            case "/admin/medicine-edit-dashboard":
                showEditForm(request, response);
                break;
            case "/admin/medicine-detail-dashboard":
                showMedicineDetail(request, response);
                break;
            case "/admin/medicine-delete-dashboard":
                deleteMedicine(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        switch (path) {
            case "/admin/medicine-add-dashboard":
                createMedicine(request, response);
                break;
            case "/admin/medicine-edit-dashboard":
                updateMedicine(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
                break;
        }
    }

    // ========== GET handlers ==========

    private void showMedicineList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("/view/admin/medicine-list-for-dashboard.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int medicineId = Integer.parseInt(idParam);
                Medicine medicine = medicineDAO.getMedicineById(medicineId);
                if (medicine != null) {
                    List<Category> categories = categoryDAO.getAllCategories();
                    request.setAttribute("medicine", medicine);
                    request.setAttribute("categories", categories);
                    request.getRequestDispatcher("/view/admin/medicine-edit-for-dashboard.jsp").forward(request,
                            response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
    }

    private void showMedicineDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int medicineId = Integer.parseInt(idParam);
                Medicine medicine = medicineDAO.getMedicineById(medicineId);
                if (medicine != null) {
                    request.setAttribute("medicine", medicine);
                    request.getRequestDispatcher("/view/admin/medicine-detail-for-dashboard.jsp").forward(request,
                            response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
    }

    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int medicineId = Integer.parseInt(idParam);
                medicineDAO.deleteMedicine(medicineId);
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
    }

    // ========== POST handlers ==========

    private void createMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Medicine medicine = new Medicine();
            medicine.setMedicineCode(request.getParameter("medicineCode"));
            medicine.setMedicineName(request.getParameter("medicineName"));
            medicine.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            medicine.setImageUrl(request.getParameter("imageUrl"));

            String sellingPriceStr = request.getParameter("sellingPrice");
            medicine.setSellingPrice(sellingPriceStr != null && !sellingPriceStr.isEmpty()
                    ? Double.parseDouble(sellingPriceStr)
                    : 0);

            String originalPriceStr = request.getParameter("originalPrice");
            medicine.setOriginalPrice(originalPriceStr != null && !originalPriceStr.isEmpty()
                    ? Double.parseDouble(originalPriceStr)
                    : 0);

            medicine.setUnit(request.getParameter("unit"));

            String quantityStr = request.getParameter("remainingQuantity");
            medicine.setRemainingQuantity(quantityStr != null && !quantityStr.isEmpty()
                    ? Integer.parseInt(quantityStr)
                    : 0);

            medicine.setBrandOrigin(request.getParameter("brandOrigin"));
            medicine.setShortDescription(request.getParameter("shortDescription"));

            boolean success = medicineDAO.createMedicine(medicine);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
            } else {
                request.setAttribute("errorMessage", "Không thể thêm thuốc. Vui lòng thử lại.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
        }
    }

    private void updateMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int medicineId = Integer.parseInt(request.getParameter("medicineId"));
            Medicine medicine = medicineDAO.getMedicineById(medicineId);

            if (medicine == null) {
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
                return;
            }

            medicine.setMedicineCode(request.getParameter("medicineCode"));
            medicine.setMedicineName(request.getParameter("medicineName"));
            medicine.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            medicine.setImageUrl(request.getParameter("imageUrl"));

            String sellingPriceStr = request.getParameter("sellingPrice");
            medicine.setSellingPrice(sellingPriceStr != null && !sellingPriceStr.isEmpty()
                    ? Double.parseDouble(sellingPriceStr)
                    : 0);

            String originalPriceStr = request.getParameter("originalPrice");
            medicine.setOriginalPrice(originalPriceStr != null && !originalPriceStr.isEmpty()
                    ? Double.parseDouble(originalPriceStr)
                    : 0);

            medicine.setUnit(request.getParameter("unit"));

            String quantityStr = request.getParameter("remainingQuantity");
            medicine.setRemainingQuantity(quantityStr != null && !quantityStr.isEmpty()
                    ? Integer.parseInt(quantityStr)
                    : 0);

            medicine.setBrandOrigin(request.getParameter("brandOrigin"));
            medicine.setShortDescription(request.getParameter("shortDescription"));

            boolean success = medicineDAO.updateMedicine(medicine);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thuốc. Vui lòng thử lại.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("medicine", medicine);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/view/admin/medicine-edit-for-dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
        }
    }
}

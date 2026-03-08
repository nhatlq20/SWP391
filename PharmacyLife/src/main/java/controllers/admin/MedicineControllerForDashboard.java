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
import dao.MedicineUnitDAO;
import models.Medicine;
import models.MedicineUnit;
import models.Category;

@WebServlet(name = "MedicineControllerForDashboard", urlPatterns = {
        "/admin/medicines-dashboard",
        "/admin/medicine-add-dashboard",
        "/admin/medicine-edit-dashboard",
        "/admin/medicine-detail-dashboard",
        "/admin/medicine-delete-dashboard",
        "/admin/medicine-next-code"
})
public class MedicineControllerForDashboard extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private MedicineUnitDAO medicineUnitDAO = new MedicineUnitDAO();

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
            case "/admin/medicine-next-code":
                handleNextMedicineCode(request, response);
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
        // Default preview code (no category chosen yet)
        request.setAttribute("nextMedicineCode", "MED001");
        request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
    }

    /**
     * AJAX endpoint: returns the next medicine code for the given categoryId as
     * plain text.
     */
    private void handleNextMedicineCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        String catParam = request.getParameter("categoryId");
        String code = "MED001";
        if (catParam != null && !catParam.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(catParam);
                code = medicineDAO.getNextMedicineCode(categoryId);
            } catch (NumberFormatException ignored) {
            }
        }
        response.getWriter().write(code);
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
                // Delete MedicineUnit rows first (FK constraint), then the Medicine
                medicineUnitDAO.deleteUnitsByMedicineId(medicineId);
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
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            // Use the code already shown to user via AJAX; fallback to server-gen if empty
            String submittedCode = request.getParameter("medicineCode");
            medicine.setMedicineCode(submittedCode != null && !submittedCode.isEmpty()
                    ? submittedCode
                    : medicineDAO.getNextMedicineCode(categoryId));
            medicine.setMedicineName(request.getParameter("medicineName"));
            medicine.setCategoryId(categoryId);
            medicine.setImageUrl(request.getParameter("imageUrl"));

            String originalPriceStr = request.getParameter("originalPrice");
            medicine.setOriginalPrice(originalPriceStr != null && !originalPriceStr.isEmpty()
                    ? Double.parseDouble(originalPriceStr)
                    : 0);

            String quantityStr = request.getParameter("remainingQuantity");
            int quantity = 0;
            if (quantityStr != null && !quantityStr.isEmpty()) {
                try {
                    long qLong = Long.parseLong(quantityStr);
                    if (qLong < 0 || qLong > 1000000) {
                        request.setAttribute("errorMessage", "Số lượng không hợp lệ.");
                        request.setAttribute("categories", categoryDAO.getAllCategories());
                        request.setAttribute("nextMedicineCode", medicineDAO.getNextMedicineCode());
                        request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request,
                                response);
                        return;
                    }
                    quantity = (int) qLong;
                } catch (NumberFormatException ex) {
                    request.setAttribute("errorMessage", "Số lượng không hợp lệ.");
                    request.setAttribute("categories", categoryDAO.getAllCategories());
                    request.setAttribute("nextMedicineCode", medicineDAO.getNextMedicineCode());
                    request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request,
                            response);
                    return;
                }
            }
            medicine.setRemainingQuantity(quantity);

            medicine.setBrandOrigin(request.getParameter("brandOrigin"));
            medicine.setShortDescription(request.getParameter("shortDescription"));
            medicine.setIngredients(request.getParameter("ingredients"));

            // Insert Medicine and get the new ID
            int newMedicineId = medicineDAO.createMedicineAndReturnId(medicine);
            if (newMedicineId > 0) {
                // Create the base unit record
                String unitName = request.getParameter("unit");
                String sellingPriceStr = request.getParameter("sellingPrice");
                double sellingPrice = (sellingPriceStr != null && !sellingPriceStr.isEmpty())
                        ? Double.parseDouble(sellingPriceStr)
                        : 0;

                MedicineUnit baseUnit = new MedicineUnit();
                baseUnit.setMedicineId(newMedicineId);
                baseUnit.setUnitName(unitName != null && !unitName.isEmpty() ? unitName : "Hộp");
                baseUnit.setConversionRate(1);
                baseUnit.setSellingPrice(sellingPrice);
                baseUnit.setBaseUnit(true);
                medicineUnitDAO.addUnit(baseUnit);

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

            String originalPriceStr = request.getParameter("originalPrice");
            medicine.setOriginalPrice(originalPriceStr != null && !originalPriceStr.isEmpty()
                    ? Double.parseDouble(originalPriceStr)
                    : 0);

            String quantityStr = request.getParameter("remainingQuantity");
            if (quantityStr != null && !quantityStr.isEmpty()) {
                medicine.setRemainingQuantity(Integer.parseInt(quantityStr));
            }
            // else: keep the existing remainingQuantity loaded from DB above

            medicine.setBrandOrigin(request.getParameter("brandOrigin"));
            medicine.setShortDescription(request.getParameter("shortDescription"));
            medicine.setIngredients(request.getParameter("ingredients"));

            boolean success = medicineDAO.updateMedicine(medicine);
            if (success) {
                // Update the base unit (unit name and selling price) in MedicineUnit
                String unitName = request.getParameter("unit");
                String sellingPriceStr = request.getParameter("sellingPrice");
                double sellingPrice = (sellingPriceStr != null && !sellingPriceStr.isEmpty())
                        ? Double.parseDouble(sellingPriceStr)
                        : 0;

                boolean unitUpdated = medicineUnitDAO.updateBaseUnit(medicineId,
                        unitName != null && !unitName.isEmpty() ? unitName : "Hộp", sellingPrice);

                // If no base unit row exists yet, create one
                if (!unitUpdated) {
                    MedicineUnit baseUnit = new MedicineUnit();
                    baseUnit.setMedicineId(medicineId);
                    baseUnit.setUnitName(unitName != null && !unitName.isEmpty() ? unitName : "Hộp");
                    baseUnit.setConversionRate(1);
                    baseUnit.setSellingPrice(sellingPrice);
                    baseUnit.setBaseUnit(true);
                    medicineUnitDAO.addUnit(baseUnit);
                }

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

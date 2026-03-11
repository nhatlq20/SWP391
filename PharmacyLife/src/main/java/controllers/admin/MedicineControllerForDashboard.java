package controllers.admin;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.MedicineDAO;
import dao.CategoryDAO;
import dao.MedicineUnitDAO;
import dao.ReviewDAO;
import dao.CartDAO;
import dao.OrderDAO;
import dao.ImportDAO;
import models.Medicine;
import models.MedicineUnit;
import models.Category;

@WebServlet(name = "MedicineControllerForDashboard", urlPatterns = {
        "/admin/medicines-dashboard",
        "/admin/medicine-add-dashboard",
        "/admin/medicine-edit-dashboard",
        "/admin/medicine-delete-dashboard",
        "/admin/medicine-next-code"
})
public class MedicineControllerForDashboard extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private MedicineUnitDAO medicineUnitDAO = new MedicineUnitDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private ImportDAO importDAO = new ImportDAO();

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
                    List<MedicineUnit> units = medicineUnitDAO.getUnitsByMedicineId(medicineId);
                    request.setAttribute("medicine", medicine);
                    request.setAttribute("categories", categories);
                    request.setAttribute("units", units);
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

    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int medicineId = Integer.parseInt(idParam);

                // Delete from all tables that have a foreign key to MedicineId
                // Order of deletion matters if there are nested FKs, but here they mostly point
                // to MedicineId

                reviewDAO.deleteReviewsByMedicineId(medicineId);
                cartDAO.removeCartItemsByMedicineId(medicineId);
                orderDAO.deleteOrderItemsByMedicineId(medicineId);
                importDAO.deleteImportDetailsByMedicineId(medicineId);
                medicineUnitDAO.deleteUnitsByMedicineId(medicineId);

                // Finally delete the medicine (this also deletes ingredients and conditions
                // inside DAO)
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
                // Correct Hierarchy: Main Unit (Hộp) > Sub Unit 1 (Vỉ) > Sub Unit 2 (Viên)
                // To store stock in smallest units:
                // Sub Unit 2 (if exists) Rate = 1
                // Sub Unit 1 Rate = SubRate2
                // Main Unit Rate = SubRate1 * SubRate2

                String subUnit1 = request.getParameter("subUnit1");
                String subRate1Str = request.getParameter("subRate1");
                String subPrice1Str = request.getParameter("subPrice1");

                String subUnit2 = request.getParameter("subUnit2");
                String subRate2Str = request.getParameter("subRate2");
                String subPrice2Str = request.getParameter("subPrice2");

                int rate1 = (subRate1Str != null && !subRate1Str.isEmpty()) ? Integer.parseInt(subRate1Str) : 1;
                int rate2 = (subRate2Str != null && !subRate2Str.isEmpty()) ? Integer.parseInt(subRate2Str) : 1;

                int mainUnitRate = rate1 * rate2;
                int unit1Rate = rate2;
                int unit2Rate = 1;

                boolean hasSub2 = subUnit2 != null && !subUnit2.isEmpty();
                boolean hasSub1 = subUnit1 != null && !subUnit1.isEmpty();

                // Create the units
                String unitName = request.getParameter("unit");
                String sellingPriceStr = request.getParameter("sellingPrice");
                double sellingPrice = (sellingPriceStr != null && !sellingPriceStr.isEmpty())
                        ? Double.parseDouble(sellingPriceStr)
                        : 0;

                MedicineUnit baseUnit = new MedicineUnit();
                baseUnit.setMedicineId(newMedicineId);
                baseUnit.setUnitName(unitName != null && !unitName.isEmpty() ? unitName : "Hộp");
                baseUnit.setConversionRate(mainUnitRate);
                baseUnit.setSellingPrice(sellingPrice);
                // Base unit is the smallest unit. If sub units exist, this is NOT the base
                // unit.
                baseUnit.setBaseUnit(!hasSub1 && !hasSub2);
                medicineUnitDAO.addUnit(baseUnit);

                // Add Sub-Unit 1 if provided
                if (hasSub1) {
                    MedicineUnit unit1 = new MedicineUnit();
                    unit1.setMedicineId(newMedicineId);
                    unit1.setUnitName(subUnit1);
                    unit1.setConversionRate(unit1Rate);
                    unit1.setSellingPrice(Double.parseDouble(subPrice1Str));
                    // Base unit is the smallest unit. If Sub-Unit 2 exists, this is NOT the base
                    // unit.
                    unit1.setBaseUnit(!hasSub2);
                    medicineUnitDAO.addUnit(unit1);
                }

                // Add Sub-Unit 2 if provided
                if (hasSub2) {
                    MedicineUnit unit2 = new MedicineUnit();
                    unit2.setMedicineId(newMedicineId);
                    unit2.setUnitName(subUnit2);
                    unit2.setConversionRate(unit2Rate);
                    unit2.setSellingPrice(Double.parseDouble(subPrice2Str));
                    // Sub-Unit 2 is always the smallest unit if it exists
                    unit2.setBaseUnit(true);
                    medicineUnitDAO.addUnit(unit2);
                }

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
            if (originalPriceStr != null && !originalPriceStr.isEmpty()) {
                medicine.setOriginalPrice(Double.parseDouble(originalPriceStr));
            }

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
                // Correct Hierarchy: Main Unit (Hộp) > Sub Unit 1 (Vỉ) > Sub Unit 2 (Viên)
                String subUnit1 = request.getParameter("subUnit1");
                String subRate1Str = request.getParameter("subRate1");
                String subPrice1Str = request.getParameter("subPrice1");

                String subUnit2 = request.getParameter("subUnit2");
                String subRate2Str = request.getParameter("subRate2");
                String subPrice2Str = request.getParameter("subPrice2");

                int rate1Value = (subRate1Str != null && !subRate1Str.isEmpty()) ? Integer.parseInt(subRate1Str) : 1;
                int rate2Value = (subRate2Str != null && !subRate2Str.isEmpty()) ? Integer.parseInt(subRate2Str) : 1;

                int mainUnitRate = rate1Value * rate2Value;
                int unit1Rate = rate2Value;
                int unit2Rate = 1;

                boolean hasSub2 = subUnit2 != null && !subUnit2.isEmpty();
                boolean hasSub1 = subUnit1 != null && !subUnit1.isEmpty();

                // Update the first unit (unit name and selling price) in MedicineUnit
                String unitName = request.getParameter("unit");
                String sellingPriceStr = request.getParameter("sellingPrice");
                double sellingPrice = (sellingPriceStr != null && !sellingPriceStr.isEmpty())
                        ? Double.parseDouble(sellingPriceStr)
                        : 0;

                // Smart Update: Update existing units instead of deleting all
                List<MedicineUnit> existingUnits = medicineUnitDAO.getUnitsByMedicineId(medicineId);
                existingUnits.sort((a, b) -> b.getConversionRate() - a.getConversionRate());

                // 1. Prepare New List
                List<MedicineUnit> newUnits = new ArrayList<>();

                // Main Unit
                MedicineUnit mainU = new MedicineUnit();
                mainU.setMedicineId(medicineId);
                mainU.setUnitName(unitName != null && !unitName.isEmpty() ? unitName : "Hộp");
                mainU.setConversionRate(mainUnitRate);
                mainU.setSellingPrice(sellingPrice);
                mainU.setBaseUnit(!hasSub1 && !hasSub2);
                newUnits.add(mainU);

                if (hasSub1) {
                    MedicineUnit u1 = new MedicineUnit();
                    u1.setMedicineId(medicineId);
                    u1.setUnitName(subUnit1);
                    u1.setConversionRate(unit1Rate);
                    u1.setSellingPrice(
                            subPrice1Str != null && !subPrice1Str.isEmpty() ? Double.parseDouble(subPrice1Str) : 0);
                    u1.setBaseUnit(!hasSub2);
                    newUnits.add(u1);
                }

                if (hasSub2) {
                    MedicineUnit u2 = new MedicineUnit();
                    u2.setMedicineId(medicineId);
                    u2.setUnitName(subUnit2);
                    u2.setConversionRate(unit2Rate);
                    u2.setSellingPrice(
                            subPrice2Str != null && !subPrice2Str.isEmpty() ? Double.parseDouble(subPrice2Str) : 0);
                    u2.setBaseUnit(true);
                    newUnits.add(u2);
                }

                // 2. Sync with DB
                for (int i = 0; i < Math.max(newUnits.size(), existingUnits.size()); i++) {
                    if (i < newUnits.size() && i < existingUnits.size()) {
                        // Update existing
                        MedicineUnit toUpdate = newUnits.get(i);
                        toUpdate.setUnitId(existingUnits.get(i).getUnitId());
                        medicineUnitDAO.updateUnit(toUpdate);
                    } else if (i < newUnits.size()) {
                        medicineUnitDAO.addUnit(newUnits.get(i));
                    } else if (i < existingUnits.size()) {
                        medicineUnitDAO.deleteUnit(existingUnits.get(i).getUnitId());
                    }
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

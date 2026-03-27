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

/* Controller for managing medicine-related operations within the admin dashboard. */
@WebServlet(name = "MedicineControllerForDashboard", urlPatterns = {
        "/admin/medicines-dashboard",
        "/admin/medicine-add-dashboard",
        "/admin/medicine-edit-dashboard",
        "/admin/medicine-delete-dashboard",
        "/admin/medicine-next-code"
})
public class MedicineControllerForDashboard extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO(); // Medicine data access
    private CategoryDAO categoryDAO = new CategoryDAO(); // Category data access
    private MedicineUnitDAO medicineUnitDAO = new MedicineUnitDAO(); // Unit data access
    private ReviewDAO reviewDAO = new ReviewDAO(); // Review data access
    private CartDAO cartDAO = new CartDAO(); // Cart data access
    private OrderDAO orderDAO = new OrderDAO(); // Order data access
    private ImportDAO importDAO = new ImportDAO(); // Inventory import data access

    /*
     * Distributes GET requests to specific internal handler methods based on the
     * URL path.
     */
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

    /* Distributes POST requests for creating or updating medicine records. */
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

    /*
     * Retrieves and displays the full list of medicines with status notifications.
     */
    private void showMedicineList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        if (status != null) {
            switch (status) {
                case "addSuccess":
                    request.setAttribute("successMessage", "New medicine added successfully!");
                    break;
                case "updateSuccess":
                    request.setAttribute("successMessage", "Medicine updated successfully!");
                    break;
                case "deleteSuccess":
                    request.setAttribute("successMessage", "Medicine deleted successfully!");
                    break;
                case "error":
                    request.setAttribute("errorMessage", "An error occurred. Please try again!");
                    break;
            }
        }
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("/view/admin/medicine-list-for-dashboard.jsp").forward(request, response);
    }

    /* Prepares and shows the form for adding a new medicine record. */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        List<models.Unit> unitTypes = medicineUnitDAO.getAllUnitTypes();
        request.setAttribute("categories", categories);
        request.setAttribute("unitTypes", unitTypes);
        // Default preview code (no category chosen yet)
        request.setAttribute("nextMedicineCode", "MED001");
        request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
    }

    /*
     * AJAX endpoint: Returns the next unique medicine code for a specific category
     * as plain text.
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

    /* Prepares and shows the edit form for a specific medicine record. */
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
                    List<models.Unit> unitTypes = medicineUnitDAO.getAllUnitTypes();
                    request.setAttribute("medicine", medicine);
                    request.setAttribute("categories", categories);
                    request.setAttribute("units", units);
                    request.setAttribute("unitTypes", unitTypes);
                    request.getRequestDispatcher("/view/admin/medicine-edit-for-dashboard.jsp").forward(request,
                            response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
    }

    /*
     * Cascades through related tables to delete all data associated with a medicine
     * record.
     */
    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int medicineId = Integer.parseInt(idParam);

                // Cascade deletion across dependent tables to maintain database integrity
                reviewDAO.deleteReviewsByMedicineId(medicineId);
                cartDAO.removeCartItemsByMedicineId(medicineId);
                orderDAO.deleteOrderItemsByMedicineId(medicineId);
                importDAO.deleteImportDetailsByMedicineId(medicineId);
                medicineUnitDAO.deleteUnitsByMedicineId(medicineId);

                // Finally, remove the medicine record (this also handles ingredients and uses
                // in the DAO)
                medicineDAO.deleteMedicine(medicineId);
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard?status=deleteSuccess");
                return;
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard?status=error");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
    }

    // ========== POST handlers ==========

    /*
     * Processes the creation of a new medicine, including its unit hierarchy and
     * ingredients.
     */
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
                    // Basic validation for quantity range
                    if (qLong < 0 || qLong > 1000000) {
                        request.setAttribute("errorMessage", "Invalid quantity value.");
                        request.setAttribute("categories", categoryDAO.getAllCategories());
                        request.setAttribute("nextMedicineCode", medicineDAO.getNextMedicineCode());
                        request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request,
                                response);
                        return;
                    }
                    quantity = (int) qLong;
                } catch (NumberFormatException ex) {
                    request.setAttribute("errorMessage", "Invalid quantity format.");
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
            medicine.setConditions(request.getParameter("uses"));

            // Insert Medicine and get the new ID
            int newMedicineId = medicineDAO.createMedicineAndReturnId(medicine);
            if (newMedicineId > 0) {
                // Save Ingredients and Uses (Conditions)
                medicineDAO.saveMedicineIngredients(newMedicineId, medicine.getIngredients());
                medicineDAO.saveMedicineConditions(newMedicineId, medicine.getConditions());

                // Logic: Handle Unit Hierarchy (e.g., Box > Strip > Tablet)
                // Calculated rates ensure inventory is tracked in the smallest unit.

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

                // Create the primary/main unit (usually the largest packaging)
                String unitName = request.getParameter("unit");
                String sellingPriceStr = request.getParameter("sellingPrice");
                double sellingPrice = (sellingPriceStr != null && !sellingPriceStr.isEmpty())
                        ? Double.parseDouble(sellingPriceStr)
                        : 0;

                MedicineUnit baseUnit = new MedicineUnit();
                baseUnit.setMedicineId(newMedicineId);
                String mainUnitName = unitName != null && !unitName.isEmpty() ? unitName : "Box";
                baseUnit.setUnitName(mainUnitName);
                baseUnit.setUnitId(medicineUnitDAO.getUnitIdByName(mainUnitName));
                baseUnit.setConversionRate(mainUnitRate);
                baseUnit.setSellingPrice(sellingPrice);
                baseUnit.setBaseUnit(!hasSub1 && !hasSub2);
                medicineUnitDAO.addUnit(baseUnit);

                // Add Sub-Unit 1 if provided (e.g., a strip)
                if (hasSub1) {
                    MedicineUnit unit1 = new MedicineUnit();
                    unit1.setMedicineId(newMedicineId);
                    unit1.setUnitName(subUnit1);
                    unit1.setUnitId(medicineUnitDAO.getUnitIdByName(subUnit1));
                    unit1.setConversionRate(unit1Rate);
                    unit1.setSellingPrice(Double.parseDouble(subPrice1Str));
                    unit1.setBaseUnit(!hasSub2);
                    medicineUnitDAO.addUnit(unit1);
                }

                // Add Sub-Unit 2 if provided (e.g., a single tablet - the base unit for stock)
                if (hasSub2) {
                    MedicineUnit unit2 = new MedicineUnit();
                    unit2.setMedicineId(newMedicineId);
                    unit2.setUnitName(subUnit2);
                    unit2.setUnitId(medicineUnitDAO.getUnitIdByName(subUnit2));
                    unit2.setConversionRate(unit2Rate);
                    unit2.setSellingPrice(Double.parseDouble(subPrice2Str));
                    unit2.setBaseUnit(true);
                    medicineUnitDAO.addUnit(unit2);
                }

                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard?status=addSuccess");
            } else {
                request.setAttribute("errorMessage", "Could not add medicine. Please try again.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/view/admin/medicine-add-for-dashboard.jsp").forward(request, response);
        }
    }

    /* Processes the update of an existing medicine record and its units. */
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
            // If quantity is missing, retain the existing remainingQuantity loaded from the
            // DB

            medicine.setBrandOrigin(request.getParameter("brandOrigin"));
            medicine.setShortDescription(request.getParameter("shortDescription"));
            medicine.setIngredients(request.getParameter("ingredients"));
            medicine.setConditions(request.getParameter("uses"));

            boolean success = medicineDAO.updateMedicine(medicine);
            if (success) {
                // Save or Update related data like Ingredients and Uses
                medicineDAO.saveMedicineIngredients(medicineId, medicine.getIngredients());
                medicineDAO.saveMedicineConditions(medicineId, medicine.getConditions());

                // Recalculate Unit Hierarchy Rates (e.g., Box > Strip > Tablet)
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

                // Get main unit details from the request
                String unitName = request.getParameter("unit");
                String sellingPriceStr = request.getParameter("sellingPrice");
                double sellingPrice = (sellingPriceStr != null && !sellingPriceStr.isEmpty())
                        ? Double.parseDouble(sellingPriceStr)
                        : 0;

                // Sync with DB: Smartly update existing units to maintain referential integrity
                List<MedicineUnit> existingUnits = medicineUnitDAO.getUnitsByMedicineId(medicineId);
                existingUnits.sort((a, b) -> b.getConversionRate() - a.getConversionRate());

                // 1. Construct the list of new unit configurations
                List<MedicineUnit> newUnits = new ArrayList<>();

                // Define the Primary (Main) Unit
                MedicineUnit mainU = new MedicineUnit();
                mainU.setMedicineId(medicineId);
                String mainUName = unitName != null && !unitName.isEmpty() ? unitName : "Box";
                mainU.setUnitName(mainUName);
                mainU.setUnitId(medicineUnitDAO.getUnitIdByName(mainUName));
                mainU.setConversionRate(mainUnitRate);
                mainU.setSellingPrice(sellingPrice);
                mainU.setBaseUnit(!hasSub1 && !hasSub2);
                newUnits.add(mainU);

                if (hasSub1) {
                    MedicineUnit u1 = new MedicineUnit();
                    u1.setMedicineId(medicineId);
                    u1.setUnitName(subUnit1);
                    u1.setUnitId(medicineUnitDAO.getUnitIdByName(subUnit1));
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
                    u2.setUnitId(medicineUnitDAO.getUnitIdByName(subUnit2));
                    u2.setConversionRate(unit2Rate);
                    u2.setSellingPrice(
                            subPrice2Str != null && !subPrice2Str.isEmpty() ? Double.parseDouble(subPrice2Str) : 0);
                    u2.setBaseUnit(true);
                    newUnits.add(u2);
                }

                // 2. Efficiently synchronize with the database
                for (int i = 0; i < Math.max(newUnits.size(), existingUnits.size()); i++) {
                    if (i < newUnits.size() && i < existingUnits.size()) {
                        // Update an existing unit entry
                        MedicineUnit toUpdate = newUnits.get(i);
                        toUpdate.setMedicineUnitId(existingUnits.get(i).getMedicineUnitId());
                        medicineUnitDAO.updateUnit(toUpdate);
                    } else if (i < newUnits.size()) {
                        // Insert a newly added unit type
                        medicineUnitDAO.addUnit(newUnits.get(i));
                    } else if (i < existingUnits.size()) {
                        // Remove unit types that are no longer part of the configuration
                        medicineUnitDAO.deleteUnit(existingUnits.get(i).getMedicineUnitId());
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard?status=updateSuccess");
            } else {
                request.setAttribute("errorMessage", "Could not update medicine record. Please try again.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("medicine", medicine);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/view/admin/medicine-edit-for-dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
        }
    }
}

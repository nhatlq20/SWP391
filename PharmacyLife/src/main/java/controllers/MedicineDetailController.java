package controllers;

import java.io.IOException;
import java.util.List;
// nhanh moi
import dao.MedicineDAO;
import dao.MedicineUnitDAO;
import dao.OrderDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Medicine;
import models.ReviewCustomer;

/* Controller for viewing detailed information about a specific medicine, including reviews and stock. */
public class MedicineDetailController extends HttpServlet {

    private final MedicineDAO medicineDAO = new MedicineDAO(); // Medicine data access
    private final MedicineUnitDAO medicineUnitDAO = new MedicineUnitDAO(); // Unit data access
    private final ReviewDAO reviewDAO = new ReviewDAO(); // Review data access
    private final OrderDAO orderDAO = new OrderDAO(); // Order data access

    /* Helper function to retrieve the logged-in customer ID from session data. */
    private Integer getLoggedInCustomerId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object userType = session.getAttribute("userType");
        if (userType == null || !"customer".equalsIgnoreCase(String.valueOf(userType))) {
            return null;
        }

        Object customerIdInSession = session.getAttribute("customerId");
        if (customerIdInSession instanceof Integer) {
            return (Integer) customerIdInSession;
        }

        if (customerIdInSession instanceof String) {
            try {
                return Integer.parseInt((String) customerIdInSession);
            } catch (NumberFormatException ignored) {
            }
        }

        return null;
    }

    /*
     * Handles GET requests to display medicine details, including reviews and stock
     * statistics.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int medicineId = Integer.parseInt(id);
            Medicine medicine = medicineDAO.getMedicineById(medicineId);

            if (medicine == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Retrieve the list of customer reviews for the medicine product
            List<ReviewCustomer> reviews = reviewDAO.getReviewsWithCustomerByMedicine(medicineId);
            double averageRating = reviewDAO.getAverageRating(medicineId);
            int totalReviews = reviewDAO.getTotalReviews(medicineId);

            // Fetch medicine component data (ingredients and active ingredients)
            List<String> ingredientNames = medicineDAO.getIngredientNamesByMedicineId(medicineId);
            // Fetch usage effects and conditions data
            List<String> conditionNames = medicineDAO.getConditionNamesByMedicineId(medicineId);

            // Fetch the total stock quantity for the entire category
            int categoryStock = 0;
            try {
                if (medicine.getCategory() != null) {
                    categoryStock = medicineDAO.getTotalStockByCategory(medicine.getCategory().getCategoryId());
                }
            } catch (Exception e) {
                e.printStackTrace();
                categoryStock = 0; // fallback to zero on error
            }

            request.setAttribute("medicine", medicine);
            request.setAttribute("ingredientNames", ingredientNames);
            request.setAttribute("conditionNames", conditionNames);
            request.setAttribute("units", medicineUnitDAO.getUnitsByMedicineId(medicineId));
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", Math.round(averageRating * 10) / 10.0);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("categoryStock", categoryStock);

            // Determine if the current user is eligible to write a review
            Integer customerId = getLoggedInCustomerId(request);
            boolean canReview = false;
            boolean hasReviewed = false;
            if (customerId != null && orderDAO.hasCustomerPurchasedMedicine(customerId, medicineId)) {
                hasReviewed = reviewDAO.hasCustomerReviewedMedicine(customerId, medicineId);
                canReview = !hasReviewed;
            }
            request.setAttribute("canReview", canReview);
            request.setAttribute("hasReviewed", hasReviewed);
            request.setAttribute("loggedCustomerId", customerId);

            request.getRequestDispatcher("/view/client/medicine-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /* Redirects POST requests to doGet for consistent detail display. */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

package controllers;

import java.io.IOException;
import java.util.List;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.ReviewCustomer;
import models.Staff;

public class ViewReviewsController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    private boolean isLoggedInStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Object userType = session.getAttribute("userType");
        Object loggedInUser = session.getAttribute("loggedInUser");
        return userType != null
                && "staff".equalsIgnoreCase(String.valueOf(userType))
                && loggedInUser instanceof Staff;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String medicineParam = request.getParameter("medicineId");
        String selectedReviewIdParam = request.getParameter("selectedReviewId");
        
        if (medicineParam == null || medicineParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int medicineId = Integer.parseInt(medicineParam);
            
            // Lấy danh sách reviews của sản phẩm (với thông tin khách hàng)
            List<ReviewCustomer> reviews = reviewDAO.getReviewsWithCustomerByMedicine(medicineId);
            double averageRating = reviewDAO.getAverageRating(medicineId);
            int totalReviews = reviewDAO.getTotalReviews(medicineId);
            
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", Math.round(averageRating * 10) / 10.0);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("medicineId", medicineId);
            request.setAttribute("selectedReviewId", selectedReviewIdParam);
            
            request.getRequestDispatcher("/view/client/viewReview.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            if (!isLoggedInStaff(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String reviewIdParam = request.getParameter("reviewId");
            String medicineIdParam = request.getParameter("medicineId");

            try {
                int reviewId = Integer.parseInt(reviewIdParam);
                int medicineId = Integer.parseInt(medicineIdParam);

                reviewDAO.deleteReviewByAdminOrStaff(reviewId);
                response.sendRedirect(request.getContextPath() + "/view-reviews?medicineId=" + medicineId);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        }

        doGet(request, response);
    }
}

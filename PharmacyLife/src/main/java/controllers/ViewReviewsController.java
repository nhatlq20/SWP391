package controllers;

import java.io.IOException;
import java.util.List;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ReviewCustomer;

public class ViewReviewsController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String medicineParam = request.getParameter("medicineId");
        
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
            
            request.getRequestDispatcher("/view/client/viewReview.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

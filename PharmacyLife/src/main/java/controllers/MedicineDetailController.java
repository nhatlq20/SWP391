package controllers;

import java.io.IOException;
import java.util.List;

import dao.MedicineDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Medicine;
import models.ReviewCustomer;

public class MedicineDetailController extends HttpServlet {

    private final MedicineDAO medicineDAO = new MedicineDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

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
            
            // Lấy danh sách reviews của sản phẩm (với thông tin khách hàng)
            List<ReviewCustomer> reviews = reviewDAO.getReviewsWithCustomerByMedicine(medicineId);
            double averageRating = reviewDAO.getAverageRating(medicineId);
           int totalReviews = reviewDAO.getTotalReviews(medicineId);
            
            request.setAttribute("medicine", medicine);
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", Math.round(averageRating * 10) / 10.0);
           request.setAttribute("totalReviews", totalReviews);
            
            request.getRequestDispatcher("/view/client/medicine-detail.jsp").forward(request, response);
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

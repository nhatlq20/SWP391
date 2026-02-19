package controllers;

import dao.ReviewDAO;
import models.Review;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
public class CreatedReview extends HttpServlet {

    private int resolveCustomerId(HttpServletRequest request) {
        HttpSession session = request.getSession();

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

        String customerIdParam = request.getParameter("customerId");
        if (customerIdParam != null && !customerIdParam.isBlank()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                if (customerId > 0) {
                    session.setAttribute("customerId", customerId);
                    return 2;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        return 1;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = resolveCustomerId(request);
        
        String medicineIdStr = request.getParameter("medicineId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (medicineIdStr == null || medicineIdStr.isEmpty()) {
            request.setAttribute("error", "Medicine not found");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int medicineId = Integer.parseInt(medicineIdStr);
            int rating = Integer.parseInt(ratingStr);

            Review r = new Review();
            r.setCustomerId(customerId);
            r.setMedicineId(medicineId);
            r.setRating(rating);
            r.setComment(comment);

            ReviewDAO dao = new ReviewDAO();
            dao.insertReview(r);

            // Quay về trang chi tiết sản phẩm để xem đánh giá vừa thêm
            response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = resolveCustomerId(request);
        String medicineIdStr = request.getParameter("medicineId");
        if (medicineIdStr != null && !medicineIdStr.isEmpty()) {
            try {
                int medicineId = Integer.parseInt(medicineIdStr);
                request.setAttribute("medicineId", medicineId);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        request.setAttribute("customerId", customerId);
        request.getRequestDispatcher("/view/client/createReview.jsp").forward(request, response);
    }
}

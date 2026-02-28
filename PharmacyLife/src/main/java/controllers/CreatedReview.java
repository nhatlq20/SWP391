package controllers;

import dao.MedicineDAO;
import dao.OrderDAO;
import dao.ReviewDAO;
import models.Review;
import models.Medicine;
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
    // check
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

    private boolean requireCustomerLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer customerId = getLoggedInCustomerId(request);
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        request.setAttribute("customerId", customerId);
        return true;
    }

    private boolean hasPurchasedMedicine(int customerId, int medicineId) {
        OrderDAO orderDAO = new OrderDAO();
        return orderDAO.hasCustomerPurchasedMedicine(customerId, medicineId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireCustomerLogin(request, response)) {
            return;
        }
        Integer customerId = (Integer) request.getAttribute("customerId");

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

            if (!hasPurchasedMedicine(customerId, medicineId)) {
                response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineId + "&reviewError=notPurchased");
                return;
            }

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
        if (!requireCustomerLogin(request, response)) {
            return;
        }

        Integer customerId = (Integer) request.getAttribute("customerId");
        String medicineIdStr = request.getParameter("medicineId");
        String replyTo = request.getParameter("replyTo");

        if (medicineIdStr != null && !medicineIdStr.isEmpty()) {
            try {
                int medicineId = Integer.parseInt(medicineIdStr);

                if (!hasPurchasedMedicine(customerId, medicineId)) {
                    response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineId + "&reviewError=notPurchased");
                    return;
                }

                MedicineDAO medicineDAO = new MedicineDAO();
                Medicine medicine = medicineDAO.getMedicineById(medicineId);
                if (medicine == null) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

                request.setAttribute("medicineId", medicineId);
                request.setAttribute("medicine", medicine);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (replyTo != null && !replyTo.trim().isEmpty()) {
            request.setAttribute("replyTo", replyTo.trim());
        }
        request.setAttribute("customerId", customerId);
        request.getRequestDispatcher("/view/client/createReview.jsp").forward(request, response);
    }
}

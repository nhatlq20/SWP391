package controllers;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.Staff;

public class ReplyReviewController extends HttpServlet {

    private boolean isAllowedStaffOrAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }

        Object userType = session.getAttribute("userType");
        Object loggedInUser = session.getAttribute("loggedInUser");

        if (userType == null || !"staff".equalsIgnoreCase(String.valueOf(userType))) {
            return false;
        }

        return loggedInUser instanceof Staff;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAllowedStaffOrAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewIdParam = request.getParameter("reviewId");
        String replyContent = request.getParameter("replyContent");
        String medicineIdParam = request.getParameter("medicineId");

        if (reviewIdParam == null || reviewIdParam.trim().isEmpty()
                || replyContent == null || replyContent.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view-reviews");
            return;
        }

        HttpSession session = request.getSession(false);
        Staff staff = (Staff) session.getAttribute("loggedInUser");
        int staffId = staff.getStaffId();

        try {
            int reviewId = Integer.parseInt(reviewIdParam);
            ReviewDAO dao = new ReviewDAO();
            dao.replyReview(reviewId, replyContent.trim(), staffId);

            if (medicineIdParam != null && !medicineIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/view-reviews?medicineId=" + medicineIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/view-reviews");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view-reviews");
        }
    }
}

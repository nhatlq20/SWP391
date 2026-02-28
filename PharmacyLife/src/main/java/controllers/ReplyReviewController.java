package controllers;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.Customer;
import models.Staff;

public class ReplyReviewController extends HttpServlet {

    private Integer getReplyUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return null;
        }

        Object userType = session.getAttribute("userType");
        Object loggedInUser = session.getAttribute("loggedInUser");

        if (userType == null) {
            return null;
        }

        String normalizedUserType = String.valueOf(userType).toLowerCase();

        if ("staff".equals(normalizedUserType) && loggedInUser instanceof Staff) {
            return ((Staff) loggedInUser).getStaffId();
        }

        if ("customer".equals(normalizedUserType) && loggedInUser instanceof Customer) {
            return -((Customer) loggedInUser).getCustomerId();
        }

        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer replyUserId = getReplyUserId(request);
        if (replyUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewIdParam = request.getParameter("reviewId");
        String replyContent = request.getParameter("replyContent");
        String medicineIdParam = request.getParameter("medicineId");
        String returnTo = request.getParameter("returnTo");

        boolean returnToDetail = "detail".equalsIgnoreCase(returnTo);

        if (reviewIdParam == null || reviewIdParam.trim().isEmpty()
                || replyContent == null || replyContent.trim().isEmpty()) {
            if (medicineIdParam != null && !medicineIdParam.trim().isEmpty() && returnToDetail) {
                int reviewIdForAnchor = Integer.parseInt(reviewIdParam);
                response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineIdParam + "#review-" + reviewIdForAnchor);
            } else if (medicineIdParam != null && !medicineIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/view-reviews?medicineId=" + medicineIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/view-reviews");
            }
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdParam);
            ReviewDAO dao = new ReviewDAO();
            dao.replyReview(reviewId, replyContent.trim(), replyUserId);

            if (medicineIdParam != null && !medicineIdParam.trim().isEmpty()) {
                if (returnToDetail) {
                    response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineIdParam + "#review-" + reviewId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/view-reviews?medicineId=" + medicineIdParam);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/view-reviews");
            }
        } catch (NumberFormatException e) {
            if (medicineIdParam != null && !medicineIdParam.trim().isEmpty() && returnToDetail) {
                response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/view-reviews");
            }
        }
    }
}

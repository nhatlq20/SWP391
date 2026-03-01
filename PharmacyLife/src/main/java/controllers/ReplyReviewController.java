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

        if ("admin".equals(normalizedUserType) && loggedInUser instanceof Staff) {
            return ((Staff) loggedInUser).getStaffId();
        }

        if ("customer".equals(normalizedUserType) && loggedInUser instanceof Customer) {
            return -((Customer) loggedInUser).getCustomerId();
        }

        return null;
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        return requestedWith != null && "XMLHttpRequest".equalsIgnoreCase(requestedWith);
    }

    private String jsonEscape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }

    private void writeJson(HttpServletResponse response, int status, String jsonBody) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(jsonBody);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean ajaxRequest = isAjaxRequest(request);

        Integer replyUserId = getReplyUserId(request);
        if (replyUserId == null) {
            if (ajaxRequest) {
                writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, "{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewIdParam = request.getParameter("reviewId");
        String replyContent = request.getParameter("replyContent");
        String medicineIdParam = request.getParameter("medicineId");
        String returnTo = request.getParameter("returnTo");

        boolean returnToDetail = "detail".equalsIgnoreCase(returnTo);
        String trimmedReply = replyContent == null ? "" : replyContent.trim();

        if (reviewIdParam == null || reviewIdParam.trim().isEmpty()
            || medicineIdParam == null || medicineIdParam.trim().isEmpty()
                || trimmedReply.isEmpty()) {
            if (ajaxRequest) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, "{\"success\":false,\"message\":\"Invalid input\"}");
                return;
            }
            if (medicineIdParam != null && !medicineIdParam.trim().isEmpty() && returnToDetail
                    && reviewIdParam != null && !reviewIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineIdParam + "#review-" + reviewIdParam.trim());
            } else if (medicineIdParam != null && !medicineIdParam.trim().isEmpty() && returnToDetail) {
                response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineIdParam);
            } else if (medicineIdParam != null && !medicineIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/view-reviews?medicineId=" + medicineIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/view-reviews");
            }
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdParam);
            int medicineId = Integer.parseInt(medicineIdParam);
            ReviewDAO dao = new ReviewDAO();
            boolean updated = dao.replyReview(reviewId, medicineId, trimmedReply, replyUserId);

            if (!updated) {
                if (ajaxRequest) {
                    writeJson(response, HttpServletResponse.SC_NOT_FOUND, "{\"success\":false,\"message\":\"Review not found\"}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            if (ajaxRequest) {
                writeJson(response, HttpServletResponse.SC_OK,
                        "{\"success\":true,\"reviewId\":" + reviewId + ",\"replyContent\":\"" + jsonEscape(trimmedReply) + "\"}");
                return;
            }

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
            if (ajaxRequest) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, "{\"success\":false,\"message\":\"Invalid number format\"}");
                return;
            }
            if (medicineIdParam != null && !medicineIdParam.trim().isEmpty() && returnToDetail) {
                response.sendRedirect(request.getContextPath() + "/medicine/detail?id=" + medicineIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/view-reviews");
            }
        }
    }
}

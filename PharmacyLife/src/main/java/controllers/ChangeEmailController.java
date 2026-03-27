package controllers;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.EmailUtils;

/**
 * ChangeEmailController - Handle email change process
 */
@WebServlet(name = "ChangeEmailController", urlPatterns = {"/change-email"})
public class ChangeEmailController extends HttpServlet {

    // check role
    private boolean isStaffOrAdmin(HttpSession session) {
        String role = (String) session.getAttribute("roleName");
        return role != null &&
               (role.equalsIgnoreCase("admin") || role.equalsIgnoreCase("staff"));
    }

    // check login
    private boolean isNotLoggedIn(HttpSession session) {
        return session == null ||
               (session.getAttribute("loggedInUser") == null && session.getAttribute("user") == null);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Chưa login
        if (isNotLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        //  Chặn admin + staff
        if (isStaffOrAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }

        String step = request.getParameter("step");

        if ("verify-new".equals(step)) {
            request.getRequestDispatcher("view/client/verify-new-email.jsp").forward(request, response);
            return;
        } else if ("reset-email".equals(step)) {
            request.getRequestDispatcher("view/client/reset-email.jsp").forward(request, response);
            return;
        }

        // Default: gửi OTP tới email cũ
        String oldEmail = (String) session.getAttribute("userEmail");

        if (oldEmail == null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof models.User) {
                oldEmail = ((models.User) userObj).getEmail();
            }
        }

        if (oldEmail == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        String otp = EmailUtils.generateOTP();

        boolean sent = EmailUtils.sendOTPEmail(oldEmail, otp, "change-email");

        if (sent) {
            session.setAttribute("otp", otp);
            session.setAttribute("otpAction", "verify-old-email");
            session.setMaxInactiveInterval(300); // 5 phút

            request.setAttribute("successMessage",
                    "Mã OTP đã được gửi đến email hiện tại của bạn: " + oldEmail);
            request.getRequestDispatcher("view/client/verify-otp.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage",
                    "Không thể gửi mã OTP. Vui lòng thử lại sau.");
            request.getRequestDispatcher("view/client/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Chưa login
        if (isNotLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chặn admin + staff
        if (isStaffOrAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return;
        }

        String action = request.getParameter("action");

        if ("submit-new-email".equals(action)) {

            String newEmail = request.getParameter("newEmail");

            if (newEmail == null || newEmail.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Email không được để trống");
                request.getRequestDispatcher("view/client/reset-email.jsp").forward(request, response);
                return;
            }

            UserDAO userDAO = new UserDAO();

            //  Email đã tồn tại
            if (userDAO.findByEmail(newEmail) != null) {
                request.setAttribute("errorMessage",
                        "Email này đã được sử dụng trong hệ thống. Vui lòng chọn email khác.");
                request.getRequestDispatcher("view/client/reset-email.jsp").forward(request, response);
                return;
            }

            // Gửi OTP tới email mới
            String otp = EmailUtils.generateOTP();
            boolean sent = EmailUtils.sendOTPEmail(newEmail, otp, "verify-new-email");

            if (sent) {
                session.setAttribute("otp", otp);
                session.setAttribute("newEmailTemp", newEmail);
                session.setAttribute("otpAction", "verify-new-email");

                request.setAttribute("successMessage",
                        "Mã OTP đã được gửi đến email mới: " + newEmail);
                request.getRequestDispatcher("view/client/verify-otp.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage",
                        "Không thể gửi mã OTP đến email mới. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("view/client/reset-email.jsp").forward(request, response);
            }
        }
    }
}
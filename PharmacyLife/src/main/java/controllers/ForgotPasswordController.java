package controllers;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import utils.EmailUtils;

/**
 * ForgotPasswordController - Handle forgot password flow
 * 
 * @author anltc
 */
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("view/client/forgot-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String input = request.getParameter("email");
        String emailInput = (input == null) ? "" : input.trim().toLowerCase();

        request.setAttribute("email", emailInput);

        // 1. Validate input
        if (emailInput.isEmpty()) {
            request.setAttribute("errorMessage", "Email không đúng");
            request.getRequestDispatcher("view/client/forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        // 2. Check user tồn tại
        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(emailInput);

        if (user == null) {
            request.setAttribute("errorMessage", "Tài khoản này không tồn tại");
            request.getRequestDispatcher("view/client/forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        // 3. Generate & send OTP
        String otp = EmailUtils.generateOTP();
        boolean isSent = EmailUtils.sendOTPEmail(user.getEmail(), otp);

        if (!isSent) {
            request.setAttribute("errorMessage", "Không thể gửi email. Vui lòng thử lại sau.");
            request.getRequestDispatcher("view/client/forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        // 4. Lưu session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", user.getEmail());
        session.setAttribute("otpAction", "reset");
        session.setMaxInactiveInterval(300); // 5 phút

        // 5. Forward sang verify OTP
        request.setAttribute("successMessage",
                "Mã OTP đã được gửi đến email: " + user.getEmail());

        request.getRequestDispatcher("view/client/verify-otp.jsp")
               .forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Controller";
    }
}
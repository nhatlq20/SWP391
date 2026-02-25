package controllers;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
        
        request.getRequestDispatcher("view/client/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String input = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByUsernameOrEmail(input);

        if (user != null && user.getEmail() != null && !user.getEmail().isEmpty()) {
            String email = user.getEmail();
            String otp = EmailUtils.generateOTP();
            boolean isSent = EmailUtils.sendOTPEmail(email, otp);

            if (isSent) {
                HttpSession session = request.getSession();
                session.setAttribute("otp", otp);
                session.setAttribute("email", email);
                session.setMaxInactiveInterval(300); // 5 minutes

                request.setAttribute("successMessage", "Mã OTP đã được gửi đến email: " + email);
                request.getRequestDispatcher("view/client/verify-otp.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không thể gửi email. Vui lòng thử lại sau.");
                request.getRequestDispatcher("view/client/forgot-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Thông tin tài khoản hoặc email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("view/client/forgot-password.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Controller";
    }
}

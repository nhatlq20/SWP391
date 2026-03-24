package controllers;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ResetPasswordController extends HttpServlet {

    private static final int MIN_PASSWORD_LENGTH = 8;
    private static final int MAX_PASSWORD_LENGTH = 16;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("view/client/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        if (newPassword == null || newPassword.length() < MIN_PASSWORD_LENGTH
                || newPassword.length() > MAX_PASSWORD_LENGTH) {
            request.setAttribute("errorMessage", "mật khẩu phải có độ dài từ 8 đến 16 kí tự");
            request.getRequestDispatcher("view/client/reset-password.jsp").forward(request, response);
            return;
        }

        if (confirmPassword == null || confirmPassword.length() < MIN_PASSWORD_LENGTH
                || confirmPassword.length() > MAX_PASSWORD_LENGTH) {
            request.setAttribute("errorMessage", "mật khẩu phải có độ dài từ 8 đến 16 kí tự");
            request.getRequestDispatcher("view/client/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword != null && newPassword.equals(confirmPassword)) {
            UserDAO userDAO = new UserDAO();
            boolean updated = userDAO.updatePasswordByEmail(email, newPassword);
            if (updated) {
                session.invalidate();
                request.setAttribute("successMessage", "Mật khẩu đã được đặt lại thành công.");
                request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Email không tồn tại trong hệ thống.");
                request.getRequestDispatcher("view/client/reset-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("view/client/reset-password.jsp").forward(request, response);
        }
    }
}

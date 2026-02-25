package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyOTPController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/client/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");

        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {
            // OTP correct, redirect to reset password page
            response.sendRedirect(request.getContextPath() + "/reset-password");
        } else {
            request.setAttribute("errorMessage", "Mã OTP không chính xác hoặc đã hết hạn.");
            request.getRequestDispatcher("view/client/verify-otp.jsp").forward(request, response);
        }
    }
}

package controllers;

import dao.CustomerDAO;
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
        String action = (String) session.getAttribute("otpAction");

        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {
            if ("register".equals(action)) {
                // Handle Registration
                String fullName = (String) session.getAttribute("regFullName");
                String email = (String) session.getAttribute("regEmail");
                String phone = (String) session.getAttribute("regPhone");
                String password = (String) session.getAttribute("regPassword");

                CustomerDAO customerDAO = new CustomerDAO();
                boolean success = false;
                try {
                    success = customerDAO.registerCustomer(fullName, email, password, phone);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (success) {
                    // Clear session attributes
                    session.removeAttribute("otp");
                    session.removeAttribute("regFullName");
                    session.removeAttribute("regEmail");
                    session.removeAttribute("regPhone");
                    session.removeAttribute("regPassword");
                    session.removeAttribute("otpAction");

                    request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Đăng ký thất bại! Vui lòng thử lại.");
                    request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
                }
            } else {
                // OTP correct for reset password
                response.sendRedirect(request.getContextPath() + "/reset-password");
            }
        } else {
            request.setAttribute("errorMessage", "Mã OTP không chính xác hoặc đã hết hạn.");
            request.getRequestDispatcher("view/client/verify-otp.jsp").forward(request, response);
        }
    }
}

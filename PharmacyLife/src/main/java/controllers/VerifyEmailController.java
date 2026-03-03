package controllers;

import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("regEmail");
        
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        
        request.setAttribute("email", email);
        request.getRequestDispatcher("view/client/verify-email.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("regEmail");

        if ("resend".equals(action)) {
            String otp = utils.EmailUtils.generateOTP();
            boolean isSent = utils.EmailUtils.sendOTPEmail(email, otp, "register");
            if (isSent) {
                session.setAttribute("otp", otp);
                request.setAttribute("successMessage", "Mã OTP mới đã được gửi đến email của bạn.");
            } else {
                request.setAttribute("errorMessage", "Không thể gửi lại mã. Vui lòng thử lại sau.");
            }
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/verify-email.jsp").forward(request, response);
            return;
        }

        String enteredOtp = request.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otp");

        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {
            String fullName = (String) session.getAttribute("regFullName");
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
                // Clear registration session data
                session.removeAttribute("otp");
                session.removeAttribute("regFullName");
                session.removeAttribute("regEmail");
                session.removeAttribute("regPhone");
                session.removeAttribute("regPassword");
                session.removeAttribute("otpAction");

                request.setAttribute("successMessage", "Xác thực email thành công! Chào mừng bạn.");
                request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Đăng ký thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("email", email);
            request.setAttribute("errorMessage", "Mã OTP không chính xác. Vui lòng kiểm tra lại email.");
            request.getRequestDispatcher("view/client/verify-email.jsp").forward(request, response);
        }
    }
}

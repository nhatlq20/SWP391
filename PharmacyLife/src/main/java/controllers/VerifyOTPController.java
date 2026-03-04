package controllers;

import dao.CustomerDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

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
            } else if ("verify-old-email".equals(action)) {
                // OTP correct for old email, move to reset email page
                session.removeAttribute("otp");
                session.removeAttribute("otpAction");
                response.sendRedirect(request.getContextPath() + "/change-email?step=reset-email");
            } else if ("verify-new-email".equals(action)) {
                // OTP correct for new email, update database
                String newEmail = (String) session.getAttribute("newEmailTemp");
                
                // Get user info from session (compatible with multiple session attribute names)
                int userId = -1;
                String roleName = null;
                
                if (session.getAttribute("userId") != null) {
                    userId = (int) session.getAttribute("userId");
                    roleName = (String) session.getAttribute("roleName");
                } else if (session.getAttribute("user") != null) {
                    User userObj = (User) session.getAttribute("user");
                    userId = userObj.getUserID();
                    roleName = (userObj.getRoles() != null && !userObj.getRoles().isEmpty()) ? userObj.getRoles().get(0) : "Customer";
                }
                
                if (newEmail != null && userId != -1) {
                    UserDAO userDAO = new UserDAO();
                    boolean updated = userDAO.updateEmail(userId, roleName, newEmail);
                    
                    if (updated) {
                        // Update session attributes
                        session.setAttribute("userEmail", newEmail);
                        
                        Object loggedInUser = session.getAttribute("loggedInUser");
                        if (loggedInUser instanceof models.Customer) {
                            ((models.Customer) loggedInUser).setEmail(newEmail);
                        } else if (loggedInUser instanceof models.Staff) {
                            ((models.Staff) loggedInUser).setStaffEmail(newEmail);
                        }
                        
                        Object userObj = session.getAttribute("user");
                        if (userObj instanceof models.User) {
                            ((models.User) userObj).setEmail(newEmail);
                        }
                        
                        session.removeAttribute("otp");
                        session.removeAttribute("otpAction");
                        session.removeAttribute("newEmailTemp");
                        
                        // Use sendRedirect to Profile page to prevent form resubmission on F5
                        session.setAttribute("successMessage", "Đổi email thành công!");
                        response.sendRedirect(request.getContextPath() + "/profile");
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Cập nhật email thất bại. Vui lòng thử lại.");
                        request.getRequestDispatcher("view/client/profile.jsp").forward(request, response);
                        return;
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/profile");
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

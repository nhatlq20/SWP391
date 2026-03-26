package controllers;

import dao.ProfileDAO;
import models.Customer;
import models.Staff;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.HashMD5;

/**
 * ChangePasswordController - Handles password change functionality
 * 
 * @author anltc
 */
public class ChangePasswordController extends HttpServlet {

    private static final int MIN_PASSWORD_LENGTH = 8;
    private static final int MAX_PASSWORD_LENGTH = 16;

    /**
     * Handles the HTTP <code>GET</code> method - Display change password page
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Process password change
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        Object loggedInUser = session.getAttribute("loggedInUser");
        String userType = (String) session.getAttribute("userType");
        Integer userId = (Integer) session.getAttribute("userId");

        // Validation
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập mật khẩu hiện tại!");
            request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.length() < MIN_PASSWORD_LENGTH || newPassword.length() > MAX_PASSWORD_LENGTH) {
            request.setAttribute("errorMessage", "mật khẩu không phải có độ dài 8 đến 16 kí tự");
            request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
            return;
        }

        if (confirmPassword == null || confirmPassword.length() < MIN_PASSWORD_LENGTH || confirmPassword.length() > MAX_PASSWORD_LENGTH) {
            request.setAttribute("errorMessage", "mật khẩu không phải có độ dài 8 đến 16 kí tự");
            request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
            return;
        }

        if (currentPassword.equals(newPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới không được trùng với mật khẩu cũ!");
            request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
            return;
        }

        boolean success = false;
        String errorMsg = "";

        try {
            ProfileDAO profileDAO = new ProfileDAO();

            if ("customer".equals(userType) && loggedInUser instanceof Customer) {
                // Change password for Customer
                Customer customer = (Customer) loggedInUser;

                // Verify current password (if user has one)
                if (customer.getPassword() != null && !customer.getPassword().equals(HashMD5.getMd5(currentPassword))) {
                    errorMsg = "Mật khẩu hiện tại không đúng!";
                } else {
                    success = profileDAO.changeCustomerPassword(userId, newPassword);
                    if (!success) {
                        errorMsg = "Đổi mật khẩu thất bại! Vui lòng thử lại.";
                    }
                }

            } else if ("staff".equals(userType) && loggedInUser instanceof Staff) {
                // Change password for Staff
                Staff staff = (Staff) loggedInUser;

                // Verify current password
                if (!staff.getStaffPassword().equals(HashMD5.getMd5(currentPassword))) {
                    errorMsg = "Mật khẩu hiện tại không đúng!";
                } else {
                    success = profileDAO.changeStaffPassword(userId, newPassword);
                    if (!success) {
                        errorMsg = "Đổi mật khẩu thất bại! Vui lòng thử lại.";
                    }
                }
            }

            if (success) {
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");

                // Update password in session
                if ("customer".equals(userType)) {
                    Customer updatedCustomer = profileDAO.getCustomerById(userId);
                    session.setAttribute("loggedInUser", updatedCustomer);
                } else if ("staff".equals(userType)) {
                    Staff updatedStaff = profileDAO.getStaffById(userId);
                    session.setAttribute("loggedInUser", updatedStaff);
                }
            } else {
                request.setAttribute("errorMessage", errorMsg);
            }

        } catch (Exception e) {
            System.out.println("Error changing password: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra! Vui lòng thử lại.");
        }

        request.getRequestDispatcher("view/client/change-password.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Change Password Controller";
    }
}

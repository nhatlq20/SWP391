package controllers.admin;

import dao.StaffDAO;
import models.Staff;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller xử lý đăng nhập dành riêng cho Admin và Staff
 */
public class AdminLoginController extends HttpServlet {

    private void forwardLoginWithError(HttpServletRequest request, HttpServletResponse response, String email,
            String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        if (email != null) {
            request.setAttribute("email", email);
        }
        request.getRequestDispatcher("/view/admin/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        email = email == null ? "" : email.trim().toLowerCase();
        password = password == null ? "" : password.trim();

        StaffDAO staffDAO = new StaffDAO();
        Staff staff = staffDAO.login(email, password);

        if (staff != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", staff);
            session.setAttribute("userType", "staff");
            session.setAttribute("userId", staff.getStaffId());
            session.setAttribute("userName", staff.getStaffName());
            session.setAttribute("userEmail", staff.getStaffEmail());
            session.setAttribute("roleId", staff.getRoleId());
            session.setAttribute("roleName", staff.getRoleName());

            String roleName = staff.getRoleName();
            if ("Admin".equalsIgnoreCase(roleName) || "Staff".equalsIgnoreCase(roleName)) {
                response.sendRedirect(request.getContextPath() + "/admin/medicines-dashboard");
                return;
            }
        }
        
        forwardLoginWithError(request, response, email, "Tài khoản Nội bộ hoặc mật khẩu không đúng!");
    }

    @Override
    public String getServletInfo() {
        return "Admin Login Controller - Handles internal authentication";
    }
}

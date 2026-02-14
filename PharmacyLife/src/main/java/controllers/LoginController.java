/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.CustomerDAO;
import dao.StaffDAO;
import models.Customer;
import models.Staff;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author anltc
 */
public class LoginController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Display login page
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Process login
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ email và mật khẩu!");
            request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        
        // Try to authenticate as Staff first
        StaffDAO staffDAO = new StaffDAO();
        Staff staff = staffDAO.login(email, password);

        if (staff != null) {
            // Staff login successful - Create session
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", staff);
            session.setAttribute("userType", "staff");
            session.setAttribute("userId", staff.getStaffId());
            session.setAttribute("userName", staff.getStaffName());
            session.setAttribute("userEmail", staff.getStaffEmail());
            session.setAttribute("roleId", staff.getRoleId());
            session.setAttribute("roleName", staff.getRoleName());

            // Redirect based on role
            String roleName = staff.getRoleName();
            if ("Admin".equalsIgnoreCase(roleName)) {
                response.sendRedirect(request.getContextPath() + "/Staffmanage");
            } else if ("Staff".equalsIgnoreCase(roleName)) {
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            return;
        }

        // Try to authenticate as Customer
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.login(email, password);

        if (customer != null) {
            // Customer login successful - Create session
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", customer);
            session.setAttribute("userType", "customer");
            session.setAttribute("userId", customer.getCustomerId());
            session.setAttribute("userName", customer.getFullName());
            session.setAttribute("userEmail", customer.getEmail());
            session.setAttribute("roleName", "Customer");

            // Redirect to shopping page
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Login failed
        request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng!");
        request.setAttribute("email", email);
        request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Login Controller - Handles user authentication";
    }

}

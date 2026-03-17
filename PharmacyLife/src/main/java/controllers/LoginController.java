/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.CustomerDAO;
import dao.StaffDAO;
import models.Customer;
import models.Staff;
import models.Cart;
import dao.CartDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.GoogleAccount;
import utils.GoogleUtils;

/**
 *
 * @author anltc
 */
public class LoginController extends HttpServlet {

    private void forwardLoginWithError(HttpServletRequest request, HttpServletResponse response, String email,
            String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        if (email != null) {
            request.setAttribute("email", email);
        }
        request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>GET</code> method - Display login page
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code != null && !code.isEmpty()) {
            // Processing Google callback
            String accessToken = GoogleUtils.getToken(code);
            GoogleAccount googleAccount = GoogleUtils.getUserInfo(accessToken);

            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerByEmail(googleAccount.getEmail());

            if (customer == null) {
                // Email doesn't exist, create a new customer account
                // Using NULL for password since they login with Google
                String defaultPassword = null;
                // Register with full name and email from Google, and an empty phone number
                boolean isRegistered = customerDAO.registerCustomer(
                        googleAccount.getName(),
                        googleAccount.getEmail(),
                        defaultPassword,
                        "" // No phone number from Google usually
                );

                if (isRegistered) {
                    // Try to get the newly created customer
                    customer = customerDAO.getCustomerByEmail(googleAccount.getEmail());
                }
            }

            if (customer != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", customer);
                session.setAttribute("userType", "customer");
                session.setAttribute("userId", customer.getCustomerId());
                session.setAttribute("customerId", customer.getCustomerId());
                session.setAttribute("userName", customer.getFullName());
                session.setAttribute("userEmail", customer.getEmail());
                session.setAttribute("roleName", "customer");

                // Load persistent cart from database
                CartDAO cartDAO_login = new CartDAO();
                Cart cart_login = cartDAO_login.getCartByCustomerId(customer.getCustomerId());
                session.setAttribute("cart", cart_login);

                response.sendRedirect(request.getContextPath() + "/home");
                return;
            } else {
                request.setAttribute("errorMessage", "Không thể tạo tài khoản tự động từ Google. Vui lòng thử lại!");
                request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
                return;
            }
        }
        // Forward to login page
        request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Process login
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        email = email == null ? "" : email.trim().toLowerCase();
        password = password == null ? "" : password.trim();

        // Trang login mặc định chỉ cho Customer
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.login(email, password);

        if (customer != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", customer);
            session.setAttribute("userType", "customer");
            session.setAttribute("userId", customer.getCustomerId());
            session.setAttribute("customerId", customer.getCustomerId());
            session.setAttribute("userName", customer.getFullName());
            session.setAttribute("userEmail", customer.getEmail());
            session.setAttribute("roleName", "customer");

            CartDAO cartDAO_login = new CartDAO();
            Cart cart_login = cartDAO_login.getCartByCustomerId(customer.getCustomerId());
            session.setAttribute("cart", cart_login);

            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        forwardLoginWithError(request, response, email, "Tài khoản Khách hàng hoặc mật khẩu không đúng!");
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

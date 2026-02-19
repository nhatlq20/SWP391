package controllers;

import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * RegisterController - Handles customer registration
 * 
 * @author anltc
 */
public class RegisterController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Display register page
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to register page
        request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Process registration
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
       
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        System.out.println("Received parameters:");
        System.out.println("  FullName: " + fullName);
        System.out.println("  Phone: " + phone);
        System.out.println("  Email: " + email);
        System.out.println("  Password: " + (password != null ? "***" : "null"));
        System.out.println("  ConfirmPassword: " + (confirmPassword != null ? "***" : "null"));

        // Validate input
        if (fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            
            System.out.println("Validation failed: Missing fields");
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            return;
        }

        // Trim inputs
        fullName = fullName.trim();
        phone = phone.trim();
        email = email.trim();

        // Validate password match
        if (!password.equals(confirmPassword)) {
            System.out.println("Validation failed: Password mismatch");
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 6) {
            System.out.println("Validation failed: Password too short");
            request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            System.out.println("Validation failed: Invalid email format");
            request.setAttribute("errorMessage", "Email không hợp lệ!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            return;
        }

        // Validate phone format (Vietnamese phone)
        if (!phone.matches("^[0-9]{10,11}$")) {
            System.out.println("Validation failed: Invalid phone format");
            request.setAttribute("errorMessage", "Số điện thoại không hợp lệ! (10-11 số)");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            return;
        }

        System.out.println("All validations passed");
        
        // Check if email already exists
        System.out.println("Checking if email exists...");
        CustomerDAO customerDAO = new CustomerDAO();
        
        try {
            if (customerDAO.isEmailExists(email)) {
                System.out.println("Email already exists");
                request.setAttribute("errorMessage", "Email này đã được đăng ký!");
                request.setAttribute("fullName", fullName);
                request.setAttribute("phone", phone);
                request.setAttribute("email", email);
                request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
                return;
            }
            System.out.println("Email is available");
        } catch (Exception e) {
            System.out.println("Error checking email: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống! Vui lòng thử lại sau.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
            return;
        }

        // Register customer
        System.out.println("Attempting to register customer...");
        boolean success = false;
        try {
            success = customerDAO.registerCustomer(fullName, email, password, phone);
        } catch (Exception e) {
            System.out.println("Exception during registration: " + e.getMessage());
            e.printStackTrace();
        }

        if (success) {
            // Registration successful - Set success message and redirect to login
            System.out.println("Registration successful!");
            
            request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
        } else {
            // Registration failed
            System.out.println("Registration failed!");
           
            request.setAttribute("errorMessage", "Đăng ký thất bại! Vui lòng thử lại.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Register Controller - Handles customer registration";
    }
}

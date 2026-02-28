package controllers;

import dao.CustomerDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.regex.Pattern;
import models.User;

/**
 * RegisterController - Handles customer registration
 * 
 * @author anltc
 */
public class RegisterController extends HttpServlet {

        private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*@(gmail\\.com|yahoo\\.com|fucantho|fucantho\\.edu\\.vn)$");
    private static final Pattern FULL_NAME_PATTERN = Pattern.compile("^[\\p{L}][\\p{L}\\s'.-]{1,99}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0(3|5|7|8|9)\\d{8}$");
    private static final int MAX_EMAIL_LENGTH = 254;
    private static final int MIN_PASSWORD_LENGTH = 8;
    private static final int MAX_PASSWORD_LENGTH = 16;

    private void forwardRegisterError(HttpServletRequest request, HttpServletResponse response,
            String message, String fullName, String phone, String email) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("fullName", fullName);
        request.setAttribute("phone", phone);
        request.setAttribute("email", email);
        request.getRequestDispatcher("view/client/register.jsp").forward(request, response);
    }

    private String normalizeName(String name) {
        if (name == null) {
            return "";
        }
        return name.trim().replaceAll("\\s+", " ");
    }

    private String normalizeEmail(String email) {
        if (email == null) {
            return "";
        }
        return email.trim().toLowerCase();
    }

    private String normalizePhone(String phone) {
        if (phone == null) {
            return "";
        }
        String normalized = phone.trim().replaceAll("[\\s.-]", "");
        if (normalized.startsWith("+84") && normalized.length() == 12) {
            return "0" + normalized.substring(3);
        }
        if (normalized.startsWith("84") && normalized.length() == 11) {
            return "0" + normalized.substring(2);
        }
        return normalized;
    }

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

        fullName = normalizeName(fullName);
        phone = normalizePhone(phone);
        email = normalizeEmail(email);
        password = password != null ? password : "";
        confirmPassword = confirmPassword != null ? confirmPassword : "";

        // Validate input
        if (fullName.isEmpty() || phone.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            forwardRegisterError(request, response, "Vui lòng nhập đầy đủ thông tin!", fullName, phone, email);
            return;
        }

        if (fullName.length() < 2 || fullName.length() > 100 || !FULL_NAME_PATTERN.matcher(fullName).matches()) {
            forwardRegisterError(request, response, "Họ tên không hợp lệ!", fullName, phone, email);
            return;
        }

        if (email.length() > MAX_EMAIL_LENGTH || !EMAIL_PATTERN.matcher(email).matches()) {
            forwardRegisterError(request, response, "Email không hợp lệ!", fullName, phone, email);
            return;
        }

        if (!PHONE_PATTERN.matcher(phone).matches()) {
            forwardRegisterError(request, response, "Số điện thoại không hợp lệ!", fullName, phone, email);
            return;
        }

        if (password.length() < MIN_PASSWORD_LENGTH || password.length() > MAX_PASSWORD_LENGTH) {
            forwardRegisterError(request, response, "Mật khẩu phải từ 8 đến 16 ký tự!", fullName, phone, email);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            forwardRegisterError(request, response, "Mật khẩu xác nhận không khớp!", fullName, phone, email);
            return;
        }

        // Check if email already exists
        CustomerDAO customerDAO = new CustomerDAO();
        UserDAO userDAO = new UserDAO();

        try {
            User existingUser = userDAO.findByUsernameOrEmail(email);
            if (existingUser != null || customerDAO.isEmailExists(email)) {
                forwardRegisterError(request, response, "Email này đã được đăng ký!", fullName, phone, email);
                return;
            }
        } catch (Exception e) {
            forwardRegisterError(request, response, "Lỗi hệ thống! Vui lòng thử lại sau.", fullName, phone, email);
            return;
        }

        // Register customer
        boolean success = false;
        try {
            success = customerDAO.registerCustomer(fullName, email, password, phone);
        } catch (Exception ignored) {
        }

        if (success) {
            // Registration successful - Set success message and redirect to login
            request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/client/login.jsp").forward(request, response);
        } else {
            // Registration failed
            forwardRegisterError(request, response, "Đăng ký thất bại! Vui lòng thử lại.", fullName, phone, email);
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

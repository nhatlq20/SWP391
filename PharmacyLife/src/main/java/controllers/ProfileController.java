package controllers;

import dao.ProfileDAO;
import models.Customer;
import models.Staff;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * ProfileController - Handles user profile view and update
 * 
 * @author anltc
 */
public class ProfileController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Display profile page
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        Object loggedInUser = session.getAttribute("loggedInUser");
        String userType = (String) session.getAttribute("userType");
        
        // Create a unified user object for the view
        ProfileUser user = new ProfileUser();
        
        if ("customer".equals(userType) && loggedInUser instanceof Customer) {
            Customer customer = (Customer) loggedInUser;
            user.setFullName(customer.getFullName());
            user.setEmail(customer.getEmail());
            user.setPhone(customer.getPhone());
            user.setAddress(customer.getAddress());
            user.setDob(customer.getDob());
            user.setGender(customer.getGender());
            
        } else if ("staff".equals(userType) && loggedInUser instanceof Staff) {
            Staff staff = (Staff) loggedInUser;
            user.setFullName(staff.getStaffName());
            user.setEmail(staff.getStaffEmail());
            user.setPhone(staff.getStaffPhone());
            user.setAddress(staff.getStaffAddress());
            user.setDob(staff.getStaffDob());
            String staffGender = staff.getStaffGender();
            if (staffGender == null || staffGender.trim().isEmpty()) {
                staffGender = "Khác";
            }
            user.setGender(staffGender);
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("view/client/profile.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Update profile
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");
        
        Object loggedInUser = session.getAttribute("loggedInUser");
        String userType = (String) session.getAttribute("userType");
        Integer userId = (Integer) session.getAttribute("userId");
        
        boolean success = false;
        
        try {
            ProfileDAO profileDAO = new ProfileDAO();
            
            if ("customer".equals(userType) && loggedInUser instanceof Customer) {
                // Update Customer
                Date dob = null;
                if (dobStr != null && !dobStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    dob = sdf.parse(dobStr);
                }
                
                success = profileDAO.updateCustomerProfile(userId, fullName, phone, address, dob, gender);
                
                if (success) {
                    // Reload customer data
                    Customer updatedCustomer = profileDAO.getCustomerById(userId);
                    session.setAttribute("loggedInUser", updatedCustomer);
                    session.setAttribute("userName", updatedCustomer.getFullName());
                }
                
            } else if ("staff".equals(userType) && loggedInUser instanceof Staff) {
                // Update Staff
                Date staffDob = null;
                if (dobStr != null && !dobStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    staffDob = sdf.parse(dobStr);
                }

                success = profileDAO.updateStaffProfile(userId, fullName, phone, address, staffDob, gender);
                
                if (success) {
                    // Reload staff data
                    Staff updatedStaff = profileDAO.getStaffById(userId);
                    session.setAttribute("loggedInUser", updatedStaff);
                    session.setAttribute("userName", updatedStaff.getStaffName());
                }
            }
            
            if (success) {
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại! Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            System.out.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra! Vui lòng thử lại.");
        }
        
        // Forward back to profile page
        doGet(request, response);
    }

    /**
     * Helper class to unify Customer and Staff data for the view
     */
    public static class ProfileUser {
        private String fullName;
        private String email;
        private String phone;
        private String address;
        private Date dob;
        private String gender;

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }
        
        public Date getDob() { return dob; }
        public void setDob(Date dob) { this.dob = dob; }
        
        public String getGender() { return gender; }
        public void setGender(String gender) { this.gender = gender; }
    }

    @Override
    public String getServletInfo() {
        return "Profile Controller - Handles user profile management";
    }
}

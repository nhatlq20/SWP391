package controllers;

import dao.ProfileDAO;
import models.Customer;
import models.Staff;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;
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

    private static final Pattern FULL_NAME_PATTERN = Pattern.compile("^[\\p{L}][\\p{L}\\s'.-]{1,99}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9}$");
    private static final Pattern ADDRESS_PATTERN = Pattern.compile("^[\\p{L}\\p{N}\\s.,-]+$");

    private String normalizeName(String name) {
        if (name == null) {
            return "";
        }
        return name.trim().replaceAll("\\s+", " ");
    }

    private String normalizePhone(String phone) {
        if (phone == null) {
            return "";
        }
        return phone.trim().replaceAll("[\\s.-]", "");
    }

    private String normalizeAddress(String address) {
        if (address == null) {
            return "";
        }
        return address.trim().replaceAll("\\s+", " ");
    }

    private Date parseDob(String dobStr) throws Exception {
        if (dobStr == null || dobStr.trim().isEmpty()) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        return sdf.parse(dobStr.trim());
    }

    private Date todayWithoutTime() {
        Date now = new Date();
        return new Date(now.getYear(), now.getMonth(), now.getDate());
    }

    private void forwardProfileError(HttpServletRequest request, HttpServletResponse response,
            Object loggedInUser, String userType,
            String fullName, String phone, String address, String dobStr, String gender, String message)
            throws ServletException, IOException {
        ProfileUser user = new ProfileUser();
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setGender(gender);

        try {
            user.setDob(parseDob(dobStr));
        } catch (Exception ignored) {
            user.setDob(null);
        }

        if ("customer".equals(userType) && loggedInUser instanceof Customer) {
            user.setEmail(((Customer) loggedInUser).getEmail());
            user.setRoleID(0);
        } else if ("staff".equals(userType) && loggedInUser instanceof Staff) {
            user.setEmail(((Staff) loggedInUser).getStaffEmail());
            user.setRoleID(((Staff) loggedInUser).getRoleId());
        }

        request.setAttribute("errorMessage", message);
        request.setAttribute("user", user);
        request.getRequestDispatcher("view/client/profile.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>GET</code> method - Display profile page
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
            user.setRoleID(0); // Use 0 to represent customer since they don't have roleId

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
            // Staff has getRoleId() (lowercase 'd')
            user.setRoleID(staff.getRoleId());
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("view/client/profile.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method - Update profile
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
        String fullName = normalizeName(request.getParameter("fullName"));
        String phone = normalizePhone(request.getParameter("phone"));
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String address = normalizeAddress(request.getParameter("address"));

        Object loggedInUser = session.getAttribute("loggedInUser");
        String userType = (String) session.getAttribute("userType");
        Integer userId = (Integer) session.getAttribute("userId");
        Integer roleId = (Integer) session.getAttribute("roleId");

        // Repopulate disabled fields from session if user is Admin/Staff
        // In this system, Staff and Admin often share the "staff" userType but check roleId
        if (("staff".equals(userType) || (roleId != null && (roleId == 1 || roleId == 2))) && loggedInUser instanceof Staff) {
            Staff staff = (Staff) loggedInUser;
            // Only update phone from request, keep other fields from current staff session if they are disabled in JSP
            fullName = staff.getStaffName();
            address = staff.getStaffAddress();
            gender = staff.getStaffGender();
            if (staff.getStaffDob() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dobStr = sdf.format(staff.getStaffDob());
            }
        }

        boolean success = false;

        try {
            // Only validate fullName if it's NOT a staff/admin (because for staff/admin it's disabled and we use session data)
            boolean isStaffOrAdmin = (("staff".equals(userType) || (roleId != null && (roleId == 1 || roleId == 2))) && loggedInUser instanceof Staff);

            if (!isStaffOrAdmin) {
                if (fullName.isEmpty() || !FULL_NAME_PATTERN.matcher(fullName).matches()) {
                    forwardProfileError(request, response, loggedInUser, userType,
                            fullName, phone, address, dobStr, gender,
                            "Họ tên không hợp lệ!");
                    return;
                }

                if (!address.isEmpty() && !ADDRESS_PATTERN.matcher(address).matches()) {
                    forwardProfileError(request, response, loggedInUser, userType,
                            fullName, phone, address, dobStr, gender,
                            "Địa chỉ không hợp lệ! Chỉ được dùng chữ, số, khoảng trắng và các ký tự . , -");
                    return;
                }
            }

            if (!phone.isEmpty() && !PHONE_PATTERN.matcher(phone).matches()) {
                forwardProfileError(request, response, loggedInUser, userType,
                        fullName, phone, address, dobStr, gender,
                        "Số điện thoại phải bắt đầu bằng 0 và có đúng 10 số!");
                return;
            }

            Date parsedDob = null;
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    parsedDob = parseDob(dobStr);
                } catch (Exception e) {
                    if (!isStaffOrAdmin) {
                        forwardProfileError(request, response, loggedInUser, userType,
                                fullName, phone, address, dobStr, gender,
                                "Ngày sinh không hợp lệ!");
                        return;
                    }
                }

                if (parsedDob != null && parsedDob.after(todayWithoutTime())) {
                    forwardProfileError(request, response, loggedInUser, userType,
                            fullName, phone, address, dobStr, gender,
                            "Ngày sinh không được vượt quá thời điểm hiện tại!");
                    return;
                }
            }

            ProfileDAO profileDAO = new ProfileDAO();

            if ("customer".equals(userType) && loggedInUser instanceof Customer) {
                // Update Customer
                success = profileDAO.updateCustomerProfile(userId, fullName, phone, address, parsedDob, gender);

                if (success) {
                    // Reload customer data
                    Customer updatedCustomer = profileDAO.getCustomerById(userId);
                    session.setAttribute("loggedInUser", updatedCustomer);
                    session.setAttribute("userName", updatedCustomer.getFullName());
                }

            } else if (loggedInUser instanceof Staff) {
                // Update Staff or Admin
                success = profileDAO.updateStaffProfile(userId, fullName, phone, address, parsedDob, gender);

                if (success) {
                    // Reload data
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
        private int roleID;

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public Date getDob() {
            return dob;
        }

        public void setDob(Date dob) {
            this.dob = dob;
        }

        public String getGender() {
            return gender;
        }

        public void setGender(String gender) {
            this.gender = gender;
        }

        public int getRoleID() {
            return roleID;
        }

        public void setRoleID(int roleID) {
            this.roleID = roleID;
        }
    }

    @Override
    public String getServletInfo() {
        return "Profile Controller - Handles user profile management";
    }
}

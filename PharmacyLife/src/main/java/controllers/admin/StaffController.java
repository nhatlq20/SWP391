package controllers.admin;

import dao.StaffDAO;
import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;
import models.Staff;
import models.Role;
import models.User;
import utils.EmailUtils;

public class StaffController extends HttpServlet {

    private static final Pattern FULL_NAME_PATTERN = Pattern.compile("^[\\p{L}][\\p{L}\\s'.-]{1,99}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*@(gmail\\.com|yahoo\\.com|fucantho|fucantho\\.edu\\.vn|pharmacy\\.com|pharmacylife\\.com)$");
    private static final int MAX_EMAIL_LENGTH = 254;
    private static final int MIN_PASSWORD_LENGTH = 8;
    private static final int MAX_PASSWORD_LENGTH = 16;

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

    private void forwardAddWithError(HttpServletRequest request, HttpServletResponse response,
            String message, String staffName, String staffEmail)
            throws ServletException, IOException {
        try {
            RoleDAO roleDao = new RoleDAO();
            List<Role> roleList = roleDao.getAllRoles();
            if (roleList == null) {
                roleList = new ArrayList<>();
            }
            request.setAttribute("roleList", roleList);
        } catch (Exception e) {
            request.setAttribute("roleList", new ArrayList<Role>());
        }

        request.setAttribute("errorMessage", message);
        request.setAttribute("staffName", staffName);
        request.setAttribute("staffEmail", staffEmail);
        request.getRequestDispatcher("/view/admin/staff-add.jsp").forward(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");
        if (!"Admin".equalsIgnoreCase(roleName)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        StaffDAO dao = new StaffDAO();

        switch (action) {

            case "list":
                String sort = request.getParameter("sort");
                String successMsg = request.getParameter("success");
                if ("1".equals(successMsg)) {
                    request.setAttribute("successMessage", "Thêm nhân viên mới thành công!");
                }
                List<Staff> staffList = dao.getAllStaff(sort);
                if (staffList == null) {
                    staffList = new ArrayList<>();
                }
                if (session != null) {
                    Object currentUser = session.getAttribute("loggedInUser");
                    if (currentUser instanceof Staff) {
                        int currId = ((Staff) currentUser).getStaffId();
                        staffList.removeIf(s -> s.getStaffId() == currId);
                    }
                }

                System.out.println("DAO size = " + staffList.size());
                request.setAttribute("staffList", staffList);
                request.setAttribute("currentSort", sort);
                request.getRequestDispatcher("/view/admin/staff-list.jsp").forward(request, response);
                break;

            case "detail":
                try {
                    int did = Integer.parseInt(request.getParameter("id"));
                    Staff sd = dao.getStaffById(did);
                    request.setAttribute("staff", sd);
                    request.getRequestDispatcher("/view/admin/staff-detail.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/admin/manage-staff");
                }
                break;

            case "delete":
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    Staff staffToDelete = dao.getStaffById(deleteId);
                    if (staffToDelete != null) {
                        // Gửi email thông báo dừng hợp tác trước khi xóa
                        EmailUtils.sendStaffTerminationEmail(staffToDelete.getStaffEmail(), staffToDelete.getStaffName());
                        dao.deleteStaff(deleteId);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/admin/manage-staff");
                break;

            case "add":
                try {
                    RoleDAO roleDao = new RoleDAO();
                    List<Role> roleList = roleDao.getAllRoles();
                    if (roleList == null) {
                        roleList = new ArrayList<>();
                    }
                    request.setAttribute("roleList", roleList);
                    System.out.println("Loaded " + roleList.size() + " roles for add form");
                } catch (Exception e) {
                    System.out.println("Error loading roles: " + e.getMessage());
                    e.printStackTrace();
                }
                request.getRequestDispatcher("/view/admin/staff-add.jsp").forward(request, response);
                break;

            case "insert":
                try {
                    String staffName = normalizeName(request.getParameter("staffName"));
                    String staffEmail = normalizeEmail(request.getParameter("staffEmail"));
                    String staffPassword = request.getParameter("staffPassword");
                    String staffPhone = request.getParameter("staffPhone");
                    String staffAddress = request.getParameter("staffAddress");
                    String staffGender = request.getParameter("staffGender");
                    String staffDobStr = request.getParameter("staffDob");
                    
                    if (staffPassword == null) {
                        staffPassword = "";
                    }

                    System.out.println("\n=== ADD STAFF REQUEST ===");
                    System.out.println("Name: " + staffName);
                    System.out.println("Email: " + staffEmail);

                    if (staffName.isEmpty()) {
                        forwardAddWithError(request, response, "Vui lòng nhập họ tên nhân viên!", staffName, staffEmail);
                        return;
                    }

                    if (staffName.length() < 2 || staffName.length() > 100 || !FULL_NAME_PATTERN.matcher(staffName).matches()) {
                        forwardAddWithError(request, response, "Họ tên không hợp lệ!", staffName, staffEmail);
                        return;
                    }

                    if (staffEmail.isEmpty()) {
                        forwardAddWithError(request, response, "Vui lòng nhập email nhân viên!", staffName, staffEmail);
                        return;
                    }

                    if (staffEmail.length() > MAX_EMAIL_LENGTH || !EMAIL_PATTERN.matcher(staffEmail).matches()) {
                        forwardAddWithError(request, response,
                                "Email không chính xác!",
                                staffName, staffEmail);
                        return;
                    }

                    UserDAO userDAO = new UserDAO();
                    User existedUser = userDAO.findByEmail(staffEmail);
                    if (existedUser != null) {
                        forwardAddWithError(request, response, "Email này đã được đăng ký!", staffName, staffEmail);
                        return;
                    }

                    if (staffPassword.length() < MIN_PASSWORD_LENGTH || staffPassword.length() > MAX_PASSWORD_LENGTH) {
                        forwardAddWithError(request, response, "mật khẩu phải có độ dài từ 8 đến 16 kí tự", staffName, staffEmail);
                        return;
                    }

                    RoleDAO roleDao = new RoleDAO();
                    Integer roleId = roleDao.getRoleIdByName("Staff");

                    if (roleId == null) {
                        System.out.println("ERROR: Role 'nhân viên' not found in database");
                        forwardAddWithError(request, response, "Không tìm thấy vai trò nhân viên!", staffName, staffEmail);
                        return;
                    }
                    System.out.println("Role ID: " + roleId);

                    Staff newStaff = new Staff();
                    newStaff.setStaffName(staffName);
                    newStaff.setStaffEmail(staffEmail);
                    newStaff.setStaffPassword(staffPassword);
                    newStaff.setStaffPhone(staffPhone);
                    newStaff.setStaffAddress(staffAddress);
                    newStaff.setStaffGender(staffGender);
                    newStaff.setRoleId(roleId);

                    if (staffDobStr != null && !staffDobStr.isEmpty()) {
                        try {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            newStaff.setStaffDob(sdf.parse(staffDobStr));
                        } catch (Exception e) {
                            System.out.println("Error parsing date: " + staffDobStr);
                        }
                    }

                    boolean success = dao.insertStaff(newStaff);

                    if (success) {
                        System.out.println("Staff added successfully!");
                        // Gửi email thông báo tài khoản
                        EmailUtils.sendStaffAccountEmail(staffEmail, staffName, staffPassword);
                        response.sendRedirect(request.getContextPath() + "/admin/manage-staff?success=1");
                    } else {
                        System.out.println("ERROR: Failed to insert staff");
                        forwardAddWithError(request, response, "Thêm nhân viên thất bại! Vui lòng thử lại.", staffName, staffEmail);
                    }
                    System.out.println("===  END ===\n");
                } catch (Exception e) {
                    System.out.println("ERROR: " + e.getMessage());
                    e.printStackTrace();
                    forwardAddWithError(request, response, "Có lỗi xảy ra! Vui lòng thử lại.",
                            normalizeName(request.getParameter("staffName")),
                            normalizeEmail(request.getParameter("staffEmail")));
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/manage-staff");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
package controllers;

import dao.StaffDAO;
import dao.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import models.Staff;
import models.Role;

public class StaffController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check - Only Admin can access staff management
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");
        if (!"Admin".equalsIgnoreCase(roleName)) {
            // User is not Admin, redirect to home or error page
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        StaffDAO dao = new StaffDAO();

        switch (action) {

            case "list":
                List<Staff> staffList = dao.getAllStaff();
                if (staffList == null) {
                    staffList = new ArrayList<>();
                }
                // Exclude currently logged-in staff (if the session user is a Staff)
                if (session != null) {
                    Object currentUser = session.getAttribute("loggedInUser");
                    if (currentUser instanceof Staff) {
                        int currId = ((Staff) currentUser).getStaffId();
                        staffList.removeIf(s -> s.getStaffId() == currId);
                    }
                }

                System.out.println("DAO size = " + staffList.size());
                request.setAttribute("staffList", staffList);
                request.getRequestDispatcher("/view/autho/staff-list.jsp").forward(request, response);
                break;

            case "detail":
                try {
                    int did = Integer.parseInt(request.getParameter("id"));
                    Staff sd = dao.getStaffById(did);
                    request.setAttribute("staff", sd);
                    request.getRequestDispatcher("/view/autho/staff-detail.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/manage-staff");
                }
                break;

            case "delete":
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    dao.deleteStaff(deleteId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/manage-staff");
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
                request.getRequestDispatcher("/view/autho/staff-add.jsp").forward(request, response);
                break;

            case "insert":
                try {
                    String staffName = request.getParameter("staffName");
                    String staffEmail = request.getParameter("staffEmail");
                    String staffPassword = request.getParameter("staffPassword");

                    System.out.println("\n=== ADD STAFF REQUEST ===");
                    System.out.println("Name: " + staffName);
                    System.out.println("Email: " + staffEmail);
                    System.out.println("Password provided: " + (staffPassword != null && !staffPassword.isEmpty()));

                    // Validate input
                    if (staffName == null || staffName.trim().isEmpty()) {
                        System.out.println("ERROR: Staff name is required");
                        response.sendRedirect(request.getContextPath() + "/manage-staff");
                        return;
                    }
                    if (staffEmail == null || staffEmail.trim().isEmpty()) {
                        System.out.println("ERROR: Staff email is required");
                        response.sendRedirect(request.getContextPath() + "/manage-staff");
                        return;
                    }

                    if (staffPassword == null || staffPassword.trim().isEmpty()) {
                        System.out.println("ERROR: Staff password is required");
                        response.sendRedirect(request.getContextPath() + "/manage-staff");
                        return;
                    }

                    // Get roleId for "nhân viên"
                    RoleDAO roleDao = new RoleDAO();
                    Integer roleId = roleDao.getRoleIdByName("Staff");

                    if (roleId == null) {
                        System.out.println("ERROR: Role 'nhân viên' not found in database");
                        response.sendRedirect(request.getContextPath() + "/manage-staff");
                        return;
                    }
                    System.out.println("Role ID: " + roleId);

                    // Create Staff object with only required fields
                    Staff newStaff = new Staff();
                    newStaff.setStaffCode("ST" + System.currentTimeMillis());
                    newStaff.setStaffName(staffName.trim());
                    newStaff.setStaffEmail(staffEmail.trim());
                    newStaff.setStaffPassword(staffPassword.trim());
                    newStaff.setRoleId(roleId);

                    System.out.println("Staff Code: " + newStaff.getStaffCode());

                    // Insert into database
                    boolean success = dao.insertStaff(newStaff);

                    if (success) {
                        System.out.println("Staff added successfully!");
                    } else {
                        System.out.println("ERROR: Failed to insert staff");
                    }
                    System.out.println("===  END ===\n");

                    response.sendRedirect(request.getContextPath() + "/manage-staff");
                } catch (Exception e) {
                    System.out.println("ERROR: " + e.getMessage());
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/manage-staff");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/manage-staff");
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

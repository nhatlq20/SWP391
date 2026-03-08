package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.Staff;
import utils.DBContext;

public class StaffDAO {

    // 1. Lấy danh sách staff
    public List<Staff> getAllStaff() {
        return getAllStaff(null);
    }

    public List<Staff> getAllStaff(String sortOrder) {
        List<Staff> list = new ArrayList<>();

        String sql = "SELECT s.StaffId, s.StaffCode, s.StaffName, s.StaffPhone, s.StaffAddress, s.StaffDob, r.RoleName, s.StaffIsActive, s.StaffEmail, s.StaffGender "
               + "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId";
        
        if (sortOrder != null && !sortOrder.isEmpty()) {
            if ("asc".equalsIgnoreCase(sortOrder)) {
                sql += " ORDER BY s.StaffCode ASC";
            } else if ("desc".equalsIgnoreCase(sortOrder)) {
                sql += " ORDER BY s.StaffCode DESC";
            }
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Staff s = new Staff();
                s.setStaffId(rs.getInt("StaffId"));
                s.setStaffCode(rs.getString("StaffCode"));
                s.setStaffName(rs.getString("StaffName"));
                s.setStaffPhone(rs.getString("StaffPhone"));
                s.setStaffAddress(rs.getString("StaffAddress"));
                s.setStaffDob(rs.getDate("StaffDob"));
                s.setRoleName(rs.getString("RoleName"));
                s.setActive(rs.getBoolean("StaffIsActive"));
                s.setStaffEmail(rs.getString("StaffEmail"));
                s.setStaffGender(rs.getString("StaffGender"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 2. Lấy staff theo ID
    public Staff getStaffById(int id) {

        String sql = "SELECT s.StaffId, s.StaffCode, s.StaffName, s.StaffPhone, s.StaffAddress, s.StaffDob, r.RoleName, s.StaffIsActive, s.StaffEmail, s.StaffGender, s.RoleId "
               + "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId "
               + "WHERE s.StaffId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Staff s = new Staff();
                s.setStaffId(rs.getInt("StaffId"));
                s.setStaffCode(rs.getString("StaffCode"));
                s.setStaffName(rs.getString("StaffName"));
                s.setStaffPhone(rs.getString("StaffPhone"));
                s.setStaffAddress(rs.getString("StaffAddress"));
                s.setStaffDob(rs.getDate("StaffDob"));
                s.setRoleName(rs.getString("RoleName"));
                s.setActive(rs.getBoolean("StaffIsActive"));
                s.setStaffEmail(rs.getString("StaffEmail"));
                s.setStaffGender(rs.getString("StaffGender"));
                s.setRoleId(rs.getInt("RoleId"));

                return s;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // 3. Xóa staff
    public void deleteStaff(int id) {

        String sql = "DELETE FROM Staff WHERE StaffId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Insert Staff
    public boolean insertStaff(models.Staff s) {
        // First, get the next ID to be generated (to form the StaffCode)
        String sqlNextId = "SELECT IDENT_CURRENT('Staff') + IDENT_INCR('Staff') as next_id";
        int nextId = 1;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement psId = conn.prepareStatement(sqlNextId);
             ResultSet rsId = psId.executeQuery()) {
            if (rsId.next()) {
                nextId = rsId.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error getting next identity value: " + e.getMessage());
            // Fallback: Use MAX(StaffId) + 1
            String sqlMaxId = "SELECT MAX(StaffId) FROM Staff";
            try (Connection conn = new DBContext().getConnection();
                 PreparedStatement psMax = conn.prepareStatement(sqlMaxId);
                 ResultSet rsMax = psMax.executeQuery()) {
                if (rsMax.next()) {
                    nextId = rsMax.getInt(1) + 1;
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        String staffCode = String.format("ST%03d", nextId);
        s.setStaffCode(staffCode);

        // Standard Insert including StaffCode to avoid NOT NULL constraints
        String sql = "INSERT INTO Staff (StaffCode, StaffName, StaffEmail, StaffPassword, StaffPhone, StaffAddress, StaffDob, StaffGender, RoleId, StaffIsActive, StaffCreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            System.out.println("\n=== INSERT STAFF ===");
            System.out.println("Predicted Code: " + staffCode);

            ps.setString(1, staffCode);
            ps.setString(2, s.getStaffName());
            ps.setString(3, s.getStaffEmail());
            ps.setString(4, s.getStaffPassword() != null ? s.getStaffPassword() : "");
            ps.setString(5, s.getStaffPhone() != null ? s.getStaffPhone() : "");
            ps.setString(6, s.getStaffAddress() != null ? s.getStaffAddress() : "");
            if (s.getStaffDob() != null) {
                ps.setDate(7, new java.sql.Date(s.getStaffDob().getTime()));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }
            ps.setString(8, s.getStaffGender() != null ? s.getStaffGender() : "Khác");
            ps.setInt(9, s.getRoleId());
            ps.setBoolean(10, true);
            ps.setTimestamp(11, new java.sql.Timestamp(System.currentTimeMillis()));

            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int actualId = rs.getInt(1);
                        s.setStaffId(actualId);
                        
                        // Verification: If predicted ID was wrong, update it finally
                        String actualCode = String.format("ST%03d", actualId);
                        if (!actualCode.equals(staffCode)) {
                            String updateSql = "UPDATE Staff SET StaffCode = ? WHERE StaffId = ?";
                            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                                psUpdate.setString(1, actualCode);
                                psUpdate.setInt(2, actualId);
                                psUpdate.executeUpdate();
                                s.setStaffCode(actualCode);
                            }
                        }
                    }
                }
                System.out.println("SUCCESS: Staff created with Code " + s.getStaffCode());
                return true;
            }
        } catch (SQLException e) {
            System.out.println("SQL ERROR: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 5. Login - Authenticate user by email and password
    public Staff login(String email, String password) {
        String sql = "SELECT s.StaffId, s.StaffCode, s.StaffName, s.StaffEmail, s.StaffPassword, s.StaffPhone, s.StaffAddress, s.StaffDob, s.StaffGender, s.RoleId, r.RoleName, s.StaffIsActive " +
                     "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId " +
                     "WHERE s.StaffEmail = ? AND s.StaffPassword = ? AND s.StaffIsActive = 1";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Staff staff = new Staff();
                staff.setStaffId(rs.getInt("StaffId"));
                staff.setStaffCode(rs.getString("StaffCode"));
                staff.setStaffName(rs.getString("StaffName"));
                staff.setStaffEmail(rs.getString("StaffEmail"));
                staff.setStaffPassword(rs.getString("StaffPassword"));
                staff.setStaffPhone(rs.getString("StaffPhone"));
                staff.setStaffAddress(rs.getString("StaffAddress"));
                staff.setStaffDob(rs.getDate("StaffDob"));
                staff.setStaffGender(rs.getString("StaffGender"));
                staff.setRoleId(rs.getInt("RoleId"));
                staff.setRoleName(rs.getString("RoleName"));
                staff.setActive(rs.getBoolean("StaffIsActive"));

                return staff;
            }

        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
    
}

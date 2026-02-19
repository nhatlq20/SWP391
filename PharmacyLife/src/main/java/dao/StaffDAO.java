package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Staff;
import utils.DBContext;

public class StaffDAO {

    // 1. Lấy danh sách staff
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();

        String sql = "SELECT s.StaffId, s.StaffCode, s.StaffName, s.StaffPhone, r.RoleName, s.StaffIsActive, s.StaffEmail, s.StaffGender "
               + "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Staff s = new Staff();
                s.setStaffId(rs.getInt("StaffId"));
                s.setStaffCode(rs.getString("StaffCode"));
                s.setStaffName(rs.getString("StaffName"));
                s.setStaffPhone(rs.getString("StaffPhone"));
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

        String sql = "SELECT s.StaffId, s.StaffCode, s.StaffName, s.StaffPhone, r.RoleName, s.StaffIsActive, s.StaffEmail, s.StaffGender, s.RoleId "
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

    // Helper: Generate next staff code (ST001, ST002, etc)
    public String generateNextStaffCode() {
        String sql = "SELECT MAX(CAST(SUBSTRING(StaffCode, 3, 3) AS INT)) as maxCode FROM Staff WHERE StaffCode LIKE 'ST%'";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int maxCode = rs.getInt("maxCode");
                if (rs.wasNull()) {
                    maxCode = 0;
                }
                int nextCode = maxCode + 1;
                String newCode = String.format("ST%03d", nextCode);
                System.out.println("Generated StaffCode: " + newCode);
                return newCode;
            }

        } catch (Exception e) {
            System.out.println("Error generating staff code: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Fallback to ST001 if error
        return "ST001";
    }

    // 4. Insert Staff
    public boolean insertStaff(models.Staff s) {
        // Generate staff code
        String staffCode = generateNextStaffCode();
        s.setStaffCode(staffCode);
        
        // Insert including StaffPassword (keep column order aligned with database)
        String sql = "INSERT INTO Staff (StaffCode, StaffName, StaffEmail, StaffPassword, StaffPhone, StaffGender, RoleId, StaffIsActive) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("\n=== INSERT STAFF ===");
            System.out.println("Code: " + staffCode);
            System.out.println("Name: " + s.getStaffName());
            System.out.println("Email: " + s.getStaffEmail());
            System.out.println("RoleId: " + s.getRoleId());
            
            ps.setString(1, staffCode);
            ps.setString(2, s.getStaffName());
            ps.setString(3, s.getStaffEmail());
            ps.setString(4, s.getStaffPassword() != null ? s.getStaffPassword() : ""); // StaffPassword
            ps.setString(5, "");  // StaffPhone
            ps.setString(6, "");  // StaffGender
            ps.setInt(7, s.getRoleId());
            ps.setBoolean(8, true);  // StaffIsActive
            
            int result = ps.executeUpdate();
            System.out.println("Result: " + result + " row inserted");
            
            if (result > 0) {
                System.out.println("SUCCESS!\n");
                return true;
            } else {
                System.out.println("FAILED: No rows\n");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("SQL ERROR: " + e.getMessage());
            System.out.println("State: " + e.getSQLState());
            e.printStackTrace();
            System.out.println("FAILED\n");
            return false;
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            System.out.println("FAILED\n");
            return false;
        }
    }

    
}

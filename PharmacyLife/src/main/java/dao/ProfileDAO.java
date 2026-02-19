package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Customer;
import models.Staff;
import utils.DBContext;

/**
 * ProfileDAO - Handles profile-related operations for both Customer and Staff
 * 
 * @author anltc
 */
public class ProfileDAO {
    
    // Get customer by ID
    public Customer getCustomerById(int customerId) {
        String sql = "SELECT CustomerId, CustomerCode, FullName, Email, Password, PhoneNumber, Address, CreatedAt, IsActive, Dob, Gender " +
                     "FROM Customer " +
                     "WHERE CustomerId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setCustomerCode(rs.getString("CustomerCode"));
                customer.setFullName(rs.getString("FullName"));
                customer.setEmail(rs.getString("Email"));
                customer.setPassword(rs.getString("Password"));
                customer.setPhone(rs.getString("PhoneNumber"));
                customer.setAddress(rs.getString("Address"));
                customer.setCreatedAt(rs.getDate("CreatedAt"));
                customer.setStatus(rs.getBoolean("IsActive"));
                customer.setDob(rs.getDate("Dob"));
                customer.setGender(rs.getString("Gender"));

                return customer;
            }

        } catch (Exception e) {
            System.out.println("Error getting customer by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
    
    // Get staff by ID
    public Staff getStaffById(int staffId) {
        String sql = "SELECT s.StaffId, s.StaffCode, s.StaffName, s.StaffPhone, r.RoleName, s.StaffIsActive, s.StaffEmail, s.StaffGender, s.RoleId, s.StaffPassword " +
                     "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId " +
                     "WHERE s.StaffId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Staff staff = new Staff();
                staff.setStaffId(rs.getInt("StaffId"));
                staff.setStaffCode(rs.getString("StaffCode"));
                staff.setStaffName(rs.getString("StaffName"));
                staff.setStaffPhone(rs.getString("StaffPhone"));
                staff.setRoleName(rs.getString("RoleName"));
                staff.setActive(rs.getBoolean("StaffIsActive"));
                staff.setStaffEmail(rs.getString("StaffEmail"));
                staff.setStaffGender(rs.getString("StaffGender"));
                staff.setRoleId(rs.getInt("RoleId"));
                staff.setStaffPassword(rs.getString("StaffPassword"));

                return staff;
            }

        } catch (Exception e) {
            System.out.println("Error getting staff by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
    
    // Update customer profile
    public boolean updateCustomerProfile(int customerId, String fullName, String phone, String address, java.util.Date dob, String gender) {
        String sql = "UPDATE Customer SET FullName = ?, PhoneNumber = ?, Address = ?, Dob = ?, Gender = ? WHERE CustomerId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, address);
            
            if (dob != null) {
                ps.setDate(4, new java.sql.Date(dob.getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            
            ps.setString(5, gender);
            ps.setInt(6, customerId);
            
            int result = ps.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            System.out.println("Error updating customer profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Update staff profile
    public boolean updateStaffProfile(int staffId, String staffName, String staffPhone, String staffGender) {
        String sql = "UPDATE Staff SET StaffName = ?, StaffPhone = ?, StaffGender = ? WHERE StaffId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, staffName);
            ps.setString(2, staffPhone);
            ps.setString(3, staffGender);
            ps.setInt(4, staffId);
            
            int result = ps.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            System.out.println("Error updating staff profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Change customer password
    public boolean changeCustomerPassword(int customerId, String newPassword) {
        String sql = "UPDATE Customer SET Password = ? WHERE CustomerId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, customerId);
            
            int result = ps.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            System.out.println("Error changing customer password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Change staff password
    public boolean changeStaffPassword(int staffId, String newPassword) {
        String sql = "UPDATE Staff SET StaffPassword = ? WHERE StaffId = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, staffId);
            
            int result = ps.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            System.out.println("Error changing staff password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

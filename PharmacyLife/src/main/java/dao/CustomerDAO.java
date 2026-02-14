/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import models.Customer;
import utils.DBContext;

/**
 *
 * @author anltc
 */
public class CustomerDAO {
    
    // Login method for Customer
    public Customer login(String email, String password) {
        String sql = "SELECT CustomerId, CustomerCode, FullName, Email, Password, PhoneNumber, Address, CreatedAt, IsActive, Dob, Gender " +
                     "FROM Customer " +
                     "WHERE Email = ? AND Password = ? AND IsActive = 1";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
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

                return customer;
            }

        } catch (Exception e) {
            System.out.println("Customer login error: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
    
    // Check if email already exists
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE Email = ?";
        
        System.out.println("  Checking email: " + email);
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            System.out.println("  Connection established");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("  Email count: " + count);
                return count > 0;
            }
            
        } catch (SQLException e) {
            System.out.println("  SQL Exception checking email:");
            System.out.println("  Error Code: " + e.getErrorCode());
            System.out.println("  SQL State: " + e.getSQLState());
            System.out.println("  Message: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("  Exception checking email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Generate next customer code (CUS001, CUS002, etc)
    public String generateNextCustomerCode() {
        String sql = "SELECT MAX(CAST(SUBSTRING(CustomerCode, 4, 3) AS INT)) as maxCode FROM Customer WHERE CustomerCode LIKE 'CUS%'";
        
        System.out.println("  Generating customer code...");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("  Connection established for code generation");
            
            if (rs.next()) {
                int maxCode = rs.getInt("maxCode");
                if (rs.wasNull()) {
                    maxCode = 0;
                }
                int nextCode = maxCode + 1;
                String newCode = String.format("CUS%03d", nextCode);
                System.out.println("  Generated CustomerCode: " + newCode);
                return newCode;
            }

        } catch (SQLException e) {
            System.out.println("  SQL Exception generating customer code:");
            System.out.println("  Error Code: " + e.getErrorCode());
            System.out.println("  SQL State: " + e.getSQLState());
            System.out.println("  Message: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("  Exception generating customer code: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("  Using fallback code: CUS001");
        return "CUS001";
    }
    
    // Register new customer
    public boolean registerCustomer(String fullName, String email, String password, String phone) {
        // Generate customer code
        String customerCode = generateNextCustomerCode();
        
        String sql = "INSERT INTO Customer (CustomerCode, FullName, Email, Password, PhoneNumber, IsActive, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("\n=== REGISTER CUSTOMER ===");
            System.out.println("Code: " + customerCode);
            System.out.println("Name: " + fullName);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);
            System.out.println("SQL: " + sql);
            
            ps.setString(1, customerCode);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);
            ps.setBoolean(6, true);  // IsActive
            ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));  // CreatedAt
            
            System.out.println("Executing SQL...");
            int result = ps.executeUpdate();
            System.out.println("Result: " + result + " row inserted");
            
            if (result > 0) {
                System.out.println("REGISTER SUCCESS!\n");
                return true;
            } else {
                System.out.println("REGISTER FAILED: No rows\n");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("SQL Exception during registration:");
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Message: " + e.getMessage());
            e.printStackTrace();
            System.out.println("REGISTER FAILED\n");
            return false;
        } catch (Exception e) {
            System.out.println("General Exception during registration:");
            System.out.println("Message: " + e.getMessage());
            e.printStackTrace();
            System.out.println("REGISTER FAILED\n");
            return false;
        }
    }
    
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
    
}

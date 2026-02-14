package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Customer;
import utils.DBContext;

public class CustomerDAO {

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        DBContext db = new DBContext();
        String sql = "SELECT * FROM Customer"; // Assuming table name is Customer

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("CustomerId"));
                c.setFullName(rs.getString("FullName"));
                c.setEmail(rs.getString("Email"));
                c.setPhone(rs.getString("Phone"));
                c.setAddress(rs.getString("Address"));
                c.setStatus(rs.getString("Status"));
                c.setJoinDate(rs.getDate("JoinDate")); // Assuming column name
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Customer getCustomerById(int id) {
        DBContext db = new DBContext();
        String sql = "SELECT * FROM Customer WHERE CustomerId = ?";

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomerId(rs.getInt("CustomerId"));
                    c.setFullName(rs.getString("FullName"));
                    c.setEmail(rs.getString("Email"));
                    c.setPhone(rs.getString("Phone"));
                    c.setAddress(rs.getString("Address"));
                    c.setStatus(rs.getString("Status"));
                    c.setJoinDate(rs.getDate("JoinDate"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

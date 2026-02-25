package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import models.User;
import utils.DBContext;

public class UserDAO {

    private DBContext dbContext = new DBContext();

    public User CheckUser(String usernameOrEmail, String passwordMd5) {
        // Since CheckUser is used for login and our tables have different passwords, we'll try Customer and then Staff.
        final String sqlCustomer = "SELECT CustomerId as UserID, CustomerCode as Username, Email, Password, FullName, PhoneNumber, IsActive, CreatedAt, NULL as UpdatedAt, 'Customer' as RoleName "
                + "FROM Customer "
                + "WHERE (CustomerCode = ? OR Email = ?) AND Password = ? AND IsActive = 1";
        
        final String sqlStaff = "SELECT s.StaffId as UserID, s.StaffCode as Username, s.StaffEmail as Email, s.StaffPassword as Password, s.StaffName as FullName, s.StaffPhone as PhoneNumber, s.StaffIsActive as IsActive, s.StaffCreatedAt as CreatedAt, s.StaffUpdateAt as UpdatedAt, r.RoleName "
                + "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId "
                + "WHERE (s.StaffCode = ? OR s.StaffEmail = ?) AND s.StaffPassword = ? AND s.StaffIsActive = 1";

        try (Connection conn = dbContext.getConnection()) {
            // Try Customer
            try (PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
                ps.setString(1, usernameOrEmail);
                ps.setString(2, usernameOrEmail);
                ps.setString(3, passwordMd5); 
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return mapRowToUser(rs);
                }
            }
            // Try Staff
            try (PreparedStatement ps = conn.prepareStatement(sqlStaff)) {
                ps.setString(1, usernameOrEmail);
                ps.setString(2, usernameOrEmail);
                ps.setString(3, passwordMd5);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return mapRowToUser(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to check user", ex);
        }
        return null;
    }

    public List<User> GetAllUser() {
        final String sql = "SELECT * FROM ("
                + "SELECT CustomerId as UserID, CustomerCode as Username, Email, Password, FullName, PhoneNumber, IsActive, CreatedAt, NULL as UpdatedAt, 'Customer' as RoleName "
                + "FROM Customer WHERE IsActive = 1 "
                + "UNION ALL "
                + "SELECT s.StaffId as UserID, s.StaffCode as Username, s.StaffEmail as Email, s.StaffPassword as Password, s.StaffName as FullName, s.StaffPhone as PhoneNumber, s.StaffIsActive as IsActive, s.StaffCreatedAt as CreatedAt, s.StaffUpdateAt as UpdatedAt, r.RoleName "
                + "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId WHERE s.StaffIsActive = 1"
                + ") as CombinedUsers";
        List<User> users = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapRowToUser(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to get all users", ex);
        }
        return users;
    }

    public User findByUsernameOrEmail(String usernameOrEmail) {
        // Query Customer table
        final String sqlCustomer = "SELECT CustomerId as UserID, CustomerCode as Username, Email, Password, FullName, PhoneNumber, IsActive, CreatedAt, NULL as UpdatedAt, 'Customer' as RoleName "
                + "FROM Customer "
                + "WHERE IsActive = 1 AND (Email = ? OR CustomerCode = ?)";
        
        // Query Staff table
        final String sqlStaff = "SELECT s.StaffId as UserID, s.StaffCode as Username, s.StaffEmail as Email, s.StaffPassword as Password, s.StaffName as FullName, s.StaffPhone as PhoneNumber, s.StaffIsActive as IsActive, s.StaffCreatedAt as CreatedAt, s.StaffUpdateAt as UpdatedAt, r.RoleName "
                + "FROM Staff s JOIN Role r ON s.RoleId = r.RoleId "
                + "WHERE s.StaffIsActive = 1 AND (s.StaffEmail = ? OR s.StaffCode = ?)";

        try (Connection conn = dbContext.getConnection()) {
            // Try Customer first
            try (PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
                ps.setString(1, usernameOrEmail);
                ps.setString(2, usernameOrEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRowToUser(rs);
                    }
                }
            }
            
            // Then try Staff
            try (PreparedStatement ps = conn.prepareStatement(sqlStaff)) {
                ps.setString(1, usernameOrEmail);
                ps.setString(2, usernameOrEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRowToUser(rs);
                    }
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to find user by username or email", ex);
        }
        return null;
    }

    public boolean createUser(User user) {
        // We assume new users are Customers for now.
        final String sqlCustomer = "INSERT INTO Customer (CustomerCode, FullName, Email, Password, PhoneNumber, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlCustomer, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername()); // We use username as CustomerCode
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getPhoneNumber());
            ps.setBoolean(6, user.isIsActive());
            ps.setTimestamp(7, java.sql.Timestamp.valueOf(user.getCreatedAt().atStartOfDay()));

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to update user in database", ex);
        }
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        int userId = rs.getInt("UserID");
        String username = rs.getString("Username");
        String email = rs.getString("Email");
        String password = rs.getString("Password");
        String fullName = rs.getString("FullName");
        String phoneNumber = rs.getString("PhoneNumber");
        boolean isActiveBool = rs.getBoolean("IsActive");
        Timestamp createdAtTs = rs.getTimestamp("CreatedAt");
        Timestamp updatedAtTs = rs.getTimestamp("UpdatedAt");

        String roleName = rs.getString("RoleName");

        LocalDate createdAt = createdAtTs != null ? createdAtTs.toLocalDateTime().toLocalDate() : null;
        LocalDate updatedAt = updatedAtTs != null ? updatedAtTs.toLocalDateTime().toLocalDate() : null;

        User u = new User();
        u.setUserID(userId);
        u.setUsername(username);
        u.setEmail(email);
        u.setPassword(password);
        u.setFullName(fullName);
        u.setPhoneNumber(phoneNumber);
        u.setIsActive(isActiveBool);
        u.setCreatedAt(createdAt);
        u.setUpdatedAt(updatedAt);

        if (roleName != null) {
            List<String> roles = new ArrayList<>();
            roles.add(roleName);
            u.setRoles(roles);
        }
        return u;
    }

    public boolean updatePassword(int userId, String newPassword) {
        final String sqlCustomer = "UPDATE Customer SET Password = ? WHERE CustomerId = ?";
        final String sqlStaff = "UPDATE Staff SET StaffPassword = ? WHERE StaffId = ?";
        try (Connection conn = dbContext.getConnection()) {
            // Since we don't know if userId is Customer or Staff, we can try both or search first
            // But we know that findByUsernameOrEmail returned this userId.
            // For now, trying both is safer than doing nothing.
            
            try (PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
                ps.setString(1, newPassword);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                if (rows > 0) return true;
            }
            
            try (PreparedStatement ps = conn.prepareStatement(sqlStaff)) {
                ps.setString(1, newPassword);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                if (rows > 0) return true;
            }
            
            return false;
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to update user password", ex);
        }
    }

    // Lấy danh sách khách hàng (role = customer)
    public List<User> getAllCustomers() {
        final String sql = "SELECT CustomerId as UserID, CustomerCode as Username, Email, Password, FullName, PhoneNumber, IsActive, CreatedAt, NULL as UpdatedAt, 'Customer' as RoleName "
                + "FROM Customer WHERE IsActive = 1 "
                + "ORDER BY CreatedAt DESC";
        List<User> customers = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                customers.add(mapRowToUser(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to get all customers", ex);
        }
        return customers;
    }
}

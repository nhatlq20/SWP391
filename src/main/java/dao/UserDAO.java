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
        final String sql = "SELECT * FROM dbo.Users WHERE (Username = ? OR Email = ?) AND Password = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, passwordMd5);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to check user", ex);
        }
        return null;
    }

    public List<User> GetAllUser() {

        final String sql = "SELECT u.*, r.RoleName "
                + "FROM dbo.Users u "
                + "LEFT JOIN dbo.UserRoles ur ON u.UserID = ur.UserID "
                + "LEFT JOIN dbo.Roles r ON ur.RoleID = r.RoleID "
                + "WHERE u.IsActive = 1 "
                + "GROUP BY u.UserID, u.Username, u.Email, u.Password, "
                + "u.FullName, u.PhoneNumber, u.IsActive, "
                + "u.CreatedAt, u.UpdatedAt, r.RoleName";
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

        final String sql = "SELECT u.*, r.RoleName "
                + "FROM dbo.Users u "
                + "LEFT JOIN dbo.UserRoles ur ON u.UserID = ur.UserID "
                + "LEFT JOIN dbo.Roles r ON ur.RoleID = r.RoleID "
                + "WHERE u.IsActive = 1 AND (u.Username = ? OR u.Email = ?) "
                + "GROUP BY u.UserID, u.Username, u.Email, u.Password, "
                + "u.FullName, u.PhoneNumber, u.IsActive, "
                + "u.CreatedAt, u.UpdatedAt, r.RoleName";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to find user by username or email", ex);
        }
        return null;
    }

    public boolean createUser(User user) {

        // First insert the user
        final String sqlUser = "INSERT INTO dbo.Users (Username, Email, Password, FullName, PhoneNumber, IsActive, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhoneNumber());
            ps.setBoolean(6, user.isIsActive());
            ps.setTimestamp(7, java.sql.Timestamp.valueOf(user.getCreatedAt().atStartOfDay()));
            ps.setTimestamp(8, java.sql.Timestamp.valueOf(user.getUpdatedAt().atStartOfDay()));

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                // Get the generated user ID
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int userId = rs.getInt(1);
                        // Insert default role (customer) for new user
                        final String sqlRole = "INSERT INTO dbo.UserRoles (UserID, RoleID) VALUES (?, ?)";
                        try (PreparedStatement psRole = conn.prepareStatement(sqlRole)) {
                            psRole.setInt(1, userId);
                            psRole.setInt(2, 3); // RoleID 3 for customer role
                            psRole.executeUpdate();
                        }
                        return true;
                    }
                }
            }
            return false;

        } catch (SQLException ex) {
            throw new RuntimeException("Failed to create user", ex);
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
        final String sql = "UPDATE dbo.Users SET Password = ?, UpdatedAt = ? WHERE UserID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setTimestamp(2, java.sql.Timestamp.valueOf(java.time.LocalDate.now().atStartOfDay()));
            ps.setInt(3, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Failed to update user password", ex);
        }
    }

    // Lấy danh sách khách hàng (role = customer)
    public List<User> getAllCustomers() {
        final String sql = "SELECT u.*, r.RoleName "
                + "FROM dbo.Users u "
                + "LEFT JOIN dbo.UserRoles ur ON u.UserID = ur.UserID "
                + "LEFT JOIN dbo.Roles r ON ur.RoleID = r.RoleID "
                + "WHERE u.IsActive = 1 AND (r.RoleName = 'customer' OR r.RoleName IS NULL) "
                + "GROUP BY u.UserID, u.Username, u.Email, u.Password, "
                + "u.FullName, u.PhoneNumber, u.IsActive, "
                + "u.CreatedAt, u.UpdatedAt, r.RoleName "
                + "ORDER BY u.CreatedAt DESC";
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

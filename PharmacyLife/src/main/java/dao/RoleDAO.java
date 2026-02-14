package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import models.Role;
import utils.DBContext;

public class RoleDAO {

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT RoleId, RoleName FROM Role";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("RoleId"));
                r.setRoleName(rs.getString("RoleName"));
                System.out.println("Loaded Role: " + r.getRoleId() + " - " + r.getRoleName());
                list.add(r);
            }
            System.out.println("Total roles loaded: " + list.size());

        } catch (Exception e) {
            System.out.println("Error loading roles: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    public Integer getRoleIdByName(String name) {
        String sql = "SELECT RoleId FROM Role WHERE LOWER(RoleName) = LOWER(?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("RoleId");
                    System.out.println("Found RoleId for '" + name + "': " + id);
                    return id;
                } else {
                    System.out.println("Role not found for name: '" + name + "'");
                }
            }
        } catch (Exception e) {
            System.out.println("Error fetching role id for '" + name + "': " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}

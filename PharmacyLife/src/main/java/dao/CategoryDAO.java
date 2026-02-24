package dao;

import models.Category;
import models.Medicine;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CategoryDAO {
    private DBContext dbContext = new DBContext();

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryCode, CategoryName FROM Category ORDER BY CategoryName";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("CategoryID"));
                category.setCategoryCode(rs.getString("CategoryCode"));
                category.setCategoryName(rs.getString("CategoryName"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public Category getCategoryById(int categoryID) {
        String sql = "SELECT CategoryID, CategoryCode, CategoryName, CreatedAt, UpdatedAt FROM Category WHERE CategoryID = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("CategoryID"));
                    category.setCategoryCode(rs.getString("CategoryCode"));
                    category.setCategoryName(rs.getString("CategoryName"));

                    Timestamp createdAt = rs.getTimestamp("CreatedAt");
                    if (createdAt != null) {
                        category.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                    if (updatedAt != null) {
                        category.setUpdatedAt(updatedAt.toLocalDateTime());
                    }

                    return category;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createCategory(Category category) {
        String sql = "INSERT INTO Category (CategoryName, CreatedAt, UpdatedAt) VALUES (?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getCategoryName());

            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(2, Timestamp.valueOf(now));
            ps.setTimestamp(3, Timestamp.valueOf(now));

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET CategoryName = ?, UpdatedAt = ? WHERE CategoryID = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getCategoryName());
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, category.getCategoryId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCategory(int categoryID) {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryID);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean categoryExists(int categoryID) {
        String sql = "SELECT COUNT(*) FROM Category WHERE CategoryID = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Category> searchCategoriesByName(String searchTerm) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryCode, CategoryName, CreatedAt, UpdatedAt FROM Category WHERE CategoryName LIKE ? ORDER BY CategoryName";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + searchTerm + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("CategoryID"));
                    category.setCategoryCode(rs.getString("CategoryCode"));
                    category.setCategoryName(rs.getString("CategoryName"));

                    Timestamp createdAt = rs.getTimestamp("CreatedAt");
                    if (createdAt != null) {
                        category.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                    if (updatedAt != null) {
                        category.setUpdatedAt(updatedAt.toLocalDateTime());
                    }

                    categories.add(category);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public Map<Integer, Integer> countAllMedicinesByCategory() {
        Map<Integer, Integer> map = new HashMap<>();
        String sql = "SELECT CategoryID, COUNT(*) as total FROM Medicine GROUP BY CategoryID";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("CategoryID"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    // kien
    public List<Medicine> getMedicineByCategory(int categoryId) {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine WHERE CategoryId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine medicine = new Medicine();
                    medicine.setMedicineId(rs.getInt("MedicineId"));
                    medicine.setMedicineCode(rs.getString("MedicineCode"));
                    medicine.setMedicineName(rs.getString("MedicineName"));
                    medicine.setSellingPrice(rs.getDouble("SellingPrice"));
                    medicine.setCategoryId(rs.getInt("CategoryId"));
                    medicine.setImageUrl(rs.getString("ImageUrl"));
                    medicine.setUnit(rs.getString("Unit"));
                    medicine.setRemainingQuantity(rs.getInt("RemainingQuantity"));
                    list.add(medicine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertCaterogy(Category category) {
        String sql = "INSERT INTO Category(CategoryCode, CategoryName) VALUES(?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getCategoryCode());
            ps.setString(2, category.getCategoryName());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Category> searchCategoryByName(String keyword) {
        return searchCategoriesByName(keyword);
    }

}
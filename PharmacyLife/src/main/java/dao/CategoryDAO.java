package dao;

import models.Category;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CategoryDAO {
    private DBContext dbContext = new DBContext();
    
//    public List<Category> getAllCategories() {
//        List<Category> categories = new ArrayList<>();
//        String sql = "SELECT CategoryID, CategoryName, CreatedAt, UpdatedAt FROM Category ORDER BY CategoryName";
//        
//        try (Connection conn = dbContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            
//            while (rs.next()) {
//                Category category = new Category();
//                category.setCategoryID(rs.getString("CategoryID"));
//                category.setCategoryName(rs.getString("CategoryName"));
//                
//                Timestamp createdAt = rs.getTimestamp("CreatedAt");
//                if (createdAt != null) {
//                    category.setCreatedAt(createdAt.toLocalDateTime());
//                }
//                
//                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
//                if (updatedAt != null) {
//                    category.setUpdatedAt(updatedAt.toLocalDateTime());
//                }
//                
//                categories.add(category);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        
//        return categories;
//    }
    
    public List<Category> getAllCategories() {
    List<Category> categories = new ArrayList<>();
    String sql = "SELECT CategoryID, CategoryName FROM Category ORDER BY CategoryName";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {


        while (rs.next()) {
            Category category = new Category();
            category.setCategoryID(rs.getString("CategoryID"));
            category.setCategoryName(rs.getString("CategoryName"));
            categories.add(category);
        }

        System.out.println("✅ Total categories loaded: " + categories.size());
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return categories;
}

    
    public Category getCategoryById(String categoryID) {
        String sql = "SELECT CategoryID, CategoryName, CreatedAt, UpdatedAt FROM Category WHERE CategoryID = ?";
        
        System.out.println("🔍 CategoryDAO.getCategoryById() - Input CategoryID: [" + categoryID + "]");
        System.out.println("🔍 CategoryDAO.getCategoryById() - SQL: " + sql);
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, categoryID);
            System.out.println("🔍 CategoryDAO.getCategoryById() - Executing query with CategoryID: " + categoryID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("✅ CategoryDAO.getCategoryById() - Found category in database");
                    Category category = new Category();
                    String catID = rs.getString("CategoryID");
                    category.setCategoryID(catID);
                    
                    // Xử lý CategoryName: nếu null hoặc rỗng thì dùng giá trị mặc định
                    String categoryName = rs.getString("CategoryName");
                    
                    // Debug: Log thông tin chi tiết về categoryName
                    System.out.println("🔍 CategoryDAO.getCategoryById() - CategoryID: " + catID);
                    System.out.println("🔍 CategoryDAO.getCategoryById() - CategoryName from ResultSet: [" + categoryName + "]");
                    System.out.println("🔍 CategoryDAO.getCategoryById() - CategoryName is null?: " + (categoryName == null));
                    if (categoryName != null) {
                        System.out.println("🔍 CategoryDAO.getCategoryById() - CategoryName length: " + categoryName.length());
                        System.out.println("🔍 CategoryDAO.getCategoryById() - CategoryName isEmpty after trim?: " + categoryName.trim().isEmpty());
                    }
                    
                    if (categoryName == null || categoryName.trim().isEmpty()) {
                        categoryName = "Danh mục " + catID;
                        System.out.println("⚠️ CategoryDAO - CategoryName is null or empty, using default: " + categoryName);
                    } else {
                        // Đảm bảo categoryName không có khoảng trắng thừa
                        // SQL Server tự động xử lý encoding dựa trên collation của database/column
                        categoryName = categoryName.trim();
                    }
                    category.setCategoryName(categoryName);
                    
                    System.out.println("✅ CategoryDAO - Final CategoryName: " + category.getCategoryName());
                    System.out.println("✅ CategoryDAO - Final CategoryName length: " + (category.getCategoryName() != null ? category.getCategoryName().length() : 0));
                    
                    Timestamp createdAt = rs.getTimestamp("CreatedAt");
                    if (createdAt != null) {
                        category.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    
                    Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                    if (updatedAt != null) {
                        category.setUpdatedAt(updatedAt.toLocalDateTime());
                    }
                    
                    return category;
                } else {
                    System.out.println("⚠️ CategoryDAO.getCategoryById() - No category found with ID: " + categoryID);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ CategoryDAO.getCategoryById() - SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("⚠️ CategoryDAO.getCategoryById() - Returning null for CategoryID: " + categoryID);
        return null;
    }
    
    public boolean createCategory(Category category) {
        String sql = "INSERT INTO Category (CategoryID, CategoryName, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getCategoryID());
            ps.setString(2, category.getCategoryName());
            
            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(3, Timestamp.valueOf(now));
            ps.setTimestamp(4, Timestamp.valueOf(now));
            
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
            ps.setString(3, category.getCategoryID());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteCategory(String categoryID) {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, categoryID);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean categoryExists(String categoryID) {
        String sql = "SELECT COUNT(*) FROM Category WHERE CategoryID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, categoryID);
            
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
        String sql = "SELECT CategoryID, CategoryName, CreatedAt, UpdatedAt FROM Category WHERE CategoryName LIKE ? ORDER BY CategoryName";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryID(rs.getString("CategoryID"));
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
    
    public Map<String, Integer> countAllMedicinesByCategory() {
    Map<String, Integer> map = new HashMap<>();
    String sql = "";
    try (Connection conn = dbContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            map.put(rs.getString("CategoryID"), rs.getInt("total"));
        }
    } catch (SQLException e) {
        System.out.println("Error in countAllMedicinesByCategory: " + e.getMessage());
    }
    return map;
}


}
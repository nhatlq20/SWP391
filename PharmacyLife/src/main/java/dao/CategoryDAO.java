package dao;

import models.Category;
import models.Medicine;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CategoryDAO {
    private DBContext dbContext = new DBContext();
    private String categoryImageColumnName;

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(buildCategorySelectSql(conn,
                "FROM Category ORDER BY CategoryCode"));
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("CategoryID"));
                category.setCategoryCode(rs.getString("CategoryCode"));
                category.setCategoryName(rs.getString("CategoryName"));
                category.setCategoryImageUrl(readCategoryImageUrl(rs));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public Category getCategoryById(int categoryID) {
        try (Connection conn = dbContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(buildCategorySelectSql(conn,
                "FROM Category WHERE CategoryID = ?"))) {

            ps.setInt(1, categoryID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("CategoryID"));
                    category.setCategoryCode(rs.getString("CategoryCode"));
                    category.setCategoryName(rs.getString("CategoryName"));
                    category.setCategoryImageUrl(readCategoryImageUrl(rs));
                    return category;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createCategory(Category category) {
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(buildCategoryInsertSql(conn))) {

            ps.setString(1, category.getCategoryCode());
            ps.setString(2, category.getCategoryName());
            if (hasCategoryImageColumn(conn)) {
                ps.setString(3, normalizeCategoryImageUrl(category.getCategoryImageUrl()));
            }

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(Category category) {
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(buildCategoryUpdateSql(conn))) {

            ps.setString(1, category.getCategoryCode());
            ps.setString(2, category.getCategoryName());
            if (hasCategoryImageColumn(conn)) {
                ps.setString(3, normalizeCategoryImageUrl(category.getCategoryImageUrl()));
                ps.setInt(4, category.getCategoryId());
            } else {
                ps.setInt(3, category.getCategoryId());
            }

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
        try (Connection conn = dbContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(buildCategorySelectSql(conn,
                "FROM Category WHERE CategoryName LIKE ? ORDER BY CategoryName"))) {

            ps.setString(1, "%" + searchTerm + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("CategoryID"));
                    category.setCategoryCode(rs.getString("CategoryCode"));
                    category.setCategoryName(rs.getString("CategoryName"));
                    category.setCategoryImageUrl(readCategoryImageUrl(rs));
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
        String sql = "SELECT m.MedicineId, m.MedicineCode, m.MedicineName, m.CategoryId, m.ImageUrl, m.RemainingQuantity, "
            + "mu.UnitName, mu.SellingPrice "
            + "FROM Medicine m "
            + "OUTER APPLY ( "
            + "    SELECT TOP 1 UnitName, SellingPrice "
            + "    FROM MedicineUnit u "
            + "    WHERE u.MedicineId = m.MedicineId "
            + "    ORDER BY CASE WHEN u.IsBaseUnit = 1 THEN 0 ELSE 1 END, u.UnitId "
            + ") mu "
            + "WHERE m.CategoryId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine medicine = new Medicine();
                    medicine.setMedicineId(rs.getInt("MedicineId"));
                    medicine.setMedicineCode(rs.getString("MedicineCode"));
                    medicine.setMedicineName(rs.getString("MedicineName"));
                    medicine.setCategoryId(rs.getInt("CategoryId"));
                    medicine.setImageUrl(rs.getString("ImageUrl"));
                    medicine.setRemainingQuantity(rs.getInt("RemainingQuantity"));
                    medicine.setUnit(rs.getString("UnitName"));
                    medicine.setSellingPrice(rs.getDouble("SellingPrice"));
                    list.add(medicine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertCaterogy(Category category) {
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(buildCategoryInsertSql(conn))) {

            ps.setString(1, category.getCategoryCode());
            ps.setString(2, category.getCategoryName());
            if (hasCategoryImageColumn(conn)) {
                ps.setString(3, normalizeCategoryImageUrl(category.getCategoryImageUrl()));
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Category> searchCategoryByName(String keyword) {
        return searchCategoriesByName(keyword);
    }

    public String generateNextCategoryCode() {
        String sql = "SELECT CategoryCode FROM Category";
        Pattern pattern = Pattern.compile("^([A-Za-z]+)(\\d+)$");

        int maxNumber = 0;
        String prefix = "CAT";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String code = rs.getString("CategoryCode");
                if (code == null) {
                    continue;
                }

                Matcher matcher = pattern.matcher(code.trim());
                if (!matcher.matches()) {
                    continue;
                }

                int number;
                try {
                    number = Integer.parseInt(matcher.group(2));
                } catch (NumberFormatException ex) {
                    continue;
                }

                if (number > maxNumber) {
                    maxNumber = number;
                    prefix = matcher.group(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return String.format("%s%03d", prefix, maxNumber + 1);
    }

    private String buildCategorySelectSql(Connection conn, String tailClause) throws SQLException {
        String imageColumn = getCategoryImageColumnName(conn);
        if (imageColumn == null) {
            return "SELECT CategoryID, CategoryCode, CategoryName " + tailClause;
        }
        return "SELECT CategoryID, CategoryCode, CategoryName, " + imageColumn + " AS CategoryImageUrl " + tailClause;
    }

    private String buildCategoryInsertSql(Connection conn) throws SQLException {
        String imageColumn = getCategoryImageColumnName(conn);
        if (imageColumn == null) {
            return "INSERT INTO Category (CategoryCode, CategoryName) VALUES (?, ?)";
        }
        return "INSERT INTO Category (CategoryCode, CategoryName, " + imageColumn + ") VALUES (?, ?, ?)";
    }

    private String buildCategoryUpdateSql(Connection conn) throws SQLException {
        String imageColumn = getCategoryImageColumnName(conn);
        if (imageColumn == null) {
            return "UPDATE Category SET CategoryCode = ?, CategoryName = ? WHERE CategoryID = ?";
        }
        return "UPDATE Category SET CategoryCode = ?, CategoryName = ?, " + imageColumn + " = ? WHERE CategoryID = ?";
    }

    private boolean hasCategoryImageColumn(Connection conn) throws SQLException {
        return getCategoryImageColumnName(conn) != null;
    }

    private String getCategoryImageColumnName(Connection conn) throws SQLException {
        if (categoryImageColumnName != null && !categoryImageColumnName.isEmpty()
                && canSelectColumn(conn, categoryImageColumnName)) {
            return categoryImageColumnName;
        }

        String[] candidates = {
                "CategoryImageUrl",
                "CategoryImageURL",
                "CategoryImagePath",
                "ImageUrl",
                "ImageURL",
                "CategoryImage"
        };
        for (String candidate : candidates) {
            if (canSelectColumn(conn, candidate)) {
                categoryImageColumnName = candidate;
                return categoryImageColumnName;
            }
        }

        // Try to auto-migrate schema so selected image can be persisted.
        ensureCategoryImageColumn(conn);
        if (canSelectColumn(conn, "CategoryImageUrl")) {
            categoryImageColumnName = "CategoryImageUrl";
            return categoryImageColumnName;
        }

        categoryImageColumnName = "";
        return null;
    }

    private boolean canSelectColumn(Connection conn, String columnName) {
        String sql = "SELECT TOP 1 " + columnName + " FROM Category";
        try (PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            return true;
        } catch (SQLException ex) {
            return false;
        }
    }

    private void ensureCategoryImageColumn(Connection conn) {
        String sql = "ALTER TABLE Category ADD CategoryImageUrl NVARCHAR(500) NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException ignored) {
            // Ignore if column exists already or account has no alter permission.
        }
    }

    private String readCategoryImageUrl(ResultSet rs) {
        try {
            return normalizeCategoryImageUrl(rs.getString("CategoryImageUrl"));
        } catch (SQLException ex) {
            return "";
        }
    }

    private String normalizeCategoryImageUrl(String raw) {
        if (raw == null) {
            return "";
        }
        return raw.trim();
    }

}
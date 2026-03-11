package dao;

import models.Medicine;
import models.MedicineUnit;
import models.Category;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {

    private DBContext dbContext = new DBContext();

    public MedicineDAO(DBContext dbContext) {
        this.dbContext = dbContext;
    }

    public MedicineDAO() {
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();

        String sql = "SELECT m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "ORDER BY c.CategoryId ASC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicine medicine = mapResultSetToMedicine(rs);
                medicines.add(medicine);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return medicines;
    }

    public Medicine getMedicineById(int medicineId) {
        String sql = "SELECT m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "WHERE m.MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMedicine(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Medicine> getMedicinesByCategory(int categoryId) {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "WHERE m.CategoryId = ? ORDER BY m.MedicineName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine medicine = mapResultSetToMedicine(rs);
                    medicines.add(medicine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return medicines;
    }

    public Medicine getMedicineByCode(String medicineCode) {
        String sql = "SELECT m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "WHERE m.MedicineCode = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, medicineCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMedicine(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Legacy support: finding by String ID maps to MedicineCode
    public Medicine getMedicineById(String medicineID) {
        // First try to parse as int (if it's a PK)
        try {
            int id = Integer.parseInt(medicineID);
            Medicine m = getMedicineById(id);
            if (m != null)
                return m;
        } catch (NumberFormatException e) {
            // Not an integer, treat as Code
        }
        return getMedicineByCode(medicineID);
    }

    public List<Medicine> searchMedicines(String searchTerm) {
        List<Medicine> medicines = new ArrayList<>();

        String sql = "SELECT DISTINCT m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "LEFT JOIN MedicineIngredients mi ON m.MedicineId = mi.MedicineId "
                + "LEFT JOIN ActiveIngredients ai ON mi.IngredientId = ai.IngredientId "
                + "LEFT JOIN ConditionMedicines mc ON m.MedicineId = mc.MedicineId "
                + "LEFT JOIN Conditions con ON mc.ConditionId = con.ConditionId "
                + "WHERE m.MedicineName LIKE ? "
                + "OR m.ShortDescription LIKE ? "
                + "OR m.BrandOrigin LIKE ? "
                + "OR c.CategoryName LIKE ? "
                + "OR ai.IngredientName LIKE ? "
                + "OR ai.Description LIKE ? "
                + "OR con.ConditionName LIKE ? "
                + "OR con.Description LIKE ? "
                + "OR con.Advice LIKE ? "
                + "ORDER BY m.MedicineName";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            for (int i = 1; i <= 9; i++) {
                ps.setString(i, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine medicine = mapResultSetToMedicine(rs);
                    medicines.add(medicine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return medicines;
    }

    public List<Medicine> getBestSellers(int limit) {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT TOP " + limit
                + " m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate, "
                + "COALESCE(SUM(oi.OrderQuantity), 0) as TotalSold "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "LEFT JOIN OrderItems oi ON m.MedicineId = oi.MedicineId "
                + "GROUP BY m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit "
                + "ORDER BY TotalSold DESC, m.MedicineName ASC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                medicines.add(mapResultSetToMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicines;
    }

    public List<Medicine> getMedicinesInStock() {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, "
                + "m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + "c.CategoryName, "
                + "mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                + "WHERE m.RemainingQuantity > 0 ORDER BY m.MedicineName";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicine medicine = mapResultSetToMedicine(rs);
                medicines.add(medicine);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return medicines;
    }

    /**
     * Creates a new Medicine record and returns the generated MedicineId, or -1 on
     * failure.
     * The caller should then create a corresponding MedicineUnit (base unit)
     * record.
     */
    public int createMedicineAndReturnId(Medicine medicine) {
        String sql = "INSERT INTO Medicine (MedicineCode, CategoryId, MedicineName, BrandOrigin, "
                + "OriginalPrice, ShortDescription, ImageUrl, RemainingQuantity) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int index = 1;
            ps.setString(index++, medicine.getMedicineCode());
            ps.setInt(index++, medicine.getCategoryId());
            ps.setString(index++, medicine.getMedicineName());
            ps.setString(index++, medicine.getBrandOrigin());
            ps.setDouble(index++, medicine.getOriginalPrice());
            ps.setString(index++, medicine.getShortDescription());
            ps.setString(index++, medicine.getImageUrl());
            ps.setInt(index++, medicine.getRemainingQuantity());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Legacy boolean wrapper kept for any other callers. */
    public boolean createMedicine(Medicine medicine) {
        return createMedicineAndReturnId(medicine) > 0;
    }

    public boolean updateMedicine(Medicine medicine) {
        String sql = "UPDATE Medicine SET MedicineCode = ?, CategoryId = ?, MedicineName = ?, BrandOrigin = ?, "
                + "OriginalPrice = ?, ShortDescription = ?, ImageUrl = ?, "
                + "RemainingQuantity = ? WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            ps.setString(index++, medicine.getMedicineCode());
            ps.setInt(index++, medicine.getCategoryId());
            ps.setString(index++, medicine.getMedicineName());
            ps.setString(index++, medicine.getBrandOrigin());
            ps.setDouble(index++, medicine.getOriginalPrice());
            ps.setString(index++, medicine.getShortDescription());
            ps.setString(index++, medicine.getImageUrl());
            ps.setInt(index++, medicine.getRemainingQuantity());
            ps.setInt(index++, medicine.getMedicineId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Generate the next MedicineCode scoped to a specific Category.
     * Finds the last code in that category (by MedicineId DESC), extracts the
     * prefix + numeric suffix and returns prefix + (number+1) with zero-padding.
     * If the category has no medicines yet, returns "MED001".
     */
    public String getNextMedicineCode(int categoryId) {
        // Get the last code that belongs to this category
        String sql = "SELECT TOP 1 MedicineCode FROM Medicine WHERE CategoryId = ? ORDER BY MedicineId DESC";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String lastCode = rs.getString(1);
                    if (lastCode != null && !lastCode.isEmpty()) {
                        String prefix = lastCode.replaceAll("\\d+$", "");
                        String numPart = lastCode.replaceAll("^\\D+", "");
                        try {
                            int num = Integer.parseInt(numPart);
                            int digits = numPart.length();
                            return prefix + String.format("%0" + digits + "d", num + 1);
                        } catch (NumberFormatException e) {
                            return lastCode + "1";
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // No medicines in this category yet → start from MED001
        return "MED001";
    }

    /**
     * Legacy no-arg overload – uses category-aware method with categoryId=0
     * fallback.
     */
    public String getNextMedicineCode() {
        return getNextMedicineCode(0);
    }

    public boolean deleteMedicine(int medicineId) {
        // First delete from child tables that are strictly related to Medicine
        deleteIngredientsByMedicineId(medicineId);
        deleteConditionsByMedicineId(medicineId);

        String sql = "DELETE FROM Medicine WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, medicineId);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteIngredientsByMedicineId(int medicineId) {
        String sql = "DELETE FROM MedicineIngredients WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteConditionsByMedicineId(int medicineId) {
        String sql = "DELETE FROM ConditionMedicines WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateQuantity(int medicineId, int newQuantity) {
        String sql = "UPDATE Medicine SET RemainingQuantity = ? WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newQuantity);
            ps.setInt(2, medicineId);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStockQuantity(int medicineId, int unitId, int delta) {
        String sql = "UPDATE Medicine SET RemainingQuantity = RemainingQuantity + (? * (SELECT COALESCE(ConversionRate, 1) FROM MedicineUnit WHERE UnitId = ?)) WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, delta);
            ps.setInt(2, unitId);
            ps.setInt(3, medicineId);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Legacy support
    public boolean updateStockQuantity(int medicineId, int delta) {
        return updateStockQuantity(medicineId, 0, delta);
    }

    public boolean addQuantityAndSetOriginalPrice(int medicineId, int unitId, int quantityToAdd,
            double newOriginalPrice) {
        double oldOriginalPrice = 0;
        String getOldPriceSql = "SELECT OriginalPrice FROM Medicine WHERE MedicineId = ?";
        String getRateSql = "SELECT ConversionRate FROM MedicineUnit WHERE UnitId = ?";

        try (Connection conn = dbContext.getConnection()) {
            int conversionRate = 1;
            if (unitId > 0) {
                try (PreparedStatement psR = conn.prepareStatement(getRateSql)) {
                    psR.setInt(1, unitId);
                    try (ResultSet rsR = psR.executeQuery()) {
                        if (rsR.next())
                            conversionRate = rsR.getInt("ConversionRate");
                    }
                }
            }

            // 1. Get old OriginalPrice to calculate adjustment factor
            try (PreparedStatement psOld = conn.prepareStatement(getOldPriceSql)) {
                psOld.setInt(1, medicineId);
                try (ResultSet rs = psOld.executeQuery()) {
                    if (rs.next()) {
                        oldOriginalPrice = rs.getDouble("OriginalPrice");
                    }
                }
            }

            // 2. Update Medicine quantity and OriginalPrice
            String sql = "UPDATE Medicine SET RemainingQuantity = RemainingQuantity + (? * ?), OriginalPrice = ? WHERE MedicineId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, quantityToAdd);
                ps.setInt(2, conversionRate);
                ps.setDouble(3, newOriginalPrice);
                ps.setInt(4, medicineId);

                int result = ps.executeUpdate();
                if (result > 0) {
                    // 3. If price changed, adjust all unit selling prices proportionally
                    if (oldOriginalPrice > 0 && newOriginalPrice > 0
                            && Math.abs(newOriginalPrice - oldOriginalPrice) > 0.0001) {
                        double factor = newOriginalPrice / oldOriginalPrice;
                        String updateUnitsSql = "UPDATE MedicineUnit SET SellingPrice = SellingPrice * ? WHERE MedicineId = ?";
                        try (PreparedStatement psUnits = conn.prepareStatement(updateUnitsSql)) {
                            psUnits.setDouble(1, factor);
                            psUnits.setInt(2, medicineId);
                            psUnits.executeUpdate();
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Legacy support
    public boolean addQuantityAndSetOriginalPrice(int medicineId, int quantityToAdd, double newOriginalPrice) {
        return addQuantityAndSetOriginalPrice(medicineId, 0, quantityToAdd, newOriginalPrice);
    }

    public boolean medicineExists(int medicineId) {
        String sql = "SELECT COUNT(*) FROM Medicine WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, medicineId);

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

    private Medicine mapResultSetToMedicine(ResultSet rs) throws SQLException {
        Medicine medicine = new Medicine();

        medicine.setMedicineId(rs.getInt("MedicineId"));
        medicine.setMedicineCode(rs.getString("MedicineCode"));
        medicine.setCategoryId(rs.getInt("CategoryId"));
        medicine.setMedicineName(rs.getString("MedicineName"));
        medicine.setBrandOrigin(rs.getString("BrandOrigin"));
        medicine.setOriginalPrice(rs.getDouble("OriginalPrice"));
        medicine.setShortDescription(rs.getString("ShortDescription"));
        medicine.setImageUrl(rs.getString("ImageUrl"));
        medicine.setRemainingQuantity(rs.getInt("RemainingQuantity"));

        // Set base unit if UnitId is available in the result set
        try {
            int unitId = rs.getInt("UnitId");
            if (!rs.wasNull() && unitId > 0) {
                MedicineUnit baseUnit = new MedicineUnit();
                baseUnit.setUnitId(unitId);
                baseUnit.setMedicineId(medicine.getMedicineId());
                baseUnit.setUnitName(rs.getString("UnitName"));
                baseUnit.setConversionRate(rs.getInt("ConversionRate"));
                baseUnit.setSellingPrice(rs.getDouble("SellingPrice"));
                baseUnit.setBaseUnit(rs.getBoolean("IsBaseUnit"));
                medicine.setBaseUnit(baseUnit);

                // Use MaxRate for quantity calculation if available
                int maxRate = rs.getInt("MaxRate");
                if (!rs.wasNull() && maxRate > 0) {
                    // Update the base unit's conversion rate to the max rate for display purposes
                    // This ensures remainingQuantity / conversionRate = boxes
                    baseUnit.setConversionRate(maxRate);
                }
            }
        } catch (SQLException e) {
            // UnitId might not be in result set for some queries
        }

        // Set category object if CategoryName is available
        try {
            String categoryName = rs.getString("CategoryName");
            if (categoryName != null) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("CategoryId"));
                category.setCategoryName(categoryName);
                medicine.setCategory(category);
            }
        } catch (SQLException e) {
            // CategoryName might not be in the result set if not joined
        }

        return medicine;
    }

    /**
     * Returns a comma-separated list of IngredientNames for the given medicineId,
     * joining MedicineIngredients with ActiveIngredients.
     */
    public List<String> getIngredientNamesByMedicineId(int medicineId) {
        List<String> names = new ArrayList<>();
        String sql = "SELECT ai.IngredientName "
                + "FROM MedicineIngredients mi "
                + "JOIN ActiveIngredients ai ON mi.IngredientId = ai.IngredientId "
                + "WHERE mi.MedicineId = ? "
                + "ORDER BY ai.IngredientName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    names.add(rs.getString("IngredientName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names;
    }

    public List<String> getConditionNamesByMedicineId(int medicineId) {
        List<String> names = new ArrayList<>();
        String sql = "SELECT con.ConditionName "
                + "FROM ConditionMedicines mc "
                + "JOIN Conditions con ON mc.ConditionId = con.ConditionId "
                + "WHERE mc.MedicineId = ? "
                + "ORDER BY con.ConditionName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    names.add(rs.getString("ConditionName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names;
    }

    public String searchMedicineByKeyword(String keyword) {
        StringBuilder sb = new StringBuilder();

        try (Connection conn = dbContext.getConnection()) {

            String sql = "SELECT TOP 3 DISTINCT "
                    + "m.MedicineName, m.ShortDescription, mu.SellingPrice, mu.UnitName as Unit, m.ImageUrl "
                    + "FROM Medicine m "
                    + "LEFT JOIN MedicineUnit mu ON mu.UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = m.MedicineId ORDER BY ConversionRate DESC) "
                    + "LEFT JOIN MedicineIngredients mi ON m.MedicineId = mi.MedicineId "
                    + "LEFT JOIN ActiveIngredients ai ON mi.IngredientId = ai.IngredientId "
                    + "LEFT JOIN ConditionMedicines mc ON m.MedicineId = mc.MedicineId "
                    + "LEFT JOIN Conditions con ON mc.ConditionId = con.ConditionId "
                    + "WHERE m.MedicineName LIKE ? "
                    + "OR m.ShortDescription LIKE ? "
                    + "OR m.BrandOrigin LIKE ? "
                    + "OR ai.IngredientName LIKE ? "
                    + "OR con.ConditionName LIKE ? "
                    + "OR con.Description LIKE ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";

            for (int i = 1; i <= 6; i++) {
                ps.setString(i, pattern);
            }

            ResultSet rs = ps.executeQuery();
            int count = 0;

            while (rs.next()) {
                count++;

                String name = rs.getString("MedicineName");
                String shortDesc = rs.getString("ShortDescription");
                double price = rs.getDouble("SellingPrice");
                String unit = rs.getString("Unit");
                String img = rs.getString("ImageUrl");

                sb.append("💊 ").append(name);
                if (price > 0) {
                    sb.append(" — ").append(String.format("%,.0f₫ / %s", price, unit));
                }
                sb.append("\n");

                if (shortDesc != null && !shortDesc.isBlank()) {
                    sb.append("📋 ").append(shortDesc).append("\n");
                }

                if (img != null && !img.isBlank()) {
                    sb.append("(Ảnh: ").append(img).append(")\n");
                }

                sb.append("\n");
            }

            if (count == 0) {
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "⚠️ Lỗi khi tìm kiếm dữ liệu thuốc trong hệ thống.";
        }

        return sb.toString();
    }

    public int getTotalStockByCategory(int categoryId) {
        String sql = "SELECT SUM(m.RemainingQuantity) AS totalStock FROM Medicine m WHERE m.CategoryId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totalStock");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}

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
                + "mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
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
                + "mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
                + "WHERE m.MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Medicine medicine = mapResultSetToMedicine(rs);
                    // Populate ingredients and conditions as comma-separated strings for forms
                    List<String> ingredients = getIngredientNamesByMedicineId(medicineId);
                    medicine.setIngredients(String.join(", ", ingredients));
                    List<String> conditions = getConditionNamesByMedicineId(medicineId);
                    medicine.setConditions(String.join(", ", conditions));
                    return medicine;
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
                + "mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
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
                + "mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
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
                + "mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
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
                + " m.OriginalPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, "
                + " c.CategoryName, "
                + " mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + " (SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate, "
                + " (SELECT COALESCE(SUM(oi.OrderQuantity * mu2.ConversionRate), 0) FROM OrderItems oi JOIN MedicineUnit mu2 ON oi.MedicineUnitId = mu2.MedicineUnitId JOIN Orders o2 ON oi.OrderId = o2.OrderId WHERE mu2.MedicineId = m.MedicineId AND LOWER(o2.Status) IN ('delivered', N'đã giao', N'đã giao hàng', 'completed', N'hoàn thành', N'giao hàng thành công', N'đã hoàn thành')) as TotalSold "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
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
                + "mu.MedicineUnitId, mu.UnitId, mu.UnitName, mu.ConversionRate, mu.SellingPrice, mu.IsBaseUnit, "
                + "(SELECT MAX(ConversionRate) FROM MedicineUnit WHERE MedicineId = m.MedicineId) as MaxRate "
                + "FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
                + "OUTER APPLY (SELECT TOP 1 mi.MedicineUnitId, mi.UnitId, u.UnitName, mi.ConversionRate, mi.SellingPrice, mi.IsBaseUnit "
                + "             FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId "
                + "             WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu "
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

    public void saveMedicineIngredients(int medicineId, String ingredientsStr) {
        if (ingredientsStr == null || ingredientsStr.isBlank()) {
            deleteIngredientsByMedicineId(medicineId);
            return;
        }

        // 1. Clear existing links
        deleteIngredientsByMedicineId(medicineId);

        // 2. Parse and insert/link
        String[] parts = ingredientsStr.split(",");
        try (Connection conn = dbContext.getConnection()) {
            for (String part : parts) {
                String input = part.trim();
                if (input.isEmpty())
                    continue;

                String name = input;
                String description = null;
                String strength = null;

                // 1. Extract Description: (...)
                if (input.contains("(") && input.contains(")")) {
                    int dStart = input.lastIndexOf("(");
                    int dEnd = input.lastIndexOf(")");
                    if (dEnd > dStart) {
                        description = input.substring(dStart + 1, dEnd).trim();
                        input = (input.substring(0, dStart) + input.substring(dEnd + 1)).trim();
                    }
                }

                // 2. Extract Strength: [...]
                if (input.contains("[") && input.contains("]")) {
                    int sStart = input.lastIndexOf("[");
                    int sEnd = input.lastIndexOf("]");
                    if (sEnd > sStart) {
                        strength = input.substring(sStart + 1, sEnd).trim();
                        input = (input.substring(0, sStart) + input.substring(sEnd + 1)).trim();
                    }
                }
                name = input.trim();

                if (name.isEmpty())
                    continue;

                // Find or create ActiveIngredient
                int ingredientId = -1;
                String selectSql = "SELECT IngredientId FROM ActiveIngredients WHERE IngredientName = ?";
                try (PreparedStatement psSelection = conn.prepareStatement(selectSql)) {
                    psSelection.setString(1, name);
                    try (ResultSet rs = psSelection.executeQuery()) {
                        if (rs.next()) {
                            ingredientId = rs.getInt(1);
                            if (description != null && !description.isEmpty()) {
                                String updateDescSql = "UPDATE ActiveIngredients SET Description = ? WHERE IngredientId = ?";
                                try (PreparedStatement psUpdate = conn.prepareStatement(updateDescSql)) {
                                    psUpdate.setString(1, description);
                                    psUpdate.setInt(2, ingredientId);
                                    psUpdate.executeUpdate();
                                }
                            }
                        }
                    }
                }

                if (ingredientId == -1) {
                    String insertSql = "INSERT INTO ActiveIngredients (IngredientName, Description) VALUES (?, ?)";
                    try (PreparedStatement psInsertion = conn.prepareStatement(insertSql,
                            Statement.RETURN_GENERATED_KEYS)) {
                        psInsertion.setString(1, name);
                        psInsertion.setString(2, description);
                        psInsertion.executeUpdate();
                        try (ResultSet keys = psInsertion.getGeneratedKeys()) {
                            if (keys.next())
                                ingredientId = keys.getInt(1);
                        }
                    }
                }

                // Link to Medicine with Strength
                if (ingredientId != -1) {
                    String linkSql = "INSERT INTO MedicineIngredients (MedicineId, IngredientId, Strength) VALUES (?, ?, ?)";
                    try (PreparedStatement psLink = conn.prepareStatement(linkSql)) {
                        psLink.setInt(1, medicineId);
                        psLink.setInt(2, ingredientId);
                        psLink.setString(3, strength);
                        psLink.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void saveMedicineConditions(int medicineId, String conditionsStr) {
        if (conditionsStr == null || conditionsStr.isBlank()) {
            deleteConditionsByMedicineId(medicineId);
            return;
        }

        // 1. Clear existing links
        deleteConditionsByMedicineId(medicineId);

        // 2. Parse and insert
        String[] parts = conditionsStr.split(",");
        try (Connection conn = dbContext.getConnection()) {
            for (String part : parts) {
                String input = part.trim();
                if (input.isEmpty())
                    continue;

                String name = input;
                String description = null;
                String advice = null;

                // 1. Extract Advice: {...}
                if (input.contains("{") && input.contains("}")) {
                    int aStart = input.lastIndexOf("{");
                    int aEnd = input.lastIndexOf("}");
                    if (aEnd > aStart) {
                        advice = input.substring(aStart + 1, aEnd).trim();
                        input = (input.substring(0, aStart) + input.substring(aEnd + 1)).trim();
                    }
                }

                // 2. Extract Description: (...)
                if (input.contains("(") && input.contains(")")) {
                    int dStart = input.lastIndexOf("(");
                    int dEnd = input.lastIndexOf(")");
                    if (dEnd > dStart) {
                        description = input.substring(dStart + 1, dEnd).trim();
                        input = (input.substring(0, dStart) + input.substring(dEnd + 1)).trim();
                    }
                }
                name = input.trim();

                if (name.isEmpty())
                    continue;

                // Find or create Condition
                int conditionId = -1;
                String selectSql = "SELECT ConditionId FROM Conditions WHERE ConditionName = ?";
                try (PreparedStatement psSelection = conn.prepareStatement(selectSql)) {
                    psSelection.setString(1, name);
                    try (ResultSet rs = psSelection.executeQuery()) {
                        if (rs.next()) {
                            conditionId = rs.getInt(1);
                        }
                    }
                }

                if (conditionId == -1) {
                    String insertSql = "INSERT INTO Conditions (ConditionName, Description, Advice) VALUES (?, ?, ?)";
                    try (PreparedStatement psInsertion = conn.prepareStatement(insertSql,
                            Statement.RETURN_GENERATED_KEYS)) {
                        psInsertion.setString(1, name);
                        psInsertion.setString(2, description);
                        psInsertion.setString(3, advice);
                        psInsertion.executeUpdate();
                        try (ResultSet keys = psInsertion.getGeneratedKeys()) {
                            if (keys.next())
                                conditionId = keys.getInt(1);
                        }
                    }
                } else {
                    // Update existing Condition with new Description/Advice if provided
                    if ((description != null && !description.isEmpty()) || (advice != null && !advice.isEmpty())) {
                        StringBuilder updateSql = new StringBuilder("UPDATE Conditions SET ");
                        boolean first = true;
                        if (description != null && !description.isEmpty()) {
                            updateSql.append("Description = ?");
                            first = false;
                        }
                        if (advice != null && !advice.isEmpty()) {
                            if (!first)
                                updateSql.append(", ");
                            updateSql.append("Advice = ?");
                        }
                        updateSql.append(" WHERE ConditionId = ?");

                        try (PreparedStatement psUpdate = conn.prepareStatement(updateSql.toString())) {
                            int idx = 1;
                            if (description != null && !description.isEmpty())
                                psUpdate.setString(idx++, description);
                            if (advice != null && !advice.isEmpty())
                                psUpdate.setString(idx++, advice);
                            psUpdate.setInt(idx, conditionId);
                            psUpdate.executeUpdate();
                        }
                    }
                }

                // Link to Medicine
                if (conditionId != -1) {
                    String linkSql = "INSERT INTO ConditionMedicines (MedicineId, ConditionId) VALUES (?, ?)";
                    try (PreparedStatement psLink = conn.prepareStatement(linkSql)) {
                        psLink.setInt(1, medicineId);
                        psLink.setInt(2, conditionId);
                        psLink.executeUpdate();
                    }
                }
            }
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
        String sql = "UPDATE Medicine SET RemainingQuantity = RemainingQuantity + (? * (SELECT COALESCE(ConversionRate, 1) FROM MedicineUnit WHERE UnitId = ? AND MedicineId = ?)) WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, delta);
            ps.setInt(2, unitId);
            ps.setInt(3, medicineId);
            ps.setInt(4, medicineId);

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
        String getRateSql = "SELECT ConversionRate FROM MedicineUnit WHERE UnitId = ? AND MedicineId = ?";

        try (Connection conn = dbContext.getConnection()) {
            int conversionRate = 1;
            if (unitId > 0) {
                try (PreparedStatement psR = conn.prepareStatement(getRateSql)) {
                    psR.setInt(1, unitId);
                    psR.setInt(2, medicineId);
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
                    // 3. If price increased, increase all unit selling prices by 10%
                    if (oldOriginalPrice > 0 && newOriginalPrice > oldOriginalPrice + 0.0001) {
                        String updateUnitsSql = "UPDATE MedicineUnit SET SellingPrice = SellingPrice * 1.1 WHERE MedicineId = ?";
                        try (PreparedStatement psUnits = conn.prepareStatement(updateUnitsSql)) {
                            psUnits.setInt(1, medicineId);
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
            int medicineUnitId = rs.getInt("MedicineUnitId");
            if (!rs.wasNull() && medicineUnitId > 0) {
                MedicineUnit baseUnit = new MedicineUnit();
                baseUnit.setMedicineUnitId(medicineUnitId);
                baseUnit.setUnitId(rs.getInt("UnitId"));
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
        String sql = "SELECT ai.IngredientName, ai.Description, mi.Strength "
                + "FROM MedicineIngredients mi "
                + "JOIN ActiveIngredients ai ON mi.IngredientId = ai.IngredientId "
                + "WHERE mi.MedicineId = ? "
                + "ORDER BY ai.IngredientName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("IngredientName");
                    String desc = rs.getString("Description");
                    String strength = rs.getString("Strength");

                    StringBuilder sb = new StringBuilder(name);
                    if (strength != null && !strength.isEmpty()) {
                        sb.append(" [").append(strength).append("]");
                    }
                    if (desc != null && !desc.isEmpty()) {
                        sb.append(" (").append(desc).append(")");
                    }
                    names.add(sb.toString());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names;
    }

    public List<String> getConditionNamesByMedicineId(int medicineId) {
        List<String> names = new ArrayList<>();
        String sql = "SELECT con.ConditionName, con.Description, con.Advice "
                + "FROM ConditionMedicines mc "
                + "JOIN Conditions con ON mc.ConditionId = con.ConditionId "
                + "WHERE mc.MedicineId = ? "
                + "ORDER BY con.ConditionName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("ConditionName");
                    String desc = rs.getString("Description");
                    String advice = rs.getString("Advice");

                    StringBuilder sb = new StringBuilder(name);
                    if (desc != null && !desc.isEmpty()) {
                        sb.append(" (").append(desc).append(")");
                    }
                    if (advice != null && !advice.isEmpty()) {
                        sb.append(" {").append(advice).append("}");
                    }
                    names.add(sb.toString());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names;
    }

    public String searchMedicineByKeyword(String keyword) {
        if (keyword == null || keyword.isBlank())
            return null;

        // 1. Preprocess: Extract important keywords
        String[] stopWords = { "tôi", "đang", "bị", "muốn", "mua", "có", "không", "cho", "của", "là", "bạn", "với",
                "và", "giúp", "em", "mình", "cần", "tìm", "thuốc", "loại" };
        String processed = keyword.toLowerCase();
        for (String word : stopWords) {
            processed = processed.replaceAll("\\b" + word + "\\b", " ");
        }
        processed = processed.trim().replaceAll("\\s+", " ");

        if (processed.isEmpty())
            processed = keyword.toLowerCase();

        String[] keywords = processed.split("\\s+");
        if (keywords.length == 0)
            return null;

        StringBuilder sb = new StringBuilder();
        try (Connection conn = dbContext.getConnection()) {
            // Build dynamic SQL with OR for each keyword and Category matching
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT TOP 3 m.MedicineId, m.MedicineName, m.ShortDescription, m.BrandOrigin, ")
                    .append("mu.SellingPrice, mu.UnitName as Unit, cat.CategoryName, ")
                    .append("(SELECT STRING_AGG(CAST(ai2.IngredientName + ISNULL(' ' + mi2.Strength, '') + ISNULL(' (' + ai2.Description + ')', '') AS NVARCHAR(MAX)), ', ') FROM MedicineIngredients mi2 JOIN ActiveIngredients ai2 ON mi2.IngredientId = ai2.IngredientId WHERE mi2.MedicineId = m.MedicineId) as Ingredients, ")
                    .append("(SELECT STRING_AGG(CAST(con2.ConditionName + ISNULL(' (' + con2.Description + ')', '') AS NVARCHAR(MAX)), ', ') FROM ConditionMedicines mc2 JOIN Conditions con2 ON mc2.ConditionId = con2.ConditionId WHERE mc2.MedicineId = m.MedicineId) as Conditions ")
                    .append("FROM Medicine m ")
                    .append("LEFT JOIN Category cat ON m.CategoryId = cat.CategoryId ")
                    .append("OUTER APPLY (SELECT TOP 1 mi.SellingPrice, u.UnitName FROM MedicineUnit mi LEFT JOIN Unit u ON mi.UnitId = u.UnitId WHERE mi.MedicineId = m.MedicineId ORDER BY mi.ConversionRate DESC) mu ")
                    .append("WHERE ");

            for (int i = 0; i < keywords.length; i++) {
                if (i > 0)
                    sql.append(" OR ");
                sql.append(
                        "(m.MedicineName LIKE ? OR m.ShortDescription LIKE ? OR m.BrandOrigin LIKE ? OR cat.CategoryName LIKE ? ")
                        .append(" OR EXISTS (SELECT 1 FROM MedicineIngredients mi3 JOIN ActiveIngredients ai3 ON mi3.IngredientId = ai3.IngredientId WHERE mi3.MedicineId = m.MedicineId AND (ai3.IngredientName LIKE ? OR ai3.Description LIKE ?)) ")
                        .append(" OR EXISTS (SELECT 1 FROM ConditionMedicines mc3 JOIN Conditions con3 ON mc3.ConditionId = con3.ConditionId WHERE mc3.MedicineId = m.MedicineId AND (con3.ConditionName LIKE ? OR con3.Description LIKE ?)))");
            }

            // Prioritize matches: Category name matches are strong signals, Medicine name
            // matches are even stronger
            sql.append(" ORDER BY ");
            for (int i = 0; i < keywords.length; i++) {
                if (i > 0)
                    sql.append(" + ");
                sql.append("(CASE WHEN cat.CategoryName LIKE ? THEN 5 WHEN m.MedicineName LIKE ? THEN 10 ELSE 0 END)");
            }
            sql.append(" DESC, m.MedicineName ASC");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            // Set params for WHERE clause
            for (String kw : keywords) {
                String pattern = "%" + kw + "%";
                for (int j = 0; j < 8; j++) { // 8 placeholders in the WHERE block for each keyword
                    ps.setString(paramIndex++, pattern);
                }
            }
            // Set params for ORDER BY clause
            for (String kw : keywords) {
                String pattern = "%" + kw + "%";
                ps.setString(paramIndex++, pattern); // for CategoryName
                ps.setString(paramIndex++, pattern); // for MedicineName
            }

            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    String name = rs.getString("MedicineName");
                    String shortDesc = rs.getString("ShortDescription");
                    String brand = rs.getString("BrandOrigin");
                    double price = rs.getDouble("SellingPrice");
                    String unit = rs.getString("Unit");
                    String ingredients = rs.getString("Ingredients");
                    String conditions = rs.getString("Conditions");
                    String category = rs.getString("CategoryName");

                    sb.append("💊 ").append(name);
                    if (brand != null && !brand.isBlank())
                        sb.append(" (").append(brand).append(")");

                    if (category != null && !category.isBlank())
                        sb.append(" [").append(category).append("]");

                    if (price > 0) {
                        sb.append(" — ").append(String.format("%,.0f₫/%s", price, unit));
                    }
                    sb.append("\n");

                    if (shortDesc != null && !shortDesc.isBlank()) {
                        sb.append("   - Mô tả: ").append(shortDesc).append("\n");
                    }
                    if (ingredients != null && !ingredients.isBlank()) {
                        sb.append("   - Thành phần: ").append(ingredients).append("\n");
                    }
                    if (conditions != null && !conditions.isBlank()) {
                        sb.append("   - Công dụng: ").append(conditions).append("\n");
                    }
                    sb.append("\n");
                }

                if (count == 0) {
                    return null;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "⚠️ Lỗi khi tìm kiếm dữ liệu thuốc.";
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

package dao;

import models.Medicine;
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

        String sql = "SELECT m.*, c.CategoryName FROM Medicine m " +
                "LEFT JOIN Category c ON m.CategoryId = c.CategoryId " +
                "ORDER BY m.MedicineId ASC";

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
        String sql = "SELECT m.*, c.CategoryName FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
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
        String sql = "SELECT m.*, c.CategoryName FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
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
        String sql = "SELECT m.*, c.CategoryName FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
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

        String sql = "SELECT m.*, c.CategoryName FROM Medicine m " +
                "LEFT JOIN Category c ON m.CategoryId = c.CategoryId " +
                "WHERE m.MedicineName LIKE ? " +
                "ORDER BY m.MedicineName";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);

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
        String sql = "SELECT TOP " + limit + " m.*, c.CategoryName, COALESCE(SUM(oi.OrderQuantity), 0) as TotalSold " +
                "FROM Medicine m " +
                "LEFT JOIN Category c ON m.CategoryId = c.CategoryId " +
                "LEFT JOIN OrderItems oi ON m.MedicineId = oi.MedicineId " +
                "GROUP BY m.MedicineId, m.MedicineCode, m.CategoryId, m.MedicineName, m.BrandOrigin, m.Unit, " +
                "m.OriginalPrice, m.SellingPrice, m.ShortDescription, m.ImageUrl, m.RemainingQuantity, c.CategoryName "
                +
                "ORDER BY TotalSold DESC, m.MedicineName ASC";

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
        String sql = "SELECT m.*, c.CategoryName FROM Medicine m "
                + "LEFT JOIN Category c ON m.CategoryId = c.CategoryId "
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

    public boolean createMedicine(Medicine medicine) {
        String sql = "INSERT INTO Medicine (MedicineCode, CategoryId, MedicineName, BrandOrigin, Unit, "
                + "OriginalPrice, SellingPrice, ShortDescription, ImageUrl, RemainingQuantity) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            ps.setString(index++, medicine.getMedicineCode());
            ps.setInt(index++, medicine.getCategoryId());
            ps.setString(index++, medicine.getMedicineName());
            ps.setString(index++, medicine.getBrandOrigin());
            ps.setString(index++, medicine.getUnit());
            ps.setDouble(index++, medicine.getOriginalPrice());
            ps.setDouble(index++, medicine.getSellingPrice());
            ps.setString(index++, medicine.getShortDescription());
            ps.setString(index++, medicine.getImageUrl());
            ps.setInt(index++, medicine.getRemainingQuantity());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateMedicine(Medicine medicine) {
        String sql = "UPDATE Medicine SET MedicineCode = ?, CategoryId = ?, MedicineName = ?, BrandOrigin = ?, "
                + "Unit = ?, OriginalPrice = ?, SellingPrice = ?, ShortDescription = ?, ImageUrl = ?, "
                + "RemainingQuantity = ? WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            ps.setString(index++, medicine.getMedicineCode());
            ps.setInt(index++, medicine.getCategoryId());
            ps.setString(index++, medicine.getMedicineName());
            ps.setString(index++, medicine.getBrandOrigin());
            ps.setString(index++, medicine.getUnit());
            ps.setDouble(index++, medicine.getOriginalPrice());
            ps.setDouble(index++, medicine.getSellingPrice());
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

    public String getNextMedicineCode() {
        String sql = "SELECT TOP 1 MedicineCode FROM Medicine ORDER BY MedicineId DESC";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastCode = rs.getString(1);
                if (lastCode != null && !lastCode.isEmpty()) {
                    // Split prefix (letters) and numeric suffix
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "TH001";
    }

    public boolean deleteMedicine(int medicineId) {
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
        medicine.setUnit(rs.getString("Unit"));
        medicine.setOriginalPrice(rs.getDouble("OriginalPrice"));
        medicine.setSellingPrice(rs.getDouble("SellingPrice"));
        medicine.setShortDescription(rs.getString("ShortDescription"));
        medicine.setImageUrl(rs.getString("ImageUrl"));
        medicine.setRemainingQuantity(rs.getInt("RemainingQuantity"));

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

    public String searchMedicineByKeyword(String keyword) {
        StringBuilder sb = new StringBuilder();

        try (Connection conn = dbContext.getConnection()) {

            String sql = "SELECT TOP 3 "
                    + "MedicineName, ShortDescription, SellingPrice, Unit, ImageUrl "
                    + "FROM Medicine "
                    + "WHERE MedicineName LIKE ? "
                    + "OR ShortDescription LIKE ? "
                    + "OR BrandOrigin LIKE ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";

            for (int i = 1; i <= 3; i++) {
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
}

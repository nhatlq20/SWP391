package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.Import;
import models.ImportDetail;
import models.Medicine;
import models.MedicineUnit;
import models.Supplier;
import utils.DBContext;

public class ImportDAO {

    private final DBContext dbContext;

    public ImportDAO() {
        this.dbContext = new DBContext();
    }

    public List<Import> getAllImports() {
        List<Import> imports = new ArrayList<>();

        String sql = "SELECT i.ImportId, i.ImportCode, i.SupplierId, s.SupplierName, " +
                "       i.StaffId, st.StaffName, i.ImportCreatedAt, i.TotalPrice, i.ImportStatus " +
                "FROM   [Import] i " +
                "LEFT JOIN Supplier s ON i.SupplierId = s.SupplierId " +
                "LEFT JOIN Staff st   ON i.StaffId   = st.StaffId " +
                "ORDER BY i.ImportCreatedAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Import imp = mapImport(rs);
                imports.add(imp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imports;
    }

    public List<Import> searchImports(String keyword) {
        List<Import> imports = new ArrayList<>();

        String sql = "SELECT i.ImportId, i.ImportCode, i.SupplierId, s.SupplierName, " +
                "       i.StaffId, st.StaffName, i.ImportCreatedAt, i.TotalPrice, i.ImportStatus " +
                "FROM   [Import] i " +
                "LEFT JOIN Supplier s ON i.SupplierId = s.SupplierId " +
                "LEFT JOIN Staff st   ON i.StaffId   = st.StaffId " +
                "WHERE  CAST(i.ImportId AS VARCHAR(10)) LIKE ? " +
                "   OR  i.ImportCode LIKE ? " +
                "   OR  s.SupplierName LIKE ? " +
                "ORDER BY i.ImportCreatedAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern.toUpperCase());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Import imp = mapImport(rs);
                    imports.add(imp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imports;
    }

    public Import getImportById(int importId) {
        Import imp = null;

        String sql = "SELECT i.ImportId, i.ImportCode, i.SupplierId, s.SupplierName, " +
                "       i.StaffId, st.StaffName, i.ImportCreatedAt, i.TotalPrice, i.ImportStatus " +
                "FROM   [Import] i " +
                "LEFT JOIN Supplier s ON i.SupplierId = s.SupplierId " +
                "LEFT JOIN Staff st   ON i.StaffId   = st.StaffId " +
                "WHERE  i.ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    imp = mapImport(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imp;
    }

    public boolean createImport(Import imp) {
        String sql = "INSERT INTO [Import] (ImportCode, SupplierId, StaffId, ImportCreatedAt, TotalPrice, ImportStatus) "
                +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, imp.getImportCode());
            ps.setInt(2, imp.getSupplierId());
            ps.setInt(3, imp.getStaffId());

            java.util.Date date = imp.getImportDate();
            if (date == null) {
                date = new java.util.Date();
            }
            ps.setTimestamp(4, new java.sql.Timestamp(date.getTime()));

            double total = imp.getTotalAmount() > 0 ? imp.getTotalAmount() : 0.0;
            ps.setDouble(5, total);

            String status = imp.getStatus();
            if (status == null || status.isEmpty()) {
                status = "Pending";
            }
            ps.setString(6, status);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        imp.setImportId(generatedId);
                        String finalCode = formatImportCode(generatedId);
                        imp.setImportCode(finalCode);

                        // Update the database with the actual ImportCode based on the generated ID
                        String updateSql = "UPDATE [Import] SET ImportCode = ? WHERE ImportId = ?";
                        try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                            ups.setString(1, finalCode);
                            ups.setInt(2, generatedId);
                            ups.executeUpdate();
                        }
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createImport: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateImport(Import imp) {
        String sql = "UPDATE [Import] " +
                "SET ImportCode = ?, SupplierId = ?, StaffId = ?, ImportCreatedAt = ?, TotalPrice = ?, ImportStatus = ? "
                +
                "WHERE ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, imp.getImportCode());
            ps.setInt(2, imp.getSupplierId());
            ps.setInt(3, imp.getStaffId());

            java.util.Date date = imp.getImportDate();
            if (date == null) {
                date = new java.util.Date();
            }
            ps.setTimestamp(4, new java.sql.Timestamp(date.getTime()));

            ps.setDouble(5, imp.getTotalAmount());
            ps.setString(6, imp.getStatus());
            ps.setInt(7, imp.getImportId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteImport(int importId) {
        deleteImportDetailsByImportId(importId);
        String deleteSql = "DELETE FROM Import WHERE ImportId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(deleteSql)) {

            ps.setInt(1, importId);
            if (ps.executeUpdate() > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ImportDetail> getImportDetails(int importId) {
        List<ImportDetail> details = new ArrayList<>();

        String sql = "SELECT d.ImportDetailId, d.ImportId, d.MedicineUnitId, " +
                "       mu.MedicineId, mu.UnitId, m.MedicineCode, m.MedicineName, u.UnitName, d.ImportQuantity, d.UnitPrice "
                +
                "FROM   ImportDetail d " +
                "JOIN MedicineUnit mu ON d.MedicineUnitId = mu.MedicineUnitId " +
                "JOIN Medicine m ON mu.MedicineId = m.MedicineId " +
                "JOIN Unit u ON mu.UnitId = u.UnitId " +
                "WHERE  d.ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, importId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportDetail detail = new ImportDetail();
                    detail.setDetailId(rs.getInt("ImportDetailId"));
                    detail.setImportId(rs.getInt("ImportId"));
                    detail.setMedicineUnitId(rs.getInt("MedicineUnitId"));
                    detail.setMedicineId(rs.getInt("MedicineId"));
                    detail.setUnitId(rs.getInt("UnitId"));
                    detail.setMedicineCode(rs.getString("MedicineCode"));
                    detail.setMedicineName(rs.getString("MedicineName"));
                    detail.setUnitName(rs.getString("UnitName"));
                    detail.setQuantity(rs.getInt("ImportQuantity"));
                    detail.setUnitPrice(rs.getDouble("UnitPrice"));
                    detail.recalculateTotal();
                    details.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    public boolean addImportDetail(ImportDetail detail) {
        String sql = "INSERT INTO ImportDetail (ImportId, MedicineUnitId, ImportQuantity, UnitPrice) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detail.getImportId());
            ps.setInt(2, detail.getMedicineUnitId());
            ps.setInt(3, detail.getQuantity());
            ps.setDouble(4, detail.getUnitPrice());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateImportDetail(ImportDetail detail) {
        String sql = "UPDATE ImportDetail SET ImportQuantity = ?, UnitPrice = ? WHERE ImportDetailId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, detail.getQuantity());
            ps.setDouble(2, detail.getUnitPrice());
            ps.setInt(3, detail.getDetailId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteImportDetail(int detailId) {
        String sql = "DELETE FROM ImportDetail WHERE ImportDetailId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteImportDetailsByImportId(int importId) {
        String sql = "DELETE FROM ImportDetail WHERE ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double calculateTotalAmount(int importId) {
        String sql = "SELECT SUM(CAST(d.ImportQuantity AS DECIMAL(18,2)) * d.UnitPrice) AS Total " +
                "FROM   ImportDetail d " +
                "WHERE  d.ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("Total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public String generateImportCode() {
        String sql = "SELECT ISNULL(MAX(ImportId), 0) AS LastId FROM Import";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            int lastId = 0;
            if (rs.next()) {
                lastId = rs.getInt("LastId");
            }
            int nextId = lastId + 1;
            return formatImportCode(nextId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "IP001";
    }

    private Import mapImport(ResultSet rs) throws SQLException {
        Import imp = new Import();
        int importId = rs.getInt("ImportId");
        imp.setImportId(importId);
        imp.setImportCode(rs.getString("ImportCode"));
        imp.setSupplierId(rs.getInt("SupplierId"));
        imp.setSupplierName(rs.getString("SupplierName"));
        imp.setStaffId(rs.getInt("StaffId"));
        imp.setStaffName(rs.getString("StaffName"));
        imp.setImportDate(rs.getDate("ImportCreatedAt"));
        imp.setTotalAmount(rs.getDouble("TotalPrice"));
        imp.setStatus(rs.getString("ImportStatus")); // Set ImportStatus
        imp.setImportCode(formatImportCode(importId));
        return imp;
    }

    public String formatImportCode(int importId) {
        return String.format("IP%03d", importId);
    }

    public int getMedicineIdByCode(String code) {
        String sql = "SELECT MedicineId FROM Medicine WHERE MedicineCode = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("MedicineId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getStaffIdByCode(String code) {
        String sql = "SELECT StaffId FROM Staff WHERE StaffCode = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("StaffId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getSupplierIdByName(String name) {
        String sql = "SELECT SupplierId FROM Supplier WHERE SupplierName LIKE ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("SupplierId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.MedicineId, m.MedicineCode, m.MedicineName, m.OriginalPrice, m.CategoryId, "
                + "mu.UnitName, mu.UnitId, mu.MedicineUnitId, mu.ConversionRate "
                + "FROM Medicine m "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 u.UnitName, mi.UnitId, mi.MedicineUnitId, mi.ConversionRate "
                + "    FROM MedicineUnit mi "
                + "    JOIN Unit u ON mi.UnitId = u.UnitId "
                + "    WHERE mi.MedicineId = m.MedicineId "
                + "    ORDER BY mi.ConversionRate DESC, mi.MedicineUnitId ASC "
                + ") mu";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("MedicineId"));
                m.setMedicineCode(rs.getString("MedicineCode"));
                m.setMedicineName(rs.getString("MedicineName"));
                m.setOriginalPrice(rs.getDouble("OriginalPrice"));
                m.setCategoryId(rs.getInt("CategoryId"));

                int unitId = rs.getInt("UnitId");
                if (!rs.wasNull() && unitId > 0) {
                    MedicineUnit bu = new MedicineUnit();
                    bu.setUnitId(unitId);
                    bu.setMedicineUnitId(rs.getInt("MedicineUnitId"));
                    bu.setUnitName(rs.getString("UnitName"));
                    bu.setConversionRate(rs.getInt("ConversionRate"));
                    m.setBaseUnit(bu);
                }
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getMedicinePriceById(int medicineId) {
        String sql = "SELECT OriginalPrice FROM Medicine WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("OriginalPrice");
                }
            }
        } catch (SQLException e) {
        }
        return 0;
    }

    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT SupplierId, SupplierName, SupplierAddress, ContactInfo FROM Supplier ORDER BY SupplierName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("SupplierId"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setSupplierAddress(rs.getString("SupplierAddress"));
                s.setContactInfo(rs.getString("ContactInfo"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteImportDetailsByMedicineId(int medicineId) {
        String sql = "DELETE FROM ImportDetail WHERE MedicineUnitId IN (SELECT MedicineUnitId FROM MedicineUnit WHERE MedicineId = ?)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

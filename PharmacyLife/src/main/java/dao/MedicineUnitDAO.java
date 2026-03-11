package dao;

import models.MedicineUnit;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineUnitDAO {

    private DBContext dbContext = new DBContext();

    public MedicineUnitDAO() {
    }

    public MedicineUnit getUnitById(int unitId) {
        String sql = "SELECT * FROM MedicineUnit WHERE UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, unitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all units for a given medicine.
     */
    public List<MedicineUnit> getUnitsByMedicineId(int medicineId) {
        List<MedicineUnit> units = new ArrayList<>();
        String sql = "SELECT * FROM MedicineUnit WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    units.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return units;
    }

    /**
     * Get the base unit (IsBaseUnit = 1) for a given medicine.
     * Returns null if no base unit is defined.
     */
    public MedicineUnit getBaseUnit(int medicineId) {
        String sql = "SELECT * FROM MedicineUnit WHERE MedicineId = ? AND IsBaseUnit = 1";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Insert a new MedicineUnit record. Returns the generated UnitId, or -1 on
     * failure.
     */
    public int addUnit(MedicineUnit unit) {
        String sql = "INSERT INTO MedicineUnit (MedicineId, UnitName, ConversionRate, SellingPrice, IsBaseUnit) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, unit.getMedicineId());
            ps.setString(2, unit.getUnitName());
            ps.setInt(3, unit.getConversionRate());
            ps.setDouble(4, unit.getSellingPrice());
            ps.setBoolean(5, unit.isBaseUnit());
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

    /**
     * Update an existing MedicineUnit by UnitId.
     */
    public boolean updateUnit(MedicineUnit unit) {
        String sql = "UPDATE MedicineUnit SET UnitName = ?, ConversionRate = ?, SellingPrice = ?, IsBaseUnit = ? "
                + "WHERE UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, unit.getUnitName());
            ps.setInt(2, unit.getConversionRate());
            ps.setDouble(3, unit.getSellingPrice());
            ps.setBoolean(4, unit.isBaseUnit());
            ps.setInt(5, unit.getUnitId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update only the base unit's UnitName, SellingPrice and ConversionRate for a
     * given medicine.
     */
    public boolean updateUnitInternal(int medicineId, String unitName, double sellingPrice, int conversionRate,
            boolean isBase) {
        String sql = "UPDATE MedicineUnit SET UnitName = ?, SellingPrice = ?, ConversionRate = ?, IsBaseUnit = ? "
                + "WHERE UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = ? AND IsBaseUnit = 1 ORDER BY UnitId ASC)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, unitName);
            ps.setDouble(2, sellingPrice);
            ps.setInt(3, conversionRate);
            ps.setBoolean(4, isBase);
            ps.setInt(5, medicineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update only the base unit's UnitName and SellingPrice for a given medicine.
     */
    public boolean updateBaseUnit(int medicineId, String unitName, double sellingPrice) {
        String sql = "UPDATE MedicineUnit SET UnitName = ?, SellingPrice = ? "
                + "WHERE UnitId = (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = ? ORDER BY UnitId ASC)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, unitName);
            ps.setDouble(2, sellingPrice);
            ps.setInt(3, medicineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete all units for a medicine (useful when deleting a medicine).
     */
    public boolean deleteUnitsByMedicineId(int medicineId) {
        String sql = "DELETE FROM MedicineUnit WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete non-base units for a medicine (useful when updating dynamic
     * sub-units).
     */
    public boolean deleteNonBaseUnitsByMedicineId(int medicineId) {
        String sql = "DELETE FROM MedicineUnit WHERE MedicineId = ? AND UnitId != (SELECT TOP 1 UnitId FROM MedicineUnit WHERE MedicineId = ? ORDER BY UnitId ASC)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.setInt(2, medicineId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUnit(int unitId) {
        String sql = "DELETE FROM MedicineUnit WHERE UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, unitId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private MedicineUnit mapResultSet(ResultSet rs) throws SQLException {
        MedicineUnit unit = new MedicineUnit();
        unit.setUnitId(rs.getInt("UnitId"));
        unit.setMedicineId(rs.getInt("MedicineId"));
        unit.setUnitName(rs.getString("UnitName"));
        unit.setConversionRate(rs.getInt("ConversionRate"));
        unit.setSellingPrice(rs.getDouble("SellingPrice"));
        unit.setBaseUnit(rs.getBoolean("IsBaseUnit"));
        return unit;
    }
}

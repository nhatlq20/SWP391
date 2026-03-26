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

    public MedicineUnit getUnitById(int medicineUnitId) {
        String sql = "SELECT mu.*, u.UnitName FROM MedicineUnit mu "
                + "LEFT JOIN Unit u ON mu.UnitId = u.UnitId "
                + "WHERE mu.MedicineUnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineUnitId);
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
        String sql = "SELECT mu.*, u.UnitName FROM MedicineUnit mu "
                + "LEFT JOIN Unit u ON mu.UnitId = u.UnitId "
                + "WHERE mu.MedicineId = ?";
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
        String sql = "SELECT mu.*, u.UnitName FROM MedicineUnit mu "
                + "LEFT JOIN Unit u ON mu.UnitId = u.UnitId "
                + "WHERE mu.MedicineId = ? AND mu.IsBaseUnit = 1";
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
        String sql = "INSERT INTO MedicineUnit (MedicineId, UnitId, ConversionRate, SellingPrice, IsBaseUnit) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, unit.getMedicineId());
            ps.setInt(2, unit.getUnitId());
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
        String sql = "UPDATE MedicineUnit SET UnitId = ?, ConversionRate = ?, SellingPrice = ?, IsBaseUnit = ? "
                + "WHERE MedicineUnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, unit.getUnitId());
            ps.setInt(2, unit.getConversionRate());
            ps.setDouble(3, unit.getSellingPrice());
            ps.setBoolean(4, unit.isBaseUnit());
            ps.setInt(5, unit.getMedicineUnitId());
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
    public boolean updateUnitInternal(int medicineId, int unitId, double sellingPrice, int conversionRate,
            boolean isBase) {
        String sql = "UPDATE MedicineUnit SET UnitId = ?, SellingPrice = ?, ConversionRate = ?, IsBaseUnit = ? "
                + "WHERE MedicineUnitId = (SELECT TOP 1 MedicineUnitId FROM MedicineUnit WHERE MedicineId = ? AND IsBaseUnit = 1 ORDER BY MedicineId ASC)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, unitId);
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
    public boolean updateBaseUnit(int medicineId, int unitId, double sellingPrice) {
        String sql = "UPDATE MedicineUnit SET UnitId = ?, SellingPrice = ? "
                + "WHERE MedicineUnitId = (SELECT TOP 1 MedicineUnitId FROM MedicineUnit WHERE MedicineId = ? ORDER BY MedicineUnitId ASC)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, unitId);
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
        String sql = "DELETE FROM MedicineUnit WHERE MedicineId = ? AND MedicineUnitId != (SELECT TOP 1 MedicineUnitId FROM MedicineUnit WHERE MedicineId = ? ORDER BY MedicineUnitId ASC)";
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

    public boolean deleteUnit(int medicineUnitId) {
        String sql = "DELETE FROM MedicineUnit WHERE MedicineUnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineUnitId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private MedicineUnit mapResultSet(ResultSet rs) throws SQLException {
        MedicineUnit unit = new MedicineUnit();
        unit.setMedicineUnitId(rs.getInt("MedicineUnitId"));
        unit.setMedicineId(rs.getInt("MedicineId"));
        unit.setUnitId(rs.getInt("UnitId"));
        unit.setUnitName(rs.getString("UnitName"));
        unit.setConversionRate(rs.getInt("ConversionRate"));
        unit.setSellingPrice(rs.getDouble("SellingPrice"));
        unit.setBaseUnit(rs.getBoolean("IsBaseUnit"));
        return unit;
    }

    public int getUnitIdByName(String unitName) {
        String sql = "SELECT UnitId FROM Unit WHERE UnitName = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, unitName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<models.Unit> getAllUnitTypes() {
        List<models.Unit> unitTypes = new ArrayList<>();
        String sql = "SELECT * FROM Unit ORDER BY UnitName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                unitTypes.add(new models.Unit(rs.getInt("UnitId"), rs.getString("UnitName")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return unitTypes;
    }
    public int getMedicineUnitId(int medicineId, int unitId) {
        String sql = "SELECT MedicineUnitId FROM MedicineUnit WHERE MedicineId = ? AND UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.setInt(2, unitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}

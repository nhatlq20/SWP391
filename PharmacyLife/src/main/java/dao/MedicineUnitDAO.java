package dao;

import models.MedicineUnit;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineUnitDAO {
    private DBContext dbContext = new DBContext();

    public List<MedicineUnit> getAllUnits() {
        List<MedicineUnit> units = new ArrayList<>();
        String sql = "SELECT UnitId, MedicineId, UnitName, ConversionRate, SellingPrice, IsBaseUnit FROM MedicineUnit";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MedicineUnit unit = new MedicineUnit();
                unit.setUnitId(rs.getInt("UnitId"));
                unit.setMedicineId(rs.getInt("MedicineId"));
                unit.setUnitName(rs.getString("UnitName"));
                unit.setConversionRate(rs.getInt("ConversionRate"));
                unit.setSellingPrice(rs.getDouble("SellingPrice"));
                unit.setBaseUnit(rs.getBoolean("IsBaseUnit"));
                units.add(unit);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return units;
    }

    public List<MedicineUnit> getUnitsByMedicineId(int medicineId) {
        List<MedicineUnit> units = new ArrayList<>();
        String sql = "SELECT UnitId, MedicineId, UnitName, ConversionRate, SellingPrice, IsBaseUnit FROM MedicineUnit WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicineUnit unit = new MedicineUnit();
                    unit.setUnitId(rs.getInt("UnitId"));
                    unit.setMedicineId(rs.getInt("MedicineId"));
                    unit.setUnitName(rs.getString("UnitName"));
                    unit.setConversionRate(rs.getInt("ConversionRate"));
                    unit.setSellingPrice(rs.getDouble("SellingPrice"));
                    unit.setBaseUnit(rs.getBoolean("IsBaseUnit"));
                    units.add(unit);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return units;
    }

    public MedicineUnit getUnitById(int unitId) {
        String sql = "SELECT UnitId, MedicineId, UnitName, ConversionRate, SellingPrice, IsBaseUnit FROM MedicineUnit WHERE UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, unitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateSellingPrice(int unitId, double newPrice) {
        String sql = "UPDATE MedicineUnit SET SellingPrice = ? WHERE UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, newPrice);
            ps.setInt(2, unitId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

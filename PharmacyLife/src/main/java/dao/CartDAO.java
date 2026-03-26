package dao;

import java.sql.*;
import models.Cart;
import models.Medicine;
import models.MedicineUnit;
import utils.DBContext;

public class CartDAO {
    private DBContext dbContext = new DBContext();

    public boolean saveCartItem(int customerId, int medicineUnitId, int quantity) {
        System.out.println("[CartDAO] saveCartItem called: customerId=" + customerId
                + ", medicineUnitId=" + medicineUnitId + ", quantity=" + quantity);

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // Check if row exists
            String checkSql = "SELECT COUNT(*) FROM Carts WHERE CustomerId = ? AND MedicineUnitId = ?";
            int count = 0;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, medicineUnitId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) count = rs.getInt(1);
                }
            }

            int rows;
            if (count > 0) {
                // UPDATE
                String updateSql = "UPDATE Carts SET CartQuantity = ?, CartUpdatedAt = GETDATE() WHERE CustomerId = ? AND MedicineUnitId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, customerId);
                    ps.setInt(3, medicineUnitId);
                    rows = ps.executeUpdate();
                }
            } else {
                // INSERT
                String insertSql = "INSERT INTO Carts (CustomerId, MedicineUnitId, CartQuantity) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, medicineUnitId);
                    ps.setInt(3, quantity);
                    rows = ps.executeUpdate();
                }
            }

            conn.commit();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
        return false;
    }

    public boolean removeCartItem(int customerId, int medicineUnitId) {
        String sql = "DELETE FROM Carts WHERE CustomerId = ? AND MedicineUnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, medicineUnitId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearCart(int customerId) {
        String sql = "DELETE FROM Carts WHERE CustomerId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeCartItemsByMedicineId(int medicineId) {
        String sql = "DELETE FROM Carts WHERE MedicineUnitId IN (SELECT MedicineUnitId FROM MedicineUnit WHERE MedicineId = ?)";
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

    public Cart getCartByCustomerId(int customerId) {
        Cart cart = new Cart();
        String sql = "SELECT c.MedicineUnitId, c.CartQuantity, " +
                "mu.MedicineId, mu.UnitId, mu.SellingPrice, mu.ConversionRate, mu.IsBaseUnit, " +
                "m.MedicineCode, m.MedicineName, m.ImageUrl, m.RemainingQuantity, " +
                "u.UnitName, " +
                "bu.MedicineUnitId as BaseMUId, bu.UnitId as BaseUnitId, u_base.UnitName as BaseUnitName, " +
                "bu.SellingPrice as BasePrice, bu.ConversionRate as BaseConvRate " +
                "FROM Carts c " +
                "JOIN MedicineUnit mu ON c.MedicineUnitId = mu.MedicineUnitId " +
                "JOIN Medicine m ON mu.MedicineId = m.MedicineId " +
                "LEFT JOIN Unit u ON mu.UnitId = u.UnitId " +
                "LEFT JOIN MedicineUnit bu ON bu.MedicineId = m.MedicineId AND bu.IsBaseUnit = 1 " +
                "LEFT JOIN Unit u_base ON bu.UnitId = u_base.UnitId " +
                "WHERE c.CustomerId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine med = new Medicine();
                    med.setMedicineId(rs.getInt("MedicineId"));
                    med.setMedicineCode(rs.getString("MedicineCode"));
                    med.setMedicineName(rs.getString("MedicineName"));
                    med.setImageUrl(rs.getString("ImageUrl"));
                    med.setRemainingQuantity(rs.getInt("RemainingQuantity"));

                    // Set base unit on med for stock calculations
                    MedicineUnit baseMU = new MedicineUnit();
                    baseMU.setMedicineUnitId(rs.getInt("BaseMUId"));
                    baseMU.setUnitId(rs.getInt("BaseUnitId"));
                    baseMU.setUnitName(rs.getString("BaseUnitName"));
                    baseMU.setSellingPrice(rs.getDouble("BasePrice"));
                    baseMU.setConversionRate(rs.getInt("BaseConvRate"));
                    baseMU.setBaseUnit(true);
                    med.setBaseUnit(baseMU);

                    Cart.Item item = new Cart.Item(
                        med, 
                        rs.getInt("MedicineUnitId"), 
                        rs.getString("UnitName"), 
                        rs.getInt("ConversionRate"),
                        rs.getInt("CartQuantity"), 
                        rs.getDouble("SellingPrice")
                    );
                    cart.addItem(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }
}

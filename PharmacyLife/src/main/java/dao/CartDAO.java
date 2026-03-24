package dao;

import java.sql.*;
import models.Cart;
import models.Medicine;
import utils.DBContext;

public class CartDAO {
    private DBContext dbContext = new DBContext();

    /**
     * Save or update a cart item using simple SELECT then UPDATE/INSERT.
     * unitId = 0 is treated as NULL (no specific unit selected).
     */
    public boolean saveCartItem(int customerId, int medicineId, int unitId, int quantity) {
        System.out.println("[CartDAO] saveCartItem called: customerId=" + customerId
                + ", medicineId=" + medicineId + ", unitId=" + unitId + ", quantity=" + quantity);

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Check if row exists
            String checkSql;
            if (unitId > 0) {
                checkSql = "SELECT COUNT(*) FROM Carts WHERE CustomerId = ? AND MedicineId = ? AND UnitId = ?";
            } else {
                checkSql = "SELECT COUNT(*) FROM Carts WHERE CustomerId = ? AND MedicineId = ? AND (UnitId IS NULL OR UnitId = 0)";
            }

            int count = 0;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, medicineId);
                if (unitId > 0) ps.setInt(3, unitId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) count = rs.getInt(1);
                }
            }
            System.out.println("[CartDAO] Row exists count=" + count);

            int rows;
            if (count > 0) {
                // UPDATE existing row
                String updateSql;
                if (unitId > 0) {
                    updateSql = "UPDATE Carts SET CartQuantity = ? WHERE CustomerId = ? AND MedicineId = ? AND UnitId = ?";
                } else {
                    updateSql = "UPDATE Carts SET CartQuantity = ? WHERE CustomerId = ? AND MedicineId = ? AND (UnitId IS NULL OR UnitId = 0)";
                }
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, customerId);
                    ps.setInt(3, medicineId);
                    if (unitId > 0) ps.setInt(4, unitId);
                    rows = ps.executeUpdate();
                    System.out.println("[CartDAO] UPDATE rows affected=" + rows);
                }
            } else {
                // INSERT new row
                String insertSql = "INSERT INTO Carts (CustomerId, MedicineId, UnitId, CartQuantity) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, medicineId);
                    if (unitId > 0) ps.setInt(3, unitId);
                    else ps.setNull(3, Types.INTEGER);
                    ps.setInt(4, quantity);
                    rows = ps.executeUpdate();
                    System.out.println("[CartDAO] INSERT rows affected=" + rows);
                }
            }

            conn.commit();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[CartDAO] SQLException in saveCartItem: " + e.getMessage());
            System.err.println("[CartDAO] SQL State: " + e.getSQLState());
            System.err.println("[CartDAO] Error Code: " + e.getErrorCode());
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

    // Legacy support
    public boolean saveCartItem(int customerId, int medicineId, int quantity) {
        return saveCartItem(customerId, medicineId, 0, quantity);
    }

    public boolean removeCartItem(int customerId, int medicineId, int unitId) {
        String sql;
        if (unitId > 0) {
            sql = "DELETE FROM Carts WHERE CustomerId = ? AND MedicineId = ? AND UnitId = ?";
        } else {
            sql = "DELETE FROM Carts WHERE CustomerId = ? AND MedicineId = ? AND (UnitId IS NULL OR UnitId = 0)";
        }
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);
            if (unitId > 0) ps.setInt(3, unitId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CartDAO] removeCartItem error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeCartItem(int customerId, int medicineId) {
        return removeCartItem(customerId, medicineId, 0);
    }

    public boolean clearCart(int customerId) {
        String sql = "DELETE FROM Carts WHERE CustomerId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CartDAO] clearCart error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Cart getCartByCustomerId(int customerId) {
        Cart cart = new Cart();
        System.out.println("[CartDAO] getCartByCustomerId: customerId=" + customerId);

        // IMPORTANT: Medicine table has NO SellingPrice column.
        // Prices are stored entirely in MedicineUnit table.
        // mu = the specific unit stored in the cart row
        // bu = the base unit (IsBaseUnit=1) as fallback
        String sql = "SELECT c.MedicineId, c.UnitId, c.CartQuantity, " +
                "m.MedicineCode, m.MedicineName, m.ImageUrl, m.RemainingQuantity, " +
                "mu.UnitName as SelectedUnitName, mu.SellingPrice as UnitSellingPrice, " +
                "mu.ConversionRate as UnitConvRate, " +
                "bu.UnitId as BaseUnitId, bu.UnitName as BaseUnitName, " +
                "bu.SellingPrice as BaseSellingPrice, bu.ConversionRate as BaseConvRate " +
                "FROM Carts c " +
                "JOIN Medicine m ON c.MedicineId = m.MedicineId " +
                "LEFT JOIN MedicineUnit mu ON mu.UnitId = c.UnitId " +
                "LEFT JOIN MedicineUnit bu ON bu.MedicineId = m.MedicineId AND bu.IsBaseUnit = 1 " +
                "WHERE c.CustomerId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                int rowCount = 0;
                while (rs.next()) {
                    rowCount++;

                    // Build Medicine object
                    Medicine med = new Medicine();
                    med.setMedicineId(rs.getInt("MedicineId"));
                    med.setMedicineCode(rs.getString("MedicineCode"));
                    med.setMedicineName(rs.getString("MedicineName"));
                    med.setImageUrl(rs.getString("ImageUrl"));
                    med.setRemainingQuantity(rs.getInt("RemainingQuantity"));

                    // Populate base unit on Medicine (for stock display calculations)
                    int baseUnitId = rs.getInt("BaseUnitId");
                    models.MedicineUnit bu = null;
                    if (!rs.wasNull() && baseUnitId > 0) {
                        bu = new models.MedicineUnit();
                        bu.setUnitId(baseUnitId);
                        bu.setUnitName(rs.getString("BaseUnitName"));
                        bu.setBaseUnit(true);
                        double baseSP = rs.getDouble("BaseSellingPrice");
                        bu.setSellingPrice(rs.wasNull() ? 0 : baseSP);
                        int baseConvRate = rs.getInt("BaseConvRate");
                        bu.setConversionRate(rs.wasNull() ? 1 : baseConvRate);
                        med.setBaseUnit(bu);
                    }

                    // Determine effective unit for this cart row
                    int storedUnitId = rs.getInt("UnitId");
                    boolean hasSpecificUnit = !rs.wasNull() && storedUnitId > 0;

                    String unitName = rs.getString("SelectedUnitName");
                    double price = rs.getDouble("UnitSellingPrice");
                    boolean priceNull = rs.wasNull();
                    int convRate = rs.getInt("UnitConvRate");
                    boolean convRateNull = rs.wasNull();

                    // Fallback to base unit values if specific unit not found
                    if (!hasSpecificUnit || priceNull) {
                        price = (bu != null) ? bu.getSellingPrice() : 0;
                    }
                    if (!hasSpecificUnit || convRateNull || convRate == 0) {
                        convRate = (bu != null) ? bu.getConversionRate() : 1;
                    }
                    if (unitName == null) {
                        unitName = (bu != null) ? bu.getUnitName() : "";
                    }

                    med.setUnit(unitName);

                    int effectiveUnitId = hasSpecificUnit ? storedUnitId : 0;
                    Cart.Item item = new Cart.Item(med, effectiveUnitId, unitName, convRate,
                            rs.getInt("CartQuantity"), price);
                    cart.addItem(item);
                    System.out.println("[CartDAO] Loaded: " + med.getMedicineName()
                            + " unitId=" + effectiveUnitId
                            + " qty=" + rs.getInt("CartQuantity")
                            + " price=" + price
                            + " convRate=" + convRate);
                }
                System.out.println("[CartDAO] Total items loaded from DB: " + rowCount);
            }
        } catch (SQLException e) {
            System.err.println("[CartDAO] getCartByCustomerId FAILED: " + e.getMessage());
            e.printStackTrace();
        }
        return cart;
    }

    public boolean removeCartItemsByMedicineId(int medicineId) {
        String sql = "DELETE FROM Carts WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CartDAO] removeCartItemsByMedicineId error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

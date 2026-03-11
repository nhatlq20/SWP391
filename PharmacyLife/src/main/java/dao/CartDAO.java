package dao;

import java.sql.*;
import models.Cart;
import models.Medicine;
import utils.DBContext;

public class CartDAO {
    private DBContext dbContext = new DBContext();

    public boolean saveCartItem(int customerId, int medicineId, int unitId, int quantity) {
        String sql = "IF EXISTS (SELECT 1 FROM Carts WHERE CustomerId = ? AND MedicineId = ? AND UnitId = ?) " +
                "UPDATE Carts SET CartQuantity = ? WHERE CustomerId = ? AND MedicineId = ? AND UnitId = ? " +
                "ELSE " +
                "INSERT INTO Carts (CustomerId, MedicineId, UnitId, CartQuantity) VALUES (?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);
            ps.setInt(3, unitId);
            ps.setInt(4, quantity);
            ps.setInt(5, customerId);
            ps.setInt(6, medicineId);
            ps.setInt(7, unitId);
            ps.setInt(8, customerId);
            ps.setInt(9, medicineId);
            ps.setInt(10, unitId);
            ps.setInt(11, quantity);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Legacy support
    public boolean saveCartItem(int customerId, int medicineId, int quantity) {
        return saveCartItem(customerId, medicineId, 0, quantity);
    }

    public boolean removeCartItem(int customerId, int medicineId, int unitId) {
        String sql = "DELETE FROM Carts WHERE CustomerId = ? AND MedicineId = ? AND UnitId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);
            ps.setInt(3, unitId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
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
            e.printStackTrace();
        }
        return false;
    }

    public Cart getCartByCustomerId(int customerId) {
        Cart cart = new Cart();
        String sql = "SELECT c.*, m.MedicineCode, m.MedicineName, m.ImageUrl, " +
                "mu.UnitName as SelectedUnitName, mu.SellingPrice, mu.ConversionRate, " +
                "bu.UnitId as BaseUnitId, bu.UnitName as BaseUnitName " +
                "FROM Carts c " +
                "JOIN Medicine m ON c.MedicineId = m.MedicineId " +
                "LEFT JOIN MedicineUnit mu ON c.UnitId = mu.UnitId " +
                "LEFT JOIN MedicineUnit bu ON m.MedicineId = bu.MedicineId AND bu.IsBaseUnit = 1 " +
                "WHERE c.CustomerId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine m = new Medicine();
                    m.setMedicineId(rs.getInt("MedicineId"));
                    m.setMedicineCode(rs.getString("MedicineCode"));
                    m.setMedicineName(rs.getString("MedicineName"));
                    m.setImageUrl(rs.getString("ImageUrl"));
                    
                    String selectedUnitName = rs.getString("SelectedUnitName");
                    m.setUnit(selectedUnitName);

                    // Populate Base Unit info for Medicine
                    int baseUnitId = rs.getInt("BaseUnitId");
                    if (!rs.wasNull()) {
                        models.MedicineUnit bu = new models.MedicineUnit();
                        bu.setUnitId(baseUnitId);
                        bu.setUnitName(rs.getString("BaseUnitName"));
                        bu.setBaseUnit(true);
                        m.setBaseUnit(bu);
                    }

                    double price = rs.getDouble("SellingPrice");
                    if (rs.wasNull())
                        price = 0; // Fallback

                    int convRate = rs.getInt("ConversionRate");
                    Cart.Item item = new Cart.Item(m, rs.getInt("UnitId"), selectedUnitName, convRate, rs.getInt("CartQuantity"), price);
                    cart.addItem(item);
                }
            }
        } catch (SQLException e) {
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
            e.printStackTrace();
        }
        return false;
    }
}

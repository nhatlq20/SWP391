package dao;

import java.sql.*;
import models.Cart;
import models.Medicine;
import utils.DBContext;

public class CartDAO {
    private DBContext dbContext = new DBContext();

    public boolean saveCartItem(int customerId, int medicineId, int quantity) {
        String sql = "IF EXISTS (SELECT 1 FROM Carts WHERE CustomerId = ? AND MedicineId = ?) " +
                "UPDATE Carts SET CartQuantity = ?, CartUpdate = GETDATE() WHERE CustomerId = ? AND MedicineId = ? " +
                "ELSE " +
                "INSERT INTO Carts (CustomerId, MedicineId, CartQuantity, CartCreateAt, CartUpdate) VALUES (?, ?, ?, GETDATE(), GETDATE())";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity);
            ps.setInt(4, customerId);
            ps.setInt(5, medicineId);
            ps.setInt(6, customerId);
            ps.setInt(7, medicineId);
            ps.setInt(8, quantity);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeCartItem(int customerId, int medicineId) {
        String sql = "DELETE FROM Carts WHERE CustomerId = ? AND MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);
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

    public Cart getCartByCustomerId(int customerId) {
        Cart cart = new Cart();
        String sql = "SELECT c.*, m.* FROM Carts c " +
                "JOIN Medicine m ON c.MedicineId = m.MedicineId " +
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
                    m.setSellingPrice(rs.getDouble("SellingPrice"));
                    m.setImageUrl(rs.getString("ImageUrl"));
                    m.setUnit(rs.getString("Unit"));

                    Cart.Item item = new Cart.Item(m, rs.getInt("CartQuantity"), m.getSellingPrice());
                    cart.addItem(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }
}

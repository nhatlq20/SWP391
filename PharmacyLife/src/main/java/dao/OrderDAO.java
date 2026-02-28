package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Order;
import models.OrderItem;
import models.Medicine;
import utils.DBContext;

public class OrderDAO {
    private DBContext dbContext = new DBContext();

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY OrderId ASC";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE CustomerId = ? ORDER BY OrderDate DESC";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(order.getOrderId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM Orders WHERE OrderId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, m.MedicineName, m.MedicineCode, m.ImageUrl " +
                "FROM OrderItems oi " +
                "JOIN Medicine m ON oi.MedicineId = m.MedicineId " +
                "WHERE oi.OrderId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderId(rs.getInt("OrderId"));
                    item.setMedicineId(rs.getInt("MedicineId"));
                    item.setQuantity(rs.getInt("OrderQuantity"));
                    item.setUnitPrice(rs.getDouble("UnitPrice"));

                    Medicine m = new Medicine();
                    m.setMedicineId(rs.getInt("MedicineId"));
                    m.setMedicineName(rs.getString("MedicineName"));
                    m.setMedicineCode(rs.getString("MedicineCode"));
                    m.setImageUrl(rs.getString("ImageUrl"));
                    item.setMedicine(m);

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
// xử lí dao để coi trạng thái
    public boolean hasCustomerPurchasedMedicine(int customerId, int medicineId) {
        String sql = "SELECT TOP 1 1 "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON oi.OrderId = o.OrderId "
                + "WHERE o.CustomerId = ? "
                + "AND oi.MedicineId = ? "
                + "AND LOWER(o.Status) IN (N'completed', N'delivered', N'đã giao', N'đã giao hàng')";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean saveOrder(Order order) {
        String sqlOrder = "INSERT INTO Orders (CustomerId, StaffId, OrderDate, ShippingName, ShippingPhone, ShippingAddress, Status, TotalAmount) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlItem = "INSERT INTO OrderItems (OrderId, MedicineId, OrderQuantity, UnitPrice) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // Insert Order
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getCustomerId());
                if (order.getStaffId() > 0)
                    ps.setInt(2, order.getStaffId());
                else
                    ps.setNull(2, Types.INTEGER);
                ps.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
                ps.setString(4, order.getShippingName());
                ps.setString(5, order.getShippingPhone());
                ps.setString(6, order.getShippingAddress());
                ps.setString(7, order.getStatus());
                ps.setDouble(8, order.getTotalAmount());

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setOrderId(generatedKeys.getInt(1));
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // Insert Items
            try (PreparedStatement ps = conn.prepareStatement(sqlItem)) {
                for (OrderItem item : order.getItems()) {
                    ps.setInt(1, order.getOrderId());
                    ps.setInt(2, item.getMedicineId());
                    ps.setInt(3, item.getQuantity());
                    ps.setDouble(4, item.getUnitPrice());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("CRITICAL DB ERROR in saveOrder:");
            System.err.println("Message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            if (conn != null) {
                try {
                    System.out.println("OrderDAO: Rolling back transaction...");
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("OrderId"));
        order.setCustomerId(rs.getInt("CustomerId"));
        order.setStaffId(rs.getInt("StaffId"));
        order.setOrderDate(rs.getTimestamp("OrderDate"));
        order.setShippingName(rs.getString("ShippingName"));
        order.setShippingPhone(rs.getString("ShippingPhone"));
        order.setShippingAddress(rs.getString("ShippingAddress"));
        order.setStatus(rs.getString("Status"));
        order.setTotalAmount(rs.getDouble("TotalAmount"));
        return order;
    }
}

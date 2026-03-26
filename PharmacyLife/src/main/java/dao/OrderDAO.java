package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Order;
import models.OrderItem;
import models.Medicine;
import models.Staff;
import utils.DBContext;

public class OrderDAO {
    private DBContext dbContext = new DBContext();

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, s.StaffName FROM Orders o " +
                "LEFT JOIN Staff s ON o.StaffId = s.StaffId " +
                "ORDER BY o.OrderDate DESC";
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
        String sql = "SELECT o.*, s.StaffName FROM Orders o " +
                "LEFT JOIN Staff s ON o.StaffId = s.StaffId " +
                "WHERE o.OrderId = ?";
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
        String sql = "SELECT oi.*, mu.MedicineId, mu.UnitId, m.MedicineName, m.MedicineCode, m.ImageUrl, u.UnitName " +
                "FROM OrderItems oi " +
                "JOIN MedicineUnit mu ON oi.MedicineUnitId = mu.MedicineUnitId " +
                "JOIN Medicine m ON mu.MedicineId = m.MedicineId " +
                "LEFT JOIN Unit u ON mu.UnitId = u.UnitId " +
                "WHERE oi.OrderId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderId(rs.getInt("OrderId"));
                    item.setMedicineUnitId(rs.getInt("MedicineUnitId"));
                    item.setQuantity(rs.getInt("OrderQuantity"));
                    item.setUnitPrice(rs.getDouble("UnitPrice"));
                    item.setUnitName(rs.getString("UnitName"));

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

    public boolean updateStatus(int orderId, String newStatus, int staffId) {
        String sqlGetOldStatus = "SELECT Status FROM Orders WHERE OrderId = ?";
        String sqlUpdateStatus = "UPDATE Orders SET Status = ?, StaffId = ? WHERE OrderId = ?";
        
        // Stock management using MedicineUnitId
        String sqlReplenishStock = "UPDATE m SET m.RemainingQuantity = m.RemainingQuantity + (? * mu.ConversionRate) " +
                                    "FROM Medicine m JOIN MedicineUnit mu ON m.MedicineId = mu.MedicineId " +
                                    "WHERE mu.MedicineUnitId = ?";
        String sqlSubtractStock = "UPDATE m SET m.RemainingQuantity = m.RemainingQuantity - (? * mu.ConversionRate) " +
                                    "FROM Medicine m JOIN MedicineUnit mu ON m.MedicineId = mu.MedicineId " +
                                    "WHERE mu.MedicineUnitId = ? AND m.RemainingQuantity >= (? * mu.ConversionRate)";
                                    
        String sqlGetItems = "SELECT MedicineUnitId, OrderQuantity FROM OrderItems WHERE OrderId = ?";

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // 1. Get old status
            String oldStatus = "";
            try (PreparedStatement ps = conn.prepareStatement(sqlGetOldStatus)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        oldStatus = rs.getString("Status");
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            if (newStatus.equalsIgnoreCase(oldStatus)) {
                conn.rollback();
                return true;
            }

            // 2. Update status
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateStatus)) {
                ps.setString(1, newStatus);
                ps.setInt(2, staffId);
                ps.setInt(3, orderId);
                ps.executeUpdate();
            }

            // 3. Handle stock changes
            boolean oldIsDeducted = "Shipping".equalsIgnoreCase(oldStatus) || "Delivered".equalsIgnoreCase(oldStatus);
            boolean newIsDeducted = "Shipping".equalsIgnoreCase(newStatus) || "Delivered".equalsIgnoreCase(newStatus);
            
            if (!oldIsDeducted && newIsDeducted) {
                // Subtract stock
                try (PreparedStatement psItems = conn.prepareStatement(sqlGetItems);
                        PreparedStatement psStock = conn.prepareStatement(sqlSubtractStock)) {
                    psItems.setInt(1, orderId);
                    try (ResultSet rs = psItems.executeQuery()) {
                        while (rs.next()) {
                            int muId = rs.getInt("MedicineUnitId");
                            int qty = rs.getInt("OrderQuantity");

                            psStock.setInt(1, qty);
                            psStock.setInt(2, muId);
                            psStock.setInt(3, qty);
                            psStock.setInt(4, muId);

                            int updated = psStock.executeUpdate();
                            if (updated == 0) {
                                lastErrorMessage = "Không đủ số lượng tồn kho để giao hàng cho mã đơn vị sản phẩm (ID: " + muId + ").";
                                conn.rollback();
                                return false;
                            }
                        }
                    }
                }
            } else if (oldIsDeducted && !newIsDeducted) {
                // Replenish stock
                try (PreparedStatement psItems = conn.prepareStatement(sqlGetItems);
                        PreparedStatement psStock = conn.prepareStatement(sqlReplenishStock)) {
                    psItems.setInt(1, orderId);
                    try (ResultSet rs = psItems.executeQuery()) {
                        while (rs.next()) {
                            int muId = rs.getInt("MedicineUnitId");
                            int qty = rs.getInt("OrderQuantity");

                            psStock.setInt(1, qty);
                            psStock.setInt(2, muId);
                            psStock.executeUpdate();
                        }
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (SQLException ex) { ex.printStackTrace(); } }
        }
        return false;
    }

    public boolean hasCustomerPurchasedMedicine(int customerId, int medicineId) {
        String sql = "SELECT TOP 1 1 "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON oi.OrderId = o.OrderId "
                + "JOIN MedicineUnit mu ON oi.MedicineUnitId = mu.MedicineUnitId "
                + "WHERE o.CustomerId = ? "
                + "AND mu.MedicineId = ? "
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

    private String lastErrorMessage = "";

    public String getLastErrorMessage() {
        return lastErrorMessage;
    }

    public boolean saveOrder(Order order) {
        String sqlOrder = "INSERT INTO Orders (CustomerId, StaffId, OrderDate, ShippingName, ShippingPhone, ShippingAddress, Status, TotalAmount, VoucherId, DiscountAmount) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlItem = "INSERT INTO OrderItems (OrderId, MedicineUnitId, OrderQuantity, UnitPrice) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        lastErrorMessage = "";
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert Order
            try (PreparedStatement ps = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getCustomerId());
                if (order.getStaffId() > 0) ps.setInt(2, order.getStaffId());
                else ps.setNull(2, Types.INTEGER);
                ps.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
                ps.setString(4, order.getShippingName());
                ps.setString(5, order.getShippingPhone());
                ps.setString(6, order.getShippingAddress());
                ps.setString(7, order.getStatus());
                ps.setDouble(8, order.getTotalAmount());
                if (order.getVoucherId() > 0) ps.setInt(9, order.getVoucherId());
                else ps.setNull(9, Types.INTEGER);
                ps.setDouble(10, order.getDiscountAmount());

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    lastErrorMessage = "Không thể tạo đơn hàng.";
                    conn.rollback();
                    return false;
                }

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setOrderId(generatedKeys.getInt(1));
                    } else {
                        lastErrorMessage = "Không lấy được mã đơn hàng.";
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2. Insert Items
            try (PreparedStatement psItem = conn.prepareStatement(sqlItem)) {
                for (OrderItem item : order.getItems()) {
                    psItem.setInt(1, order.getOrderId());
                    psItem.setInt(2, item.getMedicineUnitId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getUnitPrice());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            lastErrorMessage = "Lỗi database: " + e.getMessage();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } }
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
        order.setVoucherId(rs.getInt("VoucherId"));
        order.setDiscountAmount(rs.getDouble("DiscountAmount"));

        int staffId = rs.getInt("StaffId");
        if (!rs.wasNull()) {
            Staff staff = new Staff();
            staff.setStaffId(staffId);
            try { staff.setStaffName(rs.getString("StaffName")); } catch (SQLException e) {}
            order.setStaff(staff);
        }
        return order;
    }

    public void deleteOrderItemsByMedicineUnitId(int medicineUnitId) {
        String sql = "DELETE FROM OrderItems WHERE MedicineUnitId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineUnitId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteOrderItemsByMedicineId(int medicineId) {
        String sql = "DELETE FROM OrderItems WHERE MedicineUnitId IN (SELECT MedicineUnitId FROM MedicineUnit WHERE MedicineId = ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

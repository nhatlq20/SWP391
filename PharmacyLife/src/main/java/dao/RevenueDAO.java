package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import utils.DBContext;

public class RevenueDAO {
    public double getActualReceived(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM [Order] WHERE LOWER(Status) IN ('delivered', N'đã giao', N'đã giao hàng', 'completed', N'hoàn thành', N'giao hàng thành công', N'đã hoàn thành')";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getDouble(1);
        }
        return 0;
    }

    private void setDateParameters(PreparedStatement ps, Date from, Date to, int startIndex) throws SQLException {
        if (from != null && to != null) {
            ps.setDate(startIndex, from);
            ps.setDate(startIndex + 1, to);
        }
    }

    public int getTotalOrders(Date from, Date to) throws SQLException {

        String sql = "SELECT COUNT(*) FROM [Order] WHERE 1=1";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    public double getTotalRevenue(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM [Order] WHERE Status NOT IN ('Cancelled', N'Đã hủy')";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getDouble(1);
        }
        return 0;
    }

    public double getTotalDebt(Date from, Date to) throws SQLException {
        // Số còn phải thu: Chờ xử lý, Đã xác nhận, Đang giao hàng
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM [Order] WHERE Status IN ('Pending', N'Chờ xử lý', 'Confirmed', N'Đã xác nhận', 'Shipping', N'Đang giao hàng')";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getDouble(1);
        }
        return 0;
    }

    public double getAverageOrderValue(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(AVG(TotalAmount),0) FROM [Order] WHERE LOWER(Status) IN ('delivered', N'đã giao', N'đã giao hàng', 'completed', N'hoàn thành', N'giao hàng thành công', N'đã hoàn thành')";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getDouble(1);
        }
        return 0;
    }

    public Map<String, Integer> getOrderStatusStatistics(Date from, Date to) throws SQLException {
        String sql = "SELECT Status, COUNT(*) AS Count FROM [Order] WHERE 1=1";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        sql += " GROUP BY Status";
        Map<String, Integer> stats = new HashMap<>();

        stats.put("Pending", 0);
        stats.put("Confirmed", 0);
        stats.put("Shipping", 0);
        stats.put("Delivered", 0);
        stats.put("Cancelled", 0);

        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String statusFromDB = rs.getString("Status");
                int count = rs.getInt("Count");

                if (statusFromDB != null) {
                    String s = statusFromDB.toLowerCase();
                    if (s.equals("pending") || s.equals("chờ xử lý")) {
                        stats.put("Pending", stats.get("Pending") + count);
                    } else if (s.equals("confirmed") || s.equals("đã xác nhận")) {
                        stats.put("Confirmed", stats.get("Confirmed") + count);
                    } else if (s.equals("shipping") || s.equals("đang giao") || s.equals("đang giao hàng")) {
                        stats.put("Shipping", stats.get("Shipping") + count);
                    } else if (s.equals("delivered") || s.equals("đã giao") || s.equals("đã giao hàng") || s.equals("completed") || s.equals("hoàn thành") || s.equals("giao hàng thành công") || s.equals("đã hoàn thành")) {
                        stats.put("Delivered", stats.get("Delivered") + count);
                    } else if (s.equals("cancelled") || s.equals("đã hủy")) {
                        stats.put("Cancelled", stats.get("Cancelled") + count);
                    } else {
                        stats.put(statusFromDB, count);
                    }
                }
            }
        }
        return stats;
    }

    public java.util.List<models.TopProduct> getTopSellingProducts(Date from, Date to, int limit) throws SQLException {
        String sql = "SELECT TOP " + limit
                + " m.MedicineName, "
                + " CAST(SUM(oi.OrderQuantity * ISNULL(mu.ConversionRate, 1)) * 1.0 / ISNULL(max_mu.MaxRate, 1) AS FLOAT) as TotalQty, "
                + " SUM(oi.OrderQuantity * oi.UnitPrice) as TotalRev "
                + "FROM [Order] o "
                + "JOIN OrderItems oi ON o.OrderId = oi.OrderId "
                + "JOIN MedicineUnit mu ON oi.MedicineUnitId = mu.MedicineUnitId "
                + "JOIN Medicine m ON mu.MedicineId = m.MedicineId "
                + "CROSS APPLY (SELECT MAX(ConversionRate) as MaxRate FROM MedicineUnit WHERE MedicineId = m.MedicineId) max_mu "
                + "WHERE o.Status NOT IN ('Cancelled', N'Đã hủy') ";
        if (from != null && to != null) {
            sql += " AND CAST(o.OrderDate AS DATE) BETWEEN ? AND ? ";
        }
        sql += "GROUP BY m.MedicineId, m.MedicineName, max_mu.MaxRate " +
                "ORDER BY SUM(oi.OrderQuantity * oi.UnitPrice) DESC, SUM(oi.OrderQuantity * ISNULL(mu.ConversionRate, 1)) DESC";

        java.util.List<models.TopProduct> list = new java.util.ArrayList<>();
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new models.TopProduct(rs.getString("MedicineName"), rs.getDouble("TotalQty"),
                        rs.getDouble("TotalRev")));
            }
        }
        return list;
    }

    public java.util.List<models.TopCustomer> getTopCustomers(Date from, Date to, int limit) throws SQLException {
        String sql = "SELECT TOP " + limit
                + " c.FullName, COUNT(o.OrderId) as OrderCount, SUM(o.TotalAmount) as TotalSpent " +
                "FROM [Order] o "
                + "JOIN Customer c ON o.CustomerId = c.CustomerId "
                + "WHERE o.Status NOT IN ('Cancelled', N'Đã hủy') ";
        if (from != null && to != null) {
            sql += " AND CAST(o.OrderDate AS DATE) BETWEEN ? AND ? ";
        }
        sql += "GROUP BY c.CustomerId, c.FullName " +
                "ORDER BY SUM(o.TotalAmount) DESC, COUNT(o.OrderId) DESC";

        java.util.List<models.TopCustomer> list = new java.util.ArrayList<>();
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            setDateParameters(ps, from, to, 1);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new models.TopCustomer(rs.getString("FullName"), rs.getInt("OrderCount"),
                        rs.getDouble("TotalSpent")));
            }
        }
        return list;
    }
}

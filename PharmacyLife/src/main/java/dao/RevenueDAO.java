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
    // Thực thu: đơn hàng đã giao và đã nhận tiền
    public double getActualReceived(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM Orders WHERE Status IN ('Delivered', N'Đã giao hàng')";
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

        String sql = "SELECT COUNT(*) FROM Orders WHERE 1=1";
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
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM Orders WHERE 1=1";
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
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM Orders WHERE Status IN ('Pending', N'Chờ xử lý', 'Confirmed', N'Đã xác nhận', 'Shipping', N'Đang giao hàng')";
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
        String sql = "SELECT ISNULL(AVG(TotalAmount),0) FROM Orders WHERE Status = 'Delivered'";
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
        String sql = "SELECT Status, COUNT(*) AS Count FROM Orders WHERE 1=1";
        if (from != null && to != null) {
            sql += " AND CAST(OrderDate AS DATE) BETWEEN ? AND ?";
        }
        sql += " GROUP BY Status";
        Map<String, Integer> stats = new HashMap<>();

        // Khởi tạo mặc định để JSP hiển thị đủ trạng thái dù count = 0
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

                // Ánh xạ trạng thái tiếng Việt về phím tiếng Anh cho JSP
                if (statusFromDB != null) {
                    if (statusFromDB.equalsIgnoreCase("Pending") || statusFromDB.equals("Chờ xử lý")) {
                        stats.put("Pending", stats.get("Pending") + count);
                    } else if (statusFromDB.equalsIgnoreCase("Confirmed") || statusFromDB.equals("Đã xác nhận")) {
                        stats.put("Confirmed", stats.get("Confirmed") + count);
                    } else if (statusFromDB.equalsIgnoreCase("Shipping") || statusFromDB.equals("Đang giao hàng")) {
                        stats.put("Shipping", stats.get("Shipping") + count);
                    } else if (statusFromDB.equalsIgnoreCase("Delivered") || statusFromDB.equals("Đã giao hàng")) {
                        stats.put("Delivered", stats.get("Delivered") + count);
                    } else if (statusFromDB.equalsIgnoreCase("Cancelled") || statusFromDB.equals("Đã hủy")) {
                        stats.put("Cancelled", stats.get("Cancelled") + count);
                    } else {
                        stats.put(statusFromDB, count);
                    }
                }
            }
        }
        return stats;
    }
}

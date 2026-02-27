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
    public int getTotalOrders(Date from, Date to) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Orders WHERE OrderDate BETWEEN ? AND ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public double getTotalRevenue(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM Orders WHERE Status = N'Đã giao' AND OrderDate BETWEEN ? AND ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    public double getTotalDebt(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(SUM(TotalAmount),0) FROM Orders WHERE Status != N'Đã giao' AND OrderDate BETWEEN ? AND ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    public double getAverageOrderValue(Date from, Date to) throws SQLException {
        String sql = "SELECT ISNULL(AVG(TotalAmount),0) FROM Orders WHERE OrderDate BETWEEN ? AND ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    public Map<String, Integer> getOrderStatusStatistics(Date from, Date to) throws SQLException {
        String sql = "SELECT Status, COUNT(*) AS Count FROM Orders WHERE OrderDate BETWEEN ? AND ? GROUP BY Status";
        Map<String, Integer> stats = new HashMap<>();
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("Status"), rs.getInt("Count"));
            }
        }
        return stats;
    }
}

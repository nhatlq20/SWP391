package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Voucher;
import utils.DBContext;

public class VoucherDAO {
    private DBContext dbContext = new DBContext();

    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers ORDER BY CreatedAt DESC";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vouchers.add(mapResultSetToVoucher(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public List<Voucher> getValidVouchersForUser() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers WHERE IsActive = 1 AND StartDate <= GETDATE() AND EndDate >= GETDATE() AND UsedQuantity < Quantity ORDER BY MinOrderValue ASC";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vouchers.add(mapResultSetToVoucher(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM Vouchers WHERE VoucherId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM Vouchers WHERE VoucherCode = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addVoucher(Voucher v) {
        String sql = "INSERT INTO Vouchers (VoucherCode, Description, DiscountType, DiscountValue, MinOrderValue, MaxDiscountAmount, StartDate, EndDate, Quantity, IsActive) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getVoucherCode());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType());
            ps.setDouble(4, v.getDiscountValue());
            ps.setDouble(5, v.getMinOrderValue());
            if (v.getMaxDiscountAmount() != null)
                ps.setDouble(6, v.getMaxDiscountAmount());
            else
                ps.setNull(6, Types.DECIMAL);
            ps.setTimestamp(7, new Timestamp(v.getStartDate().getTime()));
            ps.setTimestamp(8, new Timestamp(v.getEndDate().getTime()));
            ps.setInt(9, v.getQuantity());
            ps.setBoolean(10, v.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE Vouchers SET Description = ?, DiscountType = ?, DiscountValue = ?, MinOrderValue = ?, MaxDiscountAmount = ?, StartDate = ?, EndDate = ?, Quantity = ?, IsActive = ? "
                +
                "WHERE VoucherId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getDescription());
            ps.setString(2, v.getDiscountType());
            ps.setDouble(3, v.getDiscountValue());
            ps.setDouble(4, v.getMinOrderValue());
            if (v.getMaxDiscountAmount() != null)
                ps.setDouble(5, v.getMaxDiscountAmount());
            else
                ps.setNull(5, Types.DECIMAL);
            ps.setTimestamp(6, new Timestamp(v.getStartDate().getTime()));
            ps.setTimestamp(7, new Timestamp(v.getEndDate().getTime()));
            ps.setInt(8, v.getQuantity());
            ps.setBoolean(9, v.isActive());
            ps.setInt(10, v.getVoucherId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteVoucher(int id) {
        String sql = "DELETE FROM Vouchers WHERE VoucherId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean incrementUsedQuantity(int id) {
        String sql = "UPDATE Vouchers SET UsedQuantity = UsedQuantity + 1 WHERE VoucherId = ? AND UsedQuantity < Quantity";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Voucher mapResultSetToVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("VoucherId"));
        v.setVoucherCode(rs.getString("VoucherCode"));
        v.setDescription(rs.getString("Description"));
        v.setDiscountType(rs.getString("DiscountType"));
        v.setDiscountValue(rs.getDouble("DiscountValue"));
        v.setMinOrderValue(rs.getDouble("MinOrderValue"));
        double maxAmt = rs.getDouble("MaxDiscountAmount");
        v.setMaxDiscountAmount(rs.wasNull() ? null : maxAmt);
        v.setStartDate(rs.getTimestamp("StartDate"));
        v.setEndDate(rs.getTimestamp("EndDate"));
        v.setQuantity(rs.getInt("Quantity"));
        v.setUsedQuantity(rs.getInt("UsedQuantity"));
        v.setActive(rs.getBoolean("IsActive"));
        v.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return v;
    }
}

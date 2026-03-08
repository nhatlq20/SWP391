package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Import;
import models.ImportDetail;
import models.Medicine;
import utils.DBContext;

public class ImportDAO {

    private final DBContext dbContext;

    public ImportDAO() {
        this.dbContext = new DBContext();
    }

    public List<Import> getAllImports() {
        List<Import> imports = new ArrayList<>();

        String sql = "SELECT i.ImportId, i.SupplierId, s.SupplierName, " +
            "       i.StaffId, st.StaffName, i.ImportCreateAt, i.TotalPrice, i.ImportStatus " +
            "FROM   Import i " +
            "LEFT JOIN Supplier s ON i.SupplierId = s.SupplierId " +
            "LEFT JOIN Staff st   ON i.StaffId   = st.StaffId " +
            "ORDER BY i.ImportCreateAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Import imp = mapImport(rs);
                imports.add(imp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imports;
    }

    // Tìm kiếm phiếu nhập theo mã (ImportId dạng chuỗi) hoặc tên nhà cung cấp
    public List<Import> searchImports(String keyword) {
        List<Import> imports = new ArrayList<>();

        String sql = "SELECT i.ImportId, i.SupplierId, s.SupplierName, " +
            "       i.StaffId, st.StaffName, i.ImportCreateAt, i.TotalPrice, i.ImportStatus " +
            "FROM   Import i " +
            "LEFT JOIN Supplier s ON i.SupplierId = s.SupplierId " +
            "LEFT JOIN Staff st   ON i.StaffId   = st.StaffId " +
            "WHERE  CAST(i.ImportId AS VARCHAR(10)) LIKE ? " +
            "   OR  s.SupplierName LIKE ? " +
            "   OR  ('IP' + RIGHT('000' + CAST(i.ImportId AS VARCHAR(10)), 3)) LIKE ? " +
            "ORDER BY i.ImportCreateAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {


            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern.toUpperCase());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Import imp = mapImport(rs);
                    imports.add(imp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imports;
    }

    // Lấy thông tin chi tiết một phiếu nhập theo ImportId
    public Import getImportById(int importId) {
        Import imp = null;

        String sql = "SELECT i.ImportId, i.SupplierId, s.SupplierName, " +
            "       i.StaffId, st.StaffName, i.ImportCreateAt, i.TotalPrice, i.ImportStatus " +
            "FROM   Import i " +
            "LEFT JOIN Supplier s ON i.SupplierId = s.SupplierId " +
            "LEFT JOIN Staff st   ON i.StaffId   = st.StaffId " +
            "WHERE  i.ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    imp = mapImport(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return imp;
    }

    // Tạo phiếu nhập mới
    public boolean createImport(Import imp) {
        String sql = "INSERT INTO Import (SupplierId, StaffId, ImportCreateAt, TotalPrice, ImportStatus) " +
            "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, imp.getSupplierId());
            ps.setInt(2, imp.getStaffId());

            Date importDate = imp.getImportDate();
            if (importDate == null) {
                importDate = new Date(System.currentTimeMillis());
            }
            ps.setDate(3, importDate);

            // Lần đầu tạo có thể chưa có chi tiết, cho 0 rồi sẽ update sau
            double total = imp.getTotalAmount() > 0 ? imp.getTotalAmount() : 0.0;
            ps.setDouble(4, total);

            // Default Status if null
            String status = imp.getStatus();
            if (status == null || status.isEmpty()) {
                status = "Đang chờ";
            }
            ps.setString(5, status);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        imp.setImportId(generatedId);
                        // Sinh mã hiển thị (không lưu DB)
                        imp.setImportCode(formatImportCode(generatedId));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật phiếu nhập
    public boolean updateImport(Import imp) {
        String sql = "UPDATE Import " +
            "SET SupplierId = ?, StaffId = ?, ImportCreateAt = ?, TotalPrice = ?, ImportStatus = ? " +
            "WHERE ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, imp.getSupplierId());
            ps.setInt(2, imp.getStaffId());

            Date importDate = imp.getImportDate();
            if (importDate == null) {
                importDate = new Date(System.currentTimeMillis());
            }
            ps.setDate(3, importDate);

            ps.setDouble(4, imp.getTotalAmount());
            ps.setString(5, imp.getStatus()); // Update Status
            ps.setInt(6, imp.getImportId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa phiếu nhập (và toàn bộ chi tiết)
    public boolean deleteImport(int importId) {
        // Xóa chi tiết trước
        deleteImportDetailsByImportId(importId);

        String deleteSql = "DELETE FROM Import WHERE ImportId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(deleteSql)) {

            ps.setInt(1, importId);
            if (ps.executeUpdate() > 0) {
                // Sau khi xóa, rename lại các phiếu sau nó để giữ thứ tự liên tục
                renumberImportsAfter(conn, importId);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void renumberImportsAfter(Connection conn, int deletedImportId) {
        try {
            // Lấy tất cả phiếu có ID > deletedImportId
            String selectSql = "SELECT ImportId FROM Import WHERE ImportId > ? ORDER BY ImportId ASC";
            try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
                selectPs.setInt(1, deletedImportId);
                ResultSet rs = selectPs.executeQuery();
                java.util.List<Integer> idsToRename = new java.util.ArrayList<>();
                while (rs.next()) {
                    idsToRename.add(rs.getInt("ImportId"));
                }

                // Update từng phiếu, giảm ID đi 1
                for (Integer oldId : idsToRename) {
                    int newId = oldId - 1;
                    String newCode = formatImportCode(newId);

                    // Update Import
                    String updateImportSql = "UPDATE Import SET ImportId = ?, ImportCode = ? WHERE ImportId = ?";
                    try (PreparedStatement updateImportPs = conn.prepareStatement(updateImportSql)) {
                        updateImportPs.setInt(1, newId);
                        updateImportPs.setString(2, newCode);
                        updateImportPs.setInt(3, oldId);
                        updateImportPs.executeUpdate();
                    }

                    // Update ImportDetail (FK)
                    String updateDetailSql = "UPDATE ImportDetail SET ImportId = ? WHERE ImportId = ?";
                    try (PreparedStatement updateDetailPs = conn.prepareStatement(updateDetailSql)) {
                        updateDetailPs.setInt(1, newId);
                        updateDetailPs.setInt(2, oldId);
                        updateDetailPs.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ======================== IMPORT DETAIL ========================
    // (methods omitted for brevity, assuming they are unchanged from previous view)
    // ...

    // ... (omitting getImportDetails, addImportDetail, deleteImportDetail,
    // deleteImportDetailsByImportId, calculateTotalAmount)
    // Please assume those are below unchanged or I should include them if I want to
    // be safe.
    // However, since I used line numbers, I must be careful.
    // The previous view ended around line 461.
    // mapImport is at the bottom. I need to update mapImport too.

    // Let's rely on the fact that I'm replacing a chunk. I need to include the
    // omitted methods in the replacement OR target smaller chunks.
    // Creating smaller chunks is safer.

    // I will split this into two calls. First create/update.

    // ======================== IMPORT DETAIL ========================

    // Lấy danh sách chi tiết thuốc trong phiếu nhập
    public List<ImportDetail> getImportDetails(int importId) {
        List<ImportDetail> details = new ArrayList<>();

        String sql = "SELECT d.ImportDetailId, d.ImportId, d.MedicineId, " +
                "       m.MedicineCode, m.MedicineName, d.ImportQuantity, d.UnitPrice " +
                "FROM   ImportDetail d " +
                "LEFT JOIN Medicine m ON d.MedicineId = m.MedicineId " +
                "WHERE  d.ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportDetail detail = new ImportDetail();
                    detail.setDetailId(rs.getInt("ImportDetailId"));
                    detail.setImportId(rs.getInt("ImportId"));
                    detail.setMedicineId(rs.getInt("MedicineId"));
                    detail.setMedicineCode(rs.getString("MedicineCode"));
                    detail.setMedicineName(rs.getString("MedicineName"));
                    detail.setQuantity(rs.getInt("ImportQuantity"));
                    detail.setUnitPrice(rs.getDouble("UnitPrice"));
                    detail.recalculateTotal();
                    details.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    // Thêm chi tiết thuốc vào phiếu nhập
    public boolean addImportDetail(ImportDetail detail) {
        String sql = "INSERT INTO ImportDetail (ImportId, MedicineId, ImportQuantity, UnitPrice) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detail.getImportId());
            ps.setInt(2, detail.getMedicineId());
            ps.setInt(3, detail.getQuantity());
            ps.setDouble(4, detail.getUnitPrice());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa một dòng chi tiết thuốc
    public boolean deleteImportDetail(int detailId) {
        String sql = "DELETE FROM ImportDetail WHERE ImportDetailId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa toàn bộ chi tiết theo ImportId
    public boolean deleteImportDetailsByImportId(int importId) {
        String sql = "DELETE FROM ImportDetail WHERE ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);
            // Có thể = 0 nếu không có chi tiết, vẫn coi là thành công
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tính tổng tiền của phiếu nhập từ chi tiết
    public double calculateTotalAmount(int importId) {
        String sql = "SELECT SUM(CAST(d.ImportQuantity AS DECIMAL(18,2)) * d.UnitPrice) AS Total " +
                "FROM   ImportDetail d " +
                "WHERE  d.ImportId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, importId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("Total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // ====================== HỖ TRỢ SINH MÃ ========================

    /**
     * Tạo mã phiếu nhập dạng IP001, IP002... dựa trên ImportId lớn nhất hiện có.
     * Mã này chỉ dùng để hiển thị, không lưu trong bảng Import.
     */
    public String generateImportCode() {
        String sql = "SELECT ISNULL(MAX(ImportId), 0) AS LastId FROM Import";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            int lastId = 0;
            if (rs.next()) {
                lastId = rs.getInt("LastId");
            }
            int nextId = lastId + 1;
            return formatImportCode(nextId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "IP001";
    }

    // ======================== PRIVATE HELPERS ======================

    // Map một dòng ResultSet thành đối tượng Import
    private Import mapImport(ResultSet rs) throws SQLException {
        Import imp = new Import();
        int importId = rs.getInt("ImportId");
        imp.setImportId(importId);
        imp.setSupplierId(rs.getInt("SupplierId"));
        imp.setSupplierName(rs.getString("SupplierName"));
        imp.setStaffId(rs.getInt("StaffId"));
        imp.setStaffName(rs.getString("StaffName"));
        imp.setImportDate(rs.getDate("ImportCreateAt"));
        imp.setTotalAmount(rs.getDouble("TotalPrice"));
        imp.setStatus(rs.getString("ImportStatus")); // Set ImportStatus
        // Sinh mã hiển thị từ ImportId
        imp.setImportCode(formatImportCode(importId));
        return imp;
    }

    // Format mã phiếu nhập từ ImportId (ví dụ: 1 -> IP001)
    public String formatImportCode(int importId) {
        return String.format("IP%03d", importId);
    }

    // ======================== HELPER METHODS ========================

    // Lấy MedicineId từ MedicineCode
    public int getMedicineIdByCode(String code) {
        String sql = "SELECT MedicineId FROM Medicine WHERE MedicineCode = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("MedicineId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy StaffId từ StaffCode
    public int getStaffIdByCode(String code) {
        String sql = "SELECT StaffId FROM Staff WHERE StaffCode = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("StaffId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy SupplierId từ tên (nếu chuỗi input không phải số ID)
    public int getSupplierIdByName(String name) {
        // Assume name match
        String sql = "SELECT SupplierId FROM Supplier WHERE SupplierName LIKE ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("SupplierId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Parse int safely
    public int parseId(String input) {
        if (input == null || input.trim().isEmpty())
            return 0;
        try {
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public double getMedicinePriceByCode(String code) {

        String sql = "SELECT OriginalPrice FROM Medicine WHERE MedicineCode = ?"; // Assuming Price exists
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("OriginalPrice");
                }
            }
        } catch (SQLException e) {
            // e.printStackTrace(); // Silent fail or log
        }
        return 0;
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT MedicineId, MedicineCode, MedicineName, OriginalPrice FROM Medicine";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("MedicineId"));
                m.setMedicineCode(rs.getString("MedicineCode"));
                m.setMedicineName(rs.getString("MedicineName"));
                m.setOriginalPrice(rs.getDouble("OriginalPrice"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getMedicinePriceById(int medicineId) {
        String sql = "SELECT OriginalPrice FROM Medicine WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("OriginalPrice");
                }
            }
        } catch (SQLException e) {
            // e.printStackTrace(); // Silent fail or log
        }
        return 0;
    }

    public List<Object[]> getAllSuppliers() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT SupplierId, SupplierName FROM Supplier ORDER BY SupplierName";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Object[] { rs.getInt("SupplierId"), rs.getString("SupplierName") });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

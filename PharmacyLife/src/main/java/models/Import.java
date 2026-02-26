package models;

import java.sql.Date;

/**
 * Model đại diện cho bảng [Import] trong database.
 *
 * Schema:
 * - ImportId INT IDENTITY(1,1) PRIMARY KEY
 * - SupplierId INT NOT NULL
 * - StaffId INT NOT NULL
 * - ImportCreateAt DATETIME2
 * - TotalPrice DECIMAL(12,2) NOT NULL
 *
 * Một số field (supplierName, importerName) là thông tin join thêm để hiển thị.
 * Thuộc tính importCode được dùng làm mã hiển thị (ví dụ: IP001) nhưng
 * không được lưu trong database; ta có thể sinh từ ImportId nếu cần.
 */
public class Import {

    // Khóa chính thực trong DB
    private int importId;

    // Mã hiển thị (không mapping cột, có thể sinh từ importId)
    private String importCode;

    // Khóa ngoại tới Supplier
    private int supplierId;
    private String supplierName;

    // Khóa ngoại tới Staff (người nhập)
    private int staffId;
    private String staffName;

    // Ngày/giờ nhập (map với ImportCreateAt)
    private Date importDate;

    // Tổng tiền (map với TotalPrice)
    private double totalAmount;

    // Trạng thái phiếu nhập (ImportStatus)
    private String importStatus;

    public Import() {
    }

    public Import(int importId, int supplierId, String supplierName,
            int staffId, String staffName, Date importDate, double totalAmount) {
        this.importId = importId;
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.staffId = staffId;
        this.staffName = staffName;
        this.importDate = importDate;
        this.totalAmount = totalAmount;
    }

    // Getters & Setters

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public String getImportCode() {
        return importCode;
    }

    public void setImportCode(String importCode) {
        this.importCode = importCode;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {

        return importStatus;
    }

    public void setStatus(String importStatus) {
        this.importStatus = importStatus;
    }
}

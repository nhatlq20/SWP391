package models;

import java.sql.Date;

public class Import {
    private int importId;
    private String importCode;
    private int supplierId;
    private String supplierName;
    private int staffId;
    private String staffName;
    private Date importDate;
    private double totalAmount;
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

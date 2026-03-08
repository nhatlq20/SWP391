package models;

/**
 * Model đại diện cho bảng [ImportDetail] trong database.
 *
 * Schema:
 * - ImportDetailId INT IDENTITY(1,1) PRIMARY KEY
 * - ImportId INT NOT NULL
 * - MedicineId INT NOT NULL
 * - ImportQuantity INT
 * - UnitPrice DECIMAL(12,2)
 *
 * Thuộc tính medicineName và totalAmount chỉ dùng để hiển thị,
 * totalAmount được tính từ quantity * unitPrice, không bắt buộc lưu DB.
 */
public class ImportDetail {

    private int detailId; // ImportDetailId
    private int importId; // ImportId
    private int medicineId; // MedicineId

    private String medicineName; // Tên thuốc (join từ bảng Medicine)
    private String medicineCode; // Mã thuốc (join từ bảng Medicine)

    private int quantity; // ImportQuantity
    private double unitPrice; // UnitPrice

    private double totalAmount; // quantity * unitPrice (tính toán)

    public ImportDetail() {
    }

    public ImportDetail(int importId, int medicineId, int quantity, double unitPrice) {
        this.importId = importId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalAmount = quantity * unitPrice;
    }

    public ImportDetail(int detailId, int importId, int medicineId,
            String medicineName, int quantity, double unitPrice, double totalAmount) {
        this.detailId = detailId;
        this.importId = importId;
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalAmount = totalAmount;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public String getMedicineCode() {
        return medicineCode;
    }

    public void setMedicineCode(String medicineCode) {
        this.medicineCode = medicineCode;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        recalculateTotal();
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        recalculateTotal();
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void recalculateTotal() {
        this.totalAmount = this.quantity * this.unitPrice;
    }
}

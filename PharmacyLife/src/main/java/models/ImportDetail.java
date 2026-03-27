package models;

public class ImportDetail {

    private int detailId; 
    private int importId; 
    private int medicineUnitId; 
    private int medicineId;
    private int unitId;
    private String medicineName; 
    private String medicineCode; 
    private String unitName; 
    private int quantity; 
    private double unitPrice;
    private double totalAmount; 

    public ImportDetail() {
    }

    public ImportDetail(int importId, int medicineUnitId, int quantity, double unitPrice) {
        this.importId = importId;
        this.medicineUnitId = medicineUnitId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalAmount = quantity * unitPrice;
    }

    public ImportDetail(int detailId, int importId, int medicineUnitId,
            String medicineName, String unitName, int quantity, double unitPrice, double totalAmount) {
        this.detailId = detailId;
        this.importId = importId;
        this.medicineUnitId = medicineUnitId;
        this.medicineName = medicineName;
        this.unitName = unitName;
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

    public int getMedicineUnitId() {
        return medicineUnitId;
    }

    public void setMedicineUnitId(int medicineUnitId) {
        this.medicineUnitId = medicineUnitId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
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

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
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



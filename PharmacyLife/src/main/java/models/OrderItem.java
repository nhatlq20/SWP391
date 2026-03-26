package models;

public class OrderItem {
    private int orderId;
    private int medicineUnitId;
    private int quantity;
    private double unitPrice;
    private String unitName; // For display/reporting

    // Navigation property
    private Medicine medicine;

    public OrderItem() {
    }

    public OrderItem(int orderId, int medicineUnitId, int quantity, double unitPrice) {
        this.orderId = orderId;
        this.medicineUnitId = medicineUnitId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getMedicineUnitId() {
        return medicineUnitId;
    }

    public void setMedicineUnitId(int medicineUnitId) {
        this.medicineUnitId = medicineUnitId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public Medicine getMedicine() {
        return medicine;
    }

    public void setMedicine(Medicine medicine) {
        this.medicine = medicine;
    }

    public double getTotalPrice() {
        return this.quantity * this.unitPrice;
    }
}

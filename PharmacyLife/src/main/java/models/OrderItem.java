package models;

public class OrderItem {
    private int orderId;
    private int medicineId;
    private int quantity;
    private double unitPrice;

    // Helper navigation property for display
    private Medicine medicine;

    public OrderItem() {
    }

    public OrderItem(int orderId, int medicineId, int quantity, double unitPrice) {
        this.orderId = orderId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public OrderItem(int orderId, Medicine medicine, int quantity, double unitPrice) {
        this.orderId = orderId;
        this.medicine = medicine;
        if (medicine != null) {
            this.medicineId = medicine.getMedicineId();
        }
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
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

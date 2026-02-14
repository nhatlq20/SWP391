package models;

public class Medicine {
    private int medicineId;
    private String medicineCode;
    private String medicineName;
    private double price;

    public Medicine() {
    }

    public Medicine(int medicineId, String medicineCode, String medicineName, double price) {
        this.medicineId = medicineId;
        this.medicineCode = medicineCode;
        this.medicineName = medicineName;
        this.price = price;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getMedicineCode() {
        return medicineCode;
    }

    public void setMedicineCode(String medicineCode) {
        this.medicineCode = medicineCode;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}

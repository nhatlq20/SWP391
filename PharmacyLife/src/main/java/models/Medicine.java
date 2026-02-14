package models;

public class Medicine {
    private int medicineId;
    private String medicineCode;
    private String medicineName;
    private double sellingPrice;
    private String imageUrl;
    private String shortDescription;

    public Medicine() {
    }

    public Medicine(int medicineId, String medicineCode, String medicineName, double sellingPrice, String imageUrl,
            String shortDescription) {
        this.medicineId = medicineId;
        this.medicineCode = medicineCode;
        this.medicineName = medicineName;
        this.sellingPrice = sellingPrice;
        this.imageUrl = imageUrl;
        this.shortDescription = shortDescription;
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

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Medicine{" +
                "medicineID='" + medicineID + '\'' +
                ", medicineName='" + medicineName + '\'' +
                ", sellingPrice=" + sellingPrice +
                ", unit='" + unit + '\'' +
                ", remainingQuantity=" + remainingQuantity +
                ", categoryID='" + categoryID + '\'' +
                ", prescriptionRequired=" + prescriptionRequired +
                '}';
    }
}

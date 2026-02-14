package models;

import java.time.LocalDateTime;

public class Category {

    private String categoryID;
    private String categoryName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private int medicineCount;

    // Getter
    public int getMedicineCount() {
        return medicineCount;
    }

// Setter
    public void setMedicineCount(int medicineCount) {
        this.medicineCount = medicineCount;
    }

    // Constructors
    public Category() {
    }

    public Category(String categoryID, String categoryName) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
    }

    public Category(String categoryID, String categoryName, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
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
        return "Category{"
                + "categoryID='" + categoryID + '\''
                + ", categoryName='" + categoryName + '\''
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + '}';
    }
}

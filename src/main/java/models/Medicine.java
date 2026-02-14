package models;

public class Medicine {

    private int medicineId;
    private String medicineCode;
    private int categoryId;
    private String medicineName;
    private String brandOrigin;
    private String unit;
    private double originalPrice;
    private double sellingPrice;
    private String shortDescription;
    private String imageUrl;
    private int remainingQuantity;
    private Category category; // For join query results

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

    public Medicine(int medicineId, String medicineCode, int categoryId, String medicineName, String brandOrigin,
            String unit, double originalPrice, double sellingPrice, String shortDescription, String imageUrl,
            int remainingQuantity) {
        this.medicineId = medicineId;
        this.medicineCode = medicineCode;
        this.categoryId = categoryId;
        this.medicineName = medicineName;
        this.brandOrigin = brandOrigin;
        this.unit = unit;
        this.originalPrice = originalPrice;
        this.sellingPrice = sellingPrice;
        this.shortDescription = shortDescription;
        this.imageUrl = imageUrl;
        this.remainingQuantity = remainingQuantity;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    // Legacy getter for JSP compatibility (maps to MedicineCode)
    public String getMedicineID() {
        return medicineCode;
    }

    // Legacy setter for JSP/Controller compatibility (maps to MedicineCode)
    public void setMedicineID(String medicineID) {
        this.medicineCode = medicineID;
    }

    public String getMedicineCode() {
        return medicineCode;
    }

    public void setMedicineCode(String medicineCode) {
        this.medicineCode = medicineCode;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    // Legacy setter for Controller compatibility (String to int)
    public void setCategoryID(String categoryID) {
        try {
            this.categoryId = Integer.parseInt(categoryID);
        } catch (NumberFormatException e) {
            this.categoryId = 0; // Or handle error
        }
    }

    // Legacy getter matching property name categoryID (if used in JSP)
    public int getCategoryID() {
        return categoryId;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public String getBrandOrigin() {
        return brandOrigin;
    }

    public void setBrandOrigin(String brandOrigin) {
        this.brandOrigin = brandOrigin;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    // Legacy setter for BigDecimal compatibility
    public void setSellingPrice(java.math.BigDecimal sellingPrice) {
        if (sellingPrice != null) {
            this.sellingPrice = sellingPrice.doubleValue();
        }
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    // Helper for Controller
    public void setPackDescription(String packDescription) {
        // Map to ShortDescription or ignore?
        // Old model had packDescription. New schema doesn't seem to have it separate?
        // Check schema: [ShortDescription] nvarchar(255).
        // Maybe append to short description or ignore.
        // I'll ignore for now to avoid breaking SQL, or append?
    }

    public String getPackDescription() {
        return "";
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getRemainingQuantity() {
        return remainingQuantity;
    }

    public void setRemainingQuantity(int remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "Medicine{" +
                "medicineId=" + medicineId +
                ", medicineCode='" + medicineCode + '\'' +
                ", categoryId=" + categoryId +
                ", medicineName='" + medicineName + '\'' +
                ", brandOrigin='" + brandOrigin + '\'' +
                ", unit='" + unit + '\'' +
                ", originalPrice=" + originalPrice +
                ", sellingPrice=" + sellingPrice +
                ", shortDescription='" + shortDescription + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", remainingQuantity=" + remainingQuantity +
                '}';
    }
}

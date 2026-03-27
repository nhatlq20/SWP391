package models;

/* Represents a medicine product in the system. */
public class Medicine {

    private int medicineId; // Primary key
    private String medicineCode; // Unique code (e.g., MED001)
    private int categoryId; // Category link
    private String medicineName;
    private String brandOrigin;
    private double originalPrice;
    private String shortDescription;
    private String imageUrl;
    private int remainingQuantity; // Stock quantity in smallest unit
    private Category category; // To store category join information
    private MedicineUnit baseUnit; // Best-selling unit for this medicine
    private String ingredients; // Components of the medicine
    private String conditions; // Usage and medical effects

    // Legacy fields for backward compatibility
    private String unit;
    private double sellingPrice;

    /* Default constructor. */
    public Medicine() {
    }

    /* Parameterized constructor for basic information. */
    public Medicine(int medicineId, String medicineCode, String medicineName, double sellingPrice, String imageUrl,
            String shortDescription) {
        this.medicineId = medicineId;
        this.medicineCode = medicineCode;
        this.medicineName = medicineName;
        this.sellingPrice = sellingPrice;
        this.imageUrl = imageUrl;
        this.shortDescription = shortDescription;
    }

    /* Full-parameterized constructor for legacy system support. */
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

    /* Gets the medicine's internal ID. */
    public int getMedicineId() {
        return medicineId;
    }

    /* Sets the medicine's internal ID. */
    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    /* Legacy getter for JSP compatibility mapping to Code. */
    public String getMedicineID() {
        return medicineCode;
    }

    /* Legacy setter for JSP compatibility mapping to Code. */
    public void setMedicineID(String medicineID) {
        this.medicineCode = medicineID;
    }

    /* Gets the public medicine code. */
    public String getMedicineCode() {
        return medicineCode;
    }

    /* Sets the public medicine code. */
    public void setMedicineCode(String medicineCode) {
        this.medicineCode = medicineCode;
    }

    /* Gets the category identifier. */
    public int getCategoryId() {
        return categoryId;
    }

    /* Sets the category identifier. */
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    /* Legacy setter for String category IDs. */
    public void setCategoryID(String categoryID) {
        try {
            this.categoryId = Integer.parseInt(categoryID);
        } catch (NumberFormatException e) {
            this.categoryId = 0;
        }
    }

    /* Legacy getter for property name compatibility. */
    public int getCategoryID() {
        return categoryId;
    }

    /* Gets the name of the medicine. */
    public String getMedicineName() {
        return medicineName;
    }

    /* Sets the name of the medicine. */
    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    /* Gets the manufacturer or brand origin. */
    public String getBrandOrigin() {
        return brandOrigin;
    }

    /* Sets the manufacturer or brand origin. */
    public void setBrandOrigin(String brandOrigin) {
        this.brandOrigin = brandOrigin;
    }

    /* Gets the ingredients list as a string. */
    public String getIngredients() {
        return ingredients;
    }

    /* Sets the ingredients list. */
    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    /* Gets the conditions or uses for the medicine. */
    public String getConditions() {
        return conditions;
    }

    /* Sets the conditions or uses for the medicine. */
    public void setConditions(String conditions) {
        this.conditions = conditions;
    }

    /* Gets the unit name, prioritizing base unit over legacy unit field. */
    public String getUnit() {
        if (baseUnit != null) {
            return baseUnit.getUnitName();
        }
        return unit;
    }

    /* Sets the legacy unit field. */
    public void setUnit(String unit) {
        this.unit = unit;
    }

    /* Gets the original purchase price. */
    public double getOriginalPrice() {
        return originalPrice;
    }

    /* Sets the original purchase price. */
    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
    }

    /* Gets the retail selling price, prioritizing base unit over legacy field. */
    public double getSellingPrice() {
        if (baseUnit != null) {
            return baseUnit.getSellingPrice();
        }
        return sellingPrice;
    }

    /* Sets the retail selling price. */
    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    /* Legacy setter for BigDecimal price data. */
    public void setSellingPrice(java.math.BigDecimal sellingPrice) {
        if (sellingPrice != null) {
            this.sellingPrice = sellingPrice.doubleValue();
        }
    }

    /* Gets the short descriptive text for the medicine. */
    public String getShortDescription() {
        return shortDescription;
    }

    /* Sets the short descriptive text. */
    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    /* Legacy helper for pack descriptions (currently unused). */
    public void setPackDescription(String packDescription) {
        // Reserved for future use if needed
    }

    /* Legacy helper to retrieve pack description. */
    public String getPackDescription() {
        return "";
    }

    /* Gets the image URL path. */
    public String getImageUrl() {
        return imageUrl;
    }

    /* Sets the image URL path. */
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    /* Gets the raw stock remaining in smallest units. */
    public int getRemainingQuantity() {
        return remainingQuantity;
    }

    /* Sets the raw stock remaining. */
    public void setRemainingQuantity(int remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }

    /*
     * Calculates the display quantity (e.g., number of boxes) based on conversion
     * rate.
     */
    public int getDisplayQuantity() {
        if (baseUnit != null && baseUnit.getConversionRate() > 0) {
            return remainingQuantity / baseUnit.getConversionRate();
        }
        return remainingQuantity;
    }

    /* Gets the linked Category object. */
    public Category getCategory() {
        return category;
    }

    /* Sets the linked Category object. */
    public void setCategory(Category category) {
        this.category = category;
    }

    /* Gets the associated base MedicineUnit. */
    public MedicineUnit getBaseUnit() {
        return baseUnit;
    }

    /* Sets the associated base MedicineUnit. */
    public void setBaseUnit(MedicineUnit baseUnit) {
        this.baseUnit = baseUnit;
    }

    /* Returns a string representation of the medicine data. */
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
                ", ingredients='" + ingredients + '\'' +
                ", conditions='" + conditions + '\'' +
                '}';
    }
}

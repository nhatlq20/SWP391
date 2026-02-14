package models;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Medicine {
    // Khóa chính
    private String medicineID;
    
    // Thông tin cơ bản để hiển thị danh sách / mua hàng
    private String medicineName;
    private BigDecimal sellingPrice;
    private String unit;
    private String packDescription;
    
    // Quản lý kho / hạn dùng
    private LocalDate manufactureDate;
    private LocalDate expirationDate;
    private int remainingQuantity;
    
    // Danh mục
    private String categoryID;
    private Category category; // Reference to Category object
    
    // Thông tin dược lý / hiển thị tab chi tiết
    private String registrationNumber;
    private String dosageForm;
    private String contraindications;
    private String ingredients;
    private String indications;
    private String directions;
    private String sideEffects;
    private String precautions;
    private String storage;
    
    // Thông tin nguồn gốc / quản trị
    private String manufacturer;
    private String countryOfOrigin;
    private String brandOrigin;
    private boolean prescriptionRequired;
    
    // Ảnh sản phẩm
    private String imageUrl;
    
    // SEO / mô tả ngắn
    private String shortDescription;
    
    // Audit
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Medicine() {
        this.remainingQuantity = 0;
        this.prescriptionRequired = false;
    }

    public Medicine(String medicineID, String medicineName, BigDecimal sellingPrice, String unit, String categoryID) {
        this();
        this.medicineID = medicineID;
        this.medicineName = medicineName;
        this.sellingPrice = sellingPrice;
        this.unit = unit;
        this.categoryID = categoryID;
    }

    // Getters and Setters
    public String getMedicineID() {
        return medicineID;
    }

    public void setMedicineID(String medicineID) {
        this.medicineID = medicineID;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getPackDescription() {
        return packDescription;
    }

    public void setPackDescription(String packDescription) {
        this.packDescription = packDescription;
    }

    public LocalDate getManufactureDate() {
        return manufactureDate;
    }

    public void setManufactureDate(LocalDate manufactureDate) {
        this.manufactureDate = manufactureDate;
    }

    public LocalDate getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(LocalDate expirationDate) {
        this.expirationDate = expirationDate;
    }

    public int getRemainingQuantity() {
        return remainingQuantity;
    }

    public void setRemainingQuantity(int remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }

    public String getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public String getDosageForm() {
        return dosageForm;
    }

    public void setDosageForm(String dosageForm) {
        this.dosageForm = dosageForm;
    }

    public String getContraindications() {
        return contraindications;
    }

    public void setContraindications(String contraindications) {
        this.contraindications = contraindications;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public String getIndications() {
        return indications;
    }

    public void setIndications(String indications) {
        this.indications = indications;
    }

    public String getDirections() {
        return directions;
    }

    public void setDirections(String directions) {
        this.directions = directions;
    }

    public String getSideEffects() {
        return sideEffects;
    }

    public void setSideEffects(String sideEffects) {
        this.sideEffects = sideEffects;
    }

    public String getPrecautions() {
        return precautions;
    }

    public void setPrecautions(String precautions) {
        this.precautions = precautions;
    }

    public String getStorage() {
        return storage;
    }

    public void setStorage(String storage) {
        this.storage = storage;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getCountryOfOrigin() {
        return countryOfOrigin;
    }

    public void setCountryOfOrigin(String countryOfOrigin) {
        this.countryOfOrigin = countryOfOrigin;
    }

    public String getBrandOrigin() {
        return brandOrigin;
    }

    public void setBrandOrigin(String brandOrigin) {
        this.brandOrigin = brandOrigin;
    }

    public boolean isPrescriptionRequired() {
        return prescriptionRequired;
    }

    public void setPrescriptionRequired(boolean prescriptionRequired) {
        this.prescriptionRequired = prescriptionRequired;
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
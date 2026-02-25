package models;

public class Category {

    private int categoryId;
    private String categoryCode;
    private String categoryName;

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

    public Category(int categoryId, String categoryCode, String categoryName) {
        this.categoryId = categoryId;
        this.categoryCode = categoryCode;
        this.categoryName = categoryName;
    }

    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "Category{"
                + "categoryId=" + categoryId
                + ", categoryCode='" + categoryCode + '\''
                + ", categoryName='" + categoryName + '\''
                + '}';
    }
}

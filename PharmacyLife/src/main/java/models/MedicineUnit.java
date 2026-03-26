package models;

public class MedicineUnit {

    private int medicineUnitId;
    private int medicineId;
    private int unitId;
    private String unitName;
    private int conversionRate;
    private double sellingPrice;
    private boolean isBaseUnit;

    public MedicineUnit() {
    }

    public MedicineUnit(int medicineUnitId, int medicineId, int unitId, String unitName, int conversionRate,
            double sellingPrice, boolean isBaseUnit) {
        this.medicineUnitId = medicineUnitId;
        this.medicineId = medicineId;
        this.unitId = unitId;
        this.unitName = unitName;
        this.conversionRate = conversionRate;
        this.sellingPrice = sellingPrice;
        this.isBaseUnit = isBaseUnit;
    }

    public int getMedicineUnitId() {
        return medicineUnitId;
    }

    public void setMedicineUnitId(int medicineUnitId) {
        this.medicineUnitId = medicineUnitId;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public int getConversionRate() {
        return conversionRate;
    }

    public void setConversionRate(int conversionRate) {
        this.conversionRate = conversionRate;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public boolean isBaseUnit() {
        return isBaseUnit;
    }

    public void setBaseUnit(boolean isBaseUnit) {
        this.isBaseUnit = isBaseUnit;
    }
}

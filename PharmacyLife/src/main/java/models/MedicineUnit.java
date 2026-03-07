package models;

public class MedicineUnit {
    private int unitId;
    private int medicineId;
    private String unitName;
    private int conversionRate;
    private double sellingPrice;
    private boolean isBaseUnit;

    public MedicineUnit() {
    }

    public MedicineUnit(int unitId, int medicineId, String unitName, int conversionRate, double sellingPrice,
            boolean isBaseUnit) {
        this.unitId = unitId;
        this.medicineId = medicineId;
        this.unitName = unitName;
        this.conversionRate = conversionRate;
        this.sellingPrice = sellingPrice;
        this.isBaseUnit = isBaseUnit;
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

    public void setBaseUnit(boolean baseUnit) {
        isBaseUnit = baseUnit;
    }

    @Override
    public String toString() {
        return "MedicineUnit{" +
                "unitId=" + unitId +
                ", medicineId=" + medicineId +
                ", unitName='" + unitName + '\'' +
                ", conversionRate=" + conversionRate +
                ", sellingPrice=" + sellingPrice +
                ", isBaseUnit=" + isBaseUnit +
                '}';
    }
}

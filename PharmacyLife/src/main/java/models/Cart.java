package models;

import java.util.ArrayList;
import java.util.List;

public class Cart {

    private List<Item> items;

    public Cart() {
        items = new ArrayList<>();
    }

    public Cart(List<Item> items) {
        this.items = items;
    }

    public List<Item> getItems() {
        return items;
    }

    public void setItems(List<Item> items) {
        this.items = items;
    }

    public Item getItem(int medicineUnitId) {
        for (Item item : items) {
            if (item.getMedicineUnitId() == medicineUnitId) {
                return item;
            }
        }
        return null;
    }

    public int getQuantity(int medicineUnitId) {
        Item item = getItem(medicineUnitId);
        if (item != null) {
            return item.getQuantity();
        }
        return 0;
    }

    public void addItem(Item t) {
        Item existingItem = getItem(t.getMedicineUnitId());
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + t.getQuantity());
        } else {
            items.add(t);
        }
    }

    public void removeItem(int medicineUnitId) {
        Item item = getItem(medicineUnitId);
        if (item != null) {
            items.remove(item);
        }
    }

    public void updateQuantity(int medicineUnitId, int quantity) {
        Item item = getItem(medicineUnitId);
        if (item != null) {
            if (quantity <= 0) {
                items.remove(item);
            } else {
                item.setQuantity(quantity);
            }
        }
    }

    public double getTotalMoney() {
        double total = 0;
        for (Item item : items) {
            total += item.getQuantity() * item.getPrice();
        }
        return total;
    }

    public int getItemCount() {
        int count = 0;
        if (items != null) {
            for (Item item : items) {
                count += item.getQuantity();
            }
        }
        return count;
    }

    public static class Item {

        private Medicine medicine;
        private int medicineUnitId;
        private String unitName; // Added for UI clarity
        private int conversionRate; // Added to distinguish units
        private int quantity;
        private double price; // Price at the moment of adding to cart

        public Item() {
        }

        public Item(Medicine medicine, int medicineUnitId, int quantity, double price) {
            this.medicine = medicine;
            this.medicineUnitId = medicineUnitId;
            this.quantity = quantity;
            this.price = price;
        }

        public Item(Medicine medicine, int medicineUnitId, String unitName, int conversionRate, int quantity, double price) {
            this.medicine = medicine;
            this.medicineUnitId = medicineUnitId;
            this.unitName = unitName;
            this.conversionRate = conversionRate;
            this.quantity = quantity;
            this.price = price;
        }

        public Medicine getMedicine() {
            return medicine;
        }

        public void setMedicine(Medicine medicine) {
            this.medicine = medicine;
        }

        public int getMedicineUnitId() {
            return medicineUnitId;
        }

        public void setMedicineUnitId(int medicineUnitId) {
            this.medicineUnitId = medicineUnitId;
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

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public double getPrice() {
            return price;
        }

        public void setPrice(double price) {
            this.price = price;
        }

        public double getTotalPrice() {
            return this.price * this.quantity;
        }
    }
}

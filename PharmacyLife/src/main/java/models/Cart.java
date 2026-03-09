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

    public Item getItem(int medicineId, int unitId) {
        for (Item item : items) {
            if (item.getMedicine().getMedicineId() == medicineId && item.getUnitId() == unitId) {
                return item;
            }
        }
        return null;
    }

    // Proxy for backward compatibility if needed, but better to update calls
    public Item getItemById(int medicineId) {
        for (Item item : items) {
            if (item.getMedicine().getMedicineId() == medicineId) {
                return item;
            }
        }
        return null;
    }

    public int getQuantity(int medicineId, int unitId) {
        Item item = getItem(medicineId, unitId);
        if (item != null) {
            return item.getQuantity();
        }
        return 0;
    }

    public int getQuantityById(int id) {
        Item item = getItemById(id);
        if (item != null) {
            return item.getQuantity();
        }
        return 0;
    }

    public void addItem(Item t) {
        Item existingItem = getItem(t.getMedicine().getMedicineId(), t.getUnitId());
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + t.getQuantity());
        } else {
            items.add(t);
        }
    }

    public void removeItem(int medicineId, int unitId) {
        Item item = getItem(medicineId, unitId);
        if (item != null) {
            items.remove(item);
        }
    }

    public void removeItem(int id) {
        Item item = getItemById(id);
        if (item != null) {
            items.remove(item);
        }
    }

    public void updateQuantity(int medicineId, int unitId, int quantity) {
        Item item = getItem(medicineId, unitId);
        if (item != null) {
            if (quantity <= 0) {
                items.remove(item);
            } else {
                item.setQuantity(quantity);
            }
        }
    }

    public void updateQuantity(int id, int quantity) {
        Item item = getItemById(id);
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

    public static class Item {

        private Medicine medicine;
        private int unitId; // New field
        private int quantity;
        private double price; // Price at the moment of adding to cart

        public Item() {
        }

        public Item(Medicine medicine, int unitId, int quantity, double price) {
            this.medicine = medicine;
            this.unitId = unitId;
            this.quantity = quantity;
            this.price = price;
        }

        // Legacy constructor for backward compatibility
        public Item(Medicine medicine, int quantity, double price) {
            this.medicine = medicine;
            this.quantity = quantity;
            this.price = price;
        }

        public Medicine getMedicine() {
            return medicine;
        }

        public void setMedicine(Medicine medicine) {
            this.medicine = medicine;
        }

        public int getUnitId() {
            return unitId;
        }

        public void setUnitId(int unitId) {
            this.unitId = unitId;
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

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

    public Item getItemById(int id) {
        for (Item item : items) {
            if (item.getMedicine().getMedicineId() == id) {
                return item;
            }
        }
        return null;
    }

    public int getQuantityById(int id) {
        Item item = getItemById(id);
        if (item != null) {
            return item.getQuantity();
        }
        return 0;
    }

    public void addItem(Item t) {
        if (getItemById(t.getMedicine().getMedicineId()) != null) {
            Item existingItem = getItemById(t.getMedicine().getMedicineId());
            existingItem.setQuantity(existingItem.getQuantity() + t.getQuantity());
        } else {
            items.add(t);
        }
    }

    public void removeItem(int id) {
        if (getItemById(id) != null) {
            items.remove(getItemById(id));
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
        private int quantity;
        private double price; // Price at the moment of adding to cart

        public Item() {
        }

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

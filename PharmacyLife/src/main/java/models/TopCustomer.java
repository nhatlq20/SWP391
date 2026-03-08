package models;

public class TopCustomer {
    private String customerName;
    private int orderCount;
    private double totalSpent;

    public TopCustomer() {
    }

    public TopCustomer(String customerName, int orderCount, double totalSpent) {
        this.customerName = customerName;
        this.orderCount = orderCount;
        this.totalSpent = totalSpent;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public double getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(double totalSpent) {
        this.totalSpent = totalSpent;
    }
}

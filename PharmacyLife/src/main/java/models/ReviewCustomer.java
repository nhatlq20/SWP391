package models;

import java.sql.Timestamp;

/**
 *kien
 * @author PC
 */
public class ReviewCustomer {
    private String customerName;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public ReviewCustomer() {
    }

    public ReviewCustomer(String customerName, int rating, String comment, Timestamp createdAt) {
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

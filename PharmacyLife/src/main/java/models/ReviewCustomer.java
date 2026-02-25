package models;

import java.sql.Timestamp;

/**
 *kien
 * @author PC
 */
public class ReviewCustomer {
    private int reviewId;
    private String customerName;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private String replyContent;
    private Integer replyBy;
    private Timestamp replyCreatedAt;
    private String replyStaffName;

    public ReviewCustomer() {
    }

    public ReviewCustomer(String customerName, int rating, String comment, Timestamp createdAt) {
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
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

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public Integer getReplyBy() {
        return replyBy;
    }

    public void setReplyBy(Integer replyBy) {
        this.replyBy = replyBy;
    }

    public Timestamp getReplyCreatedAt() {
        return replyCreatedAt;
    }

    public void setReplyCreatedAt(Timestamp replyCreatedAt) {
        this.replyCreatedAt = replyCreatedAt;
    }

    public String getReplyStaffName() {
        return replyStaffName;
    }

    public void setReplyStaffName(String replyStaffName) {
        this.replyStaffName = replyStaffName;
    }
}

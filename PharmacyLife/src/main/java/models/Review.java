package models;

import java.sql.Timestamp;

import java.sql.Date;
/**
 *kien
 * @author PC
 */
public class Review {

    private int reviewId;
    private int customerId;
    private int medicineId;
    private int rating;
    private String comment;
    private Timestamp reviewCreatedAt;


    private String replyContent;
    private int replyBy;
    private Date replyCreatedAt;


     public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public int getReplyBy() {
        return replyBy;
    }

    public void setReplyBy(int replyBy) {
        this.replyBy = replyBy;
    }

    public Date getReplyCreatedAt() {
        return replyCreatedAt;
    }

    public void setReplyCreatedAt(Date replyCreatedAt) {
        this.replyCreatedAt = replyCreatedAt;
    }

    public Review() {
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
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

    public Timestamp getReviewCreatedAt() {
        return reviewCreatedAt;
    }

    public void setReviewCreatedAt(Timestamp reviewCreatedAt) {
        this.reviewCreatedAt = reviewCreatedAt;
    }
}

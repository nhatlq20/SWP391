package dao;

import models.Review;
import models.ReviewCustomer;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
///Kiên
public class ReviewDAO {

    private DBContext dbContext = new DBContext();

    public ReviewDAO(DBContext dbContext) {
        this.dbContext = dbContext;
    }

    public ReviewDAO() {
    }

    public List<Review> getReviewByCustomer(int customerId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.* FROM Reviews r WHERE r.CustomerId = ? ORDER BY r.ReviewCreatedAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public List<ReviewCustomer> getReviewsWithCustomerByMedicine(int medicineId) {
        //lấy danh sách review của 1 loại thuốc
        List<ReviewCustomer> list = new ArrayList<>();
        String sql = "SELECT r.ReviewId, c.FullName, r.Rating, r.Comment, r.ReviewCreatedAt, r.ReplyContent, r.ReplyBy, r.ReplyCreatedAt, s.StaffName AS ReplyStaffName " +
                     "FROM Reviews r " +
                     "JOIN Customer c ON c.CustomerId = r.CustomerId " +
                 "LEFT JOIN Staff s ON s.StaffId = r.ReplyBy " +
                     "WHERE r.MedicineId = ? " +
                     "ORDER BY r.ReviewCreatedAt DESC";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewCustomer review = new ReviewCustomer();
                    review.setReviewId(rs.getInt("ReviewId"));
                    review.setCustomerName(rs.getString("FullName"));
                    review.setRating(rs.getInt("Rating"));
                    review.setComment(rs.getString("Comment"));
                    review.setCreatedAt(rs.getTimestamp("ReviewCreatedAt"));
                    review.setReplyContent(rs.getString("ReplyContent"));
                    int replyBy = rs.getInt("ReplyBy");
                    if (rs.wasNull()) {
                        review.setReplyBy(null);
                    } else {
                        review.setReplyBy(replyBy);
                    }
                    review.setReplyCreatedAt(rs.getTimestamp("ReplyCreatedAt"));
                    review.setReplyStaffName(rs.getString("ReplyStaffName"));
                    list.add(review);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }

      public double getAverageRating(int medicineId) {
        //tính trung bình sao
        String sql = "SELECT AVG(CAST(Rating AS FLOAT)) as avgRating FROM Reviews WHERE MedicineId = ?";
            
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avgRating");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

        public int getTotalReviews(int medicineId) {
            //đếm xem có bao nhiêu sản phẩm
        String sql = "SELECT COUNT(*) as count FROM Reviews WHERE MedicineId = ?";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean addReview(Review review) {
        String sql = "INSERT INTO Reviews (MedicineId, CustomerId, Rating, Comment, ReviewCreatedAt) VALUES (?, ?, ?, ?, GETDATE())";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getMedicineId());
            ps.setInt(2, review.getCustomerId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

  



    public boolean insertReview(Review review) {
        return addReview(review);
    }

    public boolean deleteReviewByCustomer(int reviewId, int customerId, int medicineId) {
        String sql = "DELETE FROM Reviews WHERE CustomerId = ? AND ReviewId = ? AND MedicineId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, reviewId);
            ps.setInt(3, medicineId);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteReviewByAdminOrStaff(int reviewId) {
        String sql = "DELETE FROM Reviews WHERE ReviewId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            int row = ps.executeUpdate();
            return row > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public void DeleteReview(int reviewId) {
        deleteReviewByAdminOrStaff(reviewId);
    }

    public boolean replyReview(int reviewId, String replyContent, int staffId) {
        String sql = "UPDATE Reviews SET ReplyContent = ?, ReplyBy = ?, ReplyCreatedAt = GETDATE() WHERE ReviewId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, replyContent);
            ps.setInt(2, staffId);
            ps.setInt(3, reviewId);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
// kien
    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM Reviews ORDER BY ReviewCreatedAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public List<Review> getAllReview() {
        return getAllReviews();
    }

    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("ReviewId"));
        review.setMedicineId(rs.getInt("MedicineId"));
        review.setCustomerId(rs.getInt("CustomerId"));
        review.setRating(rs.getInt("Rating"));
        review.setComment(rs.getString("Comment"));
        review.setReviewCreatedAt(rs.getTimestamp("ReviewCreatedAt"));
        review.setReplyContent(rs.getString("ReplyContent"));
        review.setReplyBy(rs.getInt("ReplyBy"));
        review.setReplyCreatedAt(rs.getDate("ReplyCreatedAt"));
        return review;
    }
}

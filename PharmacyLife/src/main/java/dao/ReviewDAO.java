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
        List<ReviewCustomer> list = new ArrayList<>();
        String sql = "SELECT c.FullName, r.Rating, r.Comment, r.ReviewCreatedAt " +
                     "FROM Reviews r " +
                     "JOIN Customer c ON c.CustomerId = r.CustomerId " +
                     "WHERE r.MedicineId = ? " +
                     "ORDER BY r.ReviewCreatedAt DESC";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewCustomer review = new ReviewCustomer();
                    review.setCustomerName(rs.getString("FullName"));
                    review.setRating(rs.getInt("Rating"));
                    review.setComment(rs.getString("Comment"));
                    review.setCreatedAt(rs.getTimestamp("ReviewCreatedAt"));
                    list.add(review);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
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

    public double getAverageRating(int medicineId) {
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

    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("ReviewId"));
        review.setMedicineId(rs.getInt("MedicineId"));
        review.setCustomerId(rs.getInt("CustomerId"));
        review.setRating(rs.getInt("Rating"));
        review.setComment(rs.getString("Comment"));
        review.setReviewCreatedAt(rs.getTimestamp("ReviewCreatedAt"));
        return review;
    }
}

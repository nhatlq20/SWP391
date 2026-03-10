
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
        // lấy danh sách review của 1 loại thuốc
        List<ReviewCustomer> list = new ArrayList<>();
        String sql = "SELECT r.ReviewId, r.CustomerId, c.FullName, r.Rating, r.Comment, r.ReviewCreatedAt, r.ReplyContent, r.ReplyBy, r.ReplyCreatedAt, "
                +
                "COALESCE(s.StaffName, rc.FullName) AS ReplyStaffName " +
                "FROM Reviews r " +
                "JOIN Customer c ON c.CustomerId = r.CustomerId " +
                "LEFT JOIN Staff s ON s.StaffId = r.ReplyBy AND r.ReplyBy > 0 " +
                "LEFT JOIN Customer rc ON rc.CustomerId = -r.ReplyBy AND r.ReplyBy < 0 " +
                "WHERE r.MedicineId = ? " +
                "ORDER BY r.ReviewCreatedAt DESC";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewCustomer review = new ReviewCustomer();
                    review.setReviewId(rs.getInt("ReviewId"));
                    review.setCustomerId(rs.getInt("CustomerId"));
                    review.setCustomerName(rs.getString("FullName"));
                    review.setRating(rs.getInt("Rating"));
                    review.setComment(rs.getString("Comment"));
                    review.setCreatedAt(rs.getTimestamp("ReviewCreatedAt"));
                    review.setReplyContent(toPlainReplyContent(rs.getString("ReplyContent")));
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

    private void appendBlock(StringBuilder builder, String value) {
        if (value == null) {
            return;
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return;
        }
        if (builder.length() > 0) {
            builder.append("@@BR@@");
        }
        builder.append(trimmed);
    }

    private String normalizeReplyMarkers(String content) {
        return content
                .replaceAll("(?i)\\|\\s*meta\\s*\\|", "@@META@@")
                .replaceAll("(?i)\\|\\s*br\\s*\\|", "@@BR@@")
                .replaceAll("(?i)@\\s*meta\\s*@", "@@META@@")
                .replaceAll("(?i)@\\s*br\\s*@", "@@BR@@");
    }

    private String addPharmacistTagIfNeeded(String author, String role) {
        if (author == null) {
            return "";
        }
        String cleanedAuthor = author.trim();
        if (cleanedAuthor.isEmpty() || role == null) {
            return cleanedAuthor;
        }

        String normalizedRole = role.toLowerCase();
        boolean isStaffRole = normalizedRole.contains("dược")
                || normalizedRole.contains("staff")
                || normalizedRole.contains("admin");

        if (isStaffRole && !cleanedAuthor.contains("(Dược sĩ)")) {
            return cleanedAuthor + " (Dược sĩ)";
        }
        return cleanedAuthor;
    }

    private String toPlainReplyContent(String rawReplyContent) {
        if (rawReplyContent == null) {
            return null;
        }

        String content = rawReplyContent.trim();
        if (content.isEmpty()) {
            return content;
        }

        if (!content.contains("@@META@@") && !content.contains("|META|")) {
            if (content.contains("@@BR@@")) {
                StringBuilder plain = new StringBuilder();
                for (String block : content.split("\\Q@@BR@@\\E")) {
                    appendBlock(plain, block);
                }
                return plain.toString();
            }

            if (content.contains("\n")) {
                StringBuilder plain = new StringBuilder();
                for (String block : content.split("\\r?\\n")) {
                    appendBlock(plain, block);
                }
                return plain.toString();
            }

            return content;
        }

        String normalized = normalizeReplyMarkers(content);
        StringBuilder plain = new StringBuilder();

        for (String blockRaw : normalized.split("\\Q@@BR@@\\E")) {
            String block = blockRaw == null ? "" : blockRaw.trim();
            if (block.isEmpty()) {
                continue;
            }

            String[] parts = block.split("\\Q@@META@@\\E");
            if (parts.length >= 3) {
                String author = addPharmacistTagIfNeeded(parts[0], parts[1]);
                String text = parts[2] == null ? "" : parts[2].trim();
                if (!text.isEmpty()) {
                    appendBlock(plain, author.isEmpty() ? text : author + ": " + text);
                    continue;
                }
            }

            appendBlock(plain, block);
        }

        return plain.toString();
    }

    private String getReplyAuthorName(Connection conn, int replyBy) throws SQLException {
        if (replyBy > 0) {
            String staffSql = "SELECT StaffName FROM Staff WHERE StaffId = ?";
            try (PreparedStatement ps = conn.prepareStatement(staffSql)) {
                ps.setInt(1, replyBy);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String name = rs.getString("StaffName");
                        if (name != null && !name.trim().isEmpty()) {
                            return name.trim();
                        }
                    }
                }
            }
            return "Nhân viên";
        }

        String customerSql = "SELECT FullName FROM Customer WHERE CustomerId = ?";
        try (PreparedStatement ps = conn.prepareStatement(customerSql)) {
            ps.setInt(1, -replyBy);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("FullName");
                    if (name != null && !name.trim().isEmpty()) {
                        return name.trim();
                    }
                }
            }
        }
        return "Khách hàng";
    }

    private String buildAuthorLabel(String authorName, int replyBy) {
        if (authorName == null) {
            authorName = "";
        }
        String cleaned = authorName.trim();
        // if (cleaned.isEmpty()) {
        // cleaned = replyBy > 0 ? "Nhân viên" : "Khách hàng";
        // }
        if (replyBy > 0 && !cleaned.contains("(Dược sĩ)")) {
            return cleaned + " (Dược sĩ)";
        }
        return cleaned;
    }

    public double getAverageRating(int medicineId) {
        // tính trung bình sao
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
        // đếm xem có bao nhiêu sản phẩm
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

    // =====================================

    private boolean hasAuthorPrefix(String replyLine) {
        if (replyLine == null) {
            return false;
        }
        int separatorIndex = replyLine.indexOf(": ");
        return separatorIndex > 0 && separatorIndex <= 80;
    }

    private String normalizeExistingReplyBlocks(String existingContent, String fallbackAuthor) {
        if (existingContent == null) {
            return "";
        }

        String[] blocks = existingContent.split("\\Q@@BR@@\\E");
        StringBuilder normalized = new StringBuilder();

        for (String blockRaw : blocks) {
            String block = blockRaw == null ? "" : blockRaw.trim();
            if (block.isEmpty()) {
                continue;
            }

            String withAuthor = hasAuthorPrefix(block) ? block : (fallbackAuthor + ": " + block);
            if (normalized.length() > 0) {
                normalized.append("@@BR@@");
            }
            normalized.append(withAuthor);
        }

        return normalized.toString();
    }

    public boolean replyReview(int reviewId, int medicineId, String replyContent, int staffId) {
        String selectSql = "SELECT ReplyContent, ReplyBy FROM Reviews WHERE ReviewId = ? AND MedicineId = ?";
        String updateSql = "UPDATE Reviews "
                + "SET ReplyContent = ?, ReplyBy = ?, ReplyCreatedAt = GETDATE() "
                + "WHERE ReviewId = ? AND MedicineId = ?";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement selectPs = conn.prepareStatement(selectSql);
                PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            String authorName = getReplyAuthorName(conn, staffId);
            String finalReply = buildAuthorLabel(authorName, staffId) + ": " + replyContent;

            selectPs.setInt(1, reviewId);
            selectPs.setInt(2, medicineId);

            String fullReplyContent = finalReply;
            try (ResultSet rs = selectPs.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                String existingContent = rs.getString("ReplyContent");
                int existingReplyByRaw = rs.getInt("ReplyBy");
                Integer existingReplyBy = rs.wasNull() ? null : existingReplyByRaw;

                if (existingContent != null && !existingContent.trim().isEmpty()) {
                    String normalizedExisting = toPlainReplyContent(existingContent);
                    String fallbackAuthor = existingReplyBy != null
                            ? buildAuthorLabel(getReplyAuthorName(conn, existingReplyBy), existingReplyBy)
                            : "Khách hàng";
                    normalizedExisting = normalizeExistingReplyBlocks(normalizedExisting, fallbackAuthor);
                    if (!normalizedExisting.isEmpty()) {
                        fullReplyContent = normalizedExisting + "@@BR@@" + finalReply;
                    }
                }
            }

            updatePs.setString(1, fullReplyContent);
            updatePs.setInt(2, staffId);
            updatePs.setInt(3, reviewId);
            updatePs.setInt(4, medicineId);

            int row = updatePs.executeUpdate();
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

    // Kiểm tra khách hàng đã đánh giá sản phẩm này chưa
    public boolean hasCustomerReviewedMedicine(int customerId, int medicineId) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE CustomerId = ? AND MedicineId = ?";
        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, medicineId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteReviewsByMedicineId(int medicineId) {
        String sql = "DELETE FROM Reviews WHERE MedicineId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

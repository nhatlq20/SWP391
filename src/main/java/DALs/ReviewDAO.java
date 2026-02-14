/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs;

import Model.Review;
import Model.ReviewDTO;
import Utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author PC
 */
public class ReviewDAO extends DBContext {

    public ReviewDAO() {
        super();
    }
//
//    private int reviewId;
//    private int customerId;
//    private int medicineId;
//    private int rating;
//    private String comment;
//    private Timestamp reviewCreatedAt;

    public List<Review> getReviewByCustomer(int customerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT * FROM Reviews Where CustomerId=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("ReviewId"));
                r.setCustomerId(rs.getInt("CustomerId"));
                r.setMedicineId(rs.getInt("MedicineId"));
                r.setRating(rs.getInt("Rating"));
                r.setComment(rs.getString("Comment"));
                r.setReviewCreatedAt(rs.getTimestamp("ReviewCreatedAt"));

                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertReview(Review r) {

        String sql = "INSERT INTO Reviews(CustomerId,MedicineId,Rating,Comment,ReviewCreatedAt)"
                + "VALUES(?,?,?,?,GETDATE())";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, r.getCustomerId());
            ps.setInt(2, r.getMedicineId());
            ps.setInt(3, r.getRating());
            ps.setString(4, r.getComment());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public List<ReviewDTO> getReviewsByMedicine(int medicineId) {
        List<ReviewDTO> list = new ArrayList<>();
        String sql = "SELECT  c.FullName,r.Rating, r.Comment,  r.ReviewCreatedAt FROM Reviews r "
                + "JOIN Customer c ON c.CustomerId = r.CustomerId "
                + "WHERE r.MedicineId=? "
                + "ORDER BY r.ReviewCreatedAt DESC";
        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, medicineId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReviewDTO r = new ReviewDTO();
                r.setCustomerName(rs.getString("FullName"));
                r.setRating(rs.getInt("Rating"));
                r.setComment(rs.getString("Comment"));
                r.setCreatedAt(rs.getTimestamp("ReviewCreatedAt"));

                list.add(r);

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public void deleteReviewByCustomer(int reviewId, int customerId, int medicineId) {

        String sql = "DELETE FROM Reviews "
                + "WHERE CustomerId=? AND ReviewId=? AND MedicineId=?;";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setInt(2, reviewId);
            ps.setInt(3, medicineId);

            int rows = ps.executeUpdate();
     

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}

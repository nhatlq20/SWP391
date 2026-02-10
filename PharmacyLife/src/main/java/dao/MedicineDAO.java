package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Medicine;
import utils.DBContext;

public class MedicineDAO {

    public Medicine getMedicineById(int id) {
        DBContext db = new DBContext();
        String sql = "SELECT * FROM Medicine WHERE MedicineId = ?";

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Medicine m = new Medicine();
                    m.setMedicineId(rs.getInt("MedicineId"));
                    m.setMedicineCode(rs.getString("MedicineCode"));
                    m.setMedicineName(rs.getString("MedicineName"));
                    m.setSellingPrice(rs.getDouble("SellingPrice"));
                    m.setImageUrl(rs.getString("ImageUrl"));
                    m.setShortDescription(rs.getString("ShortDescription"));
                    return m;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

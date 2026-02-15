package controllers;

import dao.MedicineDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Medicine;
import models.Review;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
///kiên
public class MyReviewsController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final MedicineDAO medicineDAO = new MedicineDAO();

    private int resolveCustomerId(HttpServletRequest request) {
        HttpSession session = request.getSession();

        Object customerIdInSession = session.getAttribute("customerId");
        if (customerIdInSession instanceof Integer) {
            return (Integer) customerIdInSession;
        }
        if (customerIdInSession instanceof String) {
            try {
                return Integer.parseInt((String) customerIdInSession);
            } catch (NumberFormatException ignored) {
            }
        }

        String customerIdParam = request.getParameter("customerId");
        if (customerIdParam != null && !customerIdParam.isBlank()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                if (customerId > 0) {
                    session.setAttribute("customerId", customerId);
                    return customerId;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        return 1;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = resolveCustomerId(request);
        String message = request.getParameter("message");

        List<Review> reviews = reviewDAO.getReviewByCustomer(customerId);
        Map<Integer, Medicine> medicineMap = new HashMap<>();
        Set<Integer> medicineIds = new LinkedHashSet<>();

        for (Review review : reviews) {
            medicineIds.add(review.getMedicineId());
        }

        for (Integer medicineId : medicineIds) {
            Medicine medicine = medicineDAO.getMedicineById(medicineId);
            if (medicine != null) {
                medicineMap.put(medicineId, medicine);
            }
        }

        request.setAttribute("reviews", reviews);
        request.setAttribute("medicineMap", medicineMap);
        request.setAttribute("customerId", customerId);
        request.setAttribute("message", message);

        request.getRequestDispatcher("/view/client/my-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy customer hiện tại từ session/request để đảm bảo chỉ thao tác trên review của chính user.
        int customerId = resolveCustomerId(request);
        // action dùng để phân biệt các thao tác POST (hiện tại có delete).
        String action = request.getParameter("action");

        // Xử lý xóa review thuộc quyền sở hữu của customer hiện tại.
        if ("delete".equalsIgnoreCase(action)) {
            // ID review và medicine gửi lên từ form nút "Xóa" ở my-reviews.jsp.
            String reviewIdParam = request.getParameter("reviewId");
            String medicineIdParam = request.getParameter("medicineId");

            try {
                int reviewId = Integer.parseInt(reviewIdParam);
                int medicineId = Integer.parseInt(medicineIdParam);

                // DAO sẽ chỉ xóa khi khớp đủ ReviewId + CustomerId + MedicineId.
                boolean deleted = reviewDAO.deleteReviewByCustomer(reviewId, customerId, medicineId);
                String message = deleted ? "Xóa đánh giá thành công" : "Không thể xóa đánh giá";
                // Redirect để tránh submit lại form khi refresh (Post/Redirect/Get).
                response.sendRedirect(request.getContextPath() + "/my-reviews?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                return;
            } catch (NumberFormatException e) {
                // Trường hợp dữ liệu ID không hợp lệ từ request.
                response.sendRedirect(request.getContextPath() + "/my-reviews?message=" + java.net.URLEncoder.encode("Dữ liệu xóa không hợp lệ", "UTF-8"));
                return;
            }
        }

        // Nếu không có action hợp lệ thì fallback về luồng GET để render trang.
        doGet(request, response);
    }
}

package controllers;

import dao.MedicineDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Customer;
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

    private Integer resolveCustomerId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object userTypeObj = session.getAttribute("userType");
        String userType = userTypeObj == null ? "" : userTypeObj.toString();

        Object loggedInUser = session.getAttribute("loggedInUser");
        if ("customer".equalsIgnoreCase(userType) && loggedInUser instanceof Customer) {
            return ((Customer) loggedInUser).getCustomerId();
        }

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

        if ("customer".equalsIgnoreCase(userType)) {
            Object userId = session.getAttribute("userId");
            if (userId instanceof Integer) {
                return (Integer) userId;
            }
            if (userId instanceof String) {
                try {
                    return Integer.parseInt((String) userId);
                } catch (NumberFormatException ignored) {
                }
            }
        }

        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer customerId = resolveCustomerId(request);
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
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
        // Lấy customer hiện tại từ session/request để đảm bảo chỉ thao tác trên review
        // của chính user.
        Integer customerId = resolveCustomerId(request);
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
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
                response.sendRedirect(request.getContextPath() + "/reviews?message="
                        + java.net.URLEncoder.encode(message, "UTF-8"));
                return;
            } catch (NumberFormatException e) {
                // Trường hợp dữ liệu ID không hợp lệ từ request.
                response.sendRedirect(request.getContextPath() + "/reviews?message="
                        + java.net.URLEncoder.encode("Dữ liệu xóa không hợp lệ", "UTF-8"));
                return;
            }
        }

        // Nếu không có action hợp lệ thì fallback về luồng GET để render trang.
        doGet(request, response);
    }
}

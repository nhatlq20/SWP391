package controllers.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.OrderItem;
import models.Medicine;

@WebServlet(name = "OrderControllerForDashboard", urlPatterns = { "/admin/orders-dashboard",
        "/admin/order-detail-dashboard", "/admin/order-update-dashboard" })
public class OrderControllerForDashboard extends HttpServlet {

    // Mock data storage in static list to persist updates during session
    private static List<Order> mockOrders = new ArrayList<>();

    @Override
    public void init() throws ServletException {
        super.init();
        if (mockOrders.isEmpty()) {
            initializeMockData();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/orders-dashboard".equals(path)) {
            showOrderList(request, response);
        } else if ("/admin/order-detail-dashboard".equals(path)) {
            showOrderDetail(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/order-update-dashboard".equals(path)) {
            updateOrderStatus(request, response);
        }
    }

    private void showOrderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Sort by date descending
        mockOrders.sort(Comparator.comparing(Order::getOrderDate).reversed());
        request.setAttribute("orders", mockOrders);
        request.getRequestDispatcher("/view/admin/order-list-for-dashboard.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = mockOrders.stream()
                        .filter(o -> o.getOrderId() == orderId)
                        .findFirst()
                        .orElse(null);

                if (order != null) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/view/admin/order-detail-for-dashboard.jsp").forward(request,
                            response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        // Redirect back to list if not found
        response.sendRedirect(request.getContextPath() + "/admin/orders-dashboard");
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String status = request.getParameter("status");

        if (idParam != null && status != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = mockOrders.stream()
                        .filter(o -> o.getOrderId() == orderId)
                        .findFirst()
                        .orElse(null);

                if (order != null) {
                    order.setStatus(status);

                    // Add success message
                    HttpSession session = request.getSession();
                    session.setAttribute("message", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công!");
                    session.setAttribute("messageType", "success");

                    response.sendRedirect(request.getContextPath() + "/admin/order-detail-dashboard?id=" + orderId);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders-dashboard");
    }

    private void initializeMockData() {
        // Create some mock medicines
        Medicine med1 = new Medicine();
        med1.setMedicineId(1);
        med1.setMedicineName("Panadol Extra");
        med1.setMedicineCode("MED001");
        med1.setImageUrl("assets/images/products/panadol.jpg");

        Medicine med2 = new Medicine();
        med2.setMedicineId(2);
        med2.setMedicineName("Vitamin C 1000mg");
        med2.setMedicineCode("MED002");
        med2.setImageUrl("assets/images/products/vitaminc.jpg");

        Medicine med3 = new Medicine();
        med3.setMedicineId(3);
        med3.setMedicineName("Khẩu trang y tế 4 lớp");
        med3.setMedicineCode("MED003");
        med3.setImageUrl("assets/images/products/mask.jpg");

        // Order 1
        Order o1 = new Order(1001, 1, new Date(), "Nguyễn Văn A", "0901234567", "123 Lê Lợi, Q.1, TP.HCM", "Pending",
                150000);
        List<OrderItem> items1 = new ArrayList<>();
        items1.add(new OrderItem(1001, med1, 2, 50000)); // 100k
        items1.add(new OrderItem(1001, med3, 1, 50000)); // 50k
        o1.setItems(items1);
        mockOrders.add(o1);

        // Order 2
        Order o2 = new Order(1002, 2, new Date(System.currentTimeMillis() - 86400000L), "Trần Thị B", "0987654321",
                "456 Nguyễn Huệ, Q.1, TP.HCM", "Confirmed", 200000);
        List<OrderItem> items2 = new ArrayList<>();
        items2.add(new OrderItem(1002, med2, 2, 100000)); // 200k
        o2.setItems(items2);
        mockOrders.add(o2);

        // Order 3
        Order o3 = new Order(1003, 3, new Date(System.currentTimeMillis() - 172800000L), "Lê Văn C", "0912345678",
                "789 Võ Văn Kiệt, Q.5, TP.HCM", "Shipping", 50000);
        List<OrderItem> items3 = new ArrayList<>();
        items3.add(new OrderItem(1003, med1, 1, 50000)); // 50k
        o3.setItems(items3);
        mockOrders.add(o3);

        // Order 4
        Order o4 = new Order(1004, 4, new Date(System.currentTimeMillis() - 259200000L), "Phạm Thị D", "0933445566",
                "321 Hai Bà Trưng, Q.3, TP.HCM", "Delivered", 300000);
        List<OrderItem> items4 = new ArrayList<>();
        items4.add(new OrderItem(1004, med2, 3, 100000)); // 300k
        o4.setItems(items4);
        mockOrders.add(o4);

        // Order 5
        Order o5 = new Order(1005, 5, new Date(System.currentTimeMillis() - 345600000L), "Hoàng Văn E", "0977889900",
                "654 Điện Biên Phủ, Bình Thạnh, TP.HCM", "Cancelled", 120000);
        List<OrderItem> items5 = new ArrayList<>();
        items5.add(new OrderItem(1005, med1, 1, 50000));
        items5.add(new OrderItem(1005, med3, 1, 70000));
        o5.setItems(items5);
        mockOrders.add(o5);
    }
}

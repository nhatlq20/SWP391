package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Medicine;
import models.Order;
import models.OrderItem;

@WebServlet(name = "OrderController", urlPatterns = { "/order-list", "/order-detail" })
public class OrderController extends HttpServlet {

    // Simulating database storage
    private static List<Order> mockOrders = new ArrayList<>();

    static {
        // Initialize some dummy data
        Medicine m1 = new Medicine(1, "MED001", "Paracetamol 500mg", 5000, "assets/img/thuoc-giam-dau/gd3.png",
                "Thuoc giam dau ha so");
        Medicine m2 = new Medicine(2, "MED002", "Vitamin C 1000mg", 1000, "assets/img/thuoc-bo-vitamin/vitc.png",
                "Tang cuong suc de khang");
        Medicine m3 = new Medicine(3, "MED003", "Berberin", 15000, "assets/img/thuoc-tieu-hoa/th1.png",
                "Thuoc tri Tieu Chay");

        Order o1 = new Order(1001, 1, new Date(), "Nguyen Van A", "0987654321", "123 Le Loi, District 1, HCMC",
                "Pending", 150000);
        List<OrderItem> items1 = new ArrayList<>();
        items1.add(new OrderItem(1001, m1, 2, 5000));
        items1.add(new OrderItem(1001, m2, 5, 1000));
        o1.setItems(items1);
        o1.setTotalAmount(15000); // Recalculated based on items

        Order o2 = new Order(1002, 1, new Date(System.currentTimeMillis() - 86400000L), "Nguyen Van A", "0987654321",
                "123 Le Loi, District 1, HCMC", "Completed", 50000);
        List<OrderItem> items2 = new ArrayList<>();
        items2.add(new OrderItem(1002, m3, 2, 25000));
        o2.setItems(items2);
        o2.setTotalAmount(50000);

        mockOrders.add(o1);
        mockOrders.add(o2);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/order-list".equals(path)) {
            showOrderList(request, response);
        } else if ("/order-detail".equals(path)) {
            showOrderDetail(request, response);
        }
    }

    private void showOrderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // In a real app, you'd filter by logged-in user ID
        // HttpSession session = request.getSession();
        // User user = (User) session.getAttribute("user");
        // List<Order> userOrders = orderService.getOrdersByUserId(user.getId());

        request.setAttribute("orders", mockOrders);
        request.getRequestDispatcher("view/client/order-list.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = findOrderById(orderId);

                if (order != null) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("view/client/order-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
        }

        // If order not found or invalid ID, go back to list
        response.sendRedirect("order-list");
    }

    private Order findOrderById(int id) {
        for (Order o : mockOrders) {
            if (o.getOrderId() == id) {
                return o;
            }
        }
        return null; // Not found
    }

    public static void addOrder(Order order) {
        mockOrders.add(0, order);
    }
}

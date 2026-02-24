package controllers.admin;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import dao.OrderDAO;

@WebServlet(name = "OrderControllerForDashboard", urlPatterns = { "/admin/orders-dashboard",
        "/admin/order-detail-dashboard", "/admin/order-update-dashboard" })
public class OrderControllerForDashboard extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

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
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/view/admin/order-list-for-dashboard.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.getOrderById(orderId);

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
                boolean success = orderDAO.updateStatus(orderId, status);

                if (success) {
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
    }
}

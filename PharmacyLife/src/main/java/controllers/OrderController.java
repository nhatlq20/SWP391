package controllers;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;
import dao.OrderDAO;

@WebServlet(name = "OrderController", urlPatterns = { "/order-list", "/order-detail" })
public class OrderController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

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
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        List<Order> orders;
        if (customerId != null) {
            orders = orderDAO.getOrdersByCustomerId(customerId);
        } else {
            // If not logged in, show empty list or redirect
            orders = new java.util.ArrayList<>();
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("view/client/order-list.jsp").forward(request, response);
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
}

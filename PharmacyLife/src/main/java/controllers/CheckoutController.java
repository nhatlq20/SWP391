package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Cart;
import models.Order;

@WebServlet(name = "CheckoutController", urlPatterns = { "/checkout" })
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            // Redirect to cart if empty
            response.sendRedirect("cart");
            return;
        }

        request.setAttribute("cart", cart);
        request.setAttribute("totalMoney", cart.getTotalMoney());

        request.getRequestDispatcher("view/client/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Get form data
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        // String note = request.getParameter("note"); // Not used in Order model yet

        // Here you would typically validate input and save the order to database
        // For now, we will just simulate a successful order

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null && !cart.getItems().isEmpty()) {
            // Create new Order
            Order order = new Order();
            order.setCustomerId(1); // Default user ID since no login
            order.setOrderDate(new java.util.Date());
            order.setShippingName(fullName);
            order.setShippingPhone(phone);
            order.setShippingAddress(address);

            order.setStatus("Pending");
            order.setTotalAmount(cart.getTotalMoney());

            // Convert Cart Items to Order Items
            java.util.List<models.OrderItem> orderItems = new java.util.ArrayList<>();
            for (Cart.Item cartItem : cart.getItems()) {
                models.OrderItem orderItem = new models.OrderItem();
                orderItem.setMedicineId(cartItem.getMedicine().getMedicineId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setUnitPrice(cartItem.getPrice());
                orderItems.add(orderItem);
            }
            order.setItems(orderItems);

            // Save order to database
            dao.OrderDAO orderDAO = new dao.OrderDAO();
            orderDAO.saveOrder(order);

            // Clear cart after successful order
            session.removeAttribute("cart");
        }

        // Redirect to a success page or home with a success message
        // For simplicity, redirecting to home with a flag
        request.setAttribute("orderSuccess", true);
        request.getRequestDispatcher("view/client/checkout-success.jsp").forward(request, response);
    }
}

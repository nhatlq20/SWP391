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
import dao.CartDAO;

@WebServlet(name = "CheckoutController", urlPatterns = { "/checkout", "/checkout-success" })
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/checkout-success".equals(path)) {
            request.getRequestDispatcher("view/client/checkout-success.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
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
            Integer customerId = (Integer) session.getAttribute("customerId");
            if (customerId != null) {
                order.setCustomerId(customerId);
            } else {
                order.setCustomerId(1); // Default/Guest for now
            }
            order.setOrderDate(new java.util.Date());
            order.setShippingName(fullName);
            order.setShippingPhone(phone);
            order.setShippingAddress(address);

            order.setStatus("Đang chờ");
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
            System.out.println("CheckoutController: Attempting to save order for CustomerID: " + order.getCustomerId());
            dao.OrderDAO orderDAO = new dao.OrderDAO();
            boolean isSaved = orderDAO.saveOrder(order);
            System.out.println("CheckoutController: Save result = " + isSaved);

            if (isSaved) {
                // Clear cart after successful order from session and DB
                session.removeAttribute("cart");
                if (customerId != null) {
                    CartDAO cartDAO_checkout = new CartDAO();
                    cartDAO_checkout.clearCart(customerId);
                }
                // Redirect to success page to prevent double submission
                response.sendRedirect(request.getContextPath() + "/checkout-success");
            } else {
                // If saving failed, stay on checkout page and show error
                request.setAttribute("error",
                        "Lỗi: Không thể lưu đơn hàng vào hệ thống. Vui lòng kiểm tra lại thông tin!");
                // Re-populate attributes for the checkout page
                request.setAttribute("cart", cart);
                request.setAttribute("totalMoney", cart.getTotalMoney());
                request.getRequestDispatcher("view/client/checkout.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("cart");
        }
    }
}

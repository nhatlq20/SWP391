package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Cart;

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
        String note = request.getParameter("note");

        // Here you would typically validate input and save the order to database
        // For now, we will just simulate a successful order

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            // Process order with cart items...
            // checkoutService.processOrder(cart, fullName, phone, address, note);

            // Clear cart after successful order
            session.removeAttribute("cart");
        }

        // Redirect to a success page or home with a success message
        // For simplicity, redirecting to home with a flag
        request.setAttribute("orderSuccess", true);
        request.getRequestDispatcher("view/client/checkout_success.jsp").forward(request, response);
    }
}

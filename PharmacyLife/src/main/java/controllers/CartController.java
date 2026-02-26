package controllers;

import dao.MedicineDAO;
import dao.CartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Cart;

import models.Medicine;

public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Block Admin and Staff from accessing Cart
        String role = (String) session.getAttribute("roleName");
        if (role != null && (role.equalsIgnoreCase("Admin") || role.equalsIgnoreCase("Staff"))) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            // Load cart from database if user is logged in
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                CartDAO cartDAO = new CartDAO();
                cart = cartDAO.getCartByCustomerId(userId);
            } else {
                cart = new Cart();
            }
            session.setAttribute("cart", cart);
        }

        // Remove hardcoded data

        // Calculate total amount
        double totalMoney = cart.getTotalMoney();
        request.setAttribute("totalMoney", totalMoney);
        request.setAttribute("cart", cart);

        // Forward to the JSP page
        request.getRequestDispatcher("view/client/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Block Admin and Staff from accessing Cart
        String role = (String) session.getAttribute("roleName");
        if (role != null && (role.equalsIgnoreCase("Admin") || role.equalsIgnoreCase("Staff"))) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        MedicineDAO medicineDAO = new MedicineDAO();

        CartDAO cartDAO = new CartDAO();
        int userId = (int) session.getAttribute("userId");

        try {
            if ("add".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = 1;
                try {
                    String quantityParam = request.getParameter("quantity");
                    if (quantityParam != null && !quantityParam.isEmpty()) {
                        quantity = Integer.parseInt(quantityParam);
                    }
                } catch (NumberFormatException e) {
                }

                Medicine medicine = medicineDAO.getMedicineById(id);
                if (medicine != null) {
                    Cart.Item item = new Cart.Item(medicine, quantity, medicine.getSellingPrice());
                    cart.addItem(item);
                    // Sync with DB
                    cartDAO.saveCartItem(userId, id, cart.getQuantityById(id));
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cart.updateQuantity(id, quantity);
                // Sync with DB
                cartDAO.saveCartItem(userId, id, quantity);
            } else if ("remove".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(id);
                // Sync with DB
                cartDAO.removeCartItem(userId, id);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        session.setAttribute("cart", cart);

        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            double cartTotal = (cart != null) ? cart.getTotalMoney() : 0;
            double itemTotal = 0;
            int cartCount = 0;

            if (cart != null) {
                if ("update".equals(action) || "add".equals(action)) {
                    try {
                        int id = Integer.parseInt(request.getParameter("id"));
                        models.Cart.Item item = cart.getItemById(id);
                        if (item != null)
                            itemTotal = item.getTotalPrice();
                    } catch (Exception e) {
                    }
                }
                if (cart.getItems() != null) {
                    for (models.Cart.Item item : cart.getItems()) {
                        cartCount += item.getQuantity();
                    }
                }
            }

            String json = String.format(
                    "{\"success\": true, \"cartTotal\": %.0f, \"itemTotal\": %.0f, \"cartCount\": %d}",
                    cartTotal, itemTotal, cartCount);
            out.print(json);
            out.flush();
        } else {
            response.sendRedirect("cart");
        }
    }

    @Override
    public String getServletInfo() {
        return "Cart Controller";
    }
}

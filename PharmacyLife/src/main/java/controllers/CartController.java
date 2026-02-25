package controllers;

import dao.MedicineDAO;
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

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
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

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        MedicineDAO medicineDAO = new MedicineDAO();

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
                    // Default to 1
                }

                Medicine medicine = medicineDAO.getMedicineById(id);
                if (medicine != null) {
                    Cart.Item item = new Cart.Item(medicine, quantity, medicine.getSellingPrice());
                    cart.addItem(item);
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cart.updateQuantity(id, quantity);
            } else if ("remove".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(id);
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
            int count = 0;
            if (cart != null && cart.getItems() != null) {
                for (models.Cart.Item item : cart.getItems()) {
                    count += item.getQuantity();
                }
            }
            out.print("{\"success\": true, \"cartCount\": " + count + "}");
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

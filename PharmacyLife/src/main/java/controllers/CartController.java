package controllers;

import dao.MedicineDAO;
import java.io.IOException;
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
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // --- HARDCODED DATA FOR TESTING ---
        if (cart.getItems().isEmpty()) {
            Medicine m1 = new Medicine(1, "MED001", "Paracetamol 500mg", 5000, "/assets/img/thuoc-giam-dau/gd3.png",
                    "Thuoc giam dau ha so");
            Medicine m2 = new Medicine(2, "MED002", "Vitamin C 1000mg", 1000, "assets/img/thuoc-bo-vitamin/vitc.png",
                    "Tang cuong suc de kháng");

            cart.addItem(new Cart.Item(m1, 2, m1.getSellingPrice()));
            cart.addItem(new Cart.Item(m2, 1, m2.getSellingPrice()));

        }
        // ----------------------------------

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
        response.sendRedirect("cart"); // Redirect to avoid resubmission on refresh
    }

    @Override
    public String getServletInfo() {
        return "Cart Controller";
    }
}

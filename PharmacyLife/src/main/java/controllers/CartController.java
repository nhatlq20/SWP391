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
import models.MedicineUnit;
import dao.MedicineUnitDAO;

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

        // Check if coming from checkout request explicitly or just viewing
        String mode = request.getParameter("mode");
        if ("checkout".equals(mode) && cart != null && !cart.getItems().isEmpty()) {
            for (models.Cart.Item item : cart.getItems()) {
                int requestedQty = item.getQuantity() * item.getConversionRate();
                if (item.getMedicine().getRemainingQuantity() < requestedQty) {
                    String msg = item.getMedicine().getMedicineName() + " (đơn vị: " + item.getUnitName()
                            + ") hiện không đủ hàng.";
                    if (item.getMedicine().getRemainingQuantity() <= 0) {
                        msg = item.getMedicine().getMedicineName() + " đã hết hàng.";
                    }
                    request.setAttribute("error", msg);
                    break;
                }
            }
            if (request.getAttribute("error") == null) {
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
        }

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
        MedicineUnitDAO unitDAO = new MedicineUnitDAO();
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
                    int unitId = 0;
                    double unitPrice = medicine.getSellingPrice();
                    String unitName = medicine.getUnit();
                    int convRate = 1;
                    if (medicine.getBaseUnit() != null) {
                        convRate = medicine.getBaseUnit().getConversionRate();
                    }

                    try {
                        String uIdParam = request.getParameter("unitId");
                        if (uIdParam != null && !uIdParam.isEmpty()) {
                            unitId = Integer.parseInt(uIdParam);
                            MedicineUnit mu = unitDAO.getUnitById(unitId);
                            if (mu != null) {
                                unitPrice = mu.getSellingPrice();
                                unitName = mu.getUnitName();
                                convRate = mu.getConversionRate();
                            }
                        } else if (medicine.getBaseUnit() != null) {
                            unitId = medicine.getBaseUnit().getUnitId();
                            unitPrice = medicine.getBaseUnit().getSellingPrice();
                            unitName = medicine.getBaseUnit().getUnitName();
                            convRate = medicine.getBaseUnit().getConversionRate();
                        }
                    } catch (NumberFormatException e) {
                    }

                    Cart.Item item = new Cart.Item(medicine, unitId, unitName, convRate, quantity, unitPrice);
                    cart.addItem(item);
                    // Sync with DB
                    cartDAO.saveCartItem(userId, id, unitId, cart.getQuantity(id, unitId));
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int unitId = 0;
                try {
                    String uIdParam = request.getParameter("unitId");
                    if (uIdParam != null && !uIdParam.isEmpty()) {
                        unitId = Integer.parseInt(uIdParam);
                    } else {
                        // This might be ambiguous if not passed from frontend
                        Cart.Item item = cart.getItemById(id);
                        if (item != null)
                            unitId = item.getUnitId();
                    }
                } catch (NumberFormatException e) {
                }
                cart.updateQuantity(id, unitId, quantity);
                // Sync with DB
                cartDAO.saveCartItem(userId, id, unitId, quantity);
            } else if ("remove".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int unitId = 0;
                try {
                    String uIdParam = request.getParameter("unitId");
                    if (uIdParam != null && !uIdParam.isEmpty()) {
                        unitId = Integer.parseInt(uIdParam);
                    }
                } catch (NumberFormatException e) {
                }
                cart.removeItem(id, unitId);
                // Sync with DB
                cartDAO.removeCartItem(userId, id, unitId);
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
                        int unitId = 0;
                        try {
                            String uIdParam = request.getParameter("unitId");
                            if (uIdParam != null && !uIdParam.isEmpty()) {
                                unitId = Integer.parseInt(uIdParam);
                            }
                        } catch (NumberFormatException e) {
                        }

                        models.Cart.Item item = cart.getItem(id, unitId);
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

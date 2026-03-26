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
            String selected = request.getParameter("selected");
            java.util.List<models.Cart.Item> itemsToCheck = cart.getItems();

            if (selected != null && !selected.isEmpty()) {
                itemsToCheck = new java.util.ArrayList<>();
                String[] parts = selected.split(",");
                for (String part : parts) {
                    try {
                        int muid = Integer.parseInt(part);
                        models.Cart.Item item = cart.getItem(muid);
                        if (item != null) {
                            itemsToCheck.add(item);
                        }
                    } catch (NumberFormatException e) {
                        // Support legacy format mid-uid if necessary, but prefer muid
                        if (part.contains("-")) {
                            String[] ids = part.split("-");
                            if (ids.length == 2) {
                                // Since we moved to muid, we might need a way to look up muid from mid/uid if it's still being sent this way
                                // But ideally we change the JSP to send just muid.
                            }
                        }
                    }
                }
            }

            // Step 1: Group items by medicineId and sum total consumption (in base units)
            java.util.Map<Integer, java.util.List<models.Cart.Item>> itemsByMed = new java.util.LinkedHashMap<>();
            java.util.Map<Integer, Integer> totalConsumptionByMed = new java.util.LinkedHashMap<>();
            for (models.Cart.Item item : itemsToCheck) {
                int medId = item.getMedicine().getMedicineId();
                int convRate = item.getConversionRate() > 0 ? item.getConversionRate() : 1;
                itemsByMed.computeIfAbsent(medId, k -> new java.util.ArrayList<>()).add(item);
                totalConsumptionByMed.merge(medId, item.getQuantity() * convRate, Integer::sum);
            }

            // Step 2: Check total consumption vs stock for each medicine
            java.util.List<String> errors = new java.util.ArrayList<>();
            for (java.util.Map.Entry<Integer, java.util.List<models.Cart.Item>> entry : itemsByMed.entrySet()) {
                int medId = entry.getKey();
                java.util.List<models.Cart.Item> medItems = entry.getValue();
                models.Cart.Item firstItem = medItems.get(0);
                int remainingBase = firstItem.getMedicine().getRemainingQuantity();
                int totalNeeded = totalConsumptionByMed.get(medId);
                String medicineName = firstItem.getMedicine().getMedicineName();

                if (totalNeeded > remainingBase) {
                    if (remainingBase <= 0) {
                        // Completely out of stock
                        String unitName = firstItem.getUnitName() != null ? firstItem.getUnitName() : "đơn vị";
                        errors.add("Thuốc '" + medicineName + "' (đơn vị: " + unitName + ") đã hết hàng.");
                    } else if (medItems.size() == 1) {
                        // Only one unit type ordered — simple per-unit message
                        models.Cart.Item item = medItems.get(0);
                        int convRate = item.getConversionRate() > 0 ? item.getConversionRate() : 1;
                        String unitName = item.getUnitName() != null ? item.getUnitName() : "đơn vị";
                        int remainingInUnit = remainingBase / convRate;
                        errors.add("Thuốc '" + medicineName + "' (đơn vị: " + unitName
                                + ") hiện không đủ hàng, hiện còn " + remainingInUnit + " " + unitName + ".");
                    } else {
                        // Multiple unit types of same medicine — aggregate error
                        // Build "8 Hộp + 28 Vỉ + 280 Viên" ordered string
                        // Build "8 Hộp hoặc 28 Vỉ hoặc 280 Viên" remaining string
                        StringBuilder orderedSb = new StringBuilder();
                        StringBuilder remainingSb = new StringBuilder();
                        for (int i = 0; i < medItems.size(); i++) {
                            models.Cart.Item item = medItems.get(i);
                            int convRate = item.getConversionRate() > 0 ? item.getConversionRate() : 1;
                            String unitName = item.getUnitName() != null ? item.getUnitName() : "đơn vị";
                            int remainingInUnit = remainingBase / convRate;
                            if (i > 0) { orderedSb.append(" + "); remainingSb.append(" hoặc "); }
                            orderedSb.append(item.getQuantity()).append(" ").append(unitName);
                            remainingSb.append(remainingInUnit).append(" ").append(unitName);
                        }
                        errors.add("Thuốc '" + medicineName + "' không đủ hàng — bạn đang đặt "
                                + orderedSb + " vượt quá tồn kho (hiện còn: " + remainingSb + ").");
                    }
                }
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errorList", errors);
                request.setAttribute("error", "Vui lòng điều chỉnh giỏ hàng vì một số sản phẩm không đủ hàng.");
            } else {
                String dest = request.getContextPath() + "/checkout";
                if (selected != null && !selected.isEmpty()) {
                    dest += "?selected=" + selected;
                }
                response.sendRedirect(dest);
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
                    int muid = 0;
                    double unitPrice = medicine.getSellingPrice();
                    String unitName = medicine.getUnit();
                    int convRate = 1;
                    if (medicine.getBaseUnit() != null) {
                        convRate = medicine.getBaseUnit().getConversionRate();
                    }

                    try {
                        String muidParam = request.getParameter("muid");
                        if (muidParam != null && !muidParam.isEmpty()) {
                            muid = Integer.parseInt(muidParam);
                            MedicineUnit mu = unitDAO.getUnitById(muid);
                            if (mu != null) {
                                unitPrice = mu.getSellingPrice();
                                unitName = mu.getUnitName();
                                convRate = mu.getConversionRate();
                            }
                        } else if (medicine.getBaseUnit() != null) {
                            muid = medicine.getBaseUnit().getMedicineUnitId();
                            unitPrice = medicine.getBaseUnit().getSellingPrice();
                            unitName = medicine.getBaseUnit().getUnitName();
                            convRate = medicine.getBaseUnit().getConversionRate();
                        }
                    } catch (NumberFormatException e) {
                    }

                    Cart.Item item = new Cart.Item(medicine, muid, unitName, convRate, quantity, unitPrice);
                    cart.addItem(item);
                    // Sync with DB
                    cartDAO.saveCartItem(userId, muid, quantity);
                }
            } else if ("update".equals(action)) {
                int muid = Integer.parseInt(request.getParameter("muid"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cart.updateQuantity(muid, quantity);
                // Sync with DB
                cartDAO.saveCartItem(userId, muid, quantity);
            } else if ("remove".equals(action)) {
                int muid = Integer.parseInt(request.getParameter("muid"));
                cart.removeItem(muid);
                // Sync with DB
                cartDAO.removeCartItem(userId, muid);
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
            double itemPrice = 0;
            int cartCount = 0;

            if (cart != null) {
                if ("update".equals(action) || "add".equals(action)) {
                    try {
                        int muid = Integer.parseInt(request.getParameter("muid"));
                        
                        // Debug: print current cart items
                        System.out.println("Updating Cart: MedicineUnitID=" + muid);
                        
                        models.Cart.Item item = cart.getItem(muid);
                        if (item != null) {
                            itemTotal = item.getTotalPrice();
                            itemPrice = item.getPrice();
                        }
                    } catch (Exception e) {
                    }
                }
                cartTotal = cart.getTotalMoney();
                cartCount = cart.getItemCount();
            }

            out.print("{\"success\":true,\"itemPrice\":" + itemPrice + ",\"itemTotal\":" + itemTotal + ",\"cartTotal\":" + cartTotal + ",\"cartCount\":" + cartCount + "}");
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

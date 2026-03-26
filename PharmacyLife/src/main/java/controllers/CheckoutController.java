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
import models.Voucher;
import dao.CartDAO;
import dao.VoucherDAO;

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

        String selected = request.getParameter("muids");
        if (selected == null || selected.isEmpty()) {
            selected = request.getParameter("selectedItems");
        }
        if (selected == null || selected.isEmpty()) {
            selected = (String) session.getAttribute("checkoutItems");
            // Don't clear yet, we might need it for re-renders or post
        }
        if (selected != null) {
            selected = selected.trim();
            try {
                selected = java.net.URLDecoder.decode(selected, "UTF-8");
            } catch (Exception e) {
                // keep as-is
            }
            selected = selected.trim();
        }
        
        java.util.List<models.Cart.Item> itemsToCheckout = new java.util.ArrayList<>();
        double totalMoney = 0;

        if (selected != null && !selected.isEmpty()) {
            String[] parts = selected.split(",");
            for (String part : parts) {
                try {
                    int muid = Integer.parseInt(part.trim());
                    models.Cart.Item item = cart.getItem(muid);
                    if (item != null) {
                        itemsToCheckout.add(item);
                        totalMoney += item.getTotalPrice();
                    }
                } catch (NumberFormatException e) {
                }
            }
        } else {
            itemsToCheckout = cart.getItems();
            totalMoney = cart.getTotalMoney();
        }

        request.setAttribute("itemsToCheckout", itemsToCheckout);
        request.setAttribute("totalMoney", totalMoney);
        request.setAttribute("selectedItems", selected);

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

            order.setStatus("Pending");
            
            String selected = request.getParameter("selectedItems");
            java.util.List<models.Cart.Item> itemsToProcess = new java.util.ArrayList<>(cart.getItems());
            double subTotal = cart.getTotalMoney();

            if (selected == null || selected.trim().isEmpty()) {
                // If hidden input lost (e.g., user refresh or redirect),
                // fallback to the server-side stored selection.
                selected = (String) session.getAttribute("checkoutItems");
            }

            if (selected != null) {
                selected = selected.trim();
                try {
                    selected = java.net.URLDecoder.decode(selected, "UTF-8");
                } catch (Exception e) {
                    // keep as-is
                }
                selected = selected.trim();
            }

            if (selected != null && !selected.isEmpty()) {
                itemsToProcess = new java.util.ArrayList<>();
                subTotal = 0;
                String[] parts = selected.split(",");
                for (String part : parts) {
                    try {
                        int muid = Integer.parseInt(part.trim());
                        models.Cart.Item item = cart.getItem(muid);
                        if (item != null) {
                            itemsToProcess.add(item);
                            subTotal += item.getTotalPrice();
                        }
                    } catch (NumberFormatException e) {
                        // ignore invalid muid fragment
                    }
                }
            }

            // Handle Voucher
            int appliedVoucherId = 0;
            double discountAmount = 0;
            try {
                String vIdParam = request.getParameter("appliedVoucherId");
                if (vIdParam != null && !vIdParam.equals("0")) {
                    appliedVoucherId = Integer.parseInt(vIdParam);
                    VoucherDAO vDAO = new VoucherDAO();
                    Voucher v = vDAO.getVoucherById(appliedVoucherId);
                    if (v != null && v.isActive()) {
                        // Re-calculate discount for security using subtotal of selected items
                        double tempTotal = subTotal;
                        if ("Percent".equalsIgnoreCase(v.getDiscountType())) {
                            discountAmount = tempTotal * (v.getDiscountValue() / 100);
                            if (v.getMaxDiscountAmount() != null && discountAmount > v.getMaxDiscountAmount()) {
                                discountAmount = v.getMaxDiscountAmount();
                            }
                        } else {
                            discountAmount = v.getDiscountValue();
                        }
                        order.setVoucherId(appliedVoucherId);
                        order.setDiscountAmount(discountAmount);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            order.setTotalAmount(subTotal - discountAmount);

            // Convert Processed Items to Order Items
            java.util.List<models.OrderItem> orderItems = new java.util.ArrayList<>();
            for (models.Cart.Item cartItem : itemsToProcess) {
                models.OrderItem orderItem = new models.OrderItem();
                orderItem.setMedicineUnitId(cartItem.getMedicineUnitId());
                orderItem.setUnitName(cartItem.getUnitName());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setUnitPrice(cartItem.getPrice());
                orderItem.setMedicine(cartItem.getMedicine());
                orderItems.add(orderItem);
            }
            order.setItems(orderItems);

            // Save order to database
            System.out.println("CheckoutController: Attempting to save order for CustomerID: " + order.getCustomerId());
            dao.OrderDAO orderDAO = new dao.OrderDAO();
            boolean isSaved = orderDAO.saveOrder(order);
            System.out.println("CheckoutController: Save result = " + isSaved);

            if (isSaved) {
                // Remove only selected items from cart
                CartDAO cartDAO_checkout = new CartDAO();
                if (selected == null || selected.isEmpty() || itemsToProcess.size() == cart.getItems().size()) {
                    // Optimized: Clear whole cart if all items were processed
                    cart.getItems().clear();
                    if (customerId != null) {
                        cartDAO_checkout.clearCart(customerId);
                    }
                } else {
                    for (models.Cart.Item processedItem : itemsToProcess) {
                        cart.removeItem(processedItem.getMedicineUnitId());
                        if (customerId != null) {
                            cartDAO_checkout.removeCartItem(customerId, processedItem.getMedicineUnitId());
                        }
                    }
                }

                // If cart is empty now, remove from session
                if (cart.getItems().isEmpty()) {
                    session.removeAttribute("cart");
                } else {
                    session.setAttribute("cart", cart);
                }
                // Increment voucher usage
                try {
                    if (order.getVoucherId() > 0) {
                        VoucherDAO vDAO = new VoucherDAO();
                        vDAO.incrementUsedQuantity(order.getVoucherId());
                    }
                } catch (Exception e) {
                    System.err.println("CheckoutController: Failed to update voucher usage (table might be missing): "
                            + e.getMessage());
                }
                // Redirect to success page to prevent double submission
                response.sendRedirect(request.getContextPath() + "/checkout-success");
            } else {
                String dbError = orderDAO.getLastErrorMessage();
                request.setAttribute("error", (dbError != null && !dbError.isEmpty()) ? dbError
                        : "Lỗi: Không thể lưu đơn hàng vào hệ thống. Vui lòng kiểm tra lại thông tin!");
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

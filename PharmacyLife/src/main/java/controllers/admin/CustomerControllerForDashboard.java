package controllers.admin;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Customer;

@WebServlet(name = "CustomerControllerForDashboard", urlPatterns = { "/admin/customers-dashboard",
        "/admin/customer-detail-dashboard" })
public class CustomerControllerForDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
//
//        if ("/admin/customers-dashboard".equals(path)) {
//            showCustomerList(request, response);
//        } else if ("/admin/customer-detail-dashboard".equals(path)) {
//            showCustomerDetail(request, response);
//        }
//    }
//
//    private void showCustomerList(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // List<Customer> customers = customerDAO.getAllCustomers();
//        List<Customer> customers = getMockCustomers();
//        request.setAttribute("customers", customers);
//        request.getRequestDispatcher("/view/admin/customer-list-for-dashboard.jsp").forward(request, response);
//    }
//
//    private void showCustomerDetail(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String idParam = request.getParameter("id");
//        if (idParam != null) {
//            try {
//                int customerId = Integer.parseInt(idParam);
//                // Customer customer = customerDAO.getCustomerById(customerId);
//                Customer customer = getMockCustomers().stream()
//                        .filter(c -> c.getCustomerId() == customerId)
//                        .findFirst()
//                        .orElse(null);
//
//                if (customer != null) {
//                    request.setAttribute("customer", customer);
//                    request.getRequestDispatcher("/view/admin/customer-detail-for-dashboard.jsp").forward(request,
//                            response);
//                    return;
//                }
//            } catch (NumberFormatException e) {
//                // Invalid ID
//            }
//        }

        // Redirect back to list if not found
        response.sendRedirect(request.getContextPath() + "/admin/customers-dashboard");
    }

    private List<Customer> getMockCustomers() {
        List<Customer> list = new java.util.ArrayList<>();
        // list.add(new Customer(1, "CUS001", "Nguyễn Văn A", "nguyenvana@example.com",
        // "0901234567",
        // "123 Lê Lợi, Quận 1, TP.HCM",
        // "Active", new java.util.Date()));
        // list.add(new Customer(2, "CUS002", "Trần Thị B", "tranthib@example.com",
        // "0987654321",
        // "456 Nguyễn Huệ, Quận 1, TP.HCM",
        // "Inactive", new java.util.Date()));
        // list.add(new Customer(3, "CUS003", "Lê Văn C", "levanc@example.com",
        // "0912345678",
        // "789 Võ Văn Kiệt, Quận 5, TP.HCM",
        // "Banned", new java.util.Date()));
        // list.add(new Customer(4, "CUS004", "Phạm Thị D", "phamthid@example.com",
        // "0933445566",
        // "321 Hai Bà Trưng, Quận 3, TP.HCM",
        // "Active", new java.util.Date()));
        // list.add(new Customer(5, "CUS005", "Hoàng Văn E", "hoangvane@example.com",
        // "0977889900",
        // "654 Điện Biên Phủ, Bình Thạnh, TP.HCM", "Active", new java.util.Date()));
        return list;
    }
}

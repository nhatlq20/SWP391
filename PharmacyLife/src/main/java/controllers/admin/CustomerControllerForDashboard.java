package controllers.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CustomerDAO;
import models.Customer;

@WebServlet(name = "CustomerControllerForDashboard", urlPatterns = { "/admin/customers-dashboard",
        "/admin/customer-detail-dashboard" })
public class CustomerControllerForDashboard extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/customers-dashboard".equals(path)) {
            showCustomerList(request, response);
        } else if ("/admin/customer-detail-dashboard".equals(path)) {
            showCustomerDetail(request, response);
        } else {
            // Redirect back to list if path not recognized
            response.sendRedirect(request.getContextPath() + "/admin/customers-dashboard");
        }
    }

    private void showCustomerList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/view/admin/customer-list-for-dashboard.jsp").forward(request, response);
    }

    private void showCustomerDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int customerId = Integer.parseInt(idParam);
                Customer customer = customerDAO.getCustomerById(customerId);

                if (customer != null) {
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("/view/admin/customer-detail-for-dashboard.jsp").forward(request,
                            response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }

        // Redirect back to list if not found
        response.sendRedirect(request.getContextPath() + "/admin/customers-dashboard");
    }
}

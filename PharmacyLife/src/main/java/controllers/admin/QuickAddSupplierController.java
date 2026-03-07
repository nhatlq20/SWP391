package controllers.admin;

import com.google.gson.JsonObject;
import dao.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.Supplier;

@WebServlet(name = "QuickAddSupplierController", urlPatterns = { "/admin/suppliers/quick-add" })
public class QuickAddSupplierController extends HttpServlet {

    private SupplierDAO supplierDAO;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
    }

    private boolean checkAdminPermission(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String roleName = (session != null) ? (String) session.getAttribute("roleName") : null;
        return roleName != null && roleName.equalsIgnoreCase("admin");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        if (!checkAdminPermission(request)) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Permission denied");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        String name = request.getParameter("supplierName");
        String address = request.getParameter("supplierAddress");
        String contact = request.getParameter("contactInfo");

        if (name == null || name.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Tên nhà cung cấp không được để trống");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        Supplier s = new Supplier();
        s.setSupplierName(name.trim());
        s.setSupplierAddress(address != null ? address.trim() : "");
        s.setContactInfo(contact != null ? contact.trim() : "");

        int generatedId = supplierDAO.insertSupplier(s);
        if (generatedId > 0) {
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("id", generatedId);
            jsonResponse.addProperty("name", s.getSupplierName());
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Không thể thêm nhà cung cấp vào database");
        }

        response.getWriter().write(jsonResponse.toString());
    }
}

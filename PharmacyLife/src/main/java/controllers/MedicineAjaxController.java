package controllers;

import dao.ImportDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller to fetch Medicine details (like price) via AJAX.
 */
public class MedicineAjaxController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // This controller returns JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        ImportDAO importDAO = new ImportDAO();
        PrintWriter out = response.getWriter();

        try {
            if ("getPrice".equals(action)) {
                String medicineCode = request.getParameter("code");
                // We need a method to get price by code.
                // Since ImportDAO has connection to Medicine table, let's reuse/extend it or
                // access MedicineDAO.
                // Ideally, use MedicineDAO. But for now, we'll check ImportDAO or add a helper
                // there if needed.
                // Assuming we add getMedicinePriceByCode to ImportDAO or use existing
                // facilities.

                // Let's create a quick helper DTO or use a Map
                double price = importDAO.getMedicinePriceByCode(medicineCode);

                // Return simple JSON: {"price": 5000}
                String json = "{\"price\": " + price + "}";
                out.print(json);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}

package controllers;

import java.io.IOException;
import java.io.PrintWriter;

import dao.ImportDAO;
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
                String code = request.getParameter("code");
                String id = request.getParameter("id");
                double price = 0;

                if (code != null && !code.isEmpty()) {
                    // Fetch by medicine code
                    price = importDAO.getMedicinePriceByCode(code);
                } else if (id != null && !id.isEmpty()) {
                    // Fetch by medicine ID
                    try {
                        int medicineId = Integer.parseInt(id);
                        price = importDAO.getMedicinePriceById(medicineId);
                    } catch (NumberFormatException e) {
                        out.print("{\"error\": \"Invalid medicine ID\"}");
                        out.flush();
                        return;
                    }
                }

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

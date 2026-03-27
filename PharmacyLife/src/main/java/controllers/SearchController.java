package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Medicine;

/* Controller for handling medicine search and category filtering requests. */
public class SearchController extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO(); // Data access for medicine operations

    /* Handles HTTP GET requests for searching medicines by keyword or category. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        List<Medicine> medicines = new ArrayList<>();

        // Prioritize category filtering if categoryId is provided
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int cid = Integer.parseInt(categoryIdStr);
                medicines = medicineDAO.getMedicinesByCategory(cid);
                request.setAttribute("selectedCategoryId", cid);
            } catch (NumberFormatException e) {
                // Ignore invalid category IDs
            }
        }
        // Fallback to keyword search if provided
        else if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            medicines = medicineDAO.searchMedicines(keyword);
        }

        request.setAttribute("medicines", medicines);
        request.setAttribute("keyword", keyword);
        request.setAttribute("resultCount", medicines.size());

        request.getRequestDispatcher("/view/client/search-result.jsp").forward(request, response);
    }

    /* Redirects POST requests to doGet for consistent search handling. */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /* Provides information about the servlet. */
    @Override
    public String getServletInfo() {
        return "Search medicine controller";
    }
}

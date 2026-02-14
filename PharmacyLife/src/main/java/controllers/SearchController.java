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

public class SearchController extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String keyword = request.getParameter("keyword");
        List<Medicine> medicines = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            medicines = medicineDAO.searchMedicines(keyword);
        }

        request.setAttribute("medicines", medicines);
        request.setAttribute("keyword", keyword);
        request.setAttribute("resultCount", medicines.size());

        request.getRequestDispatcher("/view/client/search-result.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Search medicine controller";
    }
}

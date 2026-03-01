package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CategoryDAO;
import dao.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Category;
import models.Medicine;

public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        MedicineDAO medicineDAO = new MedicineDAO();

        // Load all categories with item count
        List<Category> listCategory = categoryDAO.getAllCategories();
        java.util.Map<Integer, Integer> counts = categoryDAO.countAllMedicinesByCategory();
        for (Category c : listCategory) {
            c.setMedicineCount(counts.getOrDefault(c.getCategoryId(), 0));
        }
        request.setAttribute("listCategory", listCategory);

        // Load best sellers
        List<Medicine> bestSellers = medicineDAO.getBestSellers(5);
        request.setAttribute("bestSellers", bestSellers);

        // Load all medicines
        List<Medicine> allMedicines = medicineDAO.getAllMedicines();
        final List<Medicine> medicines = (allMedicines == null) ? new ArrayList<>() : allMedicines;
        request.setAttribute("allMedicines", medicines);

        request.getRequestDispatcher("/view/client/home.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home page controller";
    }
}

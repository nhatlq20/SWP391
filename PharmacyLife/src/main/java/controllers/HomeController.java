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

        // Load all categories
        List<Category> listCategory = categoryDAO.getAllCategories();
        System.out.println("Total categories loaded: " + listCategory.size());

        request.setAttribute("listCategory", listCategory);

        // Load all medicines
        List<Medicine> allMedicines = medicineDAO.getAllMedicines();
        final List<Medicine> medicines = (allMedicines == null) ? new ArrayList<>() : allMedicines;
        System.out.println("Total medicines loaded: " + medicines.size());

        request.setAttribute("allMedicines", medicines);

        // Load best sellers (top 5)
        List<Medicine> bestSellers = medicineDAO.getBestSellers(5);
        request.setAttribute("bestSellers", bestSellers);

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

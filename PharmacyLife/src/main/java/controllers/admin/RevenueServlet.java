package controllers.admin;

import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Map;

import dao.RevenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RevenueServlet", urlPatterns = {"/admin/revenue"})
public class RevenueServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        Date fromDate = null;
        Date toDate = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (fromDateStr != null && toDateStr != null) {
                fromDate = new Date(sdf.parse(fromDateStr).getTime());
                toDate = new Date(sdf.parse(toDateStr).getTime());
            }
        } catch (Exception e) {
            // fallback: null means all time
        }
        RevenueDAO dao = new RevenueDAO();
        try {
            int totalOrders = dao.getTotalOrders(fromDate, toDate);
            double totalRevenue = dao.getTotalRevenue(fromDate, toDate);
            double totalDebt = dao.getTotalDebt(fromDate, toDate);
            double aov = dao.getAverageOrderValue(fromDate, toDate);
            Map<String, Integer> statusStats = dao.getOrderStatusStatistics(fromDate, toDate);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalDebt", totalDebt);
            request.setAttribute("aov", aov);
            request.setAttribute("statusStats", statusStats);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/view/admin/revenue.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

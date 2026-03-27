package controllers.admin;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RevenueServlet", urlPatterns = { "/admin/revenue" })
public class RevenueServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                fromDate = Date.valueOf(fromDateStr);
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                toDate = Date.valueOf(toDateStr);
            }
        } catch (Exception e) {
        }

        dao.RevenueDAO revenueDAO = new dao.RevenueDAO();
        try {
            Date sqlCurrentStart, sqlCurrentEnd, sqlPrevStart = null, sqlPrevEnd = null;

            if (fromDate != null || toDate != null) {
                sqlCurrentStart = fromDate;
                sqlCurrentEnd = toDate;

                if (fromDate != null && toDate != null) {
                    java.time.LocalDate currentStartLD = fromDate.toLocalDate();
                    java.time.LocalDate currentEndLD = toDate.toLocalDate();
                    long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(currentStartLD, currentEndLD) + 1;

                    sqlPrevStart = Date.valueOf(currentStartLD.minusDays(daysBetween));
                    sqlPrevEnd = Date.valueOf(currentStartLD.minusDays(1));
                }
            } else {
                java.time.LocalDate now = java.time.LocalDate.now();
                java.time.LocalDate currentMonthStart = now.withDayOfMonth(1);
                java.time.LocalDate previousMonthStart = currentMonthStart.minusMonths(1);
                java.time.LocalDate previousMonthEnd = currentMonthStart.minusDays(1);

                sqlCurrentStart = Date.valueOf(currentMonthStart);
                sqlCurrentEnd = Date.valueOf(now);
                sqlPrevStart = Date.valueOf(previousMonthStart);
                sqlPrevEnd = Date.valueOf(previousMonthEnd);
                
                // Set these for the individual stats calls too
                fromDate = sqlCurrentStart;
                toDate = sqlCurrentEnd;
            }

            // Main stats for the chosen range (or default this month)
            int displayOrders = revenueDAO.getTotalOrders(fromDate, toDate);
            double displayRev = revenueDAO.getTotalRevenue(fromDate, toDate);
            double displayRecv = revenueDAO.getActualReceived(fromDate, toDate);
            double displayDebt = revenueDAO.getTotalDebt(fromDate, toDate);
            java.util.Map<String, Integer> statusStats = revenueDAO.getOrderStatusStatistics(fromDate, toDate);

            // Growth calculation only if we have a previous period
            if (sqlPrevStart != null && sqlPrevEnd != null) {
                int prevOrders = revenueDAO.getTotalOrders(sqlPrevStart, sqlPrevEnd);
                double prevRev = revenueDAO.getTotalRevenue(sqlPrevStart, sqlPrevEnd);
                request.setAttribute("orderGrowth", calculateGrowth(displayOrders, prevOrders));
                request.setAttribute("revenueGrowth", calculateGrowth(displayRev, prevRev));
            } else {
                request.setAttribute("orderGrowth", 0.0);
                request.setAttribute("revenueGrowth", 0.0);
            }

            double receivedRatio = (displayRev > 0) ? (displayRecv / displayRev) * 100.0 : 0.0;
            double debtRatio = (displayRev > 0) ? (displayDebt / displayRev) * 100.0 : 0.0;

            request.setAttribute("receivedRatio", receivedRatio);
            request.setAttribute("debtRatio", debtRatio);

            request.setAttribute("totalOrders", displayOrders);
            request.setAttribute("totalRevenue", displayRev);
            request.setAttribute("actualReceived", displayRecv);
            request.setAttribute("receivable", displayDebt);
            request.setAttribute("statusStats", statusStats);

            request.setAttribute("topProducts", revenueDAO.getTopSellingProducts(fromDate, toDate, 5));
            request.setAttribute("topCustomers", revenueDAO.getTopCustomers(fromDate, toDate, 5));
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/view/admin/revenue.jsp").forward(request, response);
    }

    private double calculateGrowth(double current, double previous) {
        if (previous == 0) {
            return current > 0 ? 100.0 : 0.0;
        }
        return ((current - previous) / previous) * 100.0;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

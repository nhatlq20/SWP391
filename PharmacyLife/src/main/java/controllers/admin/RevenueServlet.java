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
            if (fromDateStr != null && !fromDateStr.trim().isEmpty() &&
                    toDateStr != null && !toDateStr.trim().isEmpty()) {
                fromDate = Date.valueOf(fromDateStr);
                toDate = Date.valueOf(toDateStr);
            }
        } catch (Exception e) {
            // fallback: null means all time
        }

        dao.RevenueDAO revenueDAO = new dao.RevenueDAO();
        try {
            Date sqlCurrentStart, sqlCurrentEnd, sqlPrevStart, sqlPrevEnd;

            if (fromDate != null && toDate != null) {
                // If filtered: compare selected period with previous period of SAME length
                sqlCurrentStart = fromDate;
                sqlCurrentEnd = toDate;

                java.time.LocalDate currentStartLD = fromDate.toLocalDate();
                java.time.LocalDate currentEndLD = toDate.toLocalDate();
                long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(currentStartLD, currentEndLD) + 1;

                sqlPrevStart = Date.valueOf(currentStartLD.minusDays(daysBetween));
                sqlPrevEnd = Date.valueOf(currentStartLD.minusDays(1));
            } else {
                // If NOT filtered: compare current month up to today with previous full month
                java.time.LocalDate now = java.time.LocalDate.now();
                java.time.LocalDate currentMonthStart = now.withDayOfMonth(1);
                java.time.LocalDate previousMonthStart = currentMonthStart.minusMonths(1);
                java.time.LocalDate previousMonthEnd = currentMonthStart.minusDays(1);

                sqlCurrentStart = Date.valueOf(currentMonthStart);
                sqlCurrentEnd = Date.valueOf(now);
                sqlPrevStart = Date.valueOf(previousMonthStart);
                sqlPrevEnd = Date.valueOf(previousMonthEnd);
            }

            // Fetch metrics for data display or comparison
            int displayOrders = revenueDAO.getTotalOrders(fromDate, toDate);
            double displayRev = revenueDAO.getTotalRevenue(fromDate, toDate);
            double displayRecv = revenueDAO.getActualReceived(fromDate, toDate);
            double displayDebt = revenueDAO.getTotalDebt(fromDate, toDate);
            java.util.Map<String, Integer> statusStats = revenueDAO.getOrderStatusStatistics(fromDate, toDate);

            // Fetch current period metrics (matching growth context)
            int currentOrders = revenueDAO.getTotalOrders(sqlCurrentStart, sqlCurrentEnd);
            double currentRev = revenueDAO.getTotalRevenue(sqlCurrentStart, sqlCurrentEnd);

            // Fetch previous period metrics
            int prevOrders = revenueDAO.getTotalOrders(sqlPrevStart, sqlPrevEnd);
            double prevRev = revenueDAO.getTotalRevenue(sqlPrevStart, sqlPrevEnd);

            // Calculate Growth % for Orders & Revenue
            request.setAttribute("orderGrowth", calculateGrowth(currentOrders, prevOrders));
            request.setAttribute("revenueGrowth", calculateGrowth(currentRev, prevRev));

            // Calculate Ratios for Received & Debt relative to displayed revenue
            double receivedRatio = (displayRev > 0) ? (displayRecv / displayRev) * 100.0 : 0.0;
            double debtRatio = (displayRev > 0) ? (displayDebt / displayRev) * 100.0 : 0.0;

            request.setAttribute("receivedRatio", receivedRatio);
            request.setAttribute("debtRatio", debtRatio);

            request.setAttribute("totalOrders", displayOrders);
            request.setAttribute("totalRevenue", displayRev);
            request.setAttribute("actualReceived", displayRecv);
            request.setAttribute("receivable", displayDebt);
            request.setAttribute("statusStats", statusStats);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/view/admin/revenue.jsp").forward(request, response);
    }

    private double calculateGrowth(double current, double previous) {
        if (previous == 0) {
            // If baseline is 0, percentage reflects the current volume (e.g. 1 order =
            // 100%, 2 = 200%)
            // This is more dynamic than a hardcoded 100%.
            return current * 100.0;
        }
        return ((current - previous) / previous) * 100.0;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

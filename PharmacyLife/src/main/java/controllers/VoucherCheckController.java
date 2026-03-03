package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.VoucherDAO;
import models.Voucher;

@WebServlet(name = "VoucherCheckController", urlPatterns = { "/check-voucher" })
public class VoucherCheckController extends HttpServlet {

    private VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String code = request.getParameter("code");
        double orderTotal = Double.parseDouble(request.getParameter("total"));

        if (code == null || code.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Mã không hợp lệ\"}");
            return;
        }

        Voucher v = voucherDAO.getVoucherByCode(code.trim());
        Date now = new Date();

        if (v == null) {
            out.print("{\"success\": false, \"message\": \"Mã giảm giá không tồn tại hoặc đã hết hạn\"}");
        } else if (!v.isActive()) {
            out.print("{\"success\": false, \"message\": \"Mã giảm giá này hiện không khả dụng\"}");
        } else if (v.getStartDate().after(now)) {
            out.print("{\"success\": false, \"message\": \"Mã giảm giá này chưa đến thời gian sử dụng\"}");
        } else if (v.getEndDate().before(now)) {
            out.print("{\"success\": false, \"message\": \"Mã giảm giá này đã hết hạn\"}");
        } else if (v.getUsedQuantity() >= v.getQuantity()) {
            out.print("{\"success\": false, \"message\": \"Mã giảm giá này đã hết lượt sử dụng\"}");
        } else if (orderTotal < v.getMinOrderValue()) {
            out.print("{\"success\": false, \"message\": \"Đơn hàng tối thiểu để sử dụng mã này là "
                    + String.format("%,.0f", v.getMinOrderValue()) + "đ\"}");
        } else {
            double discount = 0;
            if ("Percent".equalsIgnoreCase(v.getDiscountType())) {
                discount = orderTotal * (v.getDiscountValue() / 100);
                if (v.getMaxDiscountAmount() != null && discount > v.getMaxDiscountAmount()) {
                    discount = v.getMaxDiscountAmount();
                }
            } else {
                discount = v.getDiscountValue();
            }

            out.print("{\"success\": true, \"discount\": " + discount + ", \"voucherId\": " + v.getVoucherId()
                    + ", \"message\": \"Áp dụng mã thành công!\"}");
        }
        out.flush();
    }
}

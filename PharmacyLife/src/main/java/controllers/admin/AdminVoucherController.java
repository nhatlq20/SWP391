package controllers.admin;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.VoucherDAO;
import models.Voucher;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminVoucherController", urlPatterns = {
        "/admin/vouchers",
        "/admin/voucher-add",
        "/admin/voucher-edit",
        "/admin/voucher-delete",
        "/admin/voucher-toggle"
})
public class AdminVoucherController extends HttpServlet {

    private VoucherDAO voucherDAO = new VoucherDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String roleName = (String) session.getAttribute("roleName");
        return "Admin".equalsIgnoreCase(roleName);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String path = request.getServletPath();

        switch (path) {
            case "/admin/vouchers":
                listVouchers(request, response);
                break;
            case "/admin/voucher-add":
                request.getRequestDispatcher("/view/admin/voucher-add.jsp").forward(request, response);
                break;
            case "/admin/voucher-edit":
                showEditForm(request, response);
                break;
            case "/admin/voucher-delete":
                deleteVoucher(request, response);
                break;
            case "/admin/voucher-toggle":
                toggleVoucher(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String path = request.getServletPath();

        if ("/admin/voucher-add".equals(path)) {
            addVoucher(request, response);
        } else if ("/admin/voucher-edit".equals(path)) {
            editVoucher(request, response);
        }
    }

    private void listVouchers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/view/admin/voucher-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Voucher v = voucherDAO.getVoucherById(id);
        request.setAttribute("voucher", v);
        request.getRequestDispatcher("/view/admin/voucher-edit.jsp").forward(request, response);
    }

    private void addVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Voucher v = new Voucher();
            v.setVoucherCode(request.getParameter("voucherCode"));
            v.setDescription(request.getParameter("description"));
            v.setDiscountType(request.getParameter("discountType"));
            v.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
            v.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue")));

            String maxAmtStr = request.getParameter("maxDiscountAmount");
            if (maxAmtStr != null && !maxAmtStr.isEmpty()) {
                v.setMaxDiscountAmount(Double.parseDouble(maxAmtStr));
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            v.setStartDate(sdf.parse(request.getParameter("startDate")));
            v.setEndDate(sdf.parse(request.getParameter("endDate")));
            v.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            v.setActive(request.getParameter("isActive") != null);

            if (voucherDAO.addVoucher(v)) {
                response.sendRedirect("vouchers?success=added");
            } else {
                request.setAttribute("error", "Không thể thêm voucher. Vui lòng kiểm tra mã có bị trùng không.");
                request.getRequestDispatcher("/view/admin/voucher-add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            request.getRequestDispatcher("/view/admin/voucher-add.jsp").forward(request, response);
        }
    }

    private void editVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("voucherId"));
            Voucher v = voucherDAO.getVoucherById(id);
            v.setDescription(request.getParameter("description"));
            v.setDiscountType(request.getParameter("discountType"));
            v.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
            v.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue")));

            String maxAmtStr = request.getParameter("maxDiscountAmount");
            if (maxAmtStr != null && !maxAmtStr.isEmpty()) {
                v.setMaxDiscountAmount(Double.parseDouble(maxAmtStr));
            } else {
                v.setMaxDiscountAmount(null);
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            v.setStartDate(sdf.parse(request.getParameter("startDate")));
            v.setEndDate(sdf.parse(request.getParameter("endDate")));
            v.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            v.setActive(request.getParameter("isActive") != null);

            if (voucherDAO.updateVoucher(v)) {
                response.sendRedirect("vouchers?success=updated");
            } else {
                request.setAttribute("voucher", v);
                request.setAttribute("error", "Không thể cập nhật voucher.");
                request.getRequestDispatcher("/view/admin/voucher-edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("vouchers?error=invalid");
        }
    }

    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (voucherDAO.deleteVoucher(id)) {
            response.sendRedirect("vouchers?success=deleted");
        } else {
            response.sendRedirect("vouchers?error=delete_failed");
        }
    }

    private void toggleVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Voucher v = voucherDAO.getVoucherById(id);
        if (v != null) {
            v.setActive(!v.isActive());
            voucherDAO.updateVoucher(v);
        }
        response.sendRedirect("vouchers");
    }
}

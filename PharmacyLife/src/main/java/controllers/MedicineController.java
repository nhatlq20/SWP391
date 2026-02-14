package controllers;

import java.io.IOException;
import java.util.List;

import dao.CategoryDAO;
import dao.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Medicine;

public class MedicineController extends HttpServlet {

    private MedicineDAO medicineDAO = new MedicineDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập encoding UTF-8 ngay từ đầu để đảm bảo xử lý đúng tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            request.setAttribute("pageTitle", "Thêm Thuốc");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("content", "/view/admin/medicine-add.jsp");
            request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);
            return;
        }

        if ("create".equalsIgnoreCase(action) && "POST".equalsIgnoreCase(request.getMethod())) {
            createMedicineFromRequest(request, response);
            return;
        }

        if ("edit".equalsIgnoreCase(action)) {
            String id = request.getParameter("id");
            Medicine med = id != null ? medicineDAO.getMedicineById(id) : null;
            if (med == null) {
                response.sendRedirect(request.getContextPath() + "/medicine");
                return;
            }
            request.setAttribute("medicine", med);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("pageTitle", "Cập nhật thuốc");
            request.setAttribute("content", "/view/admin/medicine-edit.jsp");
            request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);
            return;
        }

        if ("update".equalsIgnoreCase(action) && "POST".equalsIgnoreCase(request.getMethod())) {
            updateMedicineFromRequest(request, response);
            return;
        }

        // Get all medicines for display
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        request.setAttribute("medicines", medicines);

        request.setAttribute("pageTitle", "Quản lí thuốc");
        request.setAttribute("content", "/view/admin/medicine-content.jsp");
        request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);

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

    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    // Helper to create medicine from form
    private void createMedicineFromRequest(jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response)
            throws java.io.IOException, jakarta.servlet.ServletException {
        try {
            String medicineID = request.getParameter("medicineID"); // Code
            String medicineName = request.getParameter("medicineName");
            String sellingPriceStr = request.getParameter("sellingPrice");
            String unit = request.getParameter("unit");
            String categoryID = request.getParameter("categoryID");
            String remainingQuantityStr = request.getParameter("remainingQuantity");
            String imageUrl = request.getParameter("imageUrl");
            String shortDescription = request.getParameter("shortDescription");
            String packDescription = request.getParameter("packDescription");

            models.Medicine m = new models.Medicine();
            m.setMedicineCode(medicineID); // Set Code
            m.setMedicineName(medicineName);
            if (sellingPriceStr != null && !sellingPriceStr.isEmpty()) {
                m.setSellingPrice(Double.parseDouble(sellingPriceStr));
            }
            m.setUnit(unit);

            if (categoryID != null && !categoryID.isEmpty()) {
                try {
                    m.setCategoryId(Integer.parseInt(categoryID));
                } catch (NumberFormatException e) {
                    // Log or ignore
                }
            }

            int qty = 0;
            try {
                qty = Integer.parseInt(remainingQuantityStr);
            } catch (Exception ignored) {
            }
            m.setRemainingQuantity(qty);
            m.setImageUrl(imageUrl);
            m.setShortDescription(shortDescription);
            m.setPackDescription(packDescription);

            boolean ok = medicineDAO.createMedicine(m);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/medicine");
            } else {
                request.setAttribute("errorMessage", "Không thể thêm thuốc. Vui lòng thử lại.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("pageTitle", "Thêm Thuốc");
                request.setAttribute("content", "/view/admin/medicine-add.jsp");
                request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("pageTitle", "Thêm Thuốc");
            request.setAttribute("content", "/view/admin/medicine-add.jsp");
            request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);
        }
    }

    // Helper to update medicine from form
    private void updateMedicineFromRequest(jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response)
            throws java.io.IOException, jakarta.servlet.ServletException {
        try {
            String medicineID = request.getParameter("medicineID"); // This is the Code
            String medicineName = request.getParameter("medicineName");
            String sellingPriceStr = request.getParameter("sellingPrice");
            String unit = request.getParameter("unit");
            String categoryID = request.getParameter("categoryID");
            String remainingQuantityStr = request.getParameter("remainingQuantity");
            String imageUrl = request.getParameter("imageUrl");
            String shortDescription = request.getParameter("shortDescription");
            String packDescription = request.getParameter("packDescription");

            // Look up existing medicine to get the PK
            Medicine existing = medicineDAO.getMedicineById(medicineID);
            // Note: getMedicineById handles String by calling getMedicineByCode if not int

            if (existing == null) {
                request.setAttribute("errorMessage", "Không thể tìm thấy thuốc để cập nhật.");
                response.sendRedirect(request.getContextPath() + "/medicine");
                return;
            }

            Medicine m = new Medicine();
            m.setMedicineId(existing.getMedicineId()); // Set PK
            m.setMedicineCode(medicineID);
            m.setMedicineName(medicineName);
            if (sellingPriceStr != null && !sellingPriceStr.isEmpty()) {
                m.setSellingPrice(Double.parseDouble(sellingPriceStr));
            }
            m.setUnit(unit);

            if (categoryID != null && !categoryID.isEmpty()) {
                try {
                    m.setCategoryId(Integer.parseInt(categoryID));
                } catch (NumberFormatException e) {
                    // Log or ignore
                }
            }

            int qty = 0;
            try {
                qty = Integer.parseInt(remainingQuantityStr);
            } catch (Exception ignored) {
            }
            m.setRemainingQuantity(qty);
            m.setImageUrl(imageUrl);
            m.setShortDescription(shortDescription);
            m.setPackDescription(packDescription);

            boolean ok = medicineDAO.updateMedicine(m);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/medicine");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thuốc.");
                request.setAttribute("medicine", m);
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("pageTitle", "Cập nhật thuốc");
                request.setAttribute("content", "/view/admin/medicine-edit.jsp");
                request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            String id = request.getParameter("medicineID");
            request.setAttribute("medicine", medicineDAO.getMedicineById(id));
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("pageTitle", "Cập nhật thuốc");
            request.setAttribute("content", "/view/admin/medicine-edit.jsp");
            request.getRequestDispatcher("/view/common/sidebar.jsp").forward(request, response);
        }
    }
}

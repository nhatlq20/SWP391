package controllers;

import dao.CategoryDAO;
import models.Category;
import models.Medicine;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// kkk
public class CategoryController extends HttpServlet {

	private static final int ADMIN_ROLE_ID = 1;
	private CategoryDAO dao;

	@Override
	public void init() throws ServletException {
		dao = new CategoryDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null) {
			action = "list";
		}

		switch (action) {
			case "search":
				searchCategory(request, response);
				break;
			case "detail":
				viewDetail(request, response);
				break;
			case "delete":
				deleteCategory(request, response);
				break;
			case "show":
				showInsertForm(request, response);
				break;
			case "list":
			default:
				listCategory(request, response);
				break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null)
			action = "list";

		switch (action) {
			case "insert":
				insertCategory(request, response);
				break;
			default:
				doGet(request, response); // fallback cho các action khác
				break;
		}
	}

	// =============================
	// 17.1 - List Category
	// =============================
	private void listCategory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Category> list = dao.getAllCategories();
		request.setAttribute("categoryList", list);

		request.getRequestDispatcher("/view/admin/category-list.jsp")
				.forward(request, response);
	}

	// =============================
	// 17.2 - View Category Detail
	// =============================
	private void viewDetail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int id = Integer.parseInt(request.getParameter("id"));

		Category category = dao.getCategoryById(id);
		List<Medicine> medicine = dao.getMedicineByCategory(id);

		if (medicine == null) {
			response.sendRedirect("category?action=list");
			return;
		}

		request.setAttribute("medicineList", medicine);
		request.setAttribute("category", category);

		request.getRequestDispatcher("/view/admin/category-detail.jsp")
				.forward(request, response);
	}

	// =============================
	// 17.3 - Delete Category (chỉ ADMIN)
	// =============================
	private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!isAdmin(request)) {
			response.sendRedirect("category?action=list");
			return;
		}

		int id = Integer.parseInt(request.getParameter("id"));
		dao.deleteCategory(id);

		response.sendRedirect("category?action=list");
	}

	private void showInsertForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!isAdmin(request)) {
			response.sendRedirect("category?action=list");
			return;
		}
		request.setAttribute("nextCategoryCode", dao.generateNextCategoryCode());
		request.getRequestDispatcher("/view/admin/category-create.jsp").forward(request, response);
	}

	private void insertCategory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!isAdmin(request)) {
			response.sendRedirect("category?action=list");
			return;
		}
		String name = request.getParameter("categoryName");

		if (name == null || name.trim().isEmpty()) {
			request.setAttribute("errorMessage", "Tên danh mục không được để trống");
			request.setAttribute("nextCategoryCode", dao.generateNextCategoryCode());
			request.getRequestDispatcher("/view/admin/category-create.jsp").forward(request, response);
			return;
		}

		String code = dao.generateNextCategoryCode();

		Category c = new Category();
		c.setCategoryCode(code);
		c.setCategoryName(name.trim());

		dao.createCategory(c);

		response.sendRedirect("category?action=list");

	}

	private void searchCategory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String keyword = request.getParameter("keyword");
		List<Category> list = dao.searchCategoryByName(keyword);
		request.setAttribute("categoryList", list);
		request.getRequestDispatcher("/view/admin/category-list.jsp")
				.forward(request, response);

	}

	private boolean isAdmin(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return false;
		}

		Object userType = session.getAttribute("userType");
		if (userType == null || !"staff".equalsIgnoreCase(String.valueOf(userType))) {
			return false;
		}

		Object roleNameObj = session.getAttribute("roleName");
		if (roleNameObj != null && "admin".equalsIgnoreCase(String.valueOf(roleNameObj).trim())) {
			return true;
		}

		Object roleIdObj = session.getAttribute("roleId");
		if (roleIdObj instanceof Integer) {
			return ((Integer) roleIdObj) == ADMIN_ROLE_ID;
		}
		if (roleIdObj instanceof String) {
			try {
				return Integer.parseInt((String) roleIdObj) == ADMIN_ROLE_ID;
			} catch (NumberFormatException ignored) {
				return false;
			}
		}

		return false;
	}
}

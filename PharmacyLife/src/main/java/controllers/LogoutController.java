package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LogoutController - Handles user logout
 * 
 * @author anltc
 */
public class LogoutController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Process logout
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get current session
        HttpSession session = request.getSession(false);

        // Invalidate session if exists
        if (session != null) {
            session.invalidate();
        }

        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login");
    }

    /**
     * Handles the HTTP <code>POST</code> method
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Logout Controller - Handles user logout";
    }
}

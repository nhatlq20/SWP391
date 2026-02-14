package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LogoutPageController - Display logout confirmation page
 * 
 * @author anltc
 */
public class LogoutPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        
        request.getRequestDispatcher("view/client/logout.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Logout Page Controller";
    }
}

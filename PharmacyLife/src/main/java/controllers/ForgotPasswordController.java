package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * ForgotPasswordController - Display forgot password page (UI only)
 * 
 * @author anltc
 */
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("view/client/forgot-password.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Controller";
    }
}

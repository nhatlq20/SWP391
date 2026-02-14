/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import DALs.ReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
//
/**
 *
 * @author PC
 */
public class deleteReviewController extends HttpServlet {



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      
        int reviewId= Integer.parseInt(request.getParameter("reviewId"));
        int medicineId= Integer.parseInt(request.getParameter("medicineId"));
        int customerId=1;
        ReviewDAO d= new ReviewDAO();
        d.deleteReviewByCustomer(reviewId, customerId,medicineId);
                
          response.sendRedirect("View_all_owner_reviews");
        
    }

 
}

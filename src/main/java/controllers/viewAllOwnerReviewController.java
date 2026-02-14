/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import DALs.ReviewDAO;
import Model.Review;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
//
/**
 *
 * @author PC
 */
public class viewAllOwnerReviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        
        int customerId=1;
        ReviewDAO dao= new ReviewDAO();
          
        List<Review> r= dao.getReviewByCustomer(customerId);
       System.out.println("Review size = " + r.size());
        request.setAttribute("reviews", r);
        request.getRequestDispatcher("views/View_all_owner_reviews.jsp").forward(request, response);
        
    
    }

}

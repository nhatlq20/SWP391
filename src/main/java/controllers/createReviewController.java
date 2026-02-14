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
import jakarta.servlet.http.HttpSession;
//
/**
 *
 * @author PC
 */
public class createReviewController extends HttpServlet {

 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    
     
   
int customerId = 2; 
    String medicineIdStr = request.getParameter("medicineId");
    String ratingStr = request.getParameter("rating");
    String comment = request.getParameter("comment");

       if (medicineIdStr == null || medicineIdStr.isEmpty()) {
        request.setAttribute("error", "Medicine not found");
        request.getRequestDispatcher("views/createReview.jsp").forward(request, response);
        return;
    }
 
    int medicineId = Integer.parseInt(medicineIdStr);
    int rating = Integer.parseInt(ratingStr);

    Review r = new Review();
    r.setCustomerId(customerId);
    r.setMedicineId(medicineId);
    r.setRating(rating);
    r.setComment(comment);

    ReviewDAO dao = new ReviewDAO();
    dao.insertReview(r);

    response.sendRedirect("ViewRiews?medicineId=" + medicineId);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.getRequestDispatcher("views/createReview.jsp").forward(request, response);
}

}

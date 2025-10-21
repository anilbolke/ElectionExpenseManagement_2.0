package com.election.servlet.admin;

import com.election.dao.SubscriptionDAO;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class UpdatePlanServlet extends HttpServlet {
    
    private SubscriptionDAO subscriptionDAO;
    
    @Override
    public void init() throws ServletException {
        subscriptionDAO = new SubscriptionDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Get parameters
            String planIdStr = request.getParameter("planId");
            String priceStr = request.getParameter("price");
            
            if (planIdStr == null || priceStr == null) {
                response.sendRedirect("manage-payments.jsp?error=Missing parameters");
                return;
            }
            
            int planId = Integer.parseInt(planIdStr);
            BigDecimal price = new BigDecimal(priceStr);
            
            // Validate price
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                response.sendRedirect("manage-payments.jsp?error=Price cannot be negative");
                return;
            }
            
            // Update the plan price
            boolean updated = subscriptionDAO.updatePlanPrice(planId, price);
            
            if (updated) {
                response.sendRedirect("manage-payments.jsp?success=Subscription plan price updated successfully");
            } else {
                response.sendRedirect("manage-payments.jsp?error=Failed to update plan price");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("manage-payments.jsp?error=Invalid number format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-payments.jsp?error=An error occurred: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("manage-payments.jsp");
    }
}

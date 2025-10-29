package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.dao.CandidateDAO;
import com.election.dao.PaymentDAO;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
public class AdminServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private CandidateDAO candidateDAO;
    private PaymentDAO paymentDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        candidateDAO = new CandidateDAO();
        paymentDAO = new PaymentDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("verifyPayment".equals(action)) {
            verifyPayment(request, response);
        } else if ("updateUserStatus".equals(action)) {
            updateUserStatus(request, response);
        }
    }
    
    private void verifyPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (!"admin".equals(userRole)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            int candidateId = Integer.parseInt(request.getParameter("candidateId"));
            boolean verified = Boolean.parseBoolean(request.getParameter("verified"));
            
            if (candidateDAO.verifyPayment(candidateId, verified)) {
                request.setAttribute("success", "Payment status updated successfully");
            } else {
                request.setAttribute("error", "Failed to update payment status");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid request: " + e.getMessage());
        }
        
        response.sendRedirect("admin/payments.jsp");
    }
    
    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        
        if (!"admin".equals(userRole)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            // Update user status logic would go here
            request.setAttribute("success", "User status updated successfully");
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid request: " + e.getMessage());
        }
        
        response.sendRedirect("admin/users.jsp");
    }
}

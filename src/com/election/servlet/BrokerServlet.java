package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.dao.PaymentDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class BrokerServlet extends HttpServlet {
    
    private CandidateDAO candidateDAO;
    private PaymentDAO paymentDAO;
    
    @Override
    public void init() throws ServletException {
        candidateDAO = new CandidateDAO();
        paymentDAO = new PaymentDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("verifyPayment".equals(action)) {
            verifyPayment(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        
        if (!"broker".equals(userRole)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        response.sendRedirect("broker/dashboard.jsp");
    }
    
    private void verifyPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer brokerId = (Integer) session.getAttribute("userId");
        
        if (!"broker".equals(userRole)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            int candidateId = Integer.parseInt(request.getParameter("candidateId"));
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            
            // Verify that this candidate belongs to this broker
            if (paymentDAO.verifyPayment(paymentId, brokerId)) {
                candidateDAO.verifyPayment(candidateId, true);
                request.setAttribute("success", "Payment verified successfully");
            } else {
                request.setAttribute("error", "Failed to verify payment");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid request: " + e.getMessage());
        }
        
        response.sendRedirect("broker/candidates.jsp");
    }
}

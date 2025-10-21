package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/validate-referral")
public class ValidateReferralServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String referralCode = request.getParameter("code");
        
        if (referralCode == null || referralCode.trim().isEmpty()) {
            out.print("{\"valid\": false, \"message\": \"Referral code is required\"}");
            return;
        }
        
        // Convert to uppercase for consistency
        referralCode = referralCode.toUpperCase().trim();
        
        // Validate format (6-20 alphanumeric characters)
        if (!referralCode.matches("[A-Z0-9]{6,20}")) {
            out.print("{\"valid\": false, \"message\": \"Invalid referral code format\"}");
            return;
        }
        
        try {
            // Get broker by referral code
            User broker = userDAO.getBrokerByReferralCode(referralCode);
            
            if (broker != null) {
                // Valid referral code - return broker name
                String jsonResponse = String.format(
                    "{\"valid\": true, \"brokerName\": \"%s\", \"brokerId\": %d}",
                    broker.getFullName().replace("\"", "\\\""),
                    broker.getUserId()
                );
                out.print(jsonResponse);
            } else {
                // Invalid referral code
                out.print("{\"valid\": false, \"message\": \"Referral code not found\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"valid\": false, \"message\": \"Error validating referral code\"}");
        }
    }
}

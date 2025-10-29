package com.election.servlet;

import com.election.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/check-referral-code")
public class CheckReferralCodeServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String referralCode = request.getParameter("code");
        
        if (referralCode == null || referralCode.trim().isEmpty()) {
            out.print("{\"exists\": false}");
            return;
        }
        
        // Convert to uppercase for consistency
        referralCode = referralCode.toUpperCase().trim();
        
        try {
            // Check if referral code exists
            boolean exists = userDAO.isReferralCodeExists(referralCode);
            
            String jsonResponse = String.format("{\"exists\": %s}", exists);
            out.print(jsonResponse);
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"exists\": false, \"error\": \"Error checking referral code\"}");
        }
    }
}

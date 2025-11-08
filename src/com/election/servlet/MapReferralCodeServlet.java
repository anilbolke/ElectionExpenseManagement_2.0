package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.SMSUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/map-referral-code")
public class MapReferralCodeServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"user".equals(user.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get referral code from request
        String referralCode = request.getParameter("referralCode");
        
        if (referralCode == null || referralCode.trim().isEmpty()) {
            response.sendRedirect("map-referral-code.jsp?referralError=" + 
                java.net.URLEncoder.encode("Referral code is required", "UTF-8"));
            return;
        }
        
        // Convert to uppercase for consistency
        referralCode = referralCode.toUpperCase().trim();
        
        // Validate format (6-20 alphanumeric characters)
        if (!referralCode.matches("[A-Z0-9]{6,20}")) {
            response.sendRedirect("map-referral-code.jsp?referralError=" + 
                java.net.URLEncoder.encode("Invalid referral code format", "UTF-8"));
            return;
        }
        
        try {
            // Get broker by referral code
            User broker = userDAO.getBrokerByReferralCode(referralCode);
            
            if (broker == null) {
                response.sendRedirect("map-referral-code.jsp?referralError=" + 
                    java.net.URLEncoder.encode("Referral code not found", "UTF-8"));
                return;
            }
            
            // Check if user already has a broker assigned
            if (user.getBrokerId() != null && user.getBrokerId() > 0) {
                response.sendRedirect("map-referral-code.jsp?referralError=" + 
                    java.net.URLEncoder.encode("You already have a referral code mapped", "UTF-8"));
                return;
            }
            
            // Map the referral code (assign broker to user)
            boolean success = userDAO.updateUserBroker(user.getUserId(), broker.getUserId());
            
            if (success) {
                // Update user object in session
                user.setBrokerId(broker.getUserId());
                session.setAttribute("user", user);
                
                // Send SMS notification to broker
                try {
                    if (broker.getMobile() != null && !broker.getMobile().isEmpty()) {
                        SMSUtil.sendReferralMappedSMS(broker.getMobile(), referralCode, user.getUsername());
                        System.out.println("SMS sent to broker " + broker.getUsername() + " for referral mapping");
                    }
                } catch (Exception e) {
                    System.err.println("Failed to send SMS to broker: " + e.getMessage());
                }
                
                response.sendRedirect("map-referral-code.jsp?referralSuccess=" + 
                    java.net.URLEncoder.encode("Referral code mapped successfully to broker: " + 
                    broker.getFullName(), "UTF-8"));
            } else {
                response.sendRedirect("map-referral-code.jsp?referralError=" + 
                    java.net.URLEncoder.encode("Failed to map referral code. Please try again.", "UTF-8"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("map-referral-code.jsp?referralError=" + 
                java.net.URLEncoder.encode("An error occurred while mapping referral code", "UTF-8"));
        }
    }
}

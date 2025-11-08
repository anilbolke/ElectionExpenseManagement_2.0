package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.SMSUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/forgot-password.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Directly handle forgot password - send existing password via SMS
        handleValidation(request, response);
    }
    
    private void handleValidation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        
        if (identifier == null || identifier.trim().isEmpty()) {
            request.setAttribute("error", "Please enter username, mobile number, or email ID.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        identifier = identifier.trim();
        
        // Find user by username, email, or mobile
        User user = userDAO.findUserByIdentifier(identifier);
        
        if (user == null) {
            request.setAttribute("error", "No account found with the provided information. Please check and try again.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Check if user has mobile number
        if (user.getMobile() == null || user.getMobile().trim().isEmpty()) {
            request.setAttribute("error", "Mobile number not registered for this account. Please contact admin.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Send existing password via SMS directly
        try {
            boolean smsSent = SMSUtil.sendForgotPasswordSMS(
                user.getMobile(), 
                user.getUsername(), 
                user.getPassword()
            );
            
            if (smsSent) {
                request.setAttribute("success", "Your password has been sent to your registered mobile number: " + 
                    maskMobile(user.getMobile()));
                System.out.println("Forgot password SMS sent to user: " + user.getUsername() + 
                    " (Mobile: " + user.getMobile() + ")");
            } else {
                request.setAttribute("error", "Failed to send SMS. Please try again or contact support.");
                System.err.println("Failed to send forgot password SMS to user: " + user.getUsername());
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while sending SMS. Please try again.");
            System.err.println("Exception while sending forgot password SMS: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
    
    /**
     * Mask mobile number for security (shows only last 4 digits)
     */
    private String maskMobile(String mobile) {
        if (mobile == null || mobile.length() < 4) {
            return "****";
        }
        int length = mobile.length();
        return "******" + mobile.substring(length - 4);
    }
}

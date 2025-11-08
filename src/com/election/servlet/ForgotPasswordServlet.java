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
        
        String action = request.getParameter("action");
        
        if ("validate".equals(action)) {
            handleValidation(request, response);
        } else if ("resetPassword".equals(action)) {
            handlePasswordReset(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/forgot-password.jsp");
        }
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
        
        // User found, show password reset form
        request.setAttribute("showPasswordForm", true);
        request.setAttribute("userId", user.getUserId());
        request.setAttribute("verifiedUsername", user.getUsername());
        request.setAttribute("verifiedIdentifier", identifier);
        
        // Store in session to preserve across form submissions
        request.getSession().setAttribute("resetIdentifier", identifier);
        request.getSession().setAttribute("resetUserId", user.getUserId());
        
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
    
    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Invalid request. Please start over.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "New password cannot be empty.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("userId", userIdStr);
            preserveUserInfo(request, userIdStr);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match. Please try again.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("userId", userIdStr);
            preserveUserInfo(request, userIdStr);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("userId", userIdStr);
            preserveUserInfo(request, userIdStr);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Update password
            boolean success = userDAO.updatePassword(userId, newPassword);
            
            if (success) {
                // Send SMS with new password
                try {
                    User user = userDAO.getUserById(userId);
                    if (user != null && user.getMobile() != null && !user.getMobile().isEmpty()) {
                        SMSUtil.sendForgotPasswordSMS(user.getMobile(), user.getUsername(), newPassword);
                        System.out.println("Password reset SMS sent to user: " + user.getUsername());
                    }
                } catch (Exception e) {
                    System.err.println("Failed to send password reset SMS: " + e.getMessage());
                }
                
                // Clear session data
                request.getSession().removeAttribute("resetIdentifier");
                request.getSession().removeAttribute("resetUserId");
                
                request.setAttribute("success", "Password reset successfully! You can now login with your new password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to reset password. Please try again.");
                request.setAttribute("showPasswordForm", true);
                request.setAttribute("userId", userIdStr);
                preserveUserInfo(request, userIdStr);
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid request. Please start over.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
    
    private void preserveUserInfo(HttpServletRequest request, String userIdStr) {
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.getUserById(userId);
            if (user != null) {
                request.setAttribute("verifiedUsername", user.getUsername());
                // Try to get the original identifier from the session or use username as fallback
                String identifier = (String) request.getSession().getAttribute("resetIdentifier");
                if (identifier == null) {
                    identifier = user.getUsername();
                }
                request.setAttribute("verifiedIdentifier", identifier);
            }
        } catch (NumberFormatException e) {
            // Ignore if userId is invalid
        }
    }
}

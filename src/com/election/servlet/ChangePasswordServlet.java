package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.model.Candidate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Check if user role is allowed to change password
        if (!"user".equals(user.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=" + 
                                java.net.URLEncoder.encode("Unauthorized access", "UTF-8"));
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                java.net.URLEncoder.encode("All fields are required", "UTF-8"));
            return;
        }
        
        // Check if current password matches
        if (!user.getPassword().equals(currentPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                java.net.URLEncoder.encode("Current password is incorrect", "UTF-8"));
            return;
        }
        
        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                java.net.URLEncoder.encode("New passwords do not match", "UTF-8"));
            return;
        }
        
        // Check password length
        if (newPassword.length() < 6) {
            response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                java.net.URLEncoder.encode("New password must be at least 6 characters long", "UTF-8"));
            return;
        }
        
        // Check if new password is different from current password
        if (currentPassword.equals(newPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                java.net.URLEncoder.encode("New password must be different from current password", "UTF-8"));
            return;
        }
        
        // Update password
        try {
            boolean updated = userDAO.changePassword(user.getUserId(), newPassword);
            
            if (updated) {
                // Log the password change
                System.out.println("Password changed successfully for user: " + user.getUsername());
                
                // Invalidate the session to logout the user
                session.invalidate();
                
                // Redirect to login page with success message
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=" + 
                                    java.net.URLEncoder.encode("Password changed successfully! Please login with your new password.", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                    java.net.URLEncoder.encode("Failed to change password. Please try again.", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/change-password.jsp?error=" + 
                                java.net.URLEncoder.encode("An error occurred. Please try again.", "UTF-8"));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/user/change-password.jsp");
    }
}

package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterBrokerServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User admin = (User) session.getAttribute("user");
        if (!"admin".equals(admin.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=" + 
                                java.net.URLEncoder.encode("Unauthorized access", "UTF-8"));
            return;
        }
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String mobileNumber = request.getParameter("mobileNumber");
        String emailId = request.getParameter("emailId");
        String username = request.getParameter("username");
        String referralCode = request.getParameter("referralCode");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (!ValidationUtil.isNotEmpty(firstName) || !ValidationUtil.isNotEmpty(lastName) ||
            !ValidationUtil.isNotEmpty(mobileNumber) || !ValidationUtil.isNotEmpty(emailId) ||
            !ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password) ||
            !ValidationUtil.isNotEmpty(referralCode)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("All required fields must be filled", "UTF-8"));
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Passwords do not match", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Password must be at least 6 characters long", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidEmail(emailId)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Invalid email format", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidMobile(mobileNumber)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Invalid mobile number", "UTF-8"));
            return;
        }
        
        // Validate referral code format (alphanumeric, 6-20 characters)
        if (!referralCode.matches("[A-Z0-9]{6,20}")) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Referral code must be 6-20 alphanumeric characters (A-Z, 0-9)", "UTF-8"));
            return;
        }
        
        // Check if username exists
        if (userDAO.isUsernameExists(username)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Username already taken", "UTF-8"));
            return;
        }
        
        // Check if email exists
        if (userDAO.isEmailExists(emailId)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Email already registered", "UTF-8"));
            return;
        }
        
        // Check if mobile exists
        if (userDAO.isMobileExists(mobileNumber)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Mobile number already registered", "UTF-8"));
            return;
        }
        
        // Check if referral code exists
        if (userDAO.isReferralCodeExists(referralCode)) {
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Referral code already exists. Please choose a unique code.", "UTF-8"));
            return;
        }
        
        // Create broker user
        User broker = new User();
        broker.setFirstName(firstName);
        broker.setLastName(lastName);
        broker.setMobile(mobileNumber);
        broker.setEmail(emailId);
        broker.setUsername(username);
        broker.setPassword(password);
        broker.setReferralCode(referralCode.toUpperCase());
        broker.setBrokerId(null);  // No broker assigned, this IS a broker
        broker.setRole("broker");
        broker.setStatus("active");
        
        if (userDAO.registerBroker(broker)) {
            System.out.println("SUCCESS: Broker registered by admin " + admin.getUsername() + 
                             " - Username: " + username + ", Referral Code: " + referralCode);
            response.sendRedirect("admin/register-broker.jsp?success=" + 
                                java.net.URLEncoder.encode("Broker registered successfully! Username: " + username + ", Referral Code: " + referralCode, "UTF-8"));
        } else {
            System.err.println("ERROR: Failed to register broker - Username: " + username);
            response.sendRedirect("admin/register-broker.jsp?error=" + 
                                java.net.URLEncoder.encode("Registration failed. Please try again.", "UTF-8"));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin/register-broker.jsp");
    }
}

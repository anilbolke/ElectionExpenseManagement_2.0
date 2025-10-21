package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String mobileNumber = request.getParameter("mobileNumber");
        String emailId = request.getParameter("emailId");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String referralCode = request.getParameter("referralCode"); // New field
        
        // Validation
        if (!ValidationUtil.isNotEmpty(firstName) || !ValidationUtil.isNotEmpty(lastName) ||
            !ValidationUtil.isNotEmpty(mobileNumber) || !ValidationUtil.isNotEmpty(emailId) ||
            !ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "All required fields must be filled");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidEmail(emailId)) {
            request.setAttribute("error", "Invalid email format");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidMobile(mobileNumber)) {
            request.setAttribute("error", "Invalid mobile number");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if username exists
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username already taken");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if email exists
        if (userDAO.isEmailExists(emailId)) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if mobile exists
        if (userDAO.isMobileExists(mobileNumber)) {
            request.setAttribute("error", "Mobile number already registered");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Handle referral code if provided
        Integer brokerId = null;
        if (referralCode != null && !referralCode.trim().isEmpty()) {
            referralCode = referralCode.toUpperCase().trim();
            
            // Validate referral code and get broker
            User broker = userDAO.getBrokerByReferralCode(referralCode);
            if (broker != null) {
                brokerId = broker.getUserId();
            } else {
                request.setAttribute("error", "Invalid referral code. Please check and try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }
        
        // Create user - role is 'broker' if no referral, 'user' if referred by a broker
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setMobile(mobileNumber);
        user.setEmail(emailId);
        user.setUsername(username);
        user.setPassword(password);
        user.setBrokerId(brokerId);  // Will be null if no referral code, or broker's ID if referred
        user.setRole(brokerId != null ? "user" : "broker");  // User if referred, Broker if not
        user.setStatus("active");
        
        if (userDAO.registerUser(user)) {
            String successMessage = "Registration successful! Please login.";
            if (brokerId != null) {
                User broker = userDAO.getUserById(brokerId);
                if (broker != null) {
                    successMessage = "Registration successful! You have been referred by " + 
                                   broker.getFullName() + ". Please login.";
                }
            }
            request.setAttribute("success", successMessage);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}

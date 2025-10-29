package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/broker/update-bank-details")
public class BrokerBankDetailsServlet extends HttpServlet {
    
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
        
        // Check if user is broker
        if (!"broker".equals(user.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/broker/dashboard.jsp?error=" + 
                                java.net.URLEncoder.encode("Unauthorized access", "UTF-8"));
            return;
        }
        
        // Get form parameters
        String bankName = request.getParameter("bankName");
        String accountNumber = request.getParameter("accountNumber");
        String confirmAccountNumber = request.getParameter("confirmAccountNumber");
        String ifscCode = request.getParameter("ifscCode");
        String branchName = request.getParameter("branchName");
        String panNumber = request.getParameter("panNumber");
        
        // Validation
        if (bankName == null || bankName.trim().isEmpty() ||
            accountNumber == null || accountNumber.trim().isEmpty() ||
            confirmAccountNumber == null || confirmAccountNumber.trim().isEmpty() ||
            ifscCode == null || ifscCode.trim().isEmpty() ||
            branchName == null || branchName.trim().isEmpty() ||
            panNumber == null || panNumber.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                java.net.URLEncoder.encode("All fields are required", "UTF-8"));
            return;
        }
        
        // Trim inputs
        bankName = bankName.trim();
        accountNumber = accountNumber.trim();
        confirmAccountNumber = confirmAccountNumber.trim();
        ifscCode = ifscCode.trim().toUpperCase();
        branchName = branchName.trim();
        panNumber = panNumber.trim().toUpperCase();
        
        // Check if account numbers match
        if (!accountNumber.equals(confirmAccountNumber)) {
            response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                java.net.URLEncoder.encode("Account numbers do not match", "UTF-8"));
            return;
        }
        
        // Validate account number (should be numeric and 9-18 digits)
        if (!accountNumber.matches("\\d{9,18}")) {
            response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                java.net.URLEncoder.encode("Invalid account number format (9-18 digits required)", "UTF-8"));
            return;
        }
        
        // Validate IFSC code (should be 11 characters: 4 letters, 0, 6 alphanumeric)
        if (!ifscCode.matches("[A-Z]{4}0[A-Z0-9]{6}")) {
            response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                java.net.URLEncoder.encode("Invalid IFSC code format (e.g., SBIN0001234)", "UTF-8"));
            return;
        }
        
        // Validate PAN number (10 characters: 5 letters, 4 digits, 1 letter)
        if (!panNumber.matches("[A-Z]{5}[0-9]{4}[A-Z]{1}")) {
            response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                java.net.URLEncoder.encode("Invalid PAN number format (e.g., ABCDE1234F)", "UTF-8"));
            return;
        }
        
        // Update bank details
        try {
            boolean updated = userDAO.updateBankDetails(user.getUserId(), bankName, accountNumber, 
                                                       ifscCode, branchName, panNumber);
            
            if (updated) {
                // Update session user object
                user.setBankName(bankName);
                user.setAccountNumber(accountNumber);
                user.setIfscCode(ifscCode);
                user.setBranchName(branchName);
                user.setPanNumber(panNumber);
                session.setAttribute("user", user);
                
                System.out.println("Bank details updated successfully for broker: " + user.getUsername());
                
                response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?success=" + 
                                    java.net.URLEncoder.encode("Bank details updated successfully!", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                    java.net.URLEncoder.encode("Failed to update bank details. Please try again.", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp?error=" + 
                                java.net.URLEncoder.encode("An error occurred. Please try again.", "UTF-8"));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/broker/bank-details.jsp");
    }
}

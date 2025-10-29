<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Expense Debug Page</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        .debug-box { background: white; padding: 20px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #007bff; }
        .error { border-left-color: #dc3545; background: #fff5f5; }
        .success { border-left-color: #28a745; background: #f0fff4; }
        h2 { margin-top: 0; color: #333; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 3px; overflow-x: auto; }
        .status { padding: 5px 10px; border-radius: 3px; display: inline-block; font-weight: bold; }
        .status.ok { background: #d4edda; color: #155724; }
        .status.fail { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <h1>🔍 Edit Expense Debug Information</h1>
    
    <%
        // Check session data
        User user = (User) session.getAttribute("user");
        Candidate candidate = (Candidate) session.getAttribute("candidate");
        String expenseIdParam = request.getParameter("expenseId");
    %>
    
    <div class="debug-box <%= user != null ? "success" : "error" %>">
        <h2>1. Session Check</h2>
        <p><strong>User Session:</strong> 
            <span class="status <%= user != null ? "ok" : "fail" %>">
                <%= user != null ? "✓ EXISTS" : "✗ NOT FOUND" %>
            </span>
        </p>
        <% if(user != null) { %>
            <pre>User ID: <%= user.getUserId() %>
Name: <%= user.getFullName() %>
Email: <%= user.getEmail() %></pre>
        <% } %>
        
        <p><strong>Candidate Session:</strong> 
            <span class="status <%= candidate != null ? "ok" : "fail" %>">
                <%= candidate != null ? "✓ EXISTS" : "✗ NOT FOUND" %>
            </span>
        </p>
        <% if(candidate != null) { %>
            <pre>Candidate ID: <%= candidate.getCandidateId() %>
Name: <%= candidate.getCandidateName() %>
Payment Verified: <%= candidate.isPaymentVerified() %>
Account Status: <%= candidate.getAccountStatus() %></pre>
        <% } %>
    </div>
    
    <div class="debug-box <%= expenseIdParam != null ? "success" : "error" %>">
        <h2>2. URL Parameter Check</h2>
        <p><strong>expenseId Parameter:</strong> 
            <span class="status <%= expenseIdParam != null ? "ok" : "fail" %>">
                <%= expenseIdParam != null ? expenseIdParam : "✗ MISSING" %>
            </span>
        </p>
        <% if(expenseIdParam != null) { %>
            <p>Parameter received successfully!</p>
        <% } else { %>
            <p style="color: red;">❌ No expenseId parameter in URL. Add ?expenseId=1 to URL to test.</p>
        <% } %>
    </div>
    
    <%
        Expense expense = null;
        boolean canLoad = false;
        String errorMsg = null;
        
        if(expenseIdParam != null && candidate != null) {
            try {
                int expenseId = Integer.parseInt(expenseIdParam);
                ExpenseDAO expenseDAO = new ExpenseDAO();
                expense = expenseDAO.getExpenseById(expenseId);
                canLoad = true;
            } catch(NumberFormatException e) {
                errorMsg = "Invalid expense ID format: " + e.getMessage();
            } catch(Exception e) {
                errorMsg = "Exception loading expense: " + e.getMessage();
                e.printStackTrace();
            }
        } else {
            if(expenseIdParam == null) errorMsg = "No expense ID parameter";
            if(candidate == null) errorMsg = "No candidate selected in session";
        }
    %>
    
    <div class="debug-box <%= expense != null ? "success" : "error" %>">
        <h2>3. Database Check</h2>
        <% if(canLoad) { %>
            <p><strong>Expense Found:</strong> 
                <span class="status <%= expense != null ? "ok" : "fail" %>">
                    <%= expense != null ? "✓ YES" : "✗ NO" %>
                </span>
            </p>
            <% if(expense != null) { %>
                <pre>Expense ID: <%= expense.getExpenseId() %>
Candidate ID: <%= expense.getCandidateId() %>
Category: <%= expense.getExpenseCategory() %>
Description: <%= expense.getExpenseDescription() %>
Amount: ₹<%= expense.getExpenseAmount() %>
Date: <%= expense.getExpenseDate() %>
Payment Mode: <%= expense.getPaymentMode() %>
Vendor: <%= expense.getVendorName() %>
Receipt: <%= expense.getReceiptNumber() %></pre>
                
                <% if(candidate != null) { %>
                    <p><strong>Authorization Check:</strong> 
                        <span class="status <%= expense.getCandidateId() == candidate.getCandidateId() ? "ok" : "fail" %>">
                            <%= expense.getCandidateId() == candidate.getCandidateId() ? "✓ AUTHORIZED" : "✗ UNAUTHORIZED" %>
                        </span>
                    </p>
                    <% if(expense.getCandidateId() != candidate.getCandidateId()) { %>
                        <p style="color: red;">⚠️ This expense belongs to candidate ID <%= expense.getCandidateId() %>, 
                        but you have selected candidate ID <%= candidate.getCandidateId() %></p>
                    <% } %>
                <% } %>
            <% } else { %>
                <p style="color: red;">❌ Expense with ID <%= expenseIdParam %> not found in database!</p>
            <% } %>
        <% } else { %>
            <p style="color: red;">❌ Cannot load expense: <%= errorMsg %></p>
        <% } %>
    </div>
    
    <div class="debug-box">
        <h2>4. Database Connection Test</h2>
        <%
            boolean dbConnected = false;
            try {
                ExpenseDAO testDAO = new ExpenseDAO();
                // Try to get any expense to test connection
                testDAO.getAllExpenses();
                dbConnected = true;
        %>
            <p><span class="status ok">✓ Database Connection OK</span></p>
        <%
            } catch(Exception e) {
                dbConnected = false;
        %>
            <p><span class="status fail">✗ Database Connection FAILED</span></p>
            <pre><%= e.getMessage() %></pre>
        <%
            }
        %>
    </div>
    
    <div class="debug-box">
        <h2>5. Action Buttons</h2>
        <% if(expense != null && candidate != null && expense.getCandidateId() == candidate.getCandidateId()) { %>
            <a href="edit-expense.jsp?expenseId=<%= expense.getExpenseId() %>" 
               style="display: inline-block; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 5px;">
                ✏️ Open Real Edit Page
            </a>
            <a href="expenses.jsp" 
               style="display: inline-block; padding: 10px 20px; background: #6c757d; color: white; text-decoration: none; border-radius: 5px; margin: 5px;">
                📋 Back to Expenses List
            </a>
        <% } else { %>
            <p style="color: #856404; background: #fff3cd; padding: 10px; border-radius: 3px;">
                ⚠️ Cannot open edit page. Fix the errors above first.
            </p>
            <a href="dashboard.jsp" 
               style="display: inline-block; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 5px;">
                🏠 Go to Dashboard
            </a>
        <% } %>
    </div>
    
    <div class="debug-box">
        <h2>6. Instructions</h2>
        <ol>
            <li>Make sure you're logged in and have selected a candidate</li>
            <li>Add <code>?expenseId=X</code> to this URL (replace X with real expense ID)</li>
            <li>Check all sections above - all should show green checkmarks</li>
            <li>If all OK, click "Open Real Edit Page" button</li>
            <li>If any failures, fix those issues first</li>
        </ol>
        <p><strong>Current URL:</strong></p>
        <pre><%= request.getRequestURL() + (request.getQueryString() != null ? "?" + request.getQueryString() : "") %></pre>
    </div>
</body>
</html>

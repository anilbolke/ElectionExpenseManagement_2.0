<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%
    User user = (User) session.getAttribute("user");
    Candidate candidate = (Candidate) session.getAttribute("candidate");
    if(user == null || candidate == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Required</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="dashboard">
        <div class="navbar">
            <div class="navbar-brand">Election Expense Management</div>
            <div>
                <span style="color: #000;">Welcome, <%= user.getFullName() %></span> |
                <a href="../logout">Logout</a>
            </div>
        </div>
        
        <div class="container">
            <div class="card" style="max-width: 600px; margin: 50px auto;">
                <h2 class="card-title">Complete Payment to Activate Your Account</h2>
                
                <div class="alert alert-info">
                    <strong>Important:</strong> To access all features of the Election Expense Management system, 
                    please complete the payment process.
                </div>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <div class="dashboard-card">
                    <h3 style="color: #000;">Subscription Details</h3>
                    <p style="color: #000;"><strong>Plan:</strong> Standard Election Management</p>
                    <p style="color: #000;"><strong>Amount:</strong> ₹5,000</p>
                    <p style="color: #000;"><strong>Features:</strong></p>
                    <ul style="color: #000;">
                        <li>Unlimited Expense Tracking</li>
                        <li>Daily Activity Logs</li>
                        <li>Fund Management</li>
                        <li>Download Reports</li>
                        <li>Real-time Dashboard</li>
                    </ul>
                </div>
                
                <form action="../payment" method="post">
                    <input type="hidden" name="action" value="submit">
                    <input type="hidden" name="amount" value="5000">
                    
                    <div class="form-group">
                        <label for="paymentMethod">Payment Method:</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                            <option value="">Select Payment Method</option>
                            <option value="UPI">UPI</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="Net Banking">Net Banking</option>
                            <option value="Cash">Cash</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="remarks">Remarks (Optional):</label>
                        <textarea id="remarks" name="remarks" class="form-control" rows="3"></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">Proceed to Pay ₹5,000</button>
                </form>
                
                <div class="text-center mt-3">
                    <p style="color: #000;">Payment will be verified by admin/broker within 24 hours</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

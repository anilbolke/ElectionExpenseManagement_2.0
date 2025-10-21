<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    String transactionId = (String) session.getAttribute("transactionId");
    Double paymentAmount = (Double) session.getAttribute("paymentAmount");
    String candidateName = (String) session.getAttribute("candidateName");
    
    if(user == null || transactionId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .success-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 0 20px;
        }
        
        .success-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            background: #28a745;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 48px;
            color: white;
        }
        
        .success-title {
            color: #28a745;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .success-message {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        .payment-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        
        .detail-value {
            color: #333;
            font-weight: 600;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-direction: column;
        }
        
        .checkmark-animation {
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            0% {
                transform: scale(0);
            }
            50% {
                transform: scale(1.2);
            }
            100% {
                transform: scale(1);
            }
        }
    </style>
</head>
<body class="dashboard">
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ Election Expense</div>
            <ul class="navbar-menu">
                <li><a href="manage-candidates.jsp">My Candidates</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="success-container">
        <div class="success-card">
            <div class="success-icon checkmark-animation">✓</div>
            <h1 class="success-title">Payment Successful!</h1>
            <p class="success-message">
                Your candidate registration payment has been completed successfully. 
                The candidate account is now active.
            </p>
            
            <div class="payment-details">
                <h4 style="margin-bottom: 15px; color: #333;">Payment Details</h4>
                <div class="detail-row">
                    <span class="detail-label">Candidate Name:</span>
                    <span class="detail-value"><%= candidateName %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Transaction ID:</span>
                    <span class="detail-value"><%= transactionId %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Amount Paid:</span>
                    <span class="detail-value" style="color: #28a745;">₹<%= String.format("%.2f", paymentAmount) %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="detail-value" style="color: #28a745;">✓ Verified</span>
                </div>
            </div>
            
            <div class="alert alert-info" style="text-align: left; margin-bottom: 25px;">
                <strong>📧 Confirmation Email:</strong> A payment confirmation has been sent to your registered email address.
            </div>
            
            <div class="action-buttons">
                <a href="manage-candidates.jsp" class="btn btn-primary">Go to My Candidates</a>
                <a href="add-candidate.jsp" class="btn btn-secondary">Add Another Candidate</a>
            </div>
        </div>
    </div>
</body>
</html>

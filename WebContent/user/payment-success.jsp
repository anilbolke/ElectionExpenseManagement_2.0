<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String transactionId = (String) session.getAttribute("transactionId");
    String successMessage = (String) session.getAttribute("success");
    
    if (transactionId == null) {
        transactionId = "N/A";
    }
    if (successMessage == null) {
        successMessage = "Payment completed successfully!";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Success - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .success-container {
            background: white;
            border-radius: 20px;
            padding: 50px 40px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
        }
        
        .success-icon {
            font-size: 5rem;
            margin-bottom: 20px;
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            from {
                transform: scale(0);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .success-title {
            color: #28a745;
            font-size: 2rem;
            margin-bottom: 15px;
            font-weight: 700;
        }
        
        .success-message {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .transaction-box {
            background: #f8f9ff;
            border: 2px solid #667eea;
            border-radius: 12px;
            padding: 25px;
            margin: 30px 0;
        }
        
        .transaction-label {
            color: #666;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }
        
        .transaction-id {
            color: #333;
            font-size: 1.3rem;
            font-weight: bold;
            font-family: monospace;
            word-break: break-all;
        }
        
        .info-box {
            background: #e8f5e9;
            border-radius: 12px;
            padding: 20px;
            margin: 25px 0;
            text-align: left;
        }
        
        .info-box h4 {
            color: #2e7d32;
            margin-top: 0;
            margin-bottom: 15px;
        }
        
        .info-box ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .info-box li {
            padding: 8px 0;
            color: #555;
            display: flex;
            align-items: flex-start;
        }
        
        .info-box li:before {
            content: "✓";
            color: #28a745;
            font-weight: bold;
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .action-buttons a {
            flex: 1;
            text-decoration: none;
        }
        
        .subscription-badge {
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            color: #333;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✅</div>
        
        <h1 class="success-title">Payment Successful!</h1>
        
        <div class="subscription-badge">🎉 Subscription Activated</div>
        
        <p class="success-message">
            <%= successMessage %>
        </p>
        
        <div class="transaction-box">
            <div class="transaction-label">Transaction ID</div>
            <div class="transaction-id"><%= transactionId %></div>
        </div>
        
        <div class="info-box">
            <h4>✨ What's Next?</h4>
            <ul>
                <li>Your subscription is now active and ready to use</li>
                <li>Access all premium features from your dashboard</li>
                <li>Start tracking your election expenses</li>
                <li>Generate detailed reports anytime</li>
                <li>Receipt saved for your records</li>
            </ul>
        </div>
        
        <div class="info-box" style="background: #fff3cd; border: 1px solid #ffc107;">
            <h4 style="color: #856404;">📧 Confirmation Email</h4>
            <p style="margin: 0; color: #856404;">
                A payment confirmation has been sent to <strong><%= user.getEmail() %></strong>
            </p>
        </div>
        
        <div class="action-buttons">
            <a href="<%=request.getContextPath()%>/user/dashboard.jsp" class="btn btn-primary btn-lg">
                📊 Go to Dashboard
            </a>
            <a href="<%=request.getContextPath()%>/user/subscription.jsp" class="btn btn-secondary btn-lg">
                View Subscription
            </a>
        </div>
        
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
            <p style="color: #999; font-size: 0.9rem; margin: 0;">
                For any queries, contact us at support@electionexpense.com
            </p>
        </div>
    </div>
    
    <script>
        // Remove session attributes after displaying
        <% 
            session.removeAttribute("success");
            session.removeAttribute("transactionId");
        %>
        
        // Confetti animation (optional)
        console.log('Payment successful! Transaction ID: <%= transactionId %>');
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    Integer brokerId = user.getBrokerId();
    boolean hasBroker = (brokerId != null && brokerId > 0);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Referral Debug Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .info-box { background: #e3f2fd; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .section { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .success { background: #c8e6c9; }
        .warning { background: #fff9c4; }
    </style>
</head>
<body>
    <h1>Referral Code Feature Debug Test</h1>
    
    <div class="info-box">
        <h2>User Information:</h2>
        <p><strong>User ID:</strong> <%= user.getUserId() %></p>
        <p><strong>Username:</strong> <%= user.getUsername() %></p>
        <p><strong>Full Name:</strong> <%= user.getFullName() %></p>
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Role:</strong> <%= user.getUserRole() %></p>
    </div>
    
    <div class="info-box">
        <h2>Broker Information:</h2>
        <p><strong>Broker ID (from user object):</strong> <%= user.getBrokerId() %></p>
        <p><strong>Broker ID (local variable):</strong> <%= brokerId %></p>
        <p><strong>Has Broker:</strong> <%= hasBroker %></p>
    </div>
    
    <div class="section <%= hasBroker ? "success" : "warning" %>">
        <h2>Referral Section Visibility Test:</h2>
        <% if (!hasBroker) { %>
            <p style="color: green; font-weight: bold;">✅ REFERRAL SECTION SHOULD BE VISIBLE</p>
            <p>User does NOT have a broker assigned. The referral code mapping form should be displayed.</p>
        <% } else { %>
            <p style="color: orange; font-weight: bold;">⚠️ REFERRAL SECTION SHOULD BE HIDDEN</p>
            <p>User already has a broker assigned (ID: <%= brokerId %>). Only the "Already Mapped" message should be shown.</p>
        <% } %>
    </div>
    
    <div class="section">
        <h2>Simulated Referral Section:</h2>
        
        <% if (!hasBroker) { %>
            <div style="border: 2px solid green; padding: 15px; background: white;">
                <h3>🎁 Map Referral Code</h3>
                <p>Connect with a broker using their referral code</p>
                
                <div style="background: #e6f7ff; padding: 10px; margin: 10px 0;">
                    <strong>ℹ️ What is a Referral Code?</strong><br>
                    If you were referred by a broker, you can enter their referral code here to link your account.
                </div>
                
                <form action="<%= request.getContextPath() %>/user/map-referral-code" method="post">
                    <label for="referralCode">Referral Code:</label><br>
                    <input type="text" id="referralCode" name="referralCode" style="padding: 8px; width: 300px; text-transform: uppercase;" placeholder="Enter broker's referral code">
                    <br><br>
                    <button type="submit" style="padding: 10px 20px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer;">
                        🔗 Map Referral Code
                    </button>
                </form>
            </div>
        <% } else { %>
            <div style="border: 2px solid orange; padding: 15px; background: white;">
                <div style="background: #f0fdf4; padding: 10px; border-left: 3px solid #48bb78;">
                    <strong>✅ Referral Code Already Mapped</strong><br>
                    Your account is already linked to a broker (Broker ID: <%= brokerId %>). You cannot change the referral code once it's been set.
                </div>
            </div>
        <% } %>
    </div>
    
    <div class="section">
        <h2>Actions:</h2>
        <p><a href="change-password.jsp" style="padding: 10px 15px; background: #667eea; color: white; text-decoration: none; border-radius: 5px;">Go to Change Password Page</a></p>
        <p><a href="dashboard.jsp" style="padding: 10px 15px; background: #4caf50; color: white; text-decoration: none; border-radius: 5px;">Go to Dashboard</a></p>
    </div>
    
    <div class="info-box">
        <h3>Technical Details:</h3>
        <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
        <p><strong>Session ID:</strong> <%= session.getId() %></p>
        <p><strong>Servlet Mapping:</strong> /user/map-referral-code</p>
        <p><strong>Validation Endpoint:</strong> /validate-referral</p>
    </div>
</body>
</html>

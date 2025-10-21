<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%@ page import="com.election.dao.SubscriptionDAO" %>
<%@ page import="com.election.model.SubscriptionPlan" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    SubscriptionDAO subscriptionDAO = new SubscriptionDAO();
    List<SubscriptionPlan> plans = subscriptionDAO.getAllPlans();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subscribe - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .subscription-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
        }
        
        .subscription-header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5rem;
        }
        
        .subscription-header p {
            margin: 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .plans-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        
        .plan-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 3px solid transparent;
        }
        
        .plan-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .plan-card.featured {
            border-color: #667eea;
            transform: scale(1.05);
        }
        
        .plan-header {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .plan-name {
            font-size: 1.8rem;
            color: #333;
            margin: 0 0 10px 0;
        }
        
        .plan-price {
            font-size: 2.5rem;
            color: #667eea;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .plan-duration {
            color: #666;
            font-size: 1rem;
        }
        
        .plan-description {
            text-align: center;
            color: #666;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .plan-features {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }
        
        .plan-features li {
            padding: 10px 0;
            color: #555;
            display: flex;
            align-items: center;
        }
        
        .plan-features li:before {
            content: "✓";
            color: #4CAF50;
            font-weight: bold;
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .subscribe-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        
        .subscribe-btn:hover {
            transform: scale(1.05);
        }
        
        .featured-badge {
            background: #FFD700;
            color: #333;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 10px;
        }
        
        .payment-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .payment-modal.active {
            display: flex;
        }
        
        .payment-content {
            background: white;
            padding: 40px;
            border-radius: 15px;
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .payment-method {
            margin: 20px 0;
        }
        
        .payment-method label {
            display: block;
            padding: 15px;
            border: 2px solid #eee;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-method input[type="radio"] {
            margin-right: 10px;
        }
        
        .payment-method label:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }
        
        .payment-method input[type="radio"]:checked + span {
            color: #667eea;
            font-weight: bold;
        }
        
        .close-modal {
            float: right;
            font-size: 2rem;
            cursor: pointer;
            color: #999;
        }
        
        .close-modal:hover {
            color: #333;
        }
    </style>
</head>
<body class="dashboard">
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ Election Expense</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="subscription.jsp" class="active">Subscription</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar">
                    <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <!-- Alert Messages -->
        <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= session.getAttribute("error") %>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Subscription Header -->
        <div class="subscription-header">
            <h1>🎯 Choose Your Plan</h1>
            <p>Unlock full access to Election Expense Management features</p>
        </div>
        
        <!-- Plans Container -->
        <div class="plans-container">
            <% 
            int index = 0;
            for (SubscriptionPlan plan : plans) {
                boolean isFeatured = plan.getPlanName().equals("Quarterly");
                String[] features = plan.getFeatures().split(",");
            %>
            <div class="plan-card <%= isFeatured ? "featured" : "" %>">
                <div class="plan-header">
                    <% if (isFeatured) { %>
                        <div class="featured-badge">⭐ MOST POPULAR</div>
                    <% } %>
                    <h2 class="plan-name"><%= plan.getPlanName() %></h2>
                    <div class="plan-price">₹<%= String.format("%.0f", plan.getPriceValue()) %></div>
                    <div class="plan-duration">for <%= plan.getDurationDays() %> days</div>
                </div>
                
                <p class="plan-description"><%= plan.getPlanDescription() %></p>
                
                <ul class="plan-features">
                    <% for (String feature : features) { %>
                        <li><%= feature.trim() %></li>
                    <% } %>
                </ul>
                
                <button class="subscribe-btn" onclick="openPaymentModal('<%= plan.getPlanName() %>', <%= plan.getPriceValue() %>)">
                    Subscribe Now
                </button>
            </div>
            <% } %>
        </div>
        
        <!-- Features Comparison -->
        <div style="margin-top: 60px; text-align: center;">
            <h2 style="color: #333; margin-bottom: 20px;">🔥 What You'll Get</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-icon" style="font-size: 3rem;">📊</span>
                    <h3>Unlimited Expenses</h3>
                    <p style="color: #666;">Track all your campaign expenses without limits</p>
                </div>
                <div class="stat-card">
                    <span class="stat-icon" style="font-size: 3rem;">📄</span>
                    <h3>Receipt Management</h3>
                    <p style="color: #666;">Upload and store all your receipts securely</p>
                </div>
                <div class="stat-card">
                    <span class="stat-icon" style="font-size: 3rem;">📈</span>
                    <h3>Detailed Reports</h3>
                    <p style="color: #666;">Generate comprehensive expense reports</p>
                </div>
                <div class="stat-card">
                    <span class="stat-icon" style="font-size: 3rem;">💾</span>
                    <h3>Export Data</h3>
                    <p style="color: #666;">Download your data in multiple formats</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Payment Modal -->
    <div id="paymentModal" class="payment-modal">
        <div class="payment-content">
            <span class="close-modal" onclick="closePaymentModal()">&times;</span>
            <div class="payment-header">
                <h2>Complete Your Payment</h2>
                <p id="selectedPlan" style="color: #667eea; font-size: 1.2rem;"></p>
            </div>
            
            <form action="<%=request.getContextPath()%>/payment" method="post" id="paymentForm">
                <input type="hidden" name="action" value="processPayment">
                <input type="hidden" name="planName" id="planName">
                <input type="hidden" name="amount" id="planAmount">
                
                <div class="form-group">
                    <label>Select Payment Method:</label>
                    <div class="payment-method">
                        <label>
                            <input type="radio" name="paymentMethod" value="Credit Card" required>
                            <span>💳 Credit Card</span>
                        </label>
                        <label>
                            <input type="radio" name="paymentMethod" value="Debit Card" required>
                            <span>💳 Debit Card</span>
                        </label>
                        <label>
                            <input type="radio" name="paymentMethod" value="UPI" required>
                            <span>📱 UPI</span>
                        </label>
                        <label>
                            <input type="radio" name="paymentMethod" value="Net Banking" required>
                            <span>🏦 Net Banking</span>
                        </label>
                    </div>
                </div>
                
                <div style="background: #f8f9ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
                    <p style="margin: 0; color: #666; font-size: 0.9rem;">
                        <strong>✓ Secure Payment</strong><br>
                        This is a demo payment system. In production, this would integrate with payment gateways like Razorpay or Stripe.
                        Click "Proceed to Pay" to complete your subscription.
                    </p>
                </div>
                
                <div class="form-actions" style="margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 15px; font-size: 1.1rem;">
                        💰 Proceed to Pay
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="closePaymentModal()" style="width: 100%; margin-top: 10px;">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openPaymentModal(planName, price) {
            document.getElementById('planName').value = planName;
            document.getElementById('planAmount').value = price;
            document.getElementById('selectedPlan').innerHTML = 
                '<strong>' + planName + ' Plan</strong> - ₹' + price.toFixed(2);
            document.getElementById('paymentModal').classList.add('active');
        }
        
        function closePaymentModal() {
            document.getElementById('paymentModal').classList.remove('active');
            document.getElementById('paymentForm').reset();
        }
        
        // Close modal on outside click
        document.getElementById('paymentModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closePaymentModal();
            }
        });
    </script>
</body>
</html>

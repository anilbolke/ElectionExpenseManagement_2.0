<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%@ page import="com.election.dao.SystemSettingsDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get current payment mode
    SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
    String currentPaymentMode = settingsDAO.getSetting("payment_mode", "razorpay");
    
    // Handle form submission
    String message = null;
    String messageType = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newPaymentMode = request.getParameter("paymentMode");
        if (newPaymentMode != null && (newPaymentMode.equals("razorpay") || newPaymentMode.equals("qrcode"))) {
            boolean success = settingsDAO.updateSetting("payment_mode", newPaymentMode, 
                "Payment mode: razorpay (online gateway) or qrcode (manual QR payment)", user.getUserId());
            if (success) {
                currentPaymentMode = newPaymentMode;
                message = "Payment mode updated successfully to: " + newPaymentMode.toUpperCase();
                messageType = "success";
            } else {
                message = "Failed to update payment mode. Please try again.";
                messageType = "error";
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Settings - Admin Panel</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        .admin-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .page-header h1 {
            font-size: 28px;
            color: #2d3748;
            margin-bottom: 10px;
        }
        
        .page-header p {
            color: #718096;
            font-size: 14px;
        }
        
        .settings-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .payment-mode-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 20px;
            color: #2d3748;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .section-desc {
            color: #718096;
            font-size: 14px;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        
        .payment-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }
        
        .payment-option {
            border: 3px solid #e2e8f0;
            border-radius: 12px;
            padding: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .payment-option:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }
        
        .payment-option.active {
            border-color: #667eea;
            background: #f7faff;
        }
        
        .payment-option input[type="radio"] {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 24px;
            height: 24px;
            cursor: pointer;
        }
        
        .option-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .option-title {
            font-size: 18px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }
        
        .option-desc {
            font-size: 14px;
            color: #718096;
            line-height: 1.6;
            margin-bottom: 12px;
        }
        
        .option-features {
            list-style: none;
            padding: 0;
            margin: 15px 0 0 0;
        }
        
        .option-features li {
            font-size: 13px;
            color: #4a5568;
            padding: 6px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .option-features li::before {
            content: "✓";
            color: #48bb78;
            font-weight: bold;
        }
        
        .btn {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .current-status {
            background: #f7faff;
            border: 2px solid #667eea;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .current-status-label {
            font-size: 13px;
            color: #718096;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .current-status-value {
            font-size: 24px;
            color: #667eea;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        @media (max-width: 768px) {
            .payment-options {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../includes/admin-navbar.jsp" %>
    
    <div class="admin-container">
        <div class="page-header">
            <h1>💳 Payment Gateway Settings</h1>
            <p>Configure how users make payments in the system</p>
        </div>
        
        <div class="settings-card">
            <% if (message != null) { %>
                <div class="alert alert-<%= messageType %>">
                    <span style="font-size: 20px;"><%= "success".equals(messageType) ? "✓" : "⚠" %></span>
                    <span><%= message %></span>
                </div>
            <% } %>
            
            <div class="current-status">
                <div class="current-status-label">Current Payment Mode</div>
                <div class="current-status-value">
                    <span><%= "razorpay".equalsIgnoreCase(currentPaymentMode) ? "💳 Razorpay Online Gateway" : "📱 QR Code Payment" %></span>
                </div>
            </div>
            
            <form method="POST" action="" id="paymentForm">
                <div class="payment-mode-section">
                    <h2 class="section-title">Select Payment Mode</h2>
                    <p class="section-desc">
                        Choose how users will make payments. This setting affects all payment pages including subscription payments and candidate registration fees.
                        <br><strong>Note:</strong> Changes take effect immediately for all users.
                    </p>
                    
                    <div class="payment-options">
                        <div class="payment-option <%= "razorpay".equalsIgnoreCase(currentPaymentMode) ? "active" : "" %>" 
                             onclick="selectOption('razorpay')">
                            <input type="radio" name="paymentMode" value="razorpay" 
                                   <%= "razorpay".equalsIgnoreCase(currentPaymentMode) ? "checked" : "" %> required>
                            <div class="option-icon">💳</div>
                            <div class="option-title">Razorpay Online Gateway</div>
                            <div class="option-desc">
                                Integrated online payment gateway with automatic payment verification and instant activation.
                            </div>
                            <ul class="option-features">
                                <li>Multiple payment methods (UPI, Card, Net Banking, Wallet)</li>
                                <li>Instant payment verification</li>
                                <li>Automatic account activation</li>
                                <li>Secure Razorpay checkout</li>
                                <li>Payment tracking & receipts</li>
                            </ul>
                        </div>
                        
                        <div class="payment-option <%= "qrcode".equalsIgnoreCase(currentPaymentMode) ? "active" : "" %>" 
                             onclick="selectOption('qrcode')">
                            <input type="radio" name="paymentMode" value="qrcode" 
                                   <%= "qrcode".equalsIgnoreCase(currentPaymentMode) ? "checked" : "" %> required>
                            <div class="option-icon">📱</div>
                            <div class="option-title">QR Code Payment</div>
                            <div class="option-desc">
                                Display static QR code for UPI payments. Users scan and pay, then submit transaction ID manually.
                            </div>
                            <ul class="option-features">
                                <li>Simple QR code scan & pay</li>
                                <li>Works with any UPI app</li>
                                <li>Manual transaction ID entry</li>
                                <li>Admin verification required</li>
                                <li>No gateway fees</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="button-group">
                    <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        💾 Save Payment Settings
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function selectOption(mode) {
            // Remove active class from all options
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('active');
            });
            
            // Add active class to selected option
            event.currentTarget.classList.add('active');
            
            // Check the radio button
            document.querySelector(`input[value="${mode}"]`).checked = true;
        }
        
        // Confirmation before changing
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            const selectedMode = document.querySelector('input[name="paymentMode"]:checked').value;
            const currentMode = "<%= currentPaymentMode %>";
            
            if (selectedMode !== currentMode) {
                const modeName = selectedMode === 'razorpay' ? 'Razorpay Online Gateway' : 'QR Code Payment';
                if (!confirm(`Are you sure you want to change payment mode to ${modeName}?\n\nThis will affect all users immediately.`)) {
                    e.preventDefault();
                    return false;
                }
            }
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String planName = request.getParameter("planName");
    String paymentMethod = request.getParameter("paymentMethod");
    String amountStr = request.getParameter("amount");
    
    if (planName == null || paymentMethod == null) {
        response.sendRedirect(request.getContextPath() + "/user/subscription.jsp");
        return;
    }
    
    double amount = 500.00; // Default
    if (amountStr != null) {
        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            // Use default
        }
    } else {
        // Calculate based on plan
        if ("Quarterly".equals(planName)) {
            amount = 1350.00;
        } else if ("Annual".equals(planName)) {
            amount = 4800.00;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Gateway - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <!-- Razorpay Checkout Script -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .payment-gateway {
            background: white;
            border-radius: 20px;
            padding: 40px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .gateway-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .gateway-logo {
            font-size: 4rem;
            margin-bottom: 10px;
        }
        
        .gateway-header h1 {
            color: #333;
            font-size: 1.8rem;
            margin: 10px 0;
        }
        
        .gateway-header p {
            color: #666;
            margin: 0;
        }
        
        .payment-details {
            background: #f8f9ff;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            color: #666;
            font-weight: 500;
        }
        
        .detail-value {
            color: #333;
            font-weight: 600;
        }
        
        .amount-display {
            text-align: center;
            margin: 30px 0;
            padding: 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            color: white;
        }
        
        .amount-label {
            font-size: 1rem;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .amount-value {
            font-size: 3rem;
            font-weight: bold;
        }
        
        .payment-form {
            margin-top: 30px;
        }
        
        .card-input {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .card-input input {
            flex: 1;
        }
        
        .security-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 15px;
            background: #e8f5e9;
            border-radius: 8px;
            margin-top: 20px;
            color: #2e7d32;
        }
        
        .security-badge .icon {
            font-size: 1.5rem;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn-group button {
            flex: 1;
        }
        
        .demo-note {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            color: #856404;
        }
        
        .demo-note strong {
            display: block;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="payment-gateway">
        <div class="gateway-header">
            <div class="gateway-logo">🏦</div>
            <h1>Secure Payment Gateway</h1>
            <p>Election Expense Management</p>
        </div>
        
        <div style="background: #e3f2fd; border: 1px solid #2196f3; border-radius: 8px; padding: 15px; margin-bottom: 20px; color: #1565c0;">
            <strong>🔒 Secure Payment via Razorpay</strong>
            Your payment will be processed securely through Razorpay Payment Gateway.
            All major payment methods are supported: Cards, UPI, Net Banking, and Wallets.
        </div>
        
        <div class="payment-details">
            <div class="detail-row">
                <span class="detail-label">Plan Selected:</span>
                <span class="detail-value"><%= planName %> Plan</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment Method:</span>
                <span class="detail-value"><%= paymentMethod %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Customer:</span>
                <span class="detail-value"><%= user.getFullName() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Email:</span>
                <span class="detail-value"><%= user.getEmail() %></span>
            </div>
        </div>
        
        <div class="amount-display">
            <div class="amount-label">Total Amount to Pay</div>
            <div class="amount-value">₹<%= String.format("%.2f", amount) %></div>
        </div>
        
        <!-- Hidden form with payment details -->
        <form id="razorpay-form" style="display: none;">
            <input type="hidden" id="planName" value="<%= planName %>">
            <input type="hidden" id="paymentMethod" value="<%= paymentMethod %>">
            <input type="hidden" id="amount" value="<%= amount %>">
        </form>
        
        <div class="security-badge">
            <span class="icon">🔒</span>
            <span>256-bit SSL encrypted payment gateway powered by Razorpay</span>
        </div>
        
        <div class="btn-group">
            <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                ← Cancel
            </button>
            <button type="button" class="btn btn-success" id="rzp-button" onclick="initiateRazorpayPayment()">
                Pay ₹<%= String.format("%.2f", amount) %> with Razorpay →
            </button>
        </div>
        
        <div style="text-align: center; margin-top: 20px; color: #999; font-size: 0.9rem;">
            <p>By proceeding, you agree to our Terms of Service and Privacy Policy</p>
        </div>
    </div>
    
    <script>
        // Razorpay Payment Integration
        function initiateRazorpayPayment() {
            const planName = document.getElementById('planName').value;
            const paymentMethod = document.getElementById('paymentMethod').value;
            const amount = document.getElementById('amount').value;
            const payButton = document.getElementById('rzp-button');
            
            // Disable button and show loading
            payButton.disabled = true;
            payButton.innerHTML = '<span>Processing...</span>';
            
            // Create Razorpay order
            fetch('<%=request.getContextPath()%>/payment?action=createOrder', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'planName=' + encodeURIComponent(planName) + 
                      '&paymentMethod=' + encodeURIComponent(paymentMethod) + 
                      '&amount=' + encodeURIComponent(amount)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Open Razorpay Checkout
                    const options = {
                        "key": data.key_id,
                        "amount": data.amount,
                        "currency": data.currency,
                        "name": data.name,
                        "description": data.description,
                        "order_id": data.order_id,
                        "prefill": {
                            "name": data.prefill_name,
                            "email": data.prefill_email,
                            "contact": data.prefill_contact
                        },
                        "theme": {
                            "color": "#667eea"
                        },
                        "handler": function (response) {
                            // Payment successful - verify on server
                            verifyPayment(response);
                        },
                        "modal": {
                            "ondismiss": function() {
                                // Re-enable button if user closes modal
                                payButton.disabled = false;
                                payButton.innerHTML = 'Pay ₹' + parseFloat(amount).toFixed(2) + ' with Razorpay →';
                            }
                        }
                    };
                    
                    const rzp = new Razorpay(options);
                    
                    rzp.on('payment.failed', function (response) {
                        alert('Payment failed: ' + response.error.description);
                        payButton.disabled = false;
                        payButton.innerHTML = 'Pay ₹' + parseFloat(amount).toFixed(2) + ' with Razorpay →';
                    });
                    
                    rzp.open();
                } else {
                    alert('Error: ' + data.error);
                    payButton.disabled = false;
                    payButton.innerHTML = 'Pay ₹' + parseFloat(amount).toFixed(2) + ' with Razorpay →';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while processing payment');
                payButton.disabled = false;
                payButton.innerHTML = 'Pay ₹' + parseFloat(amount).toFixed(2) + ' with Razorpay →';
            });
        }
        
        function verifyPayment(response) {
            // Show processing message
            document.getElementById('rzp-button').innerHTML = '<span>Verifying payment...</span>';
            
            // Send payment details to server for verification
            fetch('<%=request.getContextPath()%>/payment?action=verifyPayment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'razorpay_order_id=' + encodeURIComponent(response.razorpay_order_id) +
                      '&razorpay_payment_id=' + encodeURIComponent(response.razorpay_payment_id) +
                      '&razorpay_signature=' + encodeURIComponent(response.razorpay_signature)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Redirect to success page
                    window.location.href = data.redirect_url;
                } else {
                    alert('Payment verification failed: ' + data.error);
                    window.location.href = data.redirect_url;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred during payment verification');
                window.location.href = '<%=request.getContextPath()%>/user/payment-failure.jsp';
            });
        }
    </script>
</body>
</html>

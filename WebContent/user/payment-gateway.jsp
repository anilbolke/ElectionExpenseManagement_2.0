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
        
        <div class="demo-note" id="demoNote" style="display: none;">
            <strong>⚠️ Demo Payment System</strong>
            Razorpay is not configured. Using demo payment mode. 
            To enable Razorpay, set RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET environment variables.
        </div>
        
        <div class="demo-note" id="razorpayNote" style="background: #d4edda; border-color: #c3e6cb; color: #155724; display: none;">
            <strong>✓ Razorpay Integration Active</strong>
            You will be redirected to Razorpay secure payment gateway.
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
        
        <form action="<%=request.getContextPath()%>/payment" method="post" class="payment-form">
            <input type="hidden" name="action" value="processPayment">
            <input type="hidden" name="planName" value="<%= planName %>">
            <input type="hidden" name="paymentMethod" value="<%= paymentMethod %>">
            <input type="hidden" name="amount" value="<%= amount %>">
            
            <% if ("Credit Card".equals(paymentMethod) || "Debit Card".equals(paymentMethod)) { %>
                <div class="form-group">
                    <label>Card Number</label>
                    <input type="text" class="form-control" placeholder="1234 5678 9012 3456" 
                           pattern="[0-9]{16}" maxlength="19" value="4111111111111111" required>
                </div>
                
                <div class="card-input">
                    <div class="form-group">
                        <label>Expiry Date</label>
                        <input type="text" class="form-control" placeholder="MM/YY" 
                               pattern="[0-9]{2}/[0-9]{2}" maxlength="5" value="12/25" required>
                    </div>
                    <div class="form-group">
                        <label>CVV</label>
                        <input type="text" class="form-control" placeholder="123" 
                               pattern="[0-9]{3}" maxlength="3" value="123" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Card Holder Name</label>
                    <input type="text" class="form-control" value="<%= user.getFullName() %>" required>
                </div>
            <% } else if ("UPI".equals(paymentMethod)) { %>
                <div class="form-group">
                    <label>UPI ID</label>
                    <input type="text" class="form-control" placeholder="yourname@upi" 
                           value="user@oksbi" required>
                </div>
                
                <div style="text-align: center; margin: 20px 0;">
                    <img src="https://via.placeholder.com/200x200?text=QR+Code" alt="UPI QR Code" 
                         style="border: 2px solid #ddd; border-radius: 8px;">
                    <p style="color: #666; margin-top: 10px;">Scan to pay with any UPI app</p>
                </div>
            <% } else if ("Net Banking".equals(paymentMethod)) { %>
                <div class="form-group">
                    <label>Select Bank</label>
                    <select class="form-control" required>
                        <option value="">Choose your bank</option>
                        <option value="SBI">State Bank of India</option>
                        <option value="HDFC">HDFC Bank</option>
                        <option value="ICICI">ICICI Bank</option>
                        <option value="AXIS">Axis Bank</option>
                        <option value="PNB">Punjab National Bank</option>
                    </select>
                </div>
            <% } %>
            
            <div class="security-badge">
                <span class="icon">🔒</span>
                <span>Your payment information is encrypted and secure</span>
            </div>
            
            <div class="btn-group">
                <button type="button" class="btn btn-secondary" 
                        onclick="window.history.back()">
                    ← Cancel
                </button>
                <button type="submit" class="btn btn-success">
                    Pay ₹<%= String.format("%.2f", amount) %> →
                </button>
            </div>
        </form>
        
        <div style="text-align: center; margin-top: 20px; color: #999; font-size: 0.9rem;">
            <p>By proceeding, you agree to our Terms of Service and Privacy Policy</p>
        </div>
    </div>
    
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
        let razorpayConfig = null;
        let isRazorpayConfigured = false;
        let configLoaded = false;
        
        // Load Razorpay configuration
        console.log('Loading Razorpay config from:', '<%=request.getContextPath()%>/payment?action=config');
        fetch('<%=request.getContextPath()%>/payment?action=config')
            .then(response => response.json())
            .then(config => {
                console.log('Razorpay Config Loaded:', config);
                razorpayConfig = config;
                isRazorpayConfigured = config.configured;
                configLoaded = true;
                
                if (isRazorpayConfigured) {
                    console.log('✅ Razorpay API is CONFIGURED - Will use real payment');
                    document.getElementById('razorpayNote').style.display = 'block';
                } else {
                    console.log('⚠️ Razorpay API NOT configured - Will use demo mode');
                    console.log('Key ID:', config.keyId);
                    document.getElementById('demoNote').style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Failed to load Razorpay config:', error);
                document.getElementById('demoNote').style.display = 'block';
                configLoaded = true;
            });
        
        // Handle form submission
        document.querySelector('.payment-form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Wait for config to load if still loading
            if (!configLoaded) {
                console.log('⏳ Waiting for config to load...');
                setTimeout(() => {
                    document.querySelector('.payment-form').dispatchEvent(new Event('submit'));
                }, 500);
                return;
            }
            
            console.log('💳 Processing payment...');
            console.log('isRazorpayConfigured:', isRazorpayConfigured);
            
            if (isRazorpayConfigured) {
                console.log('🚀 Using Razorpay API');
                initiateRazorpayPayment();
            } else {
                console.log('⚠️ Using fallback demo payment');
                console.log('Reason: Environment variables not set or invalid');
                // Fallback to demo payment
                HTMLFormElement.prototype.submit.call(this);
            }
        });
        
        function initiateRazorpayPayment() {
            const amount = <%= amount %>;
            const planName = '<%= planName %>';
            
            // Create Razorpay order
            fetch('<%=request.getContextPath()%>/payment?action=createOrder', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'amount=' + amount + '&paymentType=subscription&entityId=' + encodeURIComponent(planName)
            })
            .then(response => response.json())
            .then(orderData => {
                if (orderData.error) {
                    alert('Failed to create order: ' + orderData.error);
                    return;
                }
                
                // Initialize Razorpay payment
                const options = {
                    key: razorpayConfig.keyId,
                    amount: orderData.amount,
                    currency: orderData.currency,
                    name: razorpayConfig.companyName,
                    description: planName + ' Subscription',
                    image: razorpayConfig.companyLogo,
                    order_id: orderData.id,
                    handler: function (response) {
                        verifyPayment(response);
                    },
                    prefill: {
                        name: '<%= user.getFullName() %>',
                        email: '<%= user.getEmail() %>',
                        contact: '<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>'
                    },
                    theme: {
                        color: '#667eea'
                    }
                };
                
                const rzp = new Razorpay(options);
                rzp.on('payment.failed', function (response) {
                    alert('Payment failed: ' + response.error.description);
                });
                rzp.open();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to initiate payment. Please try again.');
            });
        }
        
        function verifyPayment(paymentResponse) {
            const params = new URLSearchParams({
                action: 'verifyPayment',
                razorpay_order_id: paymentResponse.razorpay_order_id,
                razorpay_payment_id: paymentResponse.razorpay_payment_id,
                razorpay_signature: paymentResponse.razorpay_signature
            });
            
            fetch('<%=request.getContextPath()%>/payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = data.redirectUrl;
                } else {
                    alert('Payment verification failed: ' + (data.error || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Payment verification failed. Please contact support with payment ID: ' + paymentResponse.razorpay_payment_id);
            });
        }
        
        // Add card number formatting (for demo mode)
        document.querySelectorAll('input[placeholder*="Card Number"]').forEach(input => {
            input.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\s/g, '');
                let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                e.target.value = formattedValue;
            });
        });
        
        // Add expiry date formatting (for demo mode)
        document.querySelectorAll('input[placeholder*="MM/YY"]').forEach(input => {
            input.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length >= 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                e.target.value = value;
            });
        });
    </script>
</body>
</html>

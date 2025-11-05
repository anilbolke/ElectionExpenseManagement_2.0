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
            
            <!-- Terms and Conditions Checkbox -->
            <div class="terms-section" style="margin-top: 25px; padding: 20px; background: #f8f9fa; border-radius: 8px; border: 2px solid #e0e0e0;">
                <div class="form-check" style="margin-bottom: 15px;">
                    <input type="checkbox" id="termsCheckbox" name="termsAccepted" class="form-check-input" 
                           required style="width: 20px; height: 20px; margin-right: 10px; cursor: pointer;">
                    <label for="termsCheckbox" style="cursor: pointer; font-size: 15px; color: #333;">
                        <strong style="color: #dc3545;">* </strong>
                        I have read and agree to the 
                        <a href="#" onclick="showTermsModal(); return false;" 
                           style="color: #667eea; text-decoration: underline; font-weight: 600;">
                            Terms and Conditions
                        </a>
                        <span style="display: block; font-size: 13px; color: #666; margin-top: 5px;">
                            (मी अटी व नियम वाचले आहेत आणि त्यांना मान्यता देतो)
                        </span>
                    </label>
                </div>
                <input type="hidden" name="termsVersion" value="v1.0">
                <input type="hidden" name="acceptedTimestamp" id="acceptedTimestamp">
                <div style="font-size: 12px; color: #dc3545; margin-top: 10px;">
                    <strong>⚠️ Important:</strong> By checking this box, you acknowledge that you have read, 
                    understood, and agree to be bound by the Terms and Conditions. This is a mandatory 
                    requirement before making any payment.
                </div>
            </div>
            
            <div class="btn-group">
                <button type="button" class="btn btn-secondary" 
                        onclick="window.history.back()">
                    ← Cancel
                </button>
                <button type="submit" class="btn btn-success" id="payButton" disabled>
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
                        contact: '<%= user.getMobile()  != null ? user.getMobile()  : "" %>'
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
        
        // Terms and Conditions Checkbox Logic
        const termsCheckbox = document.getElementById('termsCheckbox');
        const payButton = document.getElementById('payButton');
        const acceptedTimestampField = document.getElementById('acceptedTimestamp');
        
        // Enable/disable pay button based on checkbox
        termsCheckbox.addEventListener('change', function() {
            if (this.checked) {
                payButton.disabled = false;
                payButton.style.opacity = '1';
                payButton.style.cursor = 'pointer';
                // Record acceptance timestamp
                acceptedTimestampField.value = new Date().toISOString();
                console.log('Terms accepted at:', acceptedTimestampField.value);
            } else {
                payButton.disabled = true;
                payButton.style.opacity = '0.5';
                payButton.style.cursor = 'not-allowed';
                acceptedTimestampField.value = '';
            }
        });
        
        // Initial state
        payButton.style.opacity = '0.5';
        payButton.style.cursor = 'not-allowed';
    </script>
    
    <!-- Terms and Conditions Modal -->
    <div id="termsModal" style="display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.8);">
        <div style="background-color: #fefefe; margin: 3% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 800px; box-shadow: 0 20px 60px rgba(0,0,0,0.5); max-height: 85vh; display: flex; flex-direction: column;">
            <!-- Modal Header -->
            <div style="padding: 25px 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 12px 12px 0 0;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <h2 style="margin: 0; font-size: 24px;">
                        📜 Terms and Conditions
                        <span style="display: block; font-size: 16px; opacity: 0.9; margin-top: 5px;">
                            अटी व नियम
                        </span>
                    </h2>
                    <span onclick="closeTermsModal()" style="color: white; font-size: 35px; font-weight: bold; cursor: pointer; opacity: 0.8; transition: opacity 0.3s;">
                        &times;
                    </span>
                </div>
            </div>
            
            <!-- Modal Body -->
            <div style="padding: 30px; overflow-y: auto; flex: 1; line-height: 1.8; color: #333;">
                <div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                    <strong>⚠️ Important Notice / महत्त्वाची सूचना:</strong><br>
                    Please read these terms carefully before making any payment. By checking the acceptance box, you agree to be bound by these terms.
                    <br><em>कृपया पेमेंट करण्यापूर्वी या अटी काळजीपूर्वक वाचा. स्वीकृती बॉक्स चेक करून, तुम्ही या अटींना बांधील राहण्यास सहमती देता.</em>
                </div>
                
                <h3 style="color: #667eea; margin-top: 20px;">1. 'निवडणूक खर्च व्यवस्थापन सॉफ्टवेअर' वापराच्या अटी व नियम</h3>
                <p style="font-weight: 600;">(Terms and Conditions for Use of 'Election Expense Management Software')</p>
                
                <p>हे सॉफ्टवेअर वापरण्यापूर्वी (पुढे 'सॉफ्टवेअर' असे नमूद), ग्राहक (उमेदवार किंवा त्यांचे प्रतिनिधी, पुढे 'वापरकर्ता' असे नमूद) खालील अटी व शर्तींना (Terms and Conditions) सहमती देत आहेत:</p>
                
                <h4 style="color: #764ba2; margin-top: 20px;">१. सॉफ्टवेअरची स्थिती आणि उद्देश (Software Status and Purpose)</h4>
                
                <p><strong>१.१. खासगी आणि स्वतंत्र उत्पादन:</strong><br>
                हे सॉफ्टवेअर पूर्णतः खासगी मालकीचे असून ते भारतीय निवडणूक आयोग (ECI), राज्य निवडणूक आयोग (SEC) किंवा कोणत्याही सरकारी निवडणूक प्राधिकरणाशी कोणत्याही प्रकारे संलग्न नाही, त्यांच्याद्वारे प्रमाणित (Certified) नाही किंवा त्यांच्याशी संबंधित नाही.</p>
                
                <p><strong>१.२. उद्देश:</strong><br>
                हे सॉफ्टवेअर केवळ मार्गदर्शन आणि वेळ वाचवण्यासाठी (Time-Saving) एक व्यवस्थापन साधन (Management Tool) म्हणून तयार केले आहे. याचा मुख्य उद्देश उमेदवारांना त्यांच्या निवडणुकीच्या खर्चाचा दैनंदिन हिशोब सोप्या पद्धतीने ठेवण्यात मदत करणे आहे.</p>
                
                <p><strong>१.३. कायदेशीर सल्ला पर्याय नाही:</strong><br>
                सॉफ्टवेअरने दिलेली कोणतीही माहिती, अहवाल रचना किंवा मर्यादा संबंधित सूचना कायदेशीर सल्ला (Legal Advice) किंवा कायदेशीर अनुपालनाची हमी (Guarantee of Legal Compliance) मानली जाऊ नये. निवडणुकीच्या कायद्यांचे अंतिम अनुपालन (Final Compliance) आणि अहवाल सादर करण्याची जबाबदारी केवळ वापरकर्त्याची असेल.</p>
                
                <h4 style="color: #764ba2; margin-top: 20px;">२. आर्थिक नियम आणि परतावा धोरण (Financial Rules and Refund Policy)</h4>
                
                <p><strong>२.१. शुल्क परत न मिळणे (No Refund Policy):</strong><br>
                या सॉफ्टवेअरच्या वापरासाठी भरलेले शुल्क (Fees) किंवा पेमेंट हे अंतिम (Final) असेल. एकदा पेमेंट पूर्ण झाल्यावर, कोणत्याही परिस्थितीत ते परत (Refund) केले जाणार नाही. निवडणुकीच्या निकालावर, उमेदवारी रद्द झाल्यास किंवा सॉफ्टवेअरचा वापर न केल्यासदेखील शुल्क परत मिळणार नाही.</p>
                
                <p><strong>२.२. शुल्क अहस्तांतरणीय (Non-Transferable Fees):</strong><br>
                सॉफ्टवेअर वापरण्यासाठी दिलेले शुल्क दुसऱ्या व्यक्तीकडे, दुसऱ्या निवडणुकीसाठी किंवा दुसऱ्या मतदारसंघासाठी हस्तांतरित (Transfer) केले जाणार नाही. हा परवाना (License) केवळ एका नोंदणीकृत उमेदवारासाठी आणि एकाच निवडणुकीसाठी वैध असेल.</p>
                
                <h4 style="color: #764ba2; margin-top: 20px;">३. जबाबदारी आणि मर्यादा (Responsibility and Limitation)</h4>
                
                <p><strong>३.१. अंतिम जबाबदारी:</strong><br>
                सॉफ्टवेअर हे केवळ एक साधन आहे. खर्च नोंदीची सत्यता (Authenticity), खर्चाची मर्यादा पाळणे, निवडणूक आयोगाला अचूक अहवाल देणे आणि कायदेशीर आवश्यकतांचे पालन करण्याची अंतिम आणि संपूर्ण जबाबदारी केवळ वापरकर्त्याची (उमेदवाराची) राहील.</p>
                
                <p><strong>३.२. डेटा सुरक्षा:</strong><br>
                आम्ही वापरकर्त्याच्या डेटाच्या सुरक्षिततेसाठी आवश्यक ती काळजी घेतो, परंतु डेटा गळती (Data Breach), त्रुटी (Errors) किंवा तांत्रिक बिघाडामुळे (Technical Failure) होणाऱ्या कोणत्याही नुकसानीसाठी, आयोगाकडून येणाऱ्या नोटिसांसाठी किंवा अपात्रतेसाठी सॉफ्टवेअरची कंपनी कोणतीही जबाबदारी घेणार नाही.</p>
                
                <div style="background: #d4edda; border-left: 4px solid #28a745; padding: 15px; margin-top: 30px; border-radius: 4px;">
                    <strong style="color: #155724;">✓ Acceptance / स्वीकृती:</strong><br>
                    या अटी व नियमांनुसार, मी (वापरकर्ता) या सॉफ्टवेअरचा वापर करण्यास सहमती देत आहे आणि सॉफ्टवेअरच्या वापरासंबंधीचे सर्व धोके आणि जबाबदाऱ्या स्वीकारण्यास तयार आहे.
                </div>
            </div>
            
            <!-- Modal Footer -->
            <div style="padding: 20px 30px; background: #f8f9fa; border-top: 1px solid #dee2e6; border-radius: 0 0 12px 12px; display: flex; justify-content: space-between; align-items: center;">
                <div style="color: #666; font-size: 13px;">
                    Version: v1.0 | Last Updated: November 2025
                </div>
                <button onclick="acceptAndClose()" style="background: #28a745; color: white; padding: 12px 30px; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: 600;">
                    ✓ I Accept / मी स्वीकारतो
                </button>
            </div>
        </div>
    </div>
    
    <script>
        // Show Terms Modal
        function showTermsModal() {
            document.getElementById('termsModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        // Close Terms Modal
        function closeTermsModal() {
            document.getElementById('termsModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // Accept and Close
        function acceptAndClose() {
            document.getElementById('termsCheckbox').checked = true;
            document.getElementById('termsCheckbox').dispatchEvent(new Event('change'));
            closeTermsModal();
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('termsModal');
            if (event.target == modal) {
                closeTermsModal();
            }
        }
        
        // Prevent form submission if terms not accepted
        document.querySelector('.payment-form').addEventListener('submit', function(e) {
            if (!document.getElementById('termsCheckbox').checked) {
                e.preventDefault();
                alert('Please accept the Terms and Conditions before proceeding with payment.\n\nकृपया पेमेंट करण्यापूर्वी अटी व नियम स्वीकारा.');
                return false;
            }
        });
    </script>
</body>
</html>

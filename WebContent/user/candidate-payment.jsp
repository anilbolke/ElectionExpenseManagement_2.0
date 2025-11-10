<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO, com.election.dao.SystemSettingsDAO" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String candidateIdStr = request.getParameter("candidateId");
    if(candidateIdStr == null) {
        response.sendRedirect("manage-candidates.jsp?error=Invalid candidate");
        return;
    }
    
    int candidateId = Integer.parseInt(candidateIdStr);
    CandidateDAO candidateDAO = new CandidateDAO();
    Candidate candidate = candidateDAO.getCandidateById(candidateId);
    
    if(candidate == null || candidate.getUserId() != user.getUserId()) {
        response.sendRedirect("manage-candidates.jsp?error=Candidate not found");
        return;
    }
    
    // Check if already paid
    if("active".equals(candidate.getAccountStatus()) && candidate.isPaymentVerified()) {
        response.sendRedirect("manage-candidates.jsp?message=Payment already completed");
        return;
    }
    
    // Get registration fee and payment mode from database
    SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
    double registrationFee = settingsDAO.getSettingAsDouble("candidate_registration_fee", 5000.00);
    String paymentMode = settingsDAO.getSetting("payment_mode", "razorpay");
    boolean useQRCode = "qrcode".equalsIgnoreCase(paymentMode);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Registration Payment - Election Expense Management</title>
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
            display: flex;
            flex-direction: column;
        }
        
        .payment-container {
            flex: 1;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px 40px;
            width: 100%;
        }
        
        footer {
            background: #2d3748;
            color: #e2e8f0;
            padding: 20px 30px;
            text-align: center;
            margin-top: auto;
        }
        
        footer p {
            margin: 0;
            font-size: 14px;
        }
        
        .btn {
            padding: 10px 24px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .alert-info {
            background: #ebf8ff;
            border: 1px solid #bee3f8;
            color: #2c5282;
            padding: 14px 18px;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .payment-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .payment-icon {
            font-size: 64px;
            margin-bottom: 15px;
        }
        
        .candidate-details {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
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
        }
        
        .amount-section {
            background: #e7f3ff;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .amount-label {
            font-size: 16px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .amount-value {
            font-size: 36px;
            font-weight: bold;
            color: #007bff;
        }
        
        .payment-methods {
            margin-bottom: 30px;
        }
        
        .payment-method {
            border: 2px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-method:hover {
            border-color: #007bff;
            background: #f8f9fa;
        }
        
        .payment-method.selected {
            border-color: #007bff;
            background: #e7f3ff;
        }
        
        .payment-method input[type="radio"] {
            margin-right: 10px;
        }
        
        .payment-method-label {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .payment-method-icon {
            font-size: 24px;
            margin-right: 10px;
        }
        
        .payment-method-info {
            flex: 1;
        }
        
        .payment-method-name {
            font-weight: 600;
            color: #333;
        }
        
        .payment-method-desc {
            font-size: 12px;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
            }
            
            .detail-label {
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>
    
    <div class="payment-container">
        <div class="payment-card">
            <div class="payment-header">
                <div class="payment-icon">💳</div>
                <h2>Candidate Registration Payment</h2>
                <p>Complete the payment to activate candidate account</p>
            </div>
            
            <div class="candidate-details">
                <h4 style="margin-bottom: 15px;">Candidate Details</h4>
                <div class="detail-row">
                    <span class="detail-label">Candidate Name:</span>
                    <span class="detail-value"><%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <strong><%= candidate.getNominationId() %></strong><% } %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Constituency:</span>
                    <span class="detail-value"><%= candidate.getConstituency() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Party:</span>
                    <span class="detail-value"><%= candidate.getPartyName() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Election Type:</span>
                    <span class="detail-value"><%= candidate.getElectionType() %></span>
                </div>
            </div>
            
            <div class="amount-section">
                <div class="amount-label">Registration Fee</div>
                <div class="amount-value">₹<%= String.format("%.2f", registrationFee) %></div>
            </div>
            
            <% if (useQRCode) { %>
            <!-- QR Code Payment Section -->
            <div class="qr-payment-section" style="text-align: center; padding: 30px 20px; background: #f8f9fa; border-radius: 12px; margin-bottom: 30px;">
                <div class="alert alert-info" style="margin-bottom: 25px; text-align: left;">
                    <strong>📱 QR Code Payment Mode Active</strong><br>
                    Scan the QR code below with any UPI app to complete payment.
                    <br><em>(कोणत्याही UPI अॅपसह खालील QR कोड स्कॅन करा)</em>
                </div>
                
                <h3 style="color: #333; margin-bottom: 20px;">Scan QR Code to Pay / QR कोड स्कॅन करा</h3>
                <div style="background: white; padding: 20px; display: inline-block; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                    <img src="<%=request.getContextPath()%>/Document/QrCode.jpeg" 
                         alt="Payment QR Code" 
                         style="max-width: 300px; width: 100%; height: auto; border: 3px solid #667eea; border-radius: 8px;">
                </div>
                <div style="margin-top: 25px; padding: 20px; background: white; border-radius: 8px; border: 2px solid #e0e0e0;">
                    <h4 style="color: #667eea; margin-bottom: 15px;">📱 Payment Instructions / सूचना</h4>
                    <ol style="text-align: left; display: inline-block; color: #555; line-height: 1.8;">
                        <li>Open any UPI app (Google Pay, PhonePe, Paytm, etc.) / कोणतेही UPI अॅप उघडा</li>
                        <li>Scan the QR code above / वरील QR कोड स्कॅन करा</li>
                        <li>Enter amount: <strong style="color: #667eea;">₹<%= String.format("%.2f", registrationFee) %></strong></li>
                        <li>Complete the payment / पेमेंट पूर्ण करा</li>
                        <li>Take a screenshot of payment confirmation / पेमेंट कन्फर्मेशनचा स्क्रीनशॉट घ्या</li>
                    </ol>
                </div>
                <div style="margin-top: 20px; padding: 15px; background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; color: #856404;">
                    <strong>⚠️ Important:</strong> After completing payment, please enter your transaction ID below and submit.
                    <br><em>(पेमेंट पूर्ण केल्यानंतर, कृपया तुमचा ट्रान्झॅक्शन आयडी खाली एंटर करा आणि सबमिट करा)</em>
                </div>
            </div>
            
            <form action="<%=request.getContextPath()%>/qrpayment" method="post" id="paymentForm">
                <input type="hidden" name="action" value="submitPayment">
                <input type="hidden" name="paymentType" value="candidate_registration">
                <input type="hidden" name="candidateId" value="<%= candidateId %>">
                <input type="hidden" name="amount" value="<%= registrationFee %>">
                <input type="hidden" name="paymentMethod" value="QR Code">
                
                <div class="form-group" style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        UPI Transaction ID / Reference Number <span style="color: red;">*</span>
                    </label>
                    <input type="text" name="transactionId" class="form-control" 
                           placeholder="Enter UPI Transaction ID (e.g., 1234567890)" 
                           required 
                           style="width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 6px; font-size: 14px;">
                    <small style="color: #666; display: block; margin-top: 5px;">
                        📌 Find this in your UPI app's transaction history / हे तुमच्या UPI अॅपच्या ट्रान्झॅक्शन हिस्ट्री मध्ये मिळेल
                    </small>
                </div>
                
                <div class="form-group" style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        Payment Screenshot (Optional) / पेमेंट स्क्रीनशॉट (पर्यायी)
                    </label>
                    <input type="file" name="paymentProof" accept="image/*" class="form-control" 
                           style="width: 100%; padding: 10px; border: 2px solid #ddd; border-radius: 6px;">
                    <small style="color: #666; display: block; margin-top: 5px;">
                        Upload payment confirmation screenshot for faster verification
                    </small>
                </div>
            <% } else { %>
            <form action="<%=request.getContextPath()%>/candidate" method="post" id="paymentForm">
                <input type="hidden" name="action" value="processPayment">
                <input type="hidden" name="candidateId" value="<%= candidateId %>">
                <input type="hidden" name="amount" value="<%= registrationFee %>">
                
                <div class="payment-methods">
                    <h4 style="margin-bottom: 20px;">Select Payment Method</h4>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('upi')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="upi" required>
                            <span class="payment-method-icon">📱</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">UPI Payment</div>
                                <div class="payment-method-desc">Pay using Google Pay, PhonePe, Paytm, etc.</div>
                            </div>
                        </label>
                    </div>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('card')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="card" required>
                            <span class="payment-method-icon">💳</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">Credit/Debit Card</div>
                                <div class="payment-method-desc">Pay using your Visa, Mastercard, or Rupay card</div>
                            </div>
                        </label>
                    </div>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('netbanking')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="netbanking" required>
                            <span class="payment-method-icon">🏦</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">Net Banking</div>
                                <div class="payment-method-desc">Pay directly from your bank account</div>
                            </div>
                        </label>
                    </div>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('wallet')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="wallet" required>
                            <span class="payment-method-icon">👛</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">Wallet</div>
                                <div class="payment-method-desc">Pay using Paytm Wallet, MobiKwik, etc.</div>
                            </div>
                        </label>
                    </div>
                </div>
                <% } %>
                
                <!-- Terms and Conditions Checkbox -->
                <div class="terms-section" style="margin: 25px 0; padding: 20px; background: #f8f9fa; border-radius: 8px; border: 2px solid #e0e0e0;">
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
                
                <% if (!useQRCode) { %>
                <div class="alert alert-info" style="margin-bottom: 20px;">
                    <strong>📌 Important:</strong> Your candidate account will be activated immediately after successful payment. 
                    You will receive a confirmation email with the transaction details.
                </div>
                <% } %>
                
                <div style="display: flex; gap: 15px; justify-content: space-between;">
                    <a href="manage-candidates.jsp" class="btn btn-secondary" style="flex: 1;">Cancel</a>
                    <button type="submit" class="btn btn-primary" id="payButton" style="flex: 2;" disabled>
                        <% if (useQRCode) { %>
                            Submit Transaction Details
                        <% } else { %>
                            Proceed to Pay ₹<%= String.format("%.2f", registrationFee) %>
                        <% } %>
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2024 <%= MessageBundle.getMessage(request, "app.title") %>. <%= MessageBundle.getMessage(request, "footer.rights") %></p>
    </footer>
    
    <!-- Terms and Conditions Modal -->
    <div id="termsModal" style="display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.8); overflow: auto;">
        <div style="background-color: white; margin: 5% auto; padding: 0; border-radius: 12px; width: 90%; max-width: 800px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-height: 85vh; display: flex; flex-direction: column;">
            <!-- Modal Header -->
            <div style="padding: 25px 30px; border-bottom: 2px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px 12px 0 0;">
                <h2 style="margin: 0; color: white; font-size: 24px; font-weight: 600;">
                    📜 Terms and Conditions
                </h2>
                <button onclick="closeTermsModal()" style="background: rgba(255,255,255,0.2); border: none; color: white; font-size: 28px; font-weight: bold; cursor: pointer; width: 40px; height: 40px; border-radius: 50%; transition: all 0.3s; display: flex; align-items: center; justify-content: center;" onmouseover="this.style.background='rgba(255,255,255,0.3)'" onmouseout="this.style.background='rgba(255,255,255,0.2)'">&times;</button>
            </div>
            
            <!-- Modal Body (Scrollable) -->
            <div style="padding: 30px; overflow-y: auto; flex: 1; line-height: 1.8; color: #333; font-size: 15px;">
                <%
                    try {
                        java.io.File termsFile = new java.io.File(application.getRealPath("/") + "Document/Terms and Conditions");
                        if (termsFile.exists()) {
                            java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.FileReader(termsFile));
                            String line;
                            out.println("<div style='white-space: pre-wrap; font-family: Arial, sans-serif;'>");
                            while ((line = reader.readLine()) != null) {
                                out.println(line);
                                out.println("<br>");
                            }
                            out.println("</div>");
                            reader.close();
                        } else {
                            out.println("<p style='color: #dc3545;'>Terms and Conditions file not found.</p>");
                        }
                    } catch(Exception e) {
                        out.println("<p style='color: #dc3545;'>Error loading Terms and Conditions: " + e.getMessage() + "</p>");
                    }
                %>
            </div>
            
            <!-- Modal Footer -->
            <div style="padding: 20px 30px; border-top: 2px solid #e0e0e0; background: #f8f9fa; border-radius: 0 0 12px 12px; display: flex; gap: 15px; justify-content: flex-end;">
                <button onclick="closeTermsModal()" class="btn btn-secondary" style="padding: 12px 24px;">
                    Close
                </button>
                <button onclick="acceptAndClose()" class="btn btn-primary" style="padding: 12px 24px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(102,126,234,0.4)'" onmouseout="this.style.transform=''; this.style.boxShadow=''">
                    I Accept / मी स्वीकारतो ✓
                </button>
            </div>
        </div>
    </div>
    
    <% if (!useQRCode) { %>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <% } %>
    <script>
        // Terms and Conditions Modal Functions
        function showTermsModal() {
            document.getElementById('termsModal').style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        }
        
        function closeTermsModal() {
            document.getElementById('termsModal').style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
        }
        
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
                acceptedTimestampField.value = new Date().toISOString();
                console.log('Terms accepted at:', acceptedTimestampField.value);
            } else {
                payButton.disabled = true;
                payButton.style.opacity = '0.5';
                payButton.style.cursor = 'not-allowed';
                acceptedTimestampField.value = '';
            }
        });
        
        // Initial state - button disabled
        payButton.style.opacity = '0.5';
        payButton.style.cursor = 'not-allowed';
        
        console.log('🔧 Script loaded - Setting up form handler');
        console.log('Payment Mode: <%= paymentMode %>');
        console.log('useQRCode: <%= useQRCode %>');
        
        <% if (!useQRCode) { %>
        // RAZORPAY MODE ONLY
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
                
                // Show status on page
                if (isRazorpayConfigured) {
                    console.log('✅ Razorpay API is CONFIGURED - Will use real payment');
                } else {
                    console.log('⚠️ Razorpay API NOT configured - Will use demo mode');
                    console.log('Key ID:', config.keyId);
                }
            })
            .catch(error => {
                console.error('Failed to load Razorpay config:', error);
                configLoaded = true;
            });
        <% } %>
        
        // Handle payment form submission (FOR BOTH MODES)
        console.log('Attaching event listener to form...');
        const paymentFormElement = document.getElementById('paymentForm');
        if (!paymentFormElement) {
            console.error('❌ ERROR: paymentForm element not found!');
        } else {
            console.log('✅ paymentForm element found, attaching listener...');
        }
        
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            console.log('🎯 FORM SUBMIT EVENT TRIGGERED!');
            
            // Debug: Show payment mode
            console.log('=== PAYMENT MODE DEBUG ===');
            console.log('Payment Mode from JSP: <%= paymentMode %>');
            console.log('useQRCode flag: <%= useQRCode %>');
            console.log('========================');
            
            // Validate terms and conditions first
            if (!termsCheckbox.checked) {
                e.preventDefault();
                alert('⚠️ Please accept the Terms and Conditions before proceeding with payment.\n\nकृपया पेमेंट करण्यापूर्वी अटी व नियम स्वीकारा.');
                termsCheckbox.focus();
                document.querySelector('.terms-section').style.border = '2px solid #dc3545';
                setTimeout(() => {
                    document.querySelector('.terms-section').style.border = '2px solid #e0e0e0';
                }, 2000);
                return;
            }
            
            <% if (!useQRCode) { %>
            // Only validate payment method for Razorpay mode
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
            if (!paymentMethod) {
                e.preventDefault();
                alert('Please select a payment method');
                return;
            }
            <% } %>
            
            <% if (useQRCode) { %>
                // QR Code mode - allow normal form submission
                console.log('✅ QR CODE MODE ACTIVE - Allowing form submission');
                console.log('📱 QR Code payment - Submitting form to servlet');
                console.log('Form action:', this.action);
                console.log('Form will submit to:', this.action);
                // Don't call e.preventDefault() - let form submit normally
                return true; // Explicitly allow form submission
            <% } else { %>
                // Razorpay mode - prevent default and use API
                console.log('🚫 Preventing default form submission for Razorpay');
                e.preventDefault();
                
                // Wait for config to load if still loading
                if (typeof configLoaded !== 'undefined' && !configLoaded) {
                    console.log('⏳ Waiting for config to load...');
                    setTimeout(() => {
                        document.getElementById('paymentForm').dispatchEvent(new Event('submit'));
                    }, 500);
                    return;
                }
                
                console.log('💳 Processing payment...');
                console.log('isRazorpayConfigured:', typeof isRazorpayConfigured !== 'undefined' ? isRazorpayConfigured : 'N/A');
                
                if (typeof isRazorpayConfigured !== 'undefined' && isRazorpayConfigured) {
                    console.log('🚀 Using Razorpay API');
                    initiateRazorpayPayment();
                } else {
                    console.log('❌ Razorpay not configured!');
                    alert('⚠️ Payment Gateway Not Configured!\n\n' +
                          'Razorpay credentials are not set up.\n\n' +
                          'To enable real payments:\n' +
                          '1. Get credentials from https://razorpay.com\n' +
                          '2. Set environment variables:\n' +
                          '   - RAZORPAY_KEY_ID\n' +
                          '   - RAZORPAY_KEY_SECRET\n' +
                          '3. Restart the server\n\n' +
                          'Please contact administrator to configure payment gateway.');
                    return false;
                }
            <% } %>
        });
        
        function initiateRazorpayPayment() {
            const amount = <%= registrationFee %>;
            const candidateId = <%= candidateId %>;
            
            // Create Razorpay order
            fetch('<%=request.getContextPath()%>/payment?action=createOrder', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'amount=' + amount + '&paymentType=candidate&entityId=' + candidateId
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
                    description: 'Candidate Registration Fee',
                    image: razorpayConfig.companyLogo,
                    order_id: orderData.id,
                    handler: function (response) {
                        verifyPayment(response);
                    },
                    prefill: {
                        name: '<%= user.getFullName() %>',
                        email: '<%= user.getEmail() %>',
                        contact: '<%= user.getMobile() != null ? user.getMobile() : "" %>'
                    },
                    theme: {
                        color: '#667eea'
                    },
                    modal: {
                        ondismiss: function() {
                            alert('Payment cancelled');
                        }
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
        
        function selectPaymentMethod(method) {
            // Remove selected class from all methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked method
            event.currentTarget.classList.add('selected');
            
            // Check the radio button
            document.querySelector(`input[value="${method}"]`).checked = true;
        }
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.dao.UserDAO" %>
<%
    User user = (User) session.getAttribute("user");
    Candidate candidate = (Candidate) session.getAttribute("candidate");
    
    if(user == null || !"user".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    String error = request.getParameter("referralError");
    String success = request.getParameter("referralSuccess");
    
    // Check if user has a broker assigned
    Integer brokerId = user.getBrokerId();
    boolean hasBroker = (brokerId != null && brokerId > 0);
    
    // Get broker details if user has a broker
    User broker = null;
    if (hasBroker) {
        UserDAO userDAO = new UserDAO();
        broker = userDAO.getUserById(brokerId);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "referral.map.title") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Inter', 'Noto Sans Devanagari', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .main-content {
            flex: 1;
            padding: 40px 30px;
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 40px;
            animation: slideUp 0.4s ease-out;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .card-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .card-header h1 {
            font-size: 1.8rem;
            color: #1a202c;
            margin-bottom: 10px;
        }
        
        .card-header p {
            color: #718096;
            font-size: 14px;
        }
        
        .candidate-info {
            background: #eff6ff;
            border-left: 3px solid #3b82f6;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 13px;
        }
        
        .candidate-info strong {
            color: #1e3a8a;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2d3748;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-control.error {
            border-color: #e53e3e;
        }
        
        .error-message {
            color: #e53e3e;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid;
        }
        
        .alert-danger {
            background: #fee;
            color: #c53030;
            border-left-color: #e53e3e;
        }
        
        .alert-success {
            background: #f0fdf4;
            color: #22543d;
            border-left-color: #48bb78;
        }
        
        .info-box {
            background: #e6f7ff;
            border-left: 3px solid #1890ff;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 13px;
            color: #0050b3;
        }
        
        .info-box strong {
            display: block;
            margin-bottom: 5px;
        }
        
        .success-box {
            background: #f0fdf4;
            border-left: 3px solid #48bb78;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 14px;
            color: #22543d;
        }
        
        .success-box strong {
            display: block;
            margin-bottom: 5px;
        }
        
        .validation-feedback {
            font-size: 12px;
            margin-top: 5px;
            font-weight: 600;
        }
        
        .validation-feedback.valid {
            color: #48bb78;
        }
        
        .validation-feedback.invalid {
            color: #e53e3e;
        }
        
        .validation-feedback.checking {
            color: #ed8936;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
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
            width: 100%;
        }
        
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .form-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 25px;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.2s;
        }
        
        .back-link a:hover {
            color: #764ba2;
            text-decoration: underline;
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
        
        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .card {
                padding: 20px 15px;
            }
            
            h1 {
                font-size: 1.4rem;
            }
            
            .form-control {
                padding: 12px;
                font-size: 16px;
            }
            
            .btn {
                padding: 14px;
                min-height: 48px;
            }
            
            .info-card {
                padding: 15px;
            }
        }
        
        @media (max-width: 480px) {
            .card {
                padding: 15px 10px;
            }
            
            h1 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <jsp:include page="/includes/user-navbar.jsp" />
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="card">
            <div class="card-header">
                <h1>🎁 <%= MessageBundle.getMessage(request, "referral.map.title") %></h1>
                <p><%= MessageBundle.getMessage(request, "referral.map.subtitle") %></p>
            </div>
            
            <% if (candidate != null) { %>
            <div class="candidate-info">
                📌 <strong><%= MessageBundle.getMessage(request, "user.managing") %>:</strong> <%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <%= candidate.getNominationId() %><% } %>
            </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-danger">❌ <%= error %></div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success">✅ <%= success %></div>
            <% } %>
            
            <% if (!hasBroker) { %>
                <!-- Referral Code Mapping Form -->
                <div class="info-box">
                    <strong>ℹ️ <%= MessageBundle.getMessage(request, "referral.code.info") %></strong>
                    <%= MessageBundle.getMessage(request, "referral.code.info.text") %>
                </div>
                
                <form id="referralCodeForm" action="<%= request.getContextPath() %>/user/map-referral-code" method="post">
                    <div class="form-group">
                        <label for="referralCode"><%= MessageBundle.getMessage(request, "referral.code.label") %> <span style="color: #718096; font-weight: normal;">(<%= MessageBundle.getMessage(request, "form.optional") %>)</span></label>
                        <input type="text" 
                               class="form-control" 
                               id="referralCode" 
                               name="referralCode" 
                               placeholder="<%= MessageBundle.getMessage(request, "referral.code.placeholder") %>" 
                               maxlength="20" 
                               style="text-transform: uppercase;">
                        <div class="validation-feedback" id="referralValidation"></div>
                        <div class="error-message" id="referralCode-error"></div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="mapReferralBtn" disabled>
                            🔗 <%= MessageBundle.getMessage(request, "referral.code.map.button") %>
                        </button>
                    </div>
                </form>
            <% } else { %>
                <!-- Already Mapped Message -->
                <div class="success-box">
                    <strong>✅ <%= MessageBundle.getMessage(request, "referral.code.already.mapped") %></strong>
                    <%= MessageBundle.getMessage(request, "referral.code.already.mapped.text") %>
                </div>
                
                <% if (broker != null) { %>
                <!-- Broker Information -->
                <div class="info-box" style="background: #f0f9ff; border-left-color: #3b82f6; margin-top: 20px;">
                    <strong>📋 <%= MessageBundle.getMessage(request, "broker.details") %>:</strong>
                    <div style="margin-top: 10px; line-height: 1.8;">
                        <div style="display: flex; align-items: center; margin-bottom: 8px;">
                            <span style="font-weight: 600; min-width: 140px;"><%= MessageBundle.getMessage(request, "broker.name") %>:</span>
                            <span style="color: #1e40af; font-weight: 600;"><%= broker.getFullName() %></span>
                        </div>
                        <div style="display: flex; align-items: center; margin-bottom: 8px;">
                            <span style="font-weight: 600; min-width: 140px;"><%= MessageBundle.getMessage(request, "broker.email") %>:</span>
                            <span><%= broker.getEmail() != null ? broker.getEmail() : "N/A" %></span>
                        </div>
                        <div style="display: flex; align-items: center; margin-bottom: 8px;">
                            <span style="font-weight: 600; min-width: 140px;"><%= MessageBundle.getMessage(request, "broker.phone") %>:</span>
                            <span><%= broker.getMobile() != null ? broker.getMobile() : "N/A" %></span>
                        </div>
                        <% if (broker.getReferralCode() != null && !broker.getReferralCode().trim().isEmpty()) { %>
                        <div style="display: flex; align-items: center;">
                            <span style="font-weight: 600; min-width: 140px;"><%= MessageBundle.getMessage(request, "referral.code") %>:</span>
                            <span style="background: #dbeafe; padding: 4px 12px; border-radius: 4px; font-family: monospace; font-weight: 600; color: #1e40af;"><%= broker.getReferralCode() %></span>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } %>
            
            <div class="back-link">
                <a href="dashboard.jsp">← <%= MessageBundle.getMessage(request, "action.back") %> to <%= MessageBundle.getMessage(request, "nav.dashboard") %></a>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer>
        <p><%= MessageBundle.getMessage(request, "footer.copyright") %></p>
    </footer>
    
    <script>
        <% if (!hasBroker) { %>
        // Referral Code Validation
        const referralInput = document.getElementById('referralCode');
        const referralValidation = document.getElementById('referralValidation');
        const mapReferralBtn = document.getElementById('mapReferralBtn');
        const referralForm = document.getElementById('referralCodeForm');
        
        let validationTimeout;
        let lastValidatedCode = '';
        let isValidCode = false;
        
        // Real-time validation
        referralInput.addEventListener('input', function() {
            const code = this.value.toUpperCase().trim();
            this.value = code; // Update input to uppercase
            
            // Clear previous timeout
            clearTimeout(validationTimeout);
            
            // Reset validation state
            referralValidation.textContent = '';
            referralValidation.className = 'validation-feedback';
            mapReferralBtn.disabled = true;
            isValidCode = false;
            
            // Validate format first
            if (code.length === 0) {
                return;
            }
            
            if (code.length < 6) {
                referralValidation.textContent = '⚠️ <%= MessageBundle.getMessage(request, "referral.code.min.length") %>';
                referralValidation.className = 'validation-feedback invalid';
                return;
            }
            
            if (!code.match(/^[A-Z0-9]{6,20}$/)) {
                referralValidation.textContent = '❌ <%= MessageBundle.getMessage(request, "referral.code.invalid.format") %>';
                referralValidation.className = 'validation-feedback invalid';
                return;
            }
            
            // Skip validation if same as last validated code
            if (code === lastValidatedCode && isValidCode) {
                referralValidation.textContent = '✓ <%= MessageBundle.getMessage(request, "referral.code.valid") %>';
                referralValidation.className = 'validation-feedback valid';
                mapReferralBtn.disabled = false;
                return;
            }
            
            // Show checking message
            referralValidation.textContent = '🔄 <%= MessageBundle.getMessage(request, "referral.code.checking") %>';
            referralValidation.className = 'validation-feedback checking';
            
            // Validate with server after 500ms delay
            validationTimeout = setTimeout(() => {
                validateReferralCode(code);
            }, 500);
        });
        
        function validateReferralCode(code) {
            fetch('<%= request.getContextPath() %>/validate-referral?code=' + encodeURIComponent(code))
                .then(response => response.json())
                .then(data => {
                    lastValidatedCode = code;
                    
                    if (data.valid) {
                        isValidCode = true;
                        referralValidation.textContent = '✓ <%= MessageBundle.getMessage(request, "referral.code.valid") %> ' + data.brokerName;
                        referralValidation.className = 'validation-feedback valid';
                        mapReferralBtn.disabled = false;
                    } else {
                        isValidCode = false;
                        referralValidation.textContent = '❌ ' + (data.message || '<%= MessageBundle.getMessage(request, "referral.code.invalid") %>');
                        referralValidation.className = 'validation-feedback invalid';
                        mapReferralBtn.disabled = true;
                    }
                })
                .catch(error => {
                    console.error('Error validating referral code:', error);
                    referralValidation.textContent = '❌ <%= MessageBundle.getMessage(request, "referral.code.validation.error") %>';
                    referralValidation.className = 'validation-feedback invalid';
                    mapReferralBtn.disabled = true;
                });
        }
        
        // Form submission validation
        referralForm.addEventListener('submit', function(e) {
            if (!isValidCode) {
                e.preventDefault();
                alert('Please enter a valid referral code');
                return false;
            }
        });
        <% } %>
    </script>
</body>
</html>

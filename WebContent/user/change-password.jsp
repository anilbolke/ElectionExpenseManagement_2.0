<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%
    User user = (User) session.getAttribute("user");
    Candidate candidate = (Candidate) session.getAttribute("candidate");
    
    if (user == null || !"user".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String referralError = request.getParameter("referralError");
    String referralSuccess = request.getParameter("referralSuccess");
    
    // Check if user has a broker assigned
    Integer brokerId = user.getBrokerId();
    boolean hasBroker = (brokerId != null && brokerId > 0);
    
    // Debug output
    System.out.println("DEBUG Change Password Page - User ID: " + user.getUserId());
    System.out.println("DEBUG Change Password Page - Broker ID: " + brokerId);
    System.out.println("DEBUG Change Password Page - Has Broker: " + hasBroker);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - <%= MessageBundle.getMessage(request, "app.title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', 'Noto Sans Devanagari', 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 0 20px;
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
        .required {
            color: #e53e3e;
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
        
        .password-strength {
            margin-top: 8px;
        }
        .password-strength-bar {
            height: 4px;
            border-radius: 2px;
            transition: all 0.3s;
            background: #e2e8f0;
        }
        .password-strength-bar.weak {
            background: #f56565;
        }
        .password-strength-bar.medium {
            background: #ed8936;
        }
        .password-strength-bar.strong {
            background: #48bb78;
        }
        
        .password-match {
            font-size: 12px;
            margin-top: 5px;
            font-weight: 600;
        }
        .password-match.match {
            color: #48bb78;
        }
        .password-match.no-match {
            color: #e53e3e;
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
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
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
            gap: 10px;
            margin-top: 25px;
        }
        
        .password-requirements {
            background: #f7fafc;
            padding: 12px;
            border-radius: 6px;
            margin-top: 8px;
            font-size: 12px;
            color: #4a5568;
        }
        .password-requirements ul {
            margin: 5px 0 0 20px;
        }
        .password-requirements li {
            margin: 3px 0;
        }
        
        .divider {
            height: 1px;
            background: #e2e8f0;
            margin: 40px 0;
        }
        
        .referral-section {
            margin-top: 30px;
        }
        
        .info-box {
            background: #e6f7ff;
            border-left: 3px solid #1890ff;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #0050b3;
        }
        
        .success-box {
            background: #f0fdf4;
            border-left: 3px solid #48bb78;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #22543d;
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
    </style>
</head>
<body>
    <!-- Navigation -->
    <jsp:include page="/includes/user-navbar.jsp" />
    
    <!-- Main Content -->
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h1>🔒 Change Password</h1>
                <p>Update your account password</p>
            </div>
            
            <% if (candidate != null) { %>
            <div class="candidate-info">
                📌 <strong>Managing Candidate:</strong> <%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <%= candidate.getNominationId() %><% } %>
            </div>
            <% } %>
            
            <!-- DEBUG INFO - Remove after testing -->
            <div style="background: #fff3cd; border: 1px solid #ffc107; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
                <strong>Debug Info:</strong><br>
                User ID: <%= user.getUserId() %><br>
                Broker ID: <%= brokerId %><br>
                Has Broker: <%= hasBroker %><br>
                Referral Section Will Show: <%= !hasBroker %>
            </div>
            
            <% if (error != null) { %>
                <div class="alert alert-danger">❌ <%= error %></div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success">✅ <%= success %></div>
            <% } %>
            
            <% if (referralError != null) { %>
                <div class="alert alert-danger">❌ <%= referralError %></div>
            <% } %>
            
            <% if (referralSuccess != null) { %>
                <div class="alert alert-success">✅ <%= referralSuccess %></div>
            <% } %>
            
            <form id="changePasswordForm" action="<%= request.getContextPath() %>/change-password" method="post">
                <div class="form-group">
                    <label for="currentPassword">Current Password <span class="required">*</span></label>
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    <div class="error-message" id="currentPassword-error"></div>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password <span class="required">*</span></label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="password-requirements">
                        <strong>Password requirements:</strong>
                        <ul>
                            <li>At least 6 characters long</li>
                            <li>Different from current password</li>
                            <li>Stronger passwords include uppercase, lowercase, numbers, and special characters</li>
                        </ul>
                    </div>
                    <div class="error-message" id="newPassword-error"></div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password <span class="required">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <div class="password-match" id="passwordMatch"></div>
                    <div class="error-message" id="confirmPassword-error"></div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">🔒 Change Password</button>
                </div>
                
                <div style="margin-top: 20px; text-align: center;">
                    <a href="dashboard.jsp" style="color: #667eea; text-decoration: none; font-size: 14px;">← Back to Dashboard</a>
                </div>
            </form>
            
            <!-- Referral Code Mapping Section -->
            <% if (!hasBroker) { %>
            <div class="divider"></div>
            
            <div class="referral-section">
                <div class="card-header" style="margin-bottom: 20px;">
                    <h1 style="font-size: 1.5rem;">🎁 Map Referral Code</h1>
                    <p>Connect with a broker using their referral code</p>
                </div>
                
                <div class="info-box">
                    ℹ️ <strong>What is a Referral Code?</strong><br>
                    If you were referred by a broker, you can enter their referral code here to link your account. This is optional but helps track referrals.
                </div>
                
                <form id="referralCodeForm" action="<%= request.getContextPath() %>/user/map-referral-code" method="post">
                    <div class="form-group">
                        <label for="referralCode">Referral Code <span style="color: #718096; font-weight: normal;">(Optional)</span></label>
                        <input type="text" class="form-control" id="referralCode" name="referralCode" 
                               placeholder="Enter broker's referral code" 
                               maxlength="20" 
                               style="text-transform: uppercase;">
                        <div class="validation-feedback" id="referralValidation"></div>
                        <div class="error-message" id="referralCode-error"></div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="mapReferralBtn" disabled>
                            🔗 Map Referral Code
                        </button>
                    </div>
                </form>
            </div>
            <% } else { %>
            <div class="divider"></div>
            
            <div class="referral-section">
                <div class="success-box">
                    ✅ <strong>Referral Code Already Mapped</strong><br>
                    Your account is already linked to a broker. You cannot change the referral code once it's been set.
                </div>
            </div>
            <% } %>
        </div>
    </div>
    
    <script>
        const form = document.getElementById('changePasswordForm');
        
        // Password strength indicator
        document.getElementById('newPassword').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('strengthBar');
            
            if (!password) {
                strengthBar.style.width = '0%';
                strengthBar.className = 'password-strength-bar';
                return;
            }
            
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            strengthBar.className = 'password-strength-bar';
            if (strength <= 2) {
                strengthBar.classList.add('weak');
                strengthBar.style.width = '33%';
            } else if (strength <= 4) {
                strengthBar.classList.add('medium');
                strengthBar.style.width = '66%';
            } else {
                strengthBar.classList.add('strong');
                strengthBar.style.width = '100%';
            }
        });
        
        // Password match indicator
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            const matchIndicator = document.getElementById('passwordMatch');
            
            if (confirmPassword) {
                if (newPassword === confirmPassword) {
                    matchIndicator.textContent = '✓ Passwords match';
                    matchIndicator.className = 'password-match match';
                } else {
                    matchIndicator.textContent = '✗ Passwords do not match';
                    matchIndicator.className = 'password-match no-match';
                }
            } else {
                matchIndicator.textContent = '';
                matchIndicator.className = 'password-match';
            }
        });
        
        // Form validation
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            let isValid = true;
            
            // Clear previous errors
            document.querySelectorAll('.error-message').forEach(el => el.classList.remove('show'));
            document.querySelectorAll('.form-control').forEach(el => el.classList.remove('error'));
            
            // Validate current password
            if (!currentPassword) {
                showError('currentPassword', 'Current password is required');
                isValid = false;
            }
            
            // Validate new password
            if (!newPassword) {
                showError('newPassword', 'New password is required');
                isValid = false;
            } else if (newPassword.length < 6) {
                showError('newPassword', 'Password must be at least 6 characters');
                isValid = false;
            } else if (newPassword === currentPassword) {
                showError('newPassword', 'New password must be different from current password');
                isValid = false;
            }
            
            // Validate confirm password
            if (!confirmPassword) {
                showError('confirmPassword', 'Please confirm your new password');
                isValid = false;
            } else if (newPassword !== confirmPassword) {
                showError('confirmPassword', 'Passwords do not match');
                isValid = false;
            }
            
            if (isValid) {
                form.submit();
            }
        });
        
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + '-error');
            
            field.classList.add('error');
            if (errorElement) {
                errorElement.textContent = message;
                errorElement.classList.add('show');
            }
        }
        
        // Referral Code Validation
        <% if (!hasBroker) { %>
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
                referralValidation.textContent = '⚠️ Referral code must be at least 6 characters';
                referralValidation.className = 'validation-feedback invalid';
                return;
            }
            
            if (!code.match(/^[A-Z0-9]{6,20}$/)) {
                referralValidation.textContent = '❌ Invalid format. Use only letters and numbers';
                referralValidation.className = 'validation-feedback invalid';
                return;
            }
            
            // Skip validation if same as last validated code
            if (code === lastValidatedCode && isValidCode) {
                referralValidation.textContent = '✓ Valid referral code';
                referralValidation.className = 'validation-feedback valid';
                mapReferralBtn.disabled = false;
                return;
            }
            
            // Show checking message
            referralValidation.textContent = '🔄 Checking referral code...';
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
                        referralValidation.textContent = '✓ Valid referral code - Broker: ' + data.brokerName;
                        referralValidation.className = 'validation-feedback valid';
                        mapReferralBtn.disabled = false;
                    } else {
                        isValidCode = false;
                        referralValidation.textContent = '❌ ' + (data.message || 'Invalid referral code');
                        referralValidation.className = 'validation-feedback invalid';
                        mapReferralBtn.disabled = true;
                    }
                })
                .catch(error => {
                    console.error('Error validating referral code:', error);
                    referralValidation.textContent = '❌ Error validating code. Please try again.';
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

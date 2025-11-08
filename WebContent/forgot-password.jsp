<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Election Expense Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Noto Sans Devanagari', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            max-width: 500px;
            width: 100%;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px 40px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        
        h1 {
            font-size: 28px;
            color: #1a202c;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #718096;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #fee;
            color: #c53030;
            border: 1px solid #fc8181;
        }
        
        .alert-success {
            background: #f0fdf4;
            color: #22543d;
            border: 1px solid #9ae6b4;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #a0aec0;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 15px;
            font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
            transition: all 0.3s;
            background: #f7fafc;
        }
        
        input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #a0aec0;
            cursor: pointer;
            font-size: 18px;
            padding: 5px;
        }
        
        .password-toggle:hover {
            color: #667eea;
        }
        
        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 15px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #f7fafc;
            color: #4a5568;
            border: 2px solid #e2e8f0;
        }
        
        .btn-secondary:hover {
            background: #e2e8f0;
        }
        
        .divider {
            text-align: center;
            margin: 25px 0;
            color: #a0aec0;
            font-size: 14px;
            position: relative;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: #e2e8f0;
        }
        
        .divider::before {
            left: 0;
        }
        
        .divider::after {
            right: 0;
        }
        
        .back-to-login {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-to-login a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }
        
        .back-to-login a:hover {
            text-decoration: underline;
        }
        
        .new-password-section {
            display: none;
        }
        
        .new-password-section.active {
            display: block;
        }
        
        .validation-section {
            display: block;
        }
        
        .validation-section.hidden {
            display: none;
        }
        
        .info-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        @media (max-width: 480px) {
            .container {
                padding: 40px 25px;
            }
            
            h1 {
                font-size: 24px;
            }
        }
        
        /* Additional mobile enhancements */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .container {
                padding: 10px;
                max-width: 100%;
            }
            
            .card {
                padding: 25px 20px;
                border-radius: 12px;
            }
            
            h1 {
                font-size: 1.5rem;
            }
            
            .subtitle {
                font-size: 0.9rem;
            }
            
            .form-group label {
                font-size: 0.9rem;
            }
            
            .form-control {
                padding: 12px;
                font-size: 16px; /* Prevent iOS zoom */
                border-radius: 8px;
            }
            
            .btn-primary,
            .btn-secondary {
                padding: 14px;
                font-size: 1rem;
                min-height: 48px;
                border-radius: 8px;
            }
            
            .alert {
                padding: 12px;
                font-size: 0.9rem;
                border-radius: 8px;
            }
        }
        
        @media (max-width: 480px) {
            .card {
                padding: 20px 15px;
            }
            
            h1 {
                font-size: 1.3rem;
            }
            
            .subtitle {
                font-size: 0.85rem;
            }
            
            .form-control {
                padding: 11px;
                font-size: 15px;
            }
            
            .btn-primary,
            .btn-secondary {
                padding: 13px;
                font-size: 0.95rem;
            }
        }
        
        /* Touch optimizations */
        @media (hover: none) and (pointer: coarse) {
            .form-control,
            .btn-primary,
            .btn-secondary {
                min-height: 44px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">🔐</div>
            <h1>पासवर्ड पुनर्प्राप्ती<br>Forgot Password</h1>
            <p class="subtitle">
                Enter your username, mobile number, or email to reset your password
            </p>
        </div>
        
        <!-- Alert Messages -->
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <span>⚠️</span>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>
        
        <% if(request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <span>✓</span>
                <span><%= request.getAttribute("success") %></span>
            </div>
        <% } %>
        
        <!-- Validation Form -->
        <form action="<%=request.getContextPath()%>/forgotPassword" method="post" id="forgotPasswordForm" class="validation-section">
            <input type="hidden" name="action" value="validate">
            
            <div class="info-box">
                <strong>सूचना:</strong> तुमचे युजरनेम, मोबाईल नंबर किंवा ईमेल आयडी यापैकी कोणतीही एक माहिती प्रविष्ट करा. 
                आम्ही तुमचा खाता शोधून तुम्हाला पासवर्ड रीसेट करण्याची परवानगी देऊ.
            </div>
            
            <div class="form-group">
                <label for="identifier">Username / Mobile / Email ID *</label>
                <div class="input-wrapper">
                    <span class="input-icon">👤</span>
                    <input 
                        type="text" 
                        id="identifier" 
                        name="identifier" 
                        placeholder="Enter username, mobile, or email"
                        required
                        autofocus
                    >
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary">
                Verify & Continue
            </button>
        </form>
        
        <!-- New Password Form -->
        <form action="<%=request.getContextPath()%>/forgotPassword" method="post" id="newPasswordForm" class="new-password-section <%= request.getAttribute("showPasswordForm") != null ? "active" : "" %>">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="userId" value="<%= request.getAttribute("userId") != null ? request.getAttribute("userId") : "" %>">
            
            <div class="alert alert-success" style="margin-bottom: 20px;">
                <span>✓</span>
                <span>User verified successfully! Now set your new password.</span>
            </div>
            
            <% if(request.getAttribute("verifiedIdentifier") != null) { %>
            <div class="info-box" style="background: #f0fdf4; border-color: #9ae6b4; color: #22543d; margin-bottom: 20px;">
                <strong>Verified Account:</strong><br>
                <%= request.getAttribute("verifiedIdentifier") %>
                <% if(request.getAttribute("verifiedUsername") != null) { %>
                    <br><strong>Username:</strong> <%= request.getAttribute("verifiedUsername") %>
                <% } %>
            </div>
            <% } %>
            
            <div class="form-group">
                <label for="newPassword">New Password *</label>
                <div class="input-wrapper">
                    <span class="input-icon">🔒</span>
                    <input 
                        type="password" 
                        id="newPassword" 
                        name="newPassword" 
                        placeholder="Enter new password"
                        required
                        minlength="6"
                    >
                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword', 'toggleIcon1')">
                        <span id="toggleIcon1">👁️</span>
                    </button>
                </div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password *</label>
                <div class="input-wrapper">
                    <span class="input-icon">🔒</span>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        placeholder="Re-enter new password"
                        required
                        minlength="6"
                    >
                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', 'toggleIcon2')">
                        <span id="toggleIcon2">👁️</span>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary">
                Reset Password
            </button>
        </form>
        
        <div class="divider">OR</div>
        
        <a href="<%=request.getContextPath()%>/login.jsp" class="btn btn-secondary">
            ← Back to Login
        </a>
        
        <div class="back-to-login">
            Don't have an account? <a href="<%=request.getContextPath()%>/register.jsp">Register Here</a>
        </div>
    </div>
    
    <script>
        function togglePassword(fieldId, iconId) {
            const passwordField = document.getElementById(fieldId);
            const toggleIcon = document.getElementById(iconId);
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.textContent = '👁️‍🗨️';
            } else {
                passwordField.type = 'password';
                toggleIcon.textContent = '👁️';
            }
        }
        
        // Validate password match on submit
        document.getElementById('newPasswordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match! Please try again.');
                return false;
            }
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
        });
    </script>
</body>
</html>

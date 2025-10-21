<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.i18n.LocaleManager" %>
<%@ page import="java.util.Locale" %>
<%
    // Get current language for login page
    Locale currentLocale = LocaleManager.getLocale(request);
    String currentLang = currentLocale.getLanguage();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "login.title") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
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
            position: relative;
            overflow: hidden;
        }
        
        /* Language Selector Styles */
        .language-selector-wrapper {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        
        .language-selector-wrapper .language-selector {
            margin: 0;
        }
        
        /* Animated Background */
        body::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: moveBackground 20s linear infinite;
        }
        
        @keyframes moveBackground {
            0% { transform: translate(0, 0); }
            100% { transform: translate(50px, 50px); }
        }
        
        /* Main Container */
        .login-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            max-width: 1100px;
            width: 100%;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        
        /* Left Side - Branding */
        .login-brand {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        .login-brand::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 2px, transparent 2px);
            background-size: 30px 30px;
        }
        
        .brand-content {
            position: relative;
            z-index: 1;
        }
        
        .brand-logo {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .ballot-icon {
            width: 60px;
            height: 60px;
            background: rgba(255,255,255,0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            backdrop-filter: blur(10px);
        }
        
        .brand-logo h1 {
            font-size: 1.8rem;
            font-weight: 800;
            line-height: 1.2;
        }
        
        .brand-tagline {
            font-size: 1.1rem;
            margin-bottom: 40px;
            opacity: 0.95;
            font-weight: 500;
        }
        
        .features-list {
            list-style: none;
        }
        
        .features-list li {
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 0.95rem;
        }
        
        .features-list li:last-child {
            border-bottom: none;
        }
        
        .feature-icon {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.15);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }
        
        /* Right Side - Login Form */
        .login-form-section {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .form-header {
            margin-bottom: 35px;
        }
        
        .form-header h2 {
            font-size: 2rem;
            font-weight: 800;
            color: #1a202c;
            margin-bottom: 10px;
        }
        
        .form-header p {
            color: #718096;
            font-size: 0.95rem;
        }
        
        /* Alerts */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.9rem;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
        
        .alert-icon {
            font-size: 20px;
        }
        
        /* Form Styles */
        .login-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-group label {
            font-weight: 600;
            color: #2d3748;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .form-group label .required {
            color: #e53e3e;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 18px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
            transition: all 0.3s;
            background: #f7fafc;
        }
        
        .form-control:focus {
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
            display: flex;
            align-items: center;
        }
        
        .password-toggle:hover {
            color: #667eea;
        }
        
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: -5px 0 5px;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: #4a5568;
        }
        
        .remember-me input[type="checkbox"] {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }
        
        .forgot-password {
            color: #667eea;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            transition: color 0.2s;
        }
        
        .forgot-password:hover {
            color: #764ba2;
        }
        
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }
        
        .btn-login:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .btn-login span {
            position: relative;
            z-index: 1;
        }
        
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 25px 0;
            color: #a0aec0;
            font-size: 0.85rem;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .divider span {
            padding: 0 15px;
        }
        
        .register-link {
            text-align: center;
            color: #4a5568;
            font-size: 0.9rem;
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 700;
            transition: color 0.2s;
        }
        
        .register-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        /* Role Selection (Optional) */
        .role-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .role-option {
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: #f7fafc;
        }
        
        .role-option:hover {
            border-color: #667eea;
            background: white;
        }
        
        .role-option.selected {
            border-color: #667eea;
            background: #eff6ff;
            color: #667eea;
        }
        
        .role-icon {
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        .role-name {
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        /* Responsive Design */
        @media (max-width: 968px) {
            .login-container {
                grid-template-columns: 1fr;
                max-width: 500px;
            }
            
            .login-brand {
                padding: 40px 30px;
                text-align: center;
            }
            
            .brand-logo {
                justify-content: center;
            }
            
            .features-list {
                display: none;
            }
            
            .login-form-section {
                padding: 40px 30px;
            }
        }
        
        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .login-form-section {
                padding: 30px 20px;
            }
            
            .form-header h2 {
                font-size: 1.5rem;
            }
            
            .role-selector {
                grid-template-columns: 1fr;
            }
        }
        
        /* Loading State */
        .btn-login.loading {
            pointer-events: none;
            opacity: 0.7;
        }
        
        .btn-login.loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            top: 50%;
            left: 50%;
            margin-left: -8px;
            margin-top: -8px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.6s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Language Selector -->
    <div class="language-selector-wrapper">
        <jsp:include page="/includes/language-selector.jsp" />
    </div>
    
    <div class="login-container">
        <!-- Left Side - Branding -->
        <div class="login-brand">
            <div class="brand-content">
                <div class="brand-logo">
                    <div class="ballot-icon">🗳️</div>
                    <h1><%= MessageBundle.getMessage(request, "app.title") %></h1>
                </div>
                
                <p class="brand-tagline">Transparent. Accountable. Democratic.</p>
                
                <ul class="features-list">
                    <li>
                        <div class="feature-icon">✓</div>
                        <span>Track campaign expenses in real-time</span>
                    </li>
                    <li>
                        <div class="feature-icon">📊</div>
                        <span>Comprehensive financial reporting</span>
                    </li>
                    <li>
                        <div class="feature-icon">🔒</div>
                        <span>Secure & compliant with regulations</span>
                    </li>
                    <li>
                        <div class="feature-icon">👥</div>
                        <span>Multi-user role management</span>
                    </li>
                </ul>
            </div>
        </div>
        
        <!-- Right Side - Login Form -->
        <div class="login-form-section">
            <div class="form-header">
                <h2><%= MessageBundle.getMessage(request, "login.welcome") %></h2>
                <p><%= MessageBundle.getMessage(request, "login.title") %></p>
            </div>
            
            <!-- Alert Messages -->
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <span class="alert-icon">⚠️</span>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    <span><%= request.getAttribute("success") %></span>
                </div>
            <% } %>
            
            <!-- Login Form -->
            <form action="login" method="post" class="login-form" id="loginForm" accept-charset="UTF-8">
                <!-- Hidden field to capture selected language -->
                <input type="hidden" id="selectedLanguage" name="selectedLanguage" value="<%= currentLang %>">
                
                <div class="form-group">
                    <label for="username">
                        <%= MessageBundle.getMessage(request, "login.username") %> <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input 
                            type="text" 
                            id="username" 
                            name="username" 
                            class="form-control" 
                            placeholder="<%= MessageBundle.getMessage(request, "login.username") %>"
                            required 
                            autofocus
                        >
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">
                        <%= MessageBundle.getMessage(request, "login.password") %> <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            class="form-control" 
                            placeholder="<%= MessageBundle.getMessage(request, "login.password") %>"
                            required
                        >
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <span id="toggleIcon">👁️</span>
                        </button>
                    </div>
                </div>
                
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span><%= MessageBundle.getMessage(request, "login.remember") %></span>
                    </label>
                    <a href="#" class="forgot-password"><%= MessageBundle.getMessage(request, "login.forgot.password") %></a>
                </div>
                
                <button type="submit" class="btn-login" id="loginBtn">
                    <span><%= MessageBundle.getMessage(request, "login.submit") %></span>
                </button>
            </form>
            
            <div class="divider">
                <span><%= MessageBundle.getMessage(request, "login.or") %></span>
            </div>
            
            <div class="register-link">
                <%= MessageBundle.getMessage(request, "login.no.account") %> <a href="register.jsp"><%= MessageBundle.getMessage(request, "login.register") %></a>
            </div>
        </div>
    </div>
    
    <script>
        // Override switchLanguage to update hidden field on login page
        function switchLanguage(lang) {
            // Update hidden field with selected language
            var hiddenField = document.getElementById('selectedLanguage');
            if (hiddenField) {
                hiddenField.value = lang;
                console.log('Language preference set to:', lang);
            }
            
            // Perform the language switch (reload page with new language)
            var currentUrl = window.location.href;
            var contextPath = '<%= request.getContextPath() %>';
            window.location.href = contextPath + '/switchLanguage?lang=' + lang + '&redirect=' + encodeURIComponent(currentUrl);
        }
        
        // Password Toggle
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.textContent = '👁️‍🗨️';
            } else {
                passwordField.type = 'password';
                toggleIcon.textContent = '👁️';
            }
        }
        
        // Form Submission Loading State
        document.getElementById('loginForm').addEventListener('submit', function() {
            const btn = document.getElementById('loginBtn');
            btn.classList.add('loading');
            btn.querySelector('span').textContent = '<%= MessageBundle.getMessage(request, "message.loading") %>';
        });
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.animation = 'slideIn 0.3s ease-out reverse';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html>

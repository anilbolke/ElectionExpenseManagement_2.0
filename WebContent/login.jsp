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
        
        /* Social Media Links */
        .social-media-section {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }
        
        .social-media-title {
            text-align: center;
            color: #4a5568;
            font-size: 0.85rem;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .social-links {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .social-link {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 8px;
            transition: all 0.3s;
            text-decoration: none;
            font-size: 20px;
        }
        
        .social-link.youtube {
            background: #FF0000;
            color: white;
        }
        
        .social-link.youtube:hover {
            background: #CC0000;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(255, 0, 0, 0.3);
        }
        
        .social-link.instagram {
            background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%);
            color: white;
        }
        
        .social-link.instagram:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(225, 48, 108, 0.4);
        }
        
        .social-link.facebook {
            background: #1877F2;
            color: white;
        }
        
        .social-link.facebook:hover {
            background: #145dbf;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(24, 119, 242, 0.3);
        }
        
        .social-link.twitter {
            background: #000000;
            color: white;
        }
        
        .social-link.twitter:hover {
            background: #333333;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }
        
        .social-link.linkedin {
            background: #0A66C2;
            color: white;
        }
        
        .social-link.linkedin:hover {
            background: #084d92;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(10, 102, 194, 0.3);
        }
        
        .social-link.whatsapp {
            background: #25D366;
            color: white;
        }
        
        .social-link.whatsapp:hover {
            background: #1da851;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(37, 211, 102, 0.3);
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
        
        /* ================================
           MOBILE RESPONSIVE STYLES
           ================================ */
        
        @media (max-width: 968px) {
            /* Tablet adjustments */
            .login-container {
                grid-template-columns: 1fr;
                max-width: 500px;
            }
            
            .login-brand {
                display: none; /* Hide branding on tablet and mobile */
            }
            
            .login-form-section {
                padding: 40px 30px;
            }
        }
        
        @media (max-width: 768px) {
            /* Mobile - Full responsive */
            body {
                padding: 15px;
                align-items: flex-start;
                padding-top: 60px;
            }
            
            .language-selector-wrapper {
                top: 10px;
                right: 10px;
            }
            
            .login-container {
                border-radius: 15px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            }
            
            .login-form-section {
                padding: 30px 20px;
            }
            
            .login-header h1 {
                font-size: 1.5rem;
            }
            
            .login-header p {
                font-size: 0.9rem;
            }
            
            .form-group label {
                font-size: 0.85rem;
            }
            
            .form-control {
                padding: 12px 15px 12px 40px;
                font-size: 16px; /* Prevent iOS zoom on focus */
            }
            
            .input-icon {
                font-size: 16px;
                left: 12px;
            }
            
            .password-toggle {
                right: 12px;
                font-size: 16px;
            }
            
            .btn-login {
                padding: 14px;
                font-size: 1rem;
                min-height: 48px; /* Touch-friendly */
            }
            
            .login-footer {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .forgot-password,
            .register-link {
                font-size: 0.9rem;
            }
            
            /* Alert adjustments */
            .alert {
                padding: 12px;
                font-size: 0.85rem;
            }
            
            /* Social login buttons */
            .social-login-buttons {
                flex-direction: column;
                gap: 10px;
            }
            
            .social-btn {
                width: 100%;
            }
        }
        
        @media (max-width: 480px) {
            /* Small mobile optimizations */
            body {
                padding: 10px;
                padding-top: 50px;
            }
            
            .login-container {
                border-radius: 12px;
            }
            
            .login-form-section {
                padding: 25px 15px;
            }
            
            .login-header h1 {
                font-size: 1.3rem;
            }
            
            .login-header p {
                font-size: 0.85rem;
            }
            
            .form-group {
                gap: 6px;
            }
            
            .form-control {
                padding: 11px 12px 11px 38px;
                border-radius: 8px;
            }
            
            .btn-login {
                padding: 13px;
                font-size: 0.95rem;
            }
            
            .divider {
                margin: 20px 0;
                font-size: 0.8rem;
            }
            
            .alert {
                padding: 10px;
                font-size: 0.8rem;
                border-radius: 8px;
            }
            
            .alert-icon {
                font-size: 16px;
            }
        }
        
        @media (max-width: 360px) {
            /* Extra small mobile */
            .login-form-section {
                padding: 20px 12px;
            }
            
            .login-header h1 {
                font-size: 1.2rem;
            }
            
            .form-control {
                font-size: 14px;
            }
            
            .btn-login {
                font-size: 0.9rem;
                padding: 12px;
            }
        }
        
        /* Touch device optimizations */
        @media (hover: none) and (pointer: coarse) {
            .form-control,
            .btn-login,
            .social-btn,
            .forgot-password,
            .register-link {
                min-height: 44px; /* iOS touch target */
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }
            
            .form-control:focus {
                /* Reduce zoom effect on iOS */
                font-size: 16px;
            }
        }
        
        /* Landscape mode on mobile */
        @media (max-width: 768px) and (orientation: landscape) {
            body {
                padding-top: 20px;
                align-items: center;
            }
            
            .login-container {
                max-height: 90vh;
                overflow-y: auto;
            }
            
            .login-form-section {
                padding: 25px 20px;
            }
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
                    <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="forgot-password"><%= MessageBundle.getMessage(request, "login.forgot.password") %></a>
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
            
            <!-- Social Media Section -->
            <div class="social-media-section">
                <div class="social-media-title">Connect With Us</div>
                <div class="social-links">
                    <a href="https://www.youtube.com/@emsofficial" target="_blank" class="social-link youtube" title="EMS YouTube Channel">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                        </svg>
                    </a>
                   <!--  <a href="https://www.instagram.com/emsofficial" target="_blank" class="social-link instagram" title="EMS Instagram">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                        </svg>
                    </a>
                    <a href="https://www.facebook.com/emsofficial" target="_blank" class="social-link facebook" title="EMS Facebook">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                        </svg>
                    </a>
                    <a href="https://twitter.com/emsofficial" target="_blank" class="social-link twitter" title="EMS Twitter">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                        </svg>
                    </a>
                    <a href="https://www.linkedin.com/company/emsofficial" target="_blank" class="social-link linkedin" title="EMS LinkedIn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                        </svg>
                    </a> -->
                    <a href="https://wa.me/919422887070" target="_blank" class="social-link whatsapp" title="EMS WhatsApp">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z"/>
                        </svg>
                    </a>
                </div>
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
    
    <!-- Policy Links Footer -->
    <div style="position: fixed; bottom: 0; left: 0; right: 0; background: rgba(255,255,255,0.95); padding: 15px; text-align: center; font-size: 12px; color: #666; border-top: 1px solid #e2e8f0; box-shadow: 0 -2px 10px rgba(0,0,0,0.1); z-index: 1000;">
        <a href="<%= request.getContextPath() %>/terms-and-conditions.jsp" style="color: #667eea; text-decoration: none; margin: 0 10px; font-weight: 600;">Terms & Conditions</a>
        <span style="color: #cbd5e0;">|</span>
        <a href="<%= request.getContextPath() %>/privacy-policy.jsp" style="color: #667eea; text-decoration: none; margin: 0 10px; font-weight: 600;">Privacy Policy</a>
        <span style="color: #cbd5e0;">|</span>
        <a href="<%= request.getContextPath() %>/refund-policy.jsp" style="color: #667eea; text-decoration: none; margin: 0 10px; font-weight: 600;">Refund Policy</a>
        <span style="color: #cbd5e0;">|</span>
        <a href="<%= request.getContextPath() %>/shipping-policy.jsp" style="color: #667eea; text-decoration: none; margin: 0 10px; font-weight: 600;">Shipping Policy</a>
        <span style="color: #cbd5e0;">|</span>
        <a href="<%= request.getContextPath() %>/contact-us.jsp" style="color: #667eea; text-decoration: none; margin: 0 10px; font-weight: 600;">Contact Us</a>
        <br>
        <span style="margin-top: 8px; display: inline-block;">Powered by <a href="https://emsonline.in" target="_blank" style="color: #667eea; text-decoration: none; font-weight: 700;">emsonline.in</a></span>
    </div>
</body>
</html>

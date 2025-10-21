<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "login.title") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
    
    <!-- Fonts for multi-language support -->
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

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-width: 1000px;
            width: 100%;
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        .login-left {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-left h1 {
            font-size: 32px;
            margin-bottom: 20px;
            font-weight: 800;
        }

        .login-left p {
            font-size: 16px;
            line-height: 1.6;
            opacity: 0.9;
        }

        .login-right {
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .language-selector-top {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .form-header h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }

        .form-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
        }

        .form-footer {
            margin-top: 20px;
            text-align: center;
        }

        .form-footer a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-danger {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        .alert-success {
            background-color: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }

        @media (max-width: 768px) {
            .login-container {
                grid-template-columns: 1fr;
            }
            
            .login-left {
                display: none;
            }
        }
    </style>
</head>
<body>

    <!-- Language Selector -->
    <div class="language-selector-top">
        <jsp:include page="/includes/language-selector.jsp" />
    </div>

    <div class="login-container">
        <!-- Left Side - Info -->
        <div class="login-left">
            <h1><%= MessageBundle.getMessage(request, "app.title") %></h1>
            <p><%= MessageBundle.getMessage(request, "login.welcome") %></p>
        </div>

        <!-- Right Side - Form -->
        <div class="login-right">
            <div class="form-header">
                <h2><%= MessageBundle.getMessage(request, "login.title") %></h2>
                <p><%= MessageBundle.getMessage(request, "app.welcome") %></p>
            </div>

            <!-- Error Message -->
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <%= MessageBundle.getMessage(request, "login.error") %>
                </div>
            <% } %>

            <!-- Success Message -->
            <% if (request.getParameter("registered") != null) { %>
                <div class="alert alert-success">
                    <%= MessageBundle.getMessage(request, "register.success") %>
                </div>
            <% } %>

            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/login" method="post" accept-charset="UTF-8">
                <div class="form-group">
                    <label for="username"><%= MessageBundle.getMessage(request, "login.username") %></label>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           placeholder="<%= MessageBundle.getMessage(request, "login.username") %>"
                           required
                           autofocus>
                </div>

                <div class="form-group">
                    <label for="password"><%= MessageBundle.getMessage(request, "login.password") %></label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           placeholder="<%= MessageBundle.getMessage(request, "login.password") %>"
                           required>
                </div>

                <button type="submit" class="btn-login">
                    <%= MessageBundle.getMessage(request, "login.submit") %>
                </button>

                <div class="form-footer">
                    <a href="<%= request.getContextPath() %>/register.jsp">
                        <%= MessageBundle.getMessage(request, "login.register") %>
                    </a>
                    <span style="margin: 0 10px;">|</span>
                    <a href="#">
                        <%= MessageBundle.getMessage(request, "login.forgot.password") %>
                    </a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .error-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            padding: 20px;
        }
        
        .error-card {
            background: white;
            color: #333;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            max-width: 600px;
            width: 100%;
        }
        
        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        
        .error-code {
            font-size: 48px;
            font-weight: bold;
            color: #dc3545;
            margin-bottom: 10px;
        }
        
        .error-message {
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        .error-details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            font-size: 14px;
            text-align: left;
        }
        
        .btn-home {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            font-weight: bold;
            transition: transform 0.3s ease;
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">❌</div>
            
            <% 
                Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
                Exception exception1 = (Exception) request.getAttribute("javax.servlet.error.exception");
                
                if (statusCode == null) {
                    statusCode = 500;
                }
                
                String title = "Error";
                String message = "An unexpected error occurred.";
                
                switch (statusCode) {
                    case 404:
                        title = "Page Not Found";
                        message = "The page you are looking for does not exist.";
                        break;
                    case 403:
                        title = "Access Denied";
                        message = "You don't have permission to access this resource.";
                        break;
                    case 500:
                        title = "Internal Server Error";
                        message = "Something went wrong on our end. Please try again later.";
                        break;
                    default:
                        title = "Error " + statusCode;
                        message = errorMessage != null ? errorMessage : "An error occurred.";
                }
            %>
            
            <div class="error-code"><%= statusCode %></div>
            <div class="error-message"><%= title %></div>
            <p><%= message %></p>
            
            <% if (exception != null && request.isUserInRole("admin")) { %>
            <div class="error-details">
                <strong>Technical Details (Admin Only):</strong><br>
                <%= exception.getClass().getName() %><br>
                <%= exception.getMessage() %>
            </div>
            <% } %>
            
            <a href="<%=request.getContextPath()%>/login.jsp" class="btn-home">Go to Login</a>
            <a href="javascript:history.back()" class="btn-home" style="background: #6c757d;">Go Back</a>
        </div>
    </div>
</body>
</html>

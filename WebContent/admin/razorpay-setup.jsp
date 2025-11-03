<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%@ page import="com.election.util.RazorpayConfig" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Razorpay Integration Status - Admin</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .setup-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
        }
        
        .status-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .status-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .status-icon {
            font-size: 48px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
        }
        
        .badge-success {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .config-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        
        .config-table th,
        .config-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        
        .config-table th {
            background: #f8f9fa;
            font-weight: 600;
        }
        
        .code-block {
            background: #2d3748;
            color: #e2e8f0;
            padding: 20px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            overflow-x: auto;
            margin: 15px 0;
        }
        
        .instructions {
            background: #e7f3ff;
            border-left: 4px solid #0066cc;
            padding: 20px;
            margin: 20px 0;
            border-radius: 4px;
        }
        
        .instructions h4 {
            margin-top: 0;
            color: #0066cc;
        }
        
        .test-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 6px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/admin-navbar.jsp" %>
    
    <div class="setup-container">
        <div class="status-card">
            <div class="status-header">
                <span class="status-icon">💳</span>
                <div style="flex: 1;">
                    <h2 style="margin: 0 0 10px 0;">Razorpay Integration Status</h2>
                    <% if (RazorpayConfig.isConfigured()) { %>
                        <span class="status-badge badge-success">✓ Configured and Ready</span>
                    <% } else { %>
                        <span class="status-badge badge-warning">⚠ Not Configured (Demo Mode)</span>
                    <% } %>
                </div>
            </div>
            
            <table class="config-table">
                <tr>
                    <th>Configuration Item</th>
                    <th>Status</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Razorpay Key ID</td>
                    <td>
                        <% if (RazorpayConfig.getKeyId().startsWith("rzp_")) { %>
                            <span class="status-badge badge-success">✓ Set</span>
                        <% } else { %>
                            <span class="status-badge badge-danger">✗ Not Set</span>
                        <% } %>
                    </td>
                    <td>
                        <% if (RazorpayConfig.getKeyId().startsWith("rzp_")) { %>
                            <%= RazorpayConfig.getKeyId().substring(0, 15) %>...
                        <% } else { %>
                            <em>Using default (demo mode)</em>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <td>Razorpay Key Secret</td>
                    <td>
                        <% if (!RazorpayConfig.getKeySecret().equals("YOUR_KEY_SECRET")) { %>
                            <span class="status-badge badge-success">✓ Set</span>
                        <% } else { %>
                            <span class="status-badge badge-danger">✗ Not Set</span>
                        <% } %>
                    </td>
                    <td>
                        <% if (!RazorpayConfig.getKeySecret().equals("YOUR_KEY_SECRET")) { %>
                            ••••••••••••
                        <% } else { %>
                            <em>Using default (demo mode)</em>
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <td>Currency</td>
                    <td><span class="status-badge badge-success">✓ Set</span></td>
                    <td><%= RazorpayConfig.CURRENCY %></td>
                </tr>
                <tr>
                    <td>Company Name</td>
                    <td><span class="status-badge badge-success">✓ Set</span></td>
                    <td><%= RazorpayConfig.COMPANY_NAME %></td>
                </tr>
            </table>
            
            <% if (!RazorpayConfig.isConfigured()) { %>
                <div class="instructions">
                    <h4>🚀 Setup Instructions</h4>
                    <p><strong>To enable actual Razorpay payment gateway:</strong></p>
                    
                    <ol style="margin: 15px 0; padding-left: 20px;">
                        <li>Sign up at <a href="https://dashboard.razorpay.com/" target="_blank">Razorpay Dashboard</a></li>
                        <li>Navigate to Settings → API Keys</li>
                        <li>Generate Test Keys (for testing) or Live Keys (for production)</li>
                        <li>Set environment variables on your system:</li>
                    </ol>
                    
                    <p><strong>For Windows:</strong></p>
                    <div class="code-block">
setx RAZORPAY_KEY_ID "rzp_test_YOUR_KEY_ID"
setx RAZORPAY_KEY_SECRET "YOUR_KEY_SECRET"
                    </div>
                    
                    <p><strong>For Linux/Mac:</strong></p>
                    <div class="code-block">
export RAZORPAY_KEY_ID="rzp_test_YOUR_KEY_ID"
export RAZORPAY_KEY_SECRET="YOUR_KEY_SECRET"
                    </div>
                    
                    <p><strong>For Tomcat (catalina.properties):</strong></p>
                    <div class="code-block">
RAZORPAY_KEY_ID=rzp_test_YOUR_KEY_ID
RAZORPAY_KEY_SECRET=YOUR_KEY_SECRET
                    </div>
                    
                    <p style="margin-top: 15px;"><strong>5.</strong> Restart your application server</p>
                    <p><strong>6.</strong> Refresh this page to verify configuration</p>
                </div>
            <% } else { %>
                <div class="instructions" style="background: #d4edda; border-color: #28a745;">
                    <h4 style="color: #155724;">✓ Razorpay Configured Successfully!</h4>
                    <p>Your Razorpay integration is active. Users can now make real payments through Razorpay gateway.</p>
                    <p><strong>Next Steps:</strong></p>
                    <ul>
                        <li>Test payment flow with Razorpay test cards</li>
                        <li>Verify payments appear in Razorpay Dashboard</li>
                        <li>When ready for production, replace test keys with live keys</li>
                    </ul>
                </div>
            <% } %>
            
            <div class="test-section">
                <h4>🧪 Testing Payment Integration</h4>
                <p>Use these test cards in Razorpay test mode:</p>
                <table class="config-table">
                    <tr>
                        <th>Card Number</th>
                        <th>Result</th>
                        <th>Description</th>
                    </tr>
                    <tr>
                        <td>4111 1111 1111 1111</td>
                        <td><span class="status-badge badge-success">Success</span></td>
                        <td>Payment will succeed</td>
                    </tr>
                    <tr>
                        <td>4111 1111 1111 1234</td>
                        <td><span class="status-badge badge-danger">Failed</span></td>
                        <td>Payment will fail</td>
                    </tr>
                    <tr>
                        <td colspan="3" style="padding-top: 15px;">
                            <strong>Note:</strong> Use any CVV (3 digits) and any future expiry date
                        </td>
                    </tr>
                </table>
            </div>
            
            <div style="margin-top: 30px; text-align: center;">
                <a href="dashboard.jsp" class="btn btn-secondary">← Back to Dashboard</a>
                <% if (RazorpayConfig.isConfigured()) { %>
                    <a href="../user/subscription.jsp" class="btn btn-primary" style="margin-left: 10px;">Test Payment Flow →</a>
                <% } %>
            </div>
        </div>
        
        <div class="status-card">
            <h3>📚 Documentation</h3>
            <p>For complete integration guide and troubleshooting, see:</p>
            <div class="code-block">
EMS/RAZORPAY_INTEGRATION_GUIDE.md
            </div>
            <p style="margin-top: 15px;">The guide includes:</p>
            <ul>
                <li>Detailed setup instructions</li>
                <li>Payment flow diagrams</li>
                <li>Security features</li>
                <li>Troubleshooting tips</li>
                <li>Production checklist</li>
            </ul>
        </div>
    </div>
    
    <footer style="margin-top: 40px; text-align: center; padding: 20px; background: #2d3748; color: white;">
        <p>&copy; 2024 Election Expense Management System</p>
    </footer>
</body>
</html>

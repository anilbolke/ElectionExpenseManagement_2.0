<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.util.RazorpayConfig" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Razorpay Configuration Test</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        .status {
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
            font-weight: bold;
        }
        .configured {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .not-configured {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info-row {
            display: flex;
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        .info-label {
            flex: 0 0 200px;
            font-weight: bold;
            color: #555;
        }
        .info-value {
            flex: 1;
            font-family: 'Courier New', monospace;
            color: #333;
        }
        .env-check {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .code {
            background: #f4f4f4;
            padding: 10px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            margin: 10px 0;
        }
        .success { color: #28a745; }
        .error { color: #dc3545; }
        .warning { color: #ffc107; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Razorpay Configuration Test</h1>
        
        <%
            String keyId = RazorpayConfig.getKeyId();
            String keySecret = RazorpayConfig.getKeySecret();
            boolean isConfigured = RazorpayConfig.isConfigured();
            
            // Mask secret
            String maskedSecret = keySecret;
            if (keySecret != null && keySecret.length() > 8) {
                maskedSecret = keySecret.substring(0, 4) + "****" + keySecret.substring(keySecret.length() - 4);
            }
            
            // Check environment variables directly
            String envKeyId = System.getenv("RAZORPAY_KEY_ID");
            String envKeySecret = System.getenv("RAZORPAY_KEY_SECRET");
        %>
        
        <div class="status <%= isConfigured ? "configured" : "not-configured" %>">
            <% if (isConfigured) { %>
                ✅ Razorpay is CONFIGURED and ready for real payments!
            <% } else { %>
                ❌ Razorpay is NOT configured - Using demo mode
            <% } %>
        </div>
        
        <h2>Configuration Details</h2>
        
        <div class="info-row">
            <div class="info-label">Key ID:</div>
            <div class="info-value"><%= keyId %></div>
        </div>
        
        <div class="info-row">
            <div class="info-label">Key Secret:</div>
            <div class="info-value"><%= maskedSecret %></div>
        </div>
        
        <div class="info-row">
            <div class="info-label">Currency:</div>
            <div class="info-value"><%= RazorpayConfig.CURRENCY %></div>
        </div>
        
        <div class="info-row">
            <div class="info-label">Company Name:</div>
            <div class="info-value"><%= RazorpayConfig.COMPANY_NAME %></div>
        </div>
        
        <div class="info-row">
            <div class="info-label">Is Configured:</div>
            <div class="info-value <%= isConfigured ? "success" : "error" %>">
                <%= isConfigured ? "✅ YES" : "❌ NO" %>
            </div>
        </div>
        
        <h2>Environment Variables (Server)</h2>
        
        <div class="info-row">
            <div class="info-label">RAZORPAY_KEY_ID:</div>
            <div class="info-value <%= envKeyId != null ? "success" : "error" %>">
                <%= envKeyId != null ? envKeyId : "❌ NOT SET" %>
            </div>
        </div>
        
        <div class="info-row">
            <div class="info-label">RAZORPAY_KEY_SECRET:</div>
            <div class="info-value <%= envKeySecret != null ? "success" : "error" %>">
                <% if (envKeySecret != null && envKeySecret.length() > 8) { %>
                    <%= envKeySecret.substring(0, 4) + "****" + envKeySecret.substring(envKeySecret.length() - 4) %>
                <% } else if (envKeySecret != null) { %>
                    <%= envKeySecret %>
                <% } else { %>
                    ❌ NOT SET
                <% } %>
            </div>
        </div>
        
        <% if (!isConfigured) { %>
        <div class="env-check">
            <h3 style="margin-top:0;">⚠️ Action Required</h3>
            <p><strong>Your Razorpay integration will NOT work until you:</strong></p>
            <ol>
                <li>Get API keys from <a href="https://dashboard.razorpay.com/app/keys" target="_blank">Razorpay Dashboard</a></li>
                <li>Set environment variables (use setup script)</li>
                <li><strong>Restart the application server</strong></li>
            </ol>
            
            <div class="code">
                # Run this in PowerShell:<br>
                cd C:\Users\Admin<br>
                .\setup-razorpay.ps1
            </div>
            
            <p><strong style="color: #dc3545;">⚠️ CRITICAL:</strong> After setting variables, you MUST restart Tomcat/Eclipse for changes to take effect!</p>
        </div>
        <% } else { %>
        <div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <h3 style="margin-top:0; color: #155724;">✅ Configuration is Active!</h3>
            <p>Your application will use real Razorpay API for payments.</p>
            <ul>
                <li>Orders will be created via Razorpay API</li>
                <li>Payment signatures will be verified</li>
                <li>Transactions will appear in Razorpay dashboard</li>
                <li>Transaction IDs will start with <code>pay_</code></li>
            </ul>
        </div>
        <% } %>
        
        <h2>Test API Endpoint</h2>
        <button onclick="testConfig()" style="background: #667eea; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px;">
            Test /payment?action=config
        </button>
        
        <div id="testResult" style="margin-top: 20px;"></div>
        
        <h2>Browser Console Test</h2>
        <p>Open browser console (F12) and run:</p>
        <div class="code">
            fetch('/EMS/payment?action=config').then(r => r.json()).then(console.log);
        </div>
        
        <h2>Payment Flow Status</h2>
        <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <h4>What will happen when user pays?</h4>
            <% if (isConfigured) { %>
            <ol style="color: #28a745;">
                <li>✅ JavaScript detects: <code>isRazorpayConfigured = true</code></li>
                <li>✅ Calls: <code>POST /payment?action=createOrder</code></li>
                <li>✅ Creates real order via Razorpay API</li>
                <li>✅ Opens Razorpay modal</li>
                <li>✅ User completes payment</li>
                <li>✅ Verifies signature</li>
                <li>✅ Saves with transaction ID: <code>pay_xxxxx</code></li>
            </ol>
            <% } else { %>
            <ol style="color: #dc3545;">
                <li>❌ JavaScript detects: <code>isRazorpayConfigured = false</code></li>
                <li>❌ Falls back to: <code>POST /candidate?action=processPayment</code></li>
                <li>❌ Creates dummy transaction ID: <code>TXN...</code></li>
                <li>❌ No real Razorpay payment</li>
                <li>❌ No signature verification</li>
                <li>❌ Not visible in Razorpay dashboard</li>
            </ol>
            <% } %>
        </div>
        
        <div style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #eee;">
            <p style="color: #666; font-size: 14px;">
                <strong>Server Time:</strong> <%= new java.util.Date() %><br>
                <strong>Context Path:</strong> <%= request.getContextPath() %><br>
                <strong>Page:</strong> /test-razorpay-config.jsp
            </p>
        </div>
    </div>
    
    <script>
        function testConfig() {
            const resultDiv = document.getElementById('testResult');
            resultDiv.innerHTML = '<p style="color: #ffc107;">⏳ Loading...</p>';
            
            fetch('<%=request.getContextPath()%>/payment?action=config')
                .then(response => response.json())
                .then(config => {
                    console.log('Config response:', config);
                    resultDiv.innerHTML = `
                        <div style="background: #f4f4f4; padding: 15px; border-radius: 5px; margin-top: 10px;">
                            <h4 style="margin-top: 0;">API Response:</h4>
                            <pre style="margin: 0; overflow-x: auto;">${JSON.stringify(config, null, 2)}</pre>
                            <p style="margin-top: 15px; font-weight: bold; color: ${config.configured ? '#28a745' : '#dc3545'};">
                                ${config.configured ? '✅ API is configured!' : '❌ API is NOT configured'}
                            </p>
                        </div>
                    `;
                })
                .catch(error => {
                    console.error('Config error:', error);
                    resultDiv.innerHTML = `
                        <div style="background: #f8d7da; padding: 15px; border-radius: 5px; border: 1px solid #f5c6cb; margin-top: 10px;">
                            <h4 style="margin-top: 0; color: #721c24;">❌ Error:</h4>
                            <p style="color: #721c24; margin: 0;">${error.message}</p>
                        </div>
                    `;
                });
        }
        
        // Auto-test on page load
        window.addEventListener('load', () => {
            console.log('='.repeat(60));
            console.log('RAZORPAY CONFIGURATION TEST');
            console.log('='.repeat(60));
            console.log('Key ID: <%= keyId %>');
            console.log('Is Configured: <%= isConfigured %>');
            console.log('Environment RAZORPAY_KEY_ID: <%= envKeyId %>');
            console.log('='.repeat(60));
            
            // Test the endpoint
            setTimeout(testConfig, 500);
        });
    </script>
</body>
</html>

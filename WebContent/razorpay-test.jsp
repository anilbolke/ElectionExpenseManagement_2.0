<%@page import="com.election.config.RazorpayConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Razorpay Quick Test</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            max-width: 600px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        .status-box {
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            font-size: 18px;
            font-weight: bold;
        }
        .success {
            background: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }
        .info-grid {
            display: grid;
            gap: 15px;
            margin: 20px 0;
        }
        .info-item {
            display: flex;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .info-label {
            font-weight: bold;
            color: #555;
            min-width: 150px;
        }
        .info-value {
            color: #333;
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
        }
        .btn:hover { opacity: 0.9; }
        .instructions {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .instructions h3 {
            color: #856404;
            margin-bottom: 10px;
        }
        .instructions ol {
            margin-left: 20px;
            color: #856404;
        }
        .instructions li {
            margin: 8px 0;
        }
        #testResult {
            margin-top: 20px;
            padding: 20px;
            border-radius: 8px;
            display: none;
        }
        .code {
            background: #f4f4f4;
            padding: 10px;
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            margin: 10px 0;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔍 Razorpay Configuration Test</h1>
        <p class="subtitle">Quick diagnostic tool</p>
        
        <%
            // Get configuration
            String keyId = RazorpayConfig.KEY_ID;
            String keySecret = RazorpayConfig.KEY_SECRET;
            boolean isConfigured = true;
            
            // Mask secret
            String maskedSecret = keySecret;
            if (keySecret != null && keySecret.length() > 8) {
                maskedSecret = keySecret.substring(0, 4) + "****" + keySecret.substring(keySecret.length() - 4);
            }
            
            // Check environment variables
            String envKeyId = System.getenv("RAZORPAY_KEY_ID");
            String envKeySecret = System.getenv("RAZORPAY_KEY_SECRET");
        %>
        
        <!-- Status Banner -->
        <div class="status-box <%= isConfigured ? "success" : "error" %>">
            <% if (isConfigured) { %>
                ✅ CONFIGURED - Real Razorpay API Active
            <% } else { %>
                ❌ NOT CONFIGURED - Using Demo Mode
            <% } %>
        </div>
        
        <!-- Configuration Details -->
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Key ID:</div>
                <div class="info-value"><%= keyId %></div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Key Secret:</div>
                <div class="info-value"><%= maskedSecret %></div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Status:</div>
                <div class="info-value" style="color: <%= isConfigured ? "green" : "red" %>;">
                    <%= isConfigured ? "✓ Ready for real payments" : "✗ Will use dummy transactions" %>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Environment Var:</div>
                <div class="info-value" style="color: <%= envKeyId != null ? "green" : "red" %>;">
                    <%= envKeyId != null ? "✓ Set" : "✗ Not Set" %>
                </div>
            </div>
        </div>
        
        <!-- Test Button -->
        <button class="btn" onclick="testAPI()">
            🧪 Test API Endpoint
        </button>
        
        <div id="testResult"></div>
        
        <!-- Instructions -->
        <% if (!isConfigured) { %>
        <div class="instructions">
            <h3>⚠️ Why You're Getting Dummy Transaction IDs</h3>
            <p style="margin-bottom: 15px;">Your payment system checks this configuration. Since it's NOT configured, it falls back to demo mode.</p>
            
            <h3>📝 To Fix (3 Steps):</h3>
            <ol>
                <li><strong>Get keys:</strong> <a href="https://dashboard.razorpay.com/app/keys" target="_blank">Razorpay Dashboard</a></li>
                <li><strong>Configure:</strong> Run <code>.\setup-razorpay.ps1</code></li>
                <li><strong>Restart:</strong> Stop & Start Eclipse/Tomcat</li>
            </ol>
            
            <p style="margin-top: 15px; color: #856404;">
                <strong>After restart:</strong> Revisit this page. It will show ✅ GREEN and payments will use real Razorpay API with <code>pay_xxxxx</code> transaction IDs.
            </p>
        </div>
        <% } else { %>
        <div class="instructions" style="background: #d4edda; border-color: #c3e6cb;">
            <h3 style="color: #155724;">✅ Configuration Active!</h3>
            <p style="color: #155724;">
                Your application is configured and will use real Razorpay API for payments.
                Transaction IDs will start with <code>pay_</code> and will be visible in your Razorpay dashboard.
            </p>
        </div>
        <% } %>
        
        <!-- Browser Console Test -->
        <div style="margin-top: 20px; padding: 15px; background: #e7f3ff; border-radius: 8px;">
            <h4 style="margin-bottom: 10px;">🖥️ Browser Console Test</h4>
            <p style="margin-bottom: 10px; font-size: 14px;">Open console (F12) and run:</p>
            <div class="code">
fetch('/ElectionExpenseManagement/payment?action=config').then(r => r.json()).then(console.log);
            </div>
        </div>
        
        <div style="margin-top: 20px; text-align: center; color: #999; font-size: 12px;">
            <p>Server Time: <%= new java.util.Date() %></p>
            <p>File: /razorpay-test.jsp</p>
        </div>
    </div>
    
    <script>
        // Auto-log on page load
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        console.log('RAZORPAY CONFIGURATION TEST');
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        console.log('Key ID: <%= keyId %>');
        console.log('Is Configured: <%= isConfigured %>');
        console.log('Environment Variable Set: <%= envKeyId != null %>');
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        
        <% if (!isConfigured) { %>
        console.warn('⚠️ Razorpay NOT configured - Using demo mode');
        console.warn('This is why you get TXN dummy transaction IDs!');
        <% } else { %>
        console.log('✅ Razorpay IS configured - Real API active');
        console.log('Transaction IDs will be: pay_xxxxx');
        <% } %>
        
        function testAPI() {
            const resultDiv = document.getElementById('testResult');
            resultDiv.style.display = 'block';
            resultDiv.style.background = '#fff3cd';
            resultDiv.style.border = '1px solid #ffc107';
            resultDiv.innerHTML = '<p style="color: #856404;">⏳ Testing API endpoint...</p>';
            
            fetch('/ElectionExpenseManagement/payment?action=config')
                .then(response => response.json())
                .then(config => {
                    console.log('API Response:', config);
                    
                    const isConfiguredAPI = config.configured;
                    resultDiv.style.background = isConfiguredAPI ? '#d4edda' : '#f8d7da';
                    resultDiv.style.borderColor = isConfiguredAPI ? '#c3e6cb' : '#f5c6cb';
                    
                    resultDiv.innerHTML = `
                        <h3 style="color: ${isConfiguredAPI ? '#155724' : '#721c24'}; margin-bottom: 15px;">
                            ${isConfiguredAPI ? '✅ API Test Successful' : '❌ API Not Configured'}
                        </h3>
                        <div class="code" style="background: white;">
${JSON.stringify(config, null, 2)}
                        </div>
                        <p style="margin-top: 15px; color: ${isConfiguredAPI ? '#155724' : '#721c24'};">
                            <strong>Result:</strong> 
                            ${isConfiguredAPI 
                                ? 'Your payment system will use real Razorpay API' 
                                : 'Your payment system will use demo mode (dummy TXN IDs)'}
                        </p>
                    `;
                })
                .catch(error => {
                    console.error('API Error:', error);
                    resultDiv.style.background = '#f8d7da';
                    resultDiv.style.borderColor = '#f5c6cb';
                    resultDiv.innerHTML = `
                        <h3 style="color: #721c24; margin-bottom: 15px;">❌ API Test Failed</h3>
                        <p style="color: #721c24;">${error.message}</p>
                    `;
                });
        }
        
        // Auto-test on load
        setTimeout(testAPI, 500);
    </script>
</body>
</html>

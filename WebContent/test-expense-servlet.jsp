<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Expense Servlet</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        .test-box { background: white; padding: 20px; margin: 10px 0; border-radius: 5px; }
        h1 { color: #333; }
        .btn { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>🧪 Expense Servlet Test Page</h1>
    
    <div class="test-box">
        <h2>Current Configuration</h2>
        <pre>Context Path: <%= request.getContextPath() %>
Server Info: <%= application.getServerInfo() %>
Servlet Context: <%= application.getContextPath() %>

Expected Servlet URL: <%= request.getContextPath() %>/expense
Full Servlet URL: <%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/expense</pre>
    </div>
    
    <div class="test-box">
        <h2>Test 1: Simple POST Test</h2>
        <p>This will test if the servlet is accessible via POST method:</p>
        <form action="<%= request.getContextPath() %>/expense" method="post" style="margin-top: 10px;">
            <input type="hidden" name="action" value="test">
            <button type="submit" class="btn">Test POST to /expense</button>
        </form>
        <p style="margin-top: 10px; color: #666;">
            <small>Note: This will fail because you don't have a candidate selected, but it will show if servlet is found (500 error) or not found (404 error)</small>
        </p>
    </div>
    
    <div class="test-box">
        <h2>Test 2: Check web.xml Mapping</h2>
        <p>The servlet should be mapped in web.xml as:</p>
        <pre>&lt;servlet&gt;
    &lt;servlet-name&gt;ExpenseServlet&lt;/servlet-name&gt;
    &lt;servlet-class&gt;com.election.servlet.ExpenseServlet&lt;/servlet-class&gt;
&lt;/servlet&gt;
&lt;servlet-mapping&gt;
    &lt;servlet-name&gt;ExpenseServlet&lt;/servlet-name&gt;
    &lt;url-pattern&gt;/expense&lt;/url-pattern&gt;
&lt;/servlet-mapping&gt;</pre>
    </div>
    
    <div class="test-box">
        <h2>Test 3: Alternative Form Action</h2>
        <p>Try with absolute path:</p>
        <form action="/ElectionExpenseManagement/expense" method="post" style="margin-top: 10px;">
            <input type="hidden" name="action" value="test">
            <button type="submit" class="btn">Test with Absolute Path</button>
        </form>
    </div>
    
    <div class="test-box">
        <h2>Troubleshooting Steps</h2>
        <ol>
            <li>Click "Test POST to /expense" button above</li>
            <li>If you get <strong>404 error</strong>: Servlet is not deployed or mapped incorrectly</li>
            <li>If you get <strong>500 error</strong>: Servlet is found but has an error (this is expected without proper session)</li>
            <li>If you get redirected: Servlet is working!</li>
        </ol>
    </div>
    
    <div class="test-box">
        <h2>Expected Results</h2>
        <table style="width: 100%; border-collapse: collapse;">
            <tr style="background: #f8f9fa;">
                <th style="padding: 10px; text-align: left; border: 1px solid #dee2e6;">Error Code</th>
                <th style="padding: 10px; text-align: left; border: 1px solid #dee2e6;">Meaning</th>
                <th style="padding: 10px; text-align: left; border: 1px solid #dee2e6;">Solution</th>
            </tr>
            <tr>
                <td style="padding: 10px; border: 1px solid #dee2e6;"><strong>404</strong></td>
                <td style="padding: 10px; border: 1px solid #dee2e6;">Servlet not found</td>
                <td style="padding: 10px; border: 1px solid #dee2e6;">Rebuild project, restart server, check web.xml</td>
            </tr>
            <tr style="background: #f8f9fa;">
                <td style="padding: 10px; border: 1px solid #dee2e6;"><strong>500</strong></td>
                <td style="padding: 10px; border: 1px solid #dee2e6;">Servlet found but error occurred</td>
                <td style="padding: 10px; border: 1px solid #dee2e6;">Good! Servlet is working, error is expected</td>
            </tr>
            <tr>
                <td style="padding: 10px; border: 1px solid #dee2e6;"><strong>Redirect</strong></td>
                <td style="padding: 10px; border: 1px solid #dee2e6;">Servlet handled request</td>
                <td style="padding: 10px; border: 1px solid #dee2e6;">Perfect! Servlet is fully working</td>
            </tr>
        </table>
    </div>
</body>
</html>

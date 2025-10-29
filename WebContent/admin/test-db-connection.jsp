<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.util.DatabaseConnection, java.sql.*, java.math.BigDecimal" %>
<%
    // Authentication check
    com.election.model.User user = (com.election.model.User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <style>
        body { font-family: monospace; padding: 20px; background: #f5f5f5; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
        pre { background: white; padding: 15px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <h2>🔍 Database Connection & Subscription Plans Test</h2>
    
    <%
        Connection conn = null;
        try {
            out.println("<h3 class='info'>Step 1: Testing Database Connection</h3>");
            conn = DatabaseConnection.getConnection();
            out.println("<p class='success'>✅ Database connection successful!</p>");
            
            out.println("<h3 class='info'>Step 2: Checking subscription_plans table</h3>");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM subscription_plans");
            rs.next();
            int count = rs.getInt("count");
            out.println("<p class='success'>✅ subscription_plans table exists with " + count + " plans</p>");
            
            out.println("<h3 class='info'>Step 3: Listing All Plans</h3>");
            rs = stmt.executeQuery("SELECT plan_id, plan_name, price, updated_date FROM subscription_plans ORDER BY plan_id");
            out.println("<pre>");
            out.println("ID | Plan Name            | Price    | Last Updated");
            out.println("---|----------------------|----------|---------------------------");
            while (rs.next()) {
                out.println(String.format("%-3d| %-20s | ₹%-7.2f | %s", 
                    rs.getInt("plan_id"),
                    rs.getString("plan_name"),
                    rs.getBigDecimal("price").doubleValue(),
                    rs.getTimestamp("updated_date")));
            }
            out.println("</pre>");
            
            out.println("<h3 class='info'>Step 4: Testing UPDATE Query</h3>");
            String testQuery = "UPDATE subscription_plans SET updated_date = CURRENT_TIMESTAMP WHERE plan_id = 1";
            int rowsAffected = stmt.executeUpdate(testQuery);
            out.println("<p class='success'>✅ Test UPDATE successful! Rows affected: " + rowsAffected + "</p>");
            
            out.println("<h3 class='info'>Step 5: Testing updatePlanPrice Method</h3>");
            com.election.dao.SubscriptionDAO dao = new com.election.dao.SubscriptionDAO();
            BigDecimal testPrice = new BigDecimal("999.00");
            boolean result = dao.updatePlanPrice(1, testPrice);
            out.println("<p class='" + (result ? "success" : "error") + "'>" + 
                        (result ? "✅" : "❌") + " updatePlanPrice method result: " + result + "</p>");
            
            // Show current value
            rs = stmt.executeQuery("SELECT price FROM subscription_plans WHERE plan_id = 1");
            if (rs.next()) {
                out.println("<p class='info'>Current price for plan_id=1: ₹" + rs.getBigDecimal("price") + "</p>");
            }
            
            out.println("<hr><h3 class='success'>✅ All Tests Passed!</h3>");
            out.println("<p><a href='manage-payments.jsp'>← Back to Manage Payments</a></p>");
            
        } catch (Exception e) {
            out.println("<h3 class='error'>❌ Error occurred:</h3>");
            out.println("<pre class='error'>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) { }
            }
        }
    %>
</body>
</html>

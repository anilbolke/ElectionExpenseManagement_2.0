<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.util.ArrayList, java.math.BigDecimal, java.text.SimpleDateFormat" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"broker".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Initialize DAOs
    UserDAO userDAO = new UserDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    
    // Get broker's transactions (candidates with payments)
    List<Candidate> paidCandidates = new ArrayList<>();
    BigDecimal totalRevenue = BigDecimal.ZERO;
    BigDecimal totalCommission = BigDecimal.ZERO;
    
    try {
        List<User> myUsers = userDAO.getUsersByBrokerId(user.getUserId());
        if (myUsers != null) {
            for (User u : myUsers) {
                List<Candidate> userCandidates = candidateDAO.getCandidatesByUserId(u.getUserId());
                if (userCandidates != null) {
                    for (Candidate c : userCandidates) {
                        if (c.isPaymentVerified() && c.getPaymentAmount() != null) {
                            paidCandidates.add(c);
                            totalRevenue = totalRevenue.add(c.getPaymentAmount());
                            
                            // Calculate commission (10% default)
                            BigDecimal commission = c.getPaymentAmount().multiply(new BigDecimal("0.10"));
                            totalCommission = totalCommission.add(commission);
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Transactions - Broker Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f5f7fa; }
        
        .navbar {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar-brand {
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }
        .navbar-menu {
            display: flex;
            list-style: none;
            gap: 20px;
        }
        .navbar-menu a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background 0.3s;
        }
        .navbar-menu a:hover, .navbar-menu a.active {
            background: rgba(255,255,255,0.2);
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
            border: none;
            font-size: 14px;
            transition: all 0.3s;
        }
        .btn-danger {
            background: #f44336;
            color: white;
        }
        .btn-danger:hover {
            background: #d32f2f;
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 20px;
        }
        
        .page-header {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .page-header h1 {
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .page-header p {
            color: #666;
        }
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 2rem;
        }
        
        .summary-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .summary-card h3 {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .summary-card .value {
            color: #333;
            font-size: 2rem;
            font-weight: bold;
        }
        
        .summary-card .value.success {
            color: #4CAF50;
        }
        
        .transactions-table {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .transactions-table h2 {
            color: #333;
            margin-bottom: 1.5rem;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f8f9fa;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        th {
            font-weight: 600;
            color: #495057;
        }
        
        tbody tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">💼 Broker Portal</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="candidates.jsp">My Candidates</a></li>
                <li><a href="transactions.jsp" class="active">Transactions</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar">
                    <%= user.getFullName() != null ? user.getFullName().substring(0, 1).toUpperCase() : "B" %>
                </div>
                <span><%= user.getFullName() != null ? user.getFullName() : "Broker" %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1>💰 Transaction History</h1>
            <p>View all your commission earnings and payment details</p>
        </div>
        
        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="summary-card">
                <h3>Total Transactions</h3>
                <div class="value"><%= paidCandidates.size() %></div>
            </div>
            <div class="summary-card">
                <h3>Total Revenue</h3>
                <div class="value success">₹<%= String.format("%.2f", totalRevenue) %></div>
            </div>
            <div class="summary-card">
                <h3>Total Commission (10%)</h3>
                <div class="value success">₹<%= String.format("%.2f", totalCommission) %></div>
            </div>
        </div>
        
        <!-- Transactions Table -->
        <div class="transactions-table">
            <h2>Recent Transactions</h2>
            
            <% if (paidCandidates != null && !paidCandidates.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Candidate Name</th>
                            <th>Constituency</th>
                            <th>Amount</th>
                            <th>Commission</th>
                            <th>Transaction ID</th>
                            <th>Payment Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Candidate candidate : paidCandidates) { 
                            BigDecimal commission = candidate.getPaymentAmount().multiply(new BigDecimal("0.10"));
                        %>
                        <tr>
                            <td><strong><%= candidate.getCandidateName() %></strong></td>
                            <td><%= candidate.getConstituency() %></td>
                            <td><strong>₹<%= String.format("%.2f", candidate.getPaymentAmount()) %></strong></td>
                            <td><strong style="color: #4CAF50;">₹<%= String.format("%.2f", commission) %></strong></td>
                            <td><code><%= candidate.getTransactionId() != null ? candidate.getTransactionId() : "N/A" %></code></td>
                            <td><%= candidate.getPaymentDate() != null ? dateFormat.format(candidate.getPaymentDate()) : "N/A" %></td>
                            <td><span class="status-badge status-completed">✓ Completed</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <div class="empty-state-icon">📊</div>
                    <h3>No Transactions Yet</h3>
                    <p>Your transaction history will appear here once candidates complete their payments.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

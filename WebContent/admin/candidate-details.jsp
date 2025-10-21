<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.math.BigDecimal" %>
<%
    // Authentication check
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get candidate details
    String candidateIdParam = request.getParameter("candidateId");
    Candidate candidate = null;
    User candidateOwner = null;
    List<Expense> candidateExpenses = null;
    BigDecimal totalExpenses = BigDecimal.ZERO;
    
    if (candidateIdParam != null && !candidateIdParam.isEmpty()) {
        try {
            int candidateId = Integer.parseInt(candidateIdParam);
            CandidateDAO candidateDAO = new CandidateDAO();
            candidate = candidateDAO.getCandidateById(candidateId);
            
            if (candidate != null) {
                // Get the user who owns this candidate
                UserDAO userDAO = new UserDAO();
                candidateOwner = userDAO.getUserById(candidate.getUserId());
                
                // Get candidate expenses
                ExpenseDAO expenseDAO = new ExpenseDAO();
                candidateExpenses = expenseDAO.getExpensesByCandidate(candidateId);
                
                if (candidateExpenses != null) {
                    for (Expense exp : candidateExpenses) {
                        totalExpenses = totalExpenses.add(exp.getExpenseAmount());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (candidate == null) {
        response.sendRedirect("view-candidates.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Details - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 13px;
            color: #2d3748;
        }
        
        /* Compact Navigation */
        .navbar {
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar-content {
            padding: 8px 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            max-width: 1600px;
            margin: 0 auto;
        }
        .navbar-brand {
            font-size: 1.1rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .navbar-menu {
            display: flex;
            list-style: none;
            gap: 3px;
        }
        .navbar-menu a {
            color: #4a5568;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.2s;
            font-weight: 500;
            font-size: 12px;
        }
        .navbar-menu a:hover, .navbar-menu a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
        }
        .user-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 11px;
        }
        
        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            margin-bottom: 20px;
        }
        .page-header h1 {
            font-size: 1.6rem;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 5px;
        }
        .breadcrumb {
            font-size: 12px;
            color: #64748b;
        }
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 15px;
            font-size: 12px;
        }
        .back-button:hover {
            text-decoration: underline;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            margin-bottom: 20px;
        }
        .stat-box {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border-left: 3px solid;
        }
        .stat-box:nth-child(1) { border-left-color: #667eea; }
        .stat-box:nth-child(2) { border-left-color: #48bb78; }
        .stat-box:nth-child(3) { border-left-color: #ed8936; }
        .stat-box:nth-child(4) { border-left-color: #f56565; }
        .stat-box h4 {
            color: #718096;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        .stat-box .value {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1a202c;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header h3 {
            margin: 0;
            font-size: 1rem;
            font-weight: 600;
        }
        .card-body {
            padding: 20px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        .info-item {
            padding: 12px;
            background: #f8fafc;
            border-radius: 6px;
            border-left: 3px solid #667eea;
        }
        .info-item label {
            display: block;
            font-size: 11px;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 5px;
            letter-spacing: 0.5px;
        }
        .info-item .value {
            font-size: 14px;
            color: #1a202c;
            font-weight: 500;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        table th {
            background: #f7fafc;
            padding: 10px 8px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        table td {
            padding: 10px 8px;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
        }
        table tr:hover {
            background: #f7fafc;
        }
        
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-warning { background: #fed7aa; color: #78350f; }
        .badge-danger { background: #fecaca; color: #991b1b; }
        .badge-info { background: #dbeafe; color: #1e3a8a; }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            font-size: 12px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-danger {
            background: #f56565;
            color: white;
        }
        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #718096;
        }
        
        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb { background: #cbd5e0; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #a0aec0; }
        
        @media (max-width: 768px) {
            .navbar-menu { display: none; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
    <!-- Compact Navigation -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">👑 Admin Portal</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="view-users.jsp">Users</a></li>
                <li><a href="view-candidates.jsp" class="active">Candidates</a></li>
                <li><a href="view-brokers.jsp">Brokers</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= adminUser.getFullName() != null ? adminUser.getFullName().substring(0, 1).toUpperCase() : "A" %></div>
                <span><%= adminUser.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container">
        <a href="view-candidates.jsp" class="back-button">← Back to All Candidates</a>
        
        <div class="page-header">
            <h1>🗳️ Candidate Details</h1>
            <div class="breadcrumb">
                <a href="dashboard.jsp">Dashboard</a> / 
                <a href="view-candidates.jsp">Candidates</a> / 
                <%= candidate.getCandidateName() %>
            </div>
        </div>
        
        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-box">
                <h4>Candidate ID</h4>
                <div class="value">#<%= candidate.getCandidateId() %></div>
            </div>
            <div class="stat-box">
                <h4>Total Expenses</h4>
                <div class="value" style="font-size: 1.3rem;">₹<%= String.format("%.2f", totalExpenses) %></div>
            </div>
            <div class="stat-box">
                <h4>Payment Amount</h4>
                <div class="value" style="font-size: 1.3rem;">₹<%= String.format("%.2f", candidate.getPaymentAmount()) %></div>
            </div>
            <div class="stat-box">
                <h4>Expense Count</h4>
                <div class="value"><%= candidateExpenses != null ? candidateExpenses.size() : 0 %></div>
            </div>
        </div>
        
        <!-- Candidate Information -->
        <div class="card">
            <div class="card-header">
                <h3>ℹ️ Candidate Information</h3>
                <% 
                    String accStatus = candidate.getAccountStatus();
                    String accBadge = "badge-warning";
                    if ("active".equals(accStatus)) accBadge = "badge-success";
                    else if ("pending_payment".equals(accStatus)) accBadge = "badge-danger";
                %>
                <span class="badge <%= accBadge %>"><%= accStatus != null ? accStatus.replace("_", " ").toUpperCase() : "N/A" %></span>
            </div>
            <div class="card-body">
                <div class="info-grid">
                    <div class="info-item">
                        <label>Full Name</label>
                        <div class="value"><%= candidate.getCandidateName() != null ? candidate.getCandidateName() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Party Name</label>
                        <div class="value"><%= candidate.getPartyName() != null ? candidate.getPartyName() : "Independent" %></div>
                    </div>
                    <div class="info-item">
                        <label>Constituency</label>
                        <div class="value"><%= candidate.getConstituency() != null ? candidate.getConstituency() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Election Type</label>
                        <div class="value"><%= candidate.getElectionType() != null ? candidate.getElectionType() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Mobile</label>
                        <div class="value"><%= candidate.getMobile() != null ? candidate.getMobile() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <div class="value"><%= candidate.getEmail() != null ? candidate.getEmail() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Address</label>
                        <div class="value"><%= candidate.getAddress() != null ? candidate.getAddress() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Payment Status</label>
                        <div class="value">
                            <% if (candidate.isPaymentVerified()) { %>
                                <span class="badge badge-success">✓ Verified</span>
                            <% } else { %>
                                <span class="badge badge-warning">Pending</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="info-item">
                        <label>Created Date</label>
                        <div class="value"><%= candidate.getCreatedDate() != null ? candidate.getCreatedDate() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Last Updated</label>
                        <div class="value"><%= candidate.getUpdatedDate() != null ? candidate.getUpdatedDate() : "N/A" %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Owner Information -->
        <% if (candidateOwner != null) { %>
        <div class="card">
            <div class="card-header">
                <h3>👤 Registered By</h3>
            </div>
            <div class="card-body">
                <div class="info-grid">
                    <div class="info-item">
                        <label>User ID</label>
                        <div class="value">#<%= candidateOwner.getUserId() %></div>
                    </div>
                    <div class="info-item">
                        <label>Full Name</label>
                        <div class="value"><%= candidateOwner.getFullName() != null ? candidateOwner.getFullName() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <div class="value"><%= candidateOwner.getEmail() != null ? candidateOwner.getEmail() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Mobile</label>
                        <div class="value"><%= candidateOwner.getMobile() != null ? candidateOwner.getMobile() : "N/A" %></div>
                    </div>
                </div>
                <div style="margin-top: 15px;">
                    <a href="user-details.jsp?userId=<%= candidateOwner.getUserId() %>" class="btn btn-primary btn-sm">View User Profile</a>
                </div>
            </div>
        </div>
        <% } %>
        
        <!-- Expenses -->
        <div class="card">
            <div class="card-header">
                <h3>💰 Expense Records</h3>
                <span class="badge badge-info"><%= candidateExpenses != null ? candidateExpenses.size() : 0 %> Records</span>
            </div>
            <div class="card-body">
                <% if (candidateExpenses != null && !candidateExpenses.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date</th>
                                <th>Category</th>
                                <th>Description</th>
                                <th>Amount</th>
                                <th>Payment Mode</th>
                                <th>Receipt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Expense exp : candidateExpenses) { %>
                                <tr>
                                    <td>#<%= exp.getExpenseId() %></td>
                                    <td><%= exp.getExpenseDate() != null ? exp.getExpenseDate() : "N/A" %></td>
                                    <td><%= exp.getExpenseCategory() != null ? exp.getExpenseCategory() : "N/A" %></td>
                                    <td><%= exp.getExpenseDescription() != null ? exp.getExpenseDescription() : "N/A" %></td>
                                    <td><strong>₹<%= String.format("%.2f", exp.getExpenseAmount()) %></strong></td>
                                    <td><%= exp.getPaymentMode() != null ? exp.getPaymentMode() : "N/A" %></td>
                                    <td>
                                        <% if (exp.getReceiptNumber() != null && !exp.getReceiptNumber().isEmpty()) { %>
                                            <span class="badge badge-success">✓ Available</span>
                                        <% } else { %>
                                            <span class="badge badge-warning">No Receipt</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <div style="font-size: 3rem; margin-bottom: 15px;">💰</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Expenses Yet</h3>
                        <p>No expense records found for this candidate.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Actions -->
        <div style="display: flex; gap: 15px; margin-top: 20px;">
            <a href="view-candidates.jsp" class="btn btn-primary">← Back to All Candidates</a>
        </div>
    </div>
</body>
</html>

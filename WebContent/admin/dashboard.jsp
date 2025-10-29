<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.math.BigDecimal" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Initialize DAOs
    UserDAO userDAO = new UserDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    ExpenseDAO expenseDAO = new ExpenseDAO();
    
    // Get all users
    List<User> allUsers = userDAO.getAllUsers();
    
    // Get statistics
    int totalUsers = allUsers != null ? allUsers.size() : 0;
    int adminCount = 0, userCount = 0, brokerCount = 0;
    
    if (allUsers != null) {
        for (User u : allUsers) {
            String role = u.getUserRole();
            if ("admin".equals(role)) adminCount++;
            else if ("user".equals(role)) userCount++;
            else if ("broker".equals(role)) brokerCount++;
        }
    }
    
    // Get all candidates
    int totalCandidates = 0;
    int activeCandidates = 0;
    int pendingPayments = 0;
    
    try {
        if (allUsers != null) {
            for (User u : allUsers) {
                if ("user".equals(u.getUserRole())) {
                    List<Candidate> userCandidates = candidateDAO.getCandidatesByUserId(u.getUserId());
                    if (userCandidates != null) {
                        totalCandidates += userCandidates.size();
                        for (Candidate c : userCandidates) {
                            if (c.isPaymentVerified()) {
                                activeCandidates++;
                            } else {
                                pendingPayments++;
                            }
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Get total expenses
    BigDecimal totalExpenses = BigDecimal.ZERO;
    try {
        List<Expense> allExpenses = expenseDAO.getAllExpenses();
        if (allExpenses != null) {
            for (Expense exp : allExpenses) {
                totalExpenses = totalExpenses.add(exp.getExpenseAmount());
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "admin.dashboard") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', 'Noto Sans Devanagari', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 13px;
            color: #2d3748;
            height: 100vh;
            overflow: hidden;
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
        
        /* Main Container */
        .main-container {
            height: calc(100vh - 45px);
            overflow-y: auto;
            padding: 12px;
        }
        
        /* Compact Grid Layout */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 12px;
            height: 100%;
        }
        
        /* Left Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        /* Stats Compact */
        .stats-compact {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }
        .stat-mini {
            background: white;
            padding: 12px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border-left: 3px solid;
        }
        .stat-mini:nth-child(1) { border-left-color: #667eea; }
        .stat-mini:nth-child(2) { border-left-color: #48bb78; }
        .stat-mini:nth-child(3) { border-left-color: #ed8936; }
        .stat-mini:nth-child(4) { border-left-color: #f56565; }
        .stat-mini h4 {
            font-size: 10px;
            color: #718096;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 4px;
            letter-spacing: 0.3px;
        }
        .stat-mini .value {
            font-size: 1.4rem;
            font-weight: 700;
            color: #1a202c;
        }
        
        /* Quick Actions */
        .quick-actions-compact {
            background: white;
            padding: 12px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .quick-actions-compact h3 {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #1a202c;
        }
        .action-btn {
            display: block;
            padding: 8px 12px;
            margin-bottom: 6px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            transition: all 0.2s;
        }
        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }
        .action-btn.secondary {
            background: #48bb78;
        }
        .action-btn.tertiary {
            background: #4299e1;
        }
        
        /* Main Content Area */
        .main-content {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            padding: 15px;
            overflow-y: auto;
            max-height: calc(100vh - 70px);
        }
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        .content-header h2 {
            font-size: 1.2rem;
            font-weight: 700;
            color: #1a202c;
        }
        
        /* Buttons */
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
        .btn-success {
            background: #48bb78;
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
        
        /* Table */
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
        
        /* Badges */
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
        
        /* Alerts */
        .alert {
            padding: 8px 12px;
            border-radius: 6px;
            margin-bottom: 10px;
            border-left: 3px solid;
            font-size: 12px;
            line-height: 1.4;
        }
        .alert-success { background: #f0fdf4; color: #22543d; border-left-color: #48bb78; }
        .alert-info { background: #eff6ff; color: #1e3a8a; border-left-color: #3b82f6; }
        
        /* User Distribution Box */
        .distribution-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            margin-bottom: 15px;
        }
        .distribution-item {
            padding: 10px;
            border-radius: 6px;
            border-left: 3px solid;
        }
        .distribution-item h5 {
            font-size: 10px;
            color: #718096;
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .distribution-item .value {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a202c;
        }
        
        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb { background: #cbd5e0; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #a0aec0; }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            .sidebar {
                grid-template-columns: repeat(2, 1fr);
                display: grid;
            }
            .stats-compact {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .navbar-menu { display: none; }
            .stats-compact { grid-template-columns: repeat(2, 1fr); }
            .sidebar { grid-template-columns: 1fr; }
            .distribution-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Multi-Language Navigation -->
    <jsp:include page="/includes/admin-navbar.jsp" />

    <!-- Main Container -->
    <div class="main-container">
        <div class="dashboard-grid">
            <!-- Left Sidebar -->
            <div class="sidebar">
                <!-- Compact Stats -->
                <div class="stats-compact">
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "card.total.users") %></h4>
                        <div class="value"><%= totalUsers %></div>
                    </div>
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "admin.candidates") %></h4>
                        <div class="value"><%= totalCandidates %></div>
                    </div>
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "status.active") %></h4>
                        <div class="value"><%= activeCandidates %></div>
                    </div>
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "expense.total") %></h4>
                        <div class="value" style="font-size: 1rem;">₹<%= String.format("%.0f", totalExpenses) %></div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions-compact">
                    <h3>⚡ <%= MessageBundle.getMessage(request, "action.quickactions") %></h3>
                    <a href="view-users.jsp" class="action-btn">👥 <%= MessageBundle.getMessage(request, "admin.view.users") %></a>
                    <a href="view-candidates.jsp" class="action-btn secondary">🗳️ <%= MessageBundle.getMessage(request, "admin.view.candidates") %></a>
                    <a href="view-brokers.jsp" class="action-btn tertiary">🤝 <%= MessageBundle.getMessage(request, "admin.view.brokers") %></a>
                    <a href="register-broker.jsp" class="action-btn" style="background: #ed8936;">➕ <%= MessageBundle.getMessage(request, "admin.register.broker") %></a>
                    <a href="manage-payments.jsp" class="action-btn" style="background: #4299e1;">💳 <%= MessageBundle.getMessage(request, "admin.payment.activity") %></a>
                </div>
                
                <!-- User Distribution -->
                <div class="quick-actions-compact">
                    <h3>📊 <%= MessageBundle.getMessage(request, "admin.user.distribution") %></h3>
                    <div class="distribution-grid">
                        <div class="distribution-item" style="background: #f0fdf4; border-left-color: #48bb78;">
                            <h5><%= MessageBundle.getMessage(request, "admin.role.user") %></h5>
                            <div class="value"><%= userCount %></div>
                        </div>
                        <div class="distribution-item" style="background: #fff7ed; border-left-color: #f59e0b;">
                            <h5><%= MessageBundle.getMessage(request, "admin.brokers") %></h5>
                            <div class="value"><%= brokerCount %></div>
                        </div>
                        <div class="distribution-item" style="background: #fef3c7; border-left-color: #fbbf24;">
                            <h5><%= MessageBundle.getMessage(request, "admin.role.admin") %></h5>
                            <div class="value"><%= adminCount %></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">✅ <%= request.getParameter("success") %></div>
                <% } %>
                
                <div class="alert alert-info">
                    ℹ️ <strong><%= MessageBundle.getMessage(request, "admin.read.only") %>:</strong> <%= MessageBundle.getMessage(request, "admin.read.only.message") %>
                </div>
                
                <div class="content-header">
                    <h2><%= MessageBundle.getMessage(request, "dashboard.welcome") %>, <%= user.getFullName().split(" ")[0] %>! 👑</h2>
                </div>
                
                <!-- Payment Status Overview -->
                <div style="margin-bottom: 15px;">
                    <h3 style="font-size: 14px; font-weight: 600; margin-bottom: 10px;">💳 <%= MessageBundle.getMessage(request, "admin.payment.overview") %></h3>
                    <table>
                        <tr>
                            <td><strong><%= MessageBundle.getMessage(request, "admin.total.registered") %>:</strong></td>
                            <td><span class="badge badge-info"><%= totalCandidates %></span></td>
                        </tr>
                        <tr>
                            <td><strong><%= MessageBundle.getMessage(request, "admin.paid.candidates") %>:</strong></td>
                            <td><span class="badge badge-success"><%= activeCandidates %></span></td>
                        </tr>
                        <tr>
                            <td><strong><%= MessageBundle.getMessage(request, "card.pending.payments") %>:</strong></td>
                            <td><span class="badge badge-warning"><%= pendingPayments %></span></td>
                        </tr>
                        <tr>
                            <td><strong><%= MessageBundle.getMessage(request, "admin.payment.success.rate") %>:</strong></td>
                            <td><span class="badge badge-info"><%= totalCandidates > 0 ? String.format("%.1f%%", (activeCandidates * 100.0 / totalCandidates)) : "0%" %></span></td>
                        </tr>
                    </table>
                </div>
                
                <!-- Recent Users -->
                <div>
                    <div class="content-header" style="border-bottom: none;">
                        <h3 style="font-size: 14px; font-weight: 600;">👥 <%= MessageBundle.getMessage(request, "admin.recent.users") %></h3>
                        <a href="view-users.jsp" class="btn btn-primary btn-sm"><%= MessageBundle.getMessage(request, "action.viewall") %> →</a>
                    </div>
                    <% if (allUsers != null && !allUsers.isEmpty()) { %>
                        <table>
                            <thead>
                                <tr>
                                    <th><%= MessageBundle.getMessage(request, "table.id") %></th>
                                    <th><%= MessageBundle.getMessage(request, "table.name") %></th>
                                    <th><%= MessageBundle.getMessage(request, "table.email") %></th>
                                    <th>Role</th>
                                    <th><%= MessageBundle.getMessage(request, "table.status") %></th>
                                    <th><%= MessageBundle.getMessage(request, "table.actions") %></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int count = 0;
                                for (User u : allUsers) {
                                    if (count >= 10) break;
                                    count++;
                                %>
                                    <tr>
                                        <td>#<%= u.getUserId() %></td>
                                        <td><strong><%= u.getFullName() %></strong></td>
                                        <td><%= u.getEmail() %></td>
                                        <td>
                                            <% if ("admin".equals(u.getUserRole())) { %>
                                                <span class="badge badge-danger"><%= MessageBundle.getMessage(request, "admin.role.admin") %></span>
                                            <% } else if ("broker".equals(u.getUserRole())) { %>
                                                <span class="badge badge-warning"><%= MessageBundle.getMessage(request, "admin.brokers") %></span>
                                            <% } else { %>
                                                <span class="badge badge-info"><%= MessageBundle.getMessage(request, "admin.role.user") %></span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge badge-success"><%= MessageBundle.getMessage(request, "status.active") %></span>
                                        </td>
                                        <td>
                                            <a href="user-details.jsp?userId=<%= u.getUserId() %>" class="btn btn-primary btn-sm"><%= MessageBundle.getMessage(request, "action.view") %></a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div style="text-align: center; padding: 40px; color: #718096;">
                            <div style="font-size: 3rem; margin-bottom: 15px;">👥</div>
                            <h3 style="color: #4a5568; margin-bottom: 8px;"><%= MessageBundle.getMessage(request, "user.no.candidates") %></h3>
                            <p style="font-size: 12px;">Users will appear here once they register.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
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
        .navbar-menu a:hover {
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
            background: white;
            color: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        h1 {
            color: #2d3748;
            margin-bottom: 30px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: block;
        }
        .stat-card h3 {
            color: #4a5568;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header h3 {
            margin: 0;
            font-size: 1.2rem;
        }
        .card-body {
            padding: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th,
        table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        table th {
            background: #f7fafc;
            color: #4a5568;
            font-weight: 600;
        }
        table tr:hover {
            background: #f7fafc;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .badge-success {
            background: #c6f6d5;
            color: #22543d;
        }
        .badge-warning {
            background: #fef3c7;
            color: #78350f;
        }
        .badge-danger {
            background: #fed7d7;
            color: #742a2a;
        }
        .badge-info {
            background: #bee3f8;
            color: #2c5282;
        }
        
        .btn {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        .btn-danger {
            background: #f56565;
            color: white;
        }
        .btn-danger:hover {
            background: #e53e3e;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .alert-info {
            background: #bee3f8;
            color: #2c5282;
            border-left: 4px solid #3182ce;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ Election Expense Management - ADMIN</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="view-users.jsp">Users</a></li>
                <li><a href="view-candidates.jsp">Candidates</a></li>
                <li><a href="view-brokers.jsp">Brokers</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName() != null ? user.getFullName().substring(0, 1).toUpperCase() : "A" %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container">
        <h1>📊 Admin Dashboard</h1>
        
        <div class="alert alert-info">
            <strong>Read-Only Access:</strong> As an admin, you have view-only access to all system data. You cannot modify or delete records.
        </div>
        
        <!-- Statistics Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-icon">👥</span>
                <h3>Total Users</h3>
                <div class="stat-value"><%= totalUsers %></div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">🗳️</span>
                <h3>Total Candidates</h3>
                <div class="stat-value"><%= totalCandidates %></div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">✅</span>
                <h3>Active Candidates</h3>
                <div class="stat-value"><%= activeCandidates %></div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">💰</span>
                <h3>Total Expenses</h3>
                <div class="stat-value">₹<%= String.format("%.2f", totalExpenses) %></div>
            </div>
        </div>
        
        <!-- User Distribution -->
        <div class="card">
            <div class="card-header">
                <h3>👥 User Distribution by Role</h3>
            </div>
            <div class="card-body">
                <div class="stats-grid">
                    <div class="stat-card">
                        <span class="stat-icon">🔐</span>
                        <h3>Admins</h3>
                        <div class="stat-value" style="font-size: 2rem;"><%= adminCount %></div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-icon">👤</span>
                        <h3>Regular Users</h3>
                        <div class="stat-value" style="font-size: 2rem;"><%= userCount %></div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-icon">🤝</span>
                        <h3>Brokers</h3>
                        <div class="stat-value" style="font-size: 2rem;"><%= brokerCount %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Payment Status -->
        <div class="card">
            <div class="card-header">
                <h3>💳 Payment Status Overview</h3>
            </div>
            <div class="card-body">
                <table>
                    <tr>
                        <td><strong>Total Candidates Registered:</strong></td>
                        <td><span class="badge badge-info"><%= totalCandidates %></span></td>
                    </tr>
                    <tr>
                        <td><strong>Paid Candidates (Active):</strong></td>
                        <td><span class="badge badge-success"><%= activeCandidates %></span></td>
                    </tr>
                    <tr>
                        <td><strong>Pending Payments:</strong></td>
                        <td><span class="badge badge-warning"><%= pendingPayments %></span></td>
                    </tr>
                    <tr>
                        <td><strong>Payment Success Rate:</strong></td>
                        <td><span class="badge badge-info"><%= totalCandidates > 0 ? String.format("%.1f%%", (activeCandidates * 100.0 / totalCandidates)) : "0%" %></span></td>
                    </tr>
                </table>
            </div>
        </div>
        
        <!-- System Information -->
        <div class="card">
            <div class="card-header">
                <h3>ℹ️ System Information</h3>
            </div>
            <div class="card-body">
                <p><strong>Database:</strong> election_expense_db</p>
                <p><strong>System Version:</strong> 2.0 (Fresh Build)</p>
                <p><strong>Role:</strong> Administrator (Read-Only)</p>
                <p><strong>Last Login:</strong> <%= user.getLastLogin() != null ? user.getLastLogin() : "N/A" %></p>
                <p style="margin-top: 20px; color: #666;">
                    Use the navigation menu above to view users, candidates, and brokers. 
                    All data is presented in read-only mode for monitoring and reporting purposes.
                </p>
            </div>
        </div>
    </div>
</body>
</html>

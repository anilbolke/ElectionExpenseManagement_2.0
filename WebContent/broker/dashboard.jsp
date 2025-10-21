<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.math.BigDecimal" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"broker".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Debug logging
    System.out.println("========== BROKER DASHBOARD DEBUG ==========");
    System.out.println("Broker User ID: " + user.getUserId());
    System.out.println("Broker Name: " + user.getFullName());
    System.out.println("Broker Role: " + user.getUserRole());
    System.out.println("============================================");
    
    // Initialize DAOs
    UserDAO userDAO = new UserDAO();
    CandidateDAO candidateDAO = new CandidateDAO();
    
    // Get broker's assigned users
    List<User> myUsers = null;
    int totalUsers = 0;
    int totalCandidates = 0;
    int activeCandidates = 0;
    BigDecimal totalRevenue = BigDecimal.ZERO;
    
    try {
        myUsers = userDAO.getUsersByBrokerId(user.getUserId());
        totalUsers = myUsers != null ? myUsers.size() : 0;
        
        if (myUsers != null) {
            for (User u : myUsers) {
                List<Candidate> userCandidates = candidateDAO.getCandidatesByUserId(u.getUserId());
                if (userCandidates != null) {
                    totalCandidates += userCandidates.size();
                    for (Candidate c : userCandidates) {
                        if (c.isPaymentVerified()) {
                            activeCandidates++;
                            if (c.getPaymentAmount() != null) {
                                totalRevenue = totalRevenue.add(c.getPaymentAmount());
                            }
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        System.err.println("ERROR in broker dashboard: " + e.getMessage());
        e.printStackTrace();
    }
    
    int pendingPayments = totalCandidates - activeCandidates;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Broker Dashboard - Election Expense Management</title>
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        .stat-mini:nth-child(1) { border-left-color: #f093fb; }
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            box-shadow: 0 4px 8px rgba(240, 147, 251, 0.3);
        }
        .action-btn.secondary {
            background: #48bb78;
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
        
        /* Compact Buttons */
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        
        /* Compact Alerts */
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
        .badge-info { background: #dbeafe; color: #1e3a8a; }
        
        /* Info Box */
        .info-box {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 3px solid #f093fb;
        }
        .info-box h4 {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #1a202c;
        }
        .info-box p {
            font-size: 12px;
            color: #64748b;
            line-height: 1.5;
            margin: 0;
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
        }
    </style>
</head>
<body>
    <!-- Multi-Language Navigation -->
    <jsp:include page="/includes/broker-navbar.jsp" />

    <!-- Main Container -->
    <div class="main-container">
        <div class="dashboard-grid">
            <!-- Left Sidebar -->
            <div class="sidebar">
                <!-- Compact Stats -->
                <div class="stats-compact">
                    <div class="stat-mini">
                        <h4>My Users</h4>
                        <div class="value"><%= totalUsers %></div>
                    </div>
                    <div class="stat-mini">
                        <h4>Active</h4>
                        <div class="value"><%= activeCandidates %></div>
                    </div>
                    <div class="stat-mini">
                        <h4>Candidates</h4>
                        <div class="value"><%= totalCandidates %></div>
                    </div>
                    <div class="stat-mini">
                        <h4>Revenue</h4>
                        <div class="value" style="font-size: 1rem;">₹<%= String.format("%.0f", totalRevenue) %></div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions-compact">
                    <h3>⚡ Quick Actions</h3>
                    <a href="my-users.jsp" class="action-btn">👥 View My Users</a>
                    <a href="my-candidates.jsp" class="action-btn secondary">🗳️ View Candidates</a>
                </div>
                
                <!-- Broker Info -->
                <div class="info-box">
                    <h4>ℹ️ Broker Info</h4>
                    <p><strong>ID:</strong> <%= user.getUserId() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                    <p><strong>Mobile:</strong> <%= user.getMobile() %></p>
                    <p><strong>City:</strong> <%= user.getCity() != null ? user.getCity() : "N/A" %></p>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <% if (session.getAttribute("success") != null) { %>
                    <div class="alert alert-success">✅ <%= session.getAttribute("success") %></div>
                    <% session.removeAttribute("success"); %>
                <% } %>
                
                <div class="content-header">
                    <h2>Welcome, <%= user.getFullName().split(" ")[0] %>! 👋</h2>
                </div>
                
                <!-- Performance Summary -->
                <div style="margin-bottom: 15px;">
                    <h3 style="font-size: 14px; font-weight: 600; margin-bottom: 10px;">📊 Performance Summary</h3>
                    <table>
                        <tr>
                            <td><strong>Total Users Assigned:</strong></td>
                            <td><span class="badge badge-info"><%= totalUsers %></span></td>
                        </tr>
                        <tr>
                            <td><strong>Total Candidates Created:</strong></td>
                            <td><span class="badge badge-info"><%= totalCandidates %></span></td>
                        </tr>
                        <tr>
                            <td><strong>Paid Candidates:</strong></td>
                            <td><span class="badge badge-success"><%= activeCandidates %></span></td>
                        </tr>
                        <tr>
                            <td><strong>Pending Payments:</strong></td>
                            <td><span class="badge badge-warning"><%= pendingPayments %></span></td>
                        </tr>
                        <tr>
                            <td><strong>Payment Success Rate:</strong></td>
                            <td><span class="badge badge-success"><%= totalCandidates > 0 ? String.format("%.1f%%", (activeCandidates * 100.0 / totalCandidates)) : "0%" %></span></td>
                        </tr>
                    </table>
                </div>
                
                <!-- Recent Users -->
                <div>
                    <div class="content-header" style="border-bottom: none;">
                        <h3 style="font-size: 14px; font-weight: 600;">👥 Recent Users</h3>
                        <a href="my-users.jsp" class="btn btn-primary btn-sm">View All →</a>
                    </div>
                    <% if (myUsers != null && !myUsers.isEmpty()) { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Mobile</th>
                                    <th>City</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int count = 0;
                                for (User u : myUsers) { 
                                    if (count++ >= 5) break;
                                %>
                                    <tr>
                                        <td>#<%= u.getUserId() %></td>
                                        <td><strong><%= u.getFullName() %></strong></td>
                                        <td><%= u.getEmail() %></td>
                                        <td><%= u.getMobile() %></td>
                                        <td><%= u.getCity() != null ? u.getCity() : "N/A" %></td>
                                        <td><span class="badge badge-success">Active</span></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div style="text-align: center; padding: 40px 20px; color: #718096;">
                            <div style="font-size: 3rem; margin-bottom: 15px;">👥</div>
                            <h3 style="color: #4a5568; margin-bottom: 8px;">No Users Yet</h3>
                            <p style="font-size: 12px;">Users will appear here when they select you as their broker during registration.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

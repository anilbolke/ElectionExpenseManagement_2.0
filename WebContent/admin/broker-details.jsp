<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.util.ArrayList" %>
<%
    // Authentication check
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get broker details
    String brokerIdParam = request.getParameter("brokerId");
    User broker = null;
    List<User> brokerUsers = new ArrayList<>();
    List<Candidate> allCandidates = new ArrayList<>();
    int totalCandidates = 0;
    int activeCandidates = 0;
    
    if (brokerIdParam != null && !brokerIdParam.isEmpty()) {
        try {
            int brokerId = Integer.parseInt(brokerIdParam);
            UserDAO userDAO = new UserDAO();
            broker = userDAO.getUserById(brokerId);
            
            if (broker != null && "broker".equals(broker.getUserRole())) {
                // Get users assigned to this broker
                brokerUsers = userDAO.getUsersByBrokerId(brokerId);
                
                // Get all candidates for these users
                if (brokerUsers != null && !brokerUsers.isEmpty()) {
                    CandidateDAO candidateDAO = new CandidateDAO();
                    for (User u : brokerUsers) {
                        List<Candidate> userCandidates = candidateDAO.getCandidatesByUserId(u.getUserId());
                        if (userCandidates != null) {
                            allCandidates.addAll(userCandidates);
                            totalCandidates += userCandidates.size();
                            for (Candidate c : userCandidates) {
                                if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) {
                                    activeCandidates++;
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (broker == null) {
        response.sendRedirect("view-brokers.jsp");
        return;
    }
    
    int pendingCandidates = totalCandidates - activeCandidates;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Broker Details - Admin Dashboard</title>
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
        .stat-box:nth-child(1) { border-left-color: #f093fb; }
        .stat-box:nth-child(2) { border-left-color: #48bb78; }
        .stat-box:nth-child(3) { border-left-color: #667eea; }
        .stat-box:nth-child(4) { border-left-color: #ed8936; }
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
            border-left: 3px solid #f093fb;
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
        
        .user-card {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            border-left: 3px solid #667eea;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user-card:hover {
            background: #f1f5f9;
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
                <li><a href="view-candidates.jsp">Candidates</a></li>
                <li><a href="view-brokers.jsp" class="active">Brokers</a></li>
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
        <a href="view-brokers.jsp" class="back-button">← Back to All Brokers</a>
        
        <div class="page-header">
            <h1>🤝 Broker Details</h1>
            <div class="breadcrumb">
                <a href="dashboard.jsp">Dashboard</a> / 
                <a href="view-brokers.jsp">Brokers</a> / 
                <%= broker.getFullName() %>
            </div>
        </div>
        
        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-box">
                <h4>Broker ID</h4>
                <div class="value">#<%= broker.getUserId() %></div>
            </div>
            <div class="stat-box">
                <h4>Assigned Users</h4>
                <div class="value"><%= brokerUsers != null ? brokerUsers.size() : 0 %></div>
            </div>
            <div class="stat-box">
                <h4>Total Candidates</h4>
                <div class="value"><%= totalCandidates %></div>
            </div>
            <div class="stat-box">
                <h4>Active Candidates</h4>
                <div class="value"><%= activeCandidates %></div>
            </div>
        </div>
        
        <!-- Broker Information -->
        <div class="card">
            <div class="card-header">
                <h3>ℹ️ Broker Information</h3>
                <% if (broker.isActive()) { %>
                    <span class="badge badge-success">Active</span>
                <% } else { %>
                    <span class="badge badge-danger">Inactive</span>
                <% } %>
            </div>
            <div class="card-body">
                <div class="info-grid">
                    <div class="info-item">
                        <label>Username</label>
                        <div class="value"><%= broker.getUsername() %></div>
                    </div>
                    <div class="info-item">
                        <label>Full Name</label>
                        <div class="value"><%= broker.getFullName() != null ? broker.getFullName() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <div class="value"><%= broker.getEmail() != null ? broker.getEmail() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Mobile</label>
                        <div class="value"><%= broker.getMobile() != null ? broker.getMobile() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>City</label>
                        <div class="value"><%= broker.getCity() != null ? broker.getCity() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>State</label>
                        <div class="value"><%= broker.getState() != null ? broker.getState() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Pincode</label>
                        <div class="value"><%= broker.getPincode() != null ? broker.getPincode() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Registration Date</label>
                        <div class="value"><%= broker.getCreatedDate() != null ? broker.getCreatedDate() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Last Login</label>
                        <div class="value"><%= broker.getLastLogin() != null ? broker.getLastLogin() : "Never" %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Performance Overview -->
        <div class="card">
            <div class="card-header">
                <h3>📊 Performance Overview</h3>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                    <div style="padding: 15px; background: #f0fdf4; border-radius: 8px; border-left: 3px solid #48bb78;">
                        <div style="font-size: 11px; color: #718096; text-transform: uppercase; margin-bottom: 5px;">Active Candidates</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;"><%= activeCandidates %></div>
                    </div>
                    <div style="padding: 15px; background: #fff7ed; border-radius: 8px; border-left: 3px solid #ed8936;">
                        <div style="font-size: 11px; color: #718096; text-transform: uppercase; margin-bottom: 5px;">Pending Candidates</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;"><%= pendingCandidates %></div>
                    </div>
                    <div style="padding: 15px; background: #eff6ff; border-radius: 8px; border-left: 3px solid #3b82f6;">
                        <div style="font-size: 11px; color: #718096; text-transform: uppercase; margin-bottom: 5px;">Success Rate</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;">
                            <%= totalCandidates > 0 ? String.format("%.1f%%", (activeCandidates * 100.0 / totalCandidates)) : "0%" %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Assigned Users -->
        <div class="card">
            <div class="card-header">
                <h3>👥 Assigned Users</h3>
                <span class="badge badge-info"><%= brokerUsers != null ? brokerUsers.size() : 0 %> Users</span>
            </div>
            <div class="card-body">
                <% if (brokerUsers != null && !brokerUsers.isEmpty()) { %>
                    <% for (User u : brokerUsers) { 
                        CandidateDAO candidateDAO = new CandidateDAO();
                        List<Candidate> userCands = candidateDAO.getCandidatesByUserId(u.getUserId());
                        int userCandCount = userCands != null ? userCands.size() : 0;
                    %>
                        <div class="user-card">
                            <div>
                                <div style="font-weight: 600; color: #1a202c; margin-bottom: 5px;">
                                    <%= u.getFullName() != null ? u.getFullName() : u.getUsername() %>
                                </div>
                                <div style="font-size: 11px; color: #64748b;">
                                    ID: #<%= u.getUserId() %> | 
                                    Email: <%= u.getEmail() != null ? u.getEmail() : "N/A" %> | 
                                    Candidates: <%= userCandCount %>
                                </div>
                            </div>
                            <a href="user-details.jsp?userId=<%= u.getUserId() %>" class="btn btn-primary btn-sm">View</a>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state">
                        <div style="font-size: 3rem; margin-bottom: 15px;">👥</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Users Assigned</h3>
                        <p>No users have selected this broker yet.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- All Candidates -->
        <div class="card">
            <div class="card-header">
                <h3>🗳️ All Candidates Under This Broker</h3>
                <span class="badge badge-info"><%= totalCandidates %> Candidates</span>
            </div>
            <div class="card-body">
                <% if (allCandidates != null && !allCandidates.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Party</th>
                                <th>Constituency</th>
                                <th>Owner</th>
                                <th>Payment</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            UserDAO userDAO = new UserDAO();
                            for (Candidate c : allCandidates) { 
                                User owner = userDAO.getUserById(c.getUserId());
                            %>
                                <tr>
                                    <td>#<%= c.getCandidateId() %></td>
                                    <td><strong><%= c.getCandidateName() != null ? c.getCandidateName() : "N/A" %></strong></td>
                                    <td><%= c.getPartyName() != null ? c.getPartyName() : "Independent" %></td>
                                    <td><%= c.getConstituency() != null ? c.getConstituency() : "N/A" %></td>
                                    <td><%= owner != null ? owner.getFullName() : "N/A" %></td>
                                    <td>
                                        <% if (c.isPaymentVerified()) { %>
                                            <span class="badge badge-success">✓ Paid</span>
                                        <% } else { %>
                                            <span class="badge badge-warning">Pending</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% 
                                            String accStatus = c.getAccountStatus();
                                            String accBadge = "badge-warning";
                                            if ("active".equals(accStatus)) accBadge = "badge-success";
                                            else if ("pending_payment".equals(accStatus)) accBadge = "badge-danger";
                                        %>
                                        <span class="badge <%= accBadge %>"><%= accStatus != null ? accStatus.replace("_", " ").toUpperCase() : "N/A" %></span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <div style="font-size: 3rem; margin-bottom: 15px;">🗳️</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Candidates Yet</h3>
                        <p>No candidates have been created by users under this broker.</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Actions -->
        <div style="display: flex; gap: 15px; margin-top: 20px;">
            <a href="view-brokers.jsp" class="btn btn-primary">← Back to All Brokers</a>
        </div>
    </div>
</body>
</html>

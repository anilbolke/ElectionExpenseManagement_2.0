<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List" %>
<%
    // Authentication check
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get user details
    String userIdParam = request.getParameter("userId");
    User viewUser = null;
    List<Candidate> userCandidates = null;
    
    if (userIdParam != null && !userIdParam.isEmpty()) {
        try {
            int userId = Integer.parseInt(userIdParam);
            UserDAO userDAO = new UserDAO();
            viewUser = userDAO.getUserById(userId);
            
            if (viewUser != null && "user".equals(viewUser.getUserRole())) {
                CandidateDAO candidateDAO = new CandidateDAO();
                userCandidates = candidateDAO.getCandidatesByUserId(userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (viewUser == null) {
        response.sendRedirect("view-users.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 14px;
            color: #2d3748;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            padding: 10px 0;
        }
        .navbar-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar-brand {
            font-size: 1.3rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .navbar-menu {
            display: flex;
            list-style: none;
            gap: 5px;
        }
        .navbar-menu a {
            color: #4a5568;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 6px;
            transition: all 0.2s;
            font-weight: 500;
        }
        .navbar-menu a:hover, .navbar-menu a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        .page-header h1 {
            font-size: 2rem;
            color: #1a202c;
            margin-bottom: 10px;
        }
        .breadcrumb {
            color: #64748b;
            font-size: 14px;
        }
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header h3 {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
        }
        .card-body {
            padding: 25px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .info-item {
            padding: 15px;
            background: #f8fafc;
            border-radius: 8px;
            border-left: 3px solid #667eea;
        }
        .info-item label {
            display: block;
            font-size: 12px;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 5px;
            letter-spacing: 0.5px;
        }
        .info-item .value {
            font-size: 16px;
            color: #1a202c;
            font-weight: 500;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th {
            background: #f7fafc;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        table td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
        }
        table tr:hover {
            background: #f7fafc;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 12px;
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
            gap: 8px;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
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
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .btn-sm {
            padding: 6px 14px;
            font-size: 13px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }
        .empty-state .icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .back-button:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">👑 Admin Portal</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="view-users.jsp" class="active">Users</a></li>
                <li><a href="view-candidates.jsp">Candidates</a></li>
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
        <a href="view-users.jsp" class="back-button">← Back to All Users</a>
        
        <div class="page-header">
            <h1>👤 User Details</h1>
            <div class="breadcrumb">
                <a href="dashboard.jsp">Dashboard</a> / 
                <a href="view-users.jsp">Users</a> / 
                <%= viewUser.getFullName() %>
            </div>
        </div>
        
        <!-- User Information -->
        <div class="card">
            <div class="card-header">
                <h3>ℹ️ User Information</h3>
                <span class="badge <%= viewUser.isActive() ? "badge-success" : "badge-danger" %>">
                    <%= viewUser.isActive() ? "Active" : "Inactive" %>
                </span>
            </div>
            <div class="card-body">
                <div class="info-grid">
                    <div class="info-item">
                        <label>User ID</label>
                        <div class="value">#<%= viewUser.getUserId() %></div>
                    </div>
                    <div class="info-item">
                        <label>Username</label>
                        <div class="value"><%= viewUser.getUsername() %></div>
                    </div>
                    <div class="info-item">
                        <label>Full Name</label>
                        <div class="value"><%= viewUser.getFullName() != null ? viewUser.getFullName() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <div class="value"><%= viewUser.getEmail() != null ? viewUser.getEmail() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Mobile</label>
                        <div class="value"><%= viewUser.getMobile() != null ? viewUser.getMobile() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>City</label>
                        <div class="value"><%= viewUser.getCity() != null ? viewUser.getCity() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>User Role</label>
                        <div class="value">
                            <% 
                                String role = viewUser.getUserRole();
                                String badgeClass = "badge-info";
                                if ("admin".equals(role)) badgeClass = "badge-danger";
                                else if ("broker".equals(role)) badgeClass = "badge-warning";
                                else if ("user".equals(role)) badgeClass = "badge-success";
                            %>
                            <span class="badge <%= badgeClass %>"><%= role != null ? role.toUpperCase() : "N/A" %></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <label>Broker ID</label>
                        <div class="value"><%= viewUser.getBrokerId() != null && viewUser.getBrokerId() > 0 ? "#" + viewUser.getBrokerId() : "None" %></div>
                    </div>
                    <div class="info-item">
                        <label>Registration Date</label>
                        <div class="value"><%= viewUser.getCreatedDate() != null ? viewUser.getCreatedDate() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <label>Last Login</label>
                        <div class="value"><%= viewUser.getLastLogin() != null ? viewUser.getLastLogin() : "Never" %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- User's Candidates -->
        <% if ("user".equals(viewUser.getUserRole())) { %>
        <div class="card">
            <div class="card-header">
                <h3>🗳️ Candidates Registered by this User</h3>
                <span class="badge badge-info"><%= userCandidates != null ? userCandidates.size() : 0 %> Total</span>
            </div>
            <div class="card-body">
                <% if (userCandidates != null && !userCandidates.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Candidate Name</th>
                                <th>Party</th>
                                <th>Constituency</th>
                                <th>Election Type</th>
                                <th>Contact</th>
                                <th>Payment Status</th>
                                <th>Account Status</th>
                                <th>Created Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Candidate c : userCandidates) { %>
                                <tr>
                                    <td>#<%= c.getCandidateId() %></td>
                                    <td><strong><%= c.getCandidateName() != null ? c.getCandidateName() : "N/A" %><% if(c.getNominationId() != null && !c.getNominationId().trim().isEmpty()) { %> - <%= c.getNominationId() %><% } %></strong></td>
                                    <td><%= c.getPartyName() != null ? c.getPartyName() : "Independent" %></td>
                                    <td><%= c.getConstituency() != null ? c.getConstituency() : "N/A" %></td>
                                    <td><%= c.getElectionType() != null ? c.getElectionType() : "N/A" %></td>
                                    <td><%= c.getMobile() != null ? c.getMobile() : "N/A" %></td>
                                    <td>
                                        <% if (c.isPaymentVerified()) { %>
                                            <span class="badge badge-success">✓ Verified</span>
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
                                        <span class="badge <%= accBadge %>">
                                            <%= accStatus != null ? accStatus.replace("_", " ").toUpperCase() : "N/A" %>
                                        </span>
                                    </td>
                                    <td><%= c.getCreatedDate() != null ? c.getCreatedDate() : "N/A" %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <div class="icon">🗳️</div>
                        <h3 style="color: #4a5568; margin-bottom: 10px;">No Candidates Yet</h3>
                        <p>This user hasn't registered any candidates.</p>
                    </div>
                <% } %>
            </div>
        </div>
        <% } %>
        
        <!-- Actions -->
        <div style="display: flex; gap: 15px; margin-top: 30px;">
            <a href="view-users.jsp" class="btn btn-primary">← Back to All Users</a>
        </div>
    </div>
</body>
</html>

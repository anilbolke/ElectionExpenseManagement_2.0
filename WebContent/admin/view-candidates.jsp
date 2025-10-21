<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, com.election.util.PaginationUtil, java.util.List" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get ALL candidates (admin sees everything)
    CandidateDAO candidateDAO = new CandidateDAO();
    UserDAO userDAO = new UserDAO();
    List<Candidate> allCandidates = candidateDAO.getAllCandidates();
    
    // Pagination setup
    int currentPage = 1;
    int pageSize = 10; // Default page size
    
    String pageParam = request.getParameter("page");
    String pageSizeParam = request.getParameter("pageSize");
    
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    if (pageSizeParam != null) {
        try {
            pageSize = Integer.parseInt(pageSizeParam);
        } catch (NumberFormatException e) {
            pageSize = 10;
        }
    }
    
    // Create pagination object
    PaginationUtil paginationUtil = new PaginationUtil(currentPage, pageSize, allCandidates.size());
    List<Candidate> displayCandidates = paginationUtil.getPaginatedList(allCandidates);
    
    // Set pagination attributes for include
    request.setAttribute("pagination", paginationUtil);
    request.setAttribute("paginationBaseUrl", "view-candidates.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Candidates - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <%@ include file="../includes/pagination-style.jsp" %>
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
        
        .stats-summary {
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
        
        .search-box {
            margin-bottom: 15px;
        }
        .search-box input {
            width: 100%;
            max-width: 400px;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 13px;
            font-family: 'Inter', sans-serif;
        }
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
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
            position: sticky;
            top: 0;
            z-index: 10;
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
            white-space: nowrap;
        }
        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-warning { background: #fed7aa; color: #78350f; }
        .badge-danger { background: #fecaca; color: #991b1b; }
        .badge-info { background: #dbeafe; color: #1e3a8a; }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            font-size: 11px;
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
            .stats-summary { grid-template-columns: repeat(2, 1fr); }
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
                <div class="user-avatar"><%= user.getFullName() != null ? user.getFullName().substring(0, 1).toUpperCase() : "A" %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container">
        <div class="page-header">
            <h1>🗳️ All Candidates</h1>
            <div class="breadcrumb">Dashboard / Candidates</div>
        </div>
        
        <%
            int totalCandidates = allCandidates != null ? allCandidates.size() : 0;
            int activeCandidates = 0;
            int pendingPayments = 0;
            
            if (allCandidates != null) {
                for (Candidate c : allCandidates) {
                    if (c.isPaymentVerified()) {
                        activeCandidates++;
                    } else {
                        pendingPayments++;
                    }
                }
            }
        %>
        
        <!-- Statistics Summary -->
        <div class="stats-summary">
            <div class="stat-box">
                <h4>Total Candidates</h4>
                <div class="value"><%= totalCandidates %></div>
            </div>
            <div class="stat-box">
                <h4>Active (Paid)</h4>
                <div class="value"><%= activeCandidates %></div>
            </div>
            <div class="stat-box">
                <h4>Pending Payment</h4>
                <div class="value"><%= pendingPayments %></div>
            </div>
            <div class="stat-box">
                <h4>Success Rate</h4>
                <div class="value"><%= totalCandidates > 0 ? String.format("%.0f%%", (activeCandidates * 100.0 / totalCandidates)) : "0%" %></div>
            </div>
        </div>
        
        <!-- Candidates Table -->
        <div class="card">
            <div class="card-header">
                <h3>📋 Candidate List (Read-Only)</h3>
            </div>
            <div class="card-body">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="🔍 Search by name, party, constituency..." onkeyup="filterTable()">
                </div>
                
                <% if (allCandidates != null && !allCandidates.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                    <table id="candidatesTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Party</th>
                                <th>Constituency</th>
                                <th>Election Type</th>
                                <th>Broker</th>
                                <th>Contact</th>
                                <th>Payment</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Candidate c : displayCandidates) { 
                                // Get broker info for this candidate
                                User broker = null;
                                if (c.getBrokerId() > 0) {
                                    broker = userDAO.getUserById(c.getBrokerId());
                                }
                            %>
                                <tr>
                                    <td>#<%= c.getCandidateId() %></td>
                                    <td><strong><%= c.getCandidateName() != null ? c.getCandidateName() : "N/A" %></strong></td>
                                    <td><%= c.getPartyName() != null ? c.getPartyName() : "N/A" %></td>
                                    <td><%= c.getConstituency() != null ? c.getConstituency() : "N/A" %></td>
                                    <td><%= c.getElectionType() != null ? c.getElectionType() : "N/A" %></td>
                                    <td>
                                        <% if (broker != null) { %>
                                            <a href="broker-details.jsp?brokerId=<%= broker.getUserId() %>" 
                                               class="badge badge-info" 
                                               style="text-decoration: none; cursor: pointer;"
                                               title="View broker details">
                                                🤝 <%= broker.getUsername() %>
                                            </a>
                                        <% } else { %>
                                            <span class="badge badge-warning">No Broker</span>
                                        <% } %>
                                    </td>
                                    <td><%= c.getMobile() != null ? c.getMobile() : "N/A" %></td>
                                    <td>
                                        <% if (c.isPaymentVerified()) { %>
                                            <span class="badge badge-success">✓ Verified</span>
                                        <% } else if ("completed".equals(c.getPaymentStatus())) { %>
                                            <span class="badge badge-warning">Pending</span>
                                        <% } else { %>
                                            <span class="badge badge-danger">Not Paid</span>
                                        <% } %>
                                    </td>
                                    <td>₹<%= String.format("%.2f", c.getPaymentAmount()) %></td>
                                    <td>
                                        <% 
                                            String accStatus = c.getAccountStatus();
                                            String accBadge = "badge-warning";
                                            if ("active".equals(accStatus)) accBadge = "badge-success";
                                            else if ("pending_payment".equals(accStatus)) accBadge = "badge-danger";
                                        %>
                                        <span class="badge <%= accBadge %>"><%= accStatus != null ? accStatus.replace("_", " ").toUpperCase() : "N/A" %></span>
                                    </td>
                                    <td style="font-size: 11px;">
                                        <% 
                                        if (c.getCreatedDate() != null) {
                                            String dateStr = c.getCreatedDate().toString();
                                            out.print(dateStr.length() > 10 ? dateStr.substring(0, 10) : dateStr);
                                        } else {
                                            out.print("N/A");
                                        }
                                        %>
                                    </td>
                                    <td>
                                        <a href="candidate-details.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-primary btn-sm">View</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                    </div>
                    
                    <!-- Pagination -->
                    <%@ include file="../includes/pagination.jsp" %>
                    
                <% } else { %>
                    <div class="empty-state">
                        <div style="font-size: 3rem; margin-bottom: 15px;">🗳️</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Candidates Found</h3>
                        <p>No candidates found in the system.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        function filterTable() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('candidatesTable');
            const tr = table.getElementsByTagName('tr');
            
            for (let i = 1; i < tr.length; i++) {
                const td = tr[i].getElementsByTagName('td');
                let found = false;
                
                for (let j = 0; j < td.length; j++) {
                    if (td[j]) {
                        const txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            found = true;
                            break;
                        }
                    }
                }
                
                tr[i].style.display = found ? '' : 'none';
            }
        }
    </script>
</body>
</html>

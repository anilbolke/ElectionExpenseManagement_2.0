<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, com.election.util.PaginationUtil, java.util.List, java.util.ArrayList" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get all brokers
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
    List<User> brokers = new ArrayList<>();
    
    if (allUsers != null) {
        for (User u : allUsers) {
            if ("broker".equals(u.getUserRole())) {
                brokers.add(u);
            }
        }
    }
    
    // Pagination setup
    int currentPage = 1;
    int pageSize = 10;
    
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
    PaginationUtil paginationUtil = new PaginationUtil(currentPage, pageSize, brokers.size());
    List<User> displayBrokers = paginationUtil.getPaginatedList(brokers);
    
    // Set pagination attributes for include
    request.setAttribute("pagination", paginationUtil);
    request.setAttribute("paginationBaseUrl", "view-brokers.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Brokers - Admin Dashboard</title>
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
        
        .stat-box {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border-left: 3px solid #f093fb;
            margin-bottom: 20px;
            display: inline-block;
            min-width: 200px;
        }
        .stat-box h4 {
            color: #718096;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        .stat-box .value {
            font-size: 2rem;
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
        }
        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-warning { background: #fed7aa; color: #78350f; }
        .badge-danger { background: #fecaca; color: #991b1b; }
        
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
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.3s;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 10px;
            width: 90%;
            max-width: 800px;
            max-height: 80vh;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            animation: slideDown 0.3s;
        }
        @keyframes slideDown {
            from { 
                transform: translateY(-50px);
                opacity: 0;
            }
            to { 
                transform: translateY(0);
                opacity: 1;
            }
        }
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h2 {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 600;
        }
        .close-btn {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            background: none;
            border: none;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .close-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: rotate(90deg);
        }
        .modal-body {
            padding: 20px;
            max-height: 60vh;
            overflow-y: auto;
        }
        .modal-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        .modal-table th {
            background: #f7fafc;
            padding: 12px 10px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .modal-table td {
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
        }
        .modal-table tr:hover {
            background: #f7fafc;
        }
        .clickable-badge {
            cursor: pointer;
            transition: all 0.2s;
        }
        .clickable-badge:hover {
            transform: scale(1.1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .empty-modal-state {
            text-align: center;
            padding: 40px 20px;
            color: #718096;
        }
        
        @media (max-width: 768px) {
            .navbar-menu { display: none; }
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
        }
    </style>
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
                <div class="user-avatar"><%= user.getFullName() != null ? user.getFullName().substring(0, 1).toUpperCase() : "A" %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container">
        <div class="page-header">
            <h1>🤝 All Brokers <span style="color: red; font-size: 0.8rem;">[UPDATED v2.0]</span></h1>
            <div class="breadcrumb">Dashboard / Brokers</div>
        </div>
        
        <%
            int totalBrokers = brokers != null ? brokers.size() : 0;
            int activeBrokers = 0;
            
            if (brokers != null) {
                for (User b : brokers) {
                    if (b.isActive()) {
                        activeBrokers++;
                    }
                }
            }
            
            // Count users under each broker
            CandidateDAO candidateDAO = new CandidateDAO();
        %>
        
        <!-- Statistics Summary -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 12px; margin-bottom: 20px;">
            <div class="stat-box">
                <h4>Total Brokers</h4>
                <div class="value"><%= totalBrokers %></div>
            </div>
            <div class="stat-box" style="border-left-color: #48bb78;">
                <h4>Active Brokers</h4>
                <div class="value"><%= activeBrokers %></div>
            </div>
            <div class="stat-box" style="border-left-color: #f56565;">
                <h4>Inactive Brokers</h4>
                <div class="value"><%= totalBrokers - activeBrokers %></div>
            </div>
        </div>
        
        <!-- Brokers Table -->
        <div class="card">
            <div class="card-header">
                <h3>📋 Broker List (Read-Only)</h3>
            </div>
            <div class="card-body">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="🔍 Search by name, email, username..." onkeyup="filterTable()">
                </div>
                
                <% if (brokers != null && !brokers.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                    <table id="brokersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                                <th>Status</th>
                                <th>Users</th>
                                <th>Candidates</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User broker : displayBrokers) {
                                // Count users assigned to this broker
                                int assignedUsers = 0;
                                if (allUsers != null) {
                                    for (User u : allUsers) {
                                        if ("user".equals(u.getUserRole()) && u.getBrokerId() != null && u.getBrokerId() == broker.getUserId()) {
                                            assignedUsers++;
                                        }
                                    }
                                }
                                
                                // Count candidates assigned to this broker
                                int candidateCount = candidateDAO.getCandidateCountByBroker(broker.getUserId());
                            %>
                                <tr>
                                    <td>#<%= broker.getUserId() %></td>
                                    <td><strong><%= broker.getUsername() %></strong></td>
                                    <td><%= broker.getFullName() != null ? broker.getFullName() : "N/A" %></td>
                                    <td><%= broker.getEmail() != null ? broker.getEmail() : "N/A" %></td>
                                    <td><%= broker.getMobile() != null ? broker.getMobile() : "N/A" %></td>
                                    <td>
                                        <% if (broker.isActive()) { %>
                                            <span class="badge badge-success">Active</span>
                                        <% } else { %>
                                            <span class="badge badge-danger">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td><span class="badge badge-warning clickable-badge" onclick="showUsers(<%= broker.getUserId() %>, '<%= broker.getUsername().replace("'", "\\'") %>')"><%= assignedUsers %></span></td>
                                    <td><span class="badge badge-success clickable-badge" onclick="showCandidates(<%= broker.getUserId() %>, '<%= broker.getUsername().replace("'", "\\'") %>')"><%= candidateCount %></span></td>
                                    <td style="font-size: 11px;"><%= broker.getCreatedDate() != null ? broker.getCreatedDate().toString().substring(0, 10) : "N/A" %></td>
                                    <td>
                                        <a href="broker-details.jsp?brokerId=<%= broker.getUserId() %>" class="btn btn-primary btn-sm">View</a>
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
                        <div style="font-size: 3rem; margin-bottom: 15px;">🤝</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Brokers Found</h3>
                        <p>No brokers found in the system.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Users Modal -->
    <div id="usersModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="usersModalTitle">👥 Users</h2>
                <button class="close-btn" onclick="closeModal('usersModal')">&times;</button>
            </div>
            <div class="modal-body" id="usersModalBody">
                <div style="text-align: center; padding: 40px;">
                    <div style="font-size: 2rem;">⏳</div>
                    <p>Loading users...</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Candidates Modal -->
    <div id="candidatesModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="candidatesModalTitle">🗳️ Candidates</h2>
                <button class="close-btn" onclick="closeModal('candidatesModal')">&times;</button>
            </div>
            <div class="modal-body" id="candidatesModalBody">
                <div style="text-align: center; padding: 40px;">
                    <div style="font-size: 2rem;">⏳</div>
                    <p>Loading candidates...</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Store data for modals
        const brokersData = {
            <% 
            for (int i = 0; i < brokers.size(); i++) {
                User broker = brokers.get(i);
                
                // Get users for this broker
                List<User> brokerUsers = new ArrayList<>();
                if (allUsers != null) {
                    for (User u : allUsers) {
                        if ("user".equals(u.getUserRole()) && u.getBrokerId() != null && u.getBrokerId() == broker.getUserId()) {
                            brokerUsers.add(u);
                        }
                    }
                }
                
                // Get candidates for this broker
                List<Candidate> brokerCandidates = candidateDAO.getCandidatesByBroker(broker.getUserId());
                if (brokerCandidates == null) {
                    brokerCandidates = new ArrayList<>();
                }
            %>
            <%= broker.getUserId() %>: {
                brokerName: '<%= broker.getUsername().replace("'", "\\'") %>',
                users: [
                    <% for (int j = 0; j < brokerUsers.size(); j++) {
                        User u = brokerUsers.get(j);
                    %>
                    {
                        userId: <%= u.getUserId() %>,
                        username: '<%= u.getUsername() != null ? u.getUsername().replace("'", "\\'") : "N/A" %>',
                        fullName: '<%= u.getFullName() != null ? u.getFullName().replace("'", "\\'") : "N/A" %>',
                        email: '<%= u.getEmail() != null ? u.getEmail().replace("'", "\\'") : "N/A" %>',
                        mobile: '<%= u.getMobile() != null ? u.getMobile().replace("'", "\\'") : "N/A" %>',
                        status: '<%= u.isActive() ? "Active" : "Inactive" %>'
                    }<%= j < brokerUsers.size() - 1 ? "," : "" %>
                    <% } %>
                ],
                candidates: [
                    <% for (int k = 0; k < brokerCandidates.size(); k++) {
                        Candidate c = brokerCandidates.get(k);
                    %>
                    {
                        candidateId: <%= c.getCandidateId() %>,
                        name: '<%= c.getCandidateName() != null ? c.getCandidateName().replace("'", "\\'") : "N/A" %><% if(c.getNominationId() != null && !c.getNominationId().trim().isEmpty()) { %> - <%= c.getNominationId().replace("'", "\\'") %><% } %>',
                        email: '<%= c.getEmail() != null ? c.getEmail().replace("'", "\\'") : "N/A" %>',
                        mobile: '<%= c.getMobile() != null ? c.getMobile().replace("'", "\\'") : "N/A" %>',
                        constituency: '<%= c.getConstituency() != null ? c.getConstituency().replace("'", "\\'") : "N/A" %>',
                        partyName: '<%= c.getPartyName() != null ? c.getPartyName().replace("'", "\\'") : "N/A" %>',
                        electionType: '<%= c.getElectionType() != null ? c.getElectionType().replace("'", "\\'") : "N/A" %>',
                        paymentStatus: '<%= c.getPaymentStatus() != null ? c.getPaymentStatus().replace("'", "\\'") : "N/A" %>'
                    }<%= k < brokerCandidates.size() - 1 ? "," : "" %>
                    <% } %>
                ]
            }<%= i < brokers.size() - 1 ? "," : "" %>
            <% } %>
        };
        
        // Debug: Log all brokers data
        console.log('All Brokers Data:', brokersData);
        console.log('Total Brokers:', Object.keys(brokersData).length);
        
        function showUsers(brokerId, brokerName) {
            const modal = document.getElementById('usersModal');
            const title = document.getElementById('usersModalTitle');
            const body = document.getElementById('usersModalBody');
            
            title.innerHTML = '👥 Users assigned to Broker: ' + brokerName;
            
            const data = brokersData[brokerId];
            
            // Debug logging
            console.log('Broker ID:', brokerId);
            console.log('Broker Data:', data);
            console.log('Users:', data ? data.users : 'No data');
            
            if (!data || !data.users || data.users.length === 0) {
                body.innerHTML = `
                    <div class="empty-modal-state">
                        <div style="font-size: 3rem; margin-bottom: 15px;">👥</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Users Found</h3>
                        <p>No users are assigned to this broker.</p>
                    </div>
                `;
            } else {
                let tableHTML = `
                    <table class="modal-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                `;
                
                data.users.forEach(user => {
                    const statusBadge = user.status === 'Active' 
                        ? '<span class="badge badge-success">Active</span>'
                        : '<span class="badge badge-danger">Inactive</span>';
                    
                    tableHTML += `
                        <tr>
                            <td>#${user.userId}</td>
                            <td><strong>${user.username}</strong></td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>${user.mobile}</td>
                            <td>${statusBadge}</td>
                        </tr>
                    `;
                });
                
                tableHTML += `
                        </tbody>
                    </table>
                `;
                
                body.innerHTML = tableHTML;
            }
            
            modal.style.display = 'block';
        }
        
        function showCandidates(brokerId, brokerName) {
            const modal = document.getElementById('candidatesModal');
            const title = document.getElementById('candidatesModalTitle');
            const body = document.getElementById('candidatesModalBody');
            
            title.innerHTML = '🗳️ Candidates registered under Broker: ' + brokerName;
            
            const data = brokersData[brokerId];
            
            // Debug logging
            console.log('Broker ID:', brokerId);
            console.log('Broker Data:', data);
            console.log('Candidates:', data ? data.candidates : 'No data');
            
            if (!data || !data.candidates || data.candidates.length === 0) {
                body.innerHTML = `
                    <div class="empty-modal-state">
                        <div style="font-size: 3rem; margin-bottom: 15px;">🗳️</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Candidates Found</h3>
                        <p>No candidates are registered under this broker.</p>
                    </div>
                `;
            } else {
                let tableHTML = '';
                tableHTML += '<div style="background: white; color: black; padding: 10px;">';
                tableHTML += '<table class="modal-table" style="width: 100%; border-collapse: collapse; color: black !important;">';
                tableHTML += '<thead><tr>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">ID</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Name</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Email</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Mobile</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Constituency</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Party</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Election Type</th>';
                tableHTML += '<th style="background: #f7fafc; padding: 12px; color: #4a5568; border-bottom: 2px solid #e2e8f0;">Payment Status</th>';
                tableHTML += '</tr></thead>';
                tableHTML += '<tbody>';
                
                console.log('Number of candidates to display:', data.candidates.length);
                console.log('Starting to build table...');
                data.candidates.forEach(candidate => {
                    // Debug each candidate
                    console.log('Processing candidate:', candidate);
                    
                    let paymentBadge = '';
                    if (candidate.paymentStatus === 'verified') {
                        paymentBadge = '<span class="badge badge-success">Verified</span>';
                    } else if (candidate.paymentStatus === 'pending') {
                        paymentBadge = '<span class="badge badge-warning">Pending</span>';
                    } else {
                        paymentBadge = '<span class="badge badge-danger">' + candidate.paymentStatus + '</span>';
                    }
                    
                    console.log('candidateId:', candidate.candidateId);
                    console.log('name:', candidate.name);
                    console.log('email:', candidate.email);
                    
                    // Build row HTML using string concatenation instead of template literals
                    let row = '<tr style="border-bottom: 1px solid #e2e8f0;">';
                    row += '<td style="padding: 10px; color: #2d3748;">#' + candidate.candidateId + '</td>';
                    row += '<td style="padding: 10px; color: #2d3748;"><strong>' + candidate.name + '</strong></td>';
                    row += '<td style="padding: 10px; color: #2d3748;">' + candidate.email + '</td>';
                    row += '<td style="padding: 10px; color: #2d3748;">' + candidate.mobile + '</td>';
                    row += '<td style="padding: 10px; color: #2d3748;">' + candidate.constituency + '</td>';
                    row += '<td style="padding: 10px; color: #2d3748;">' + candidate.partyName + '</td>';
                    row += '<td style="padding: 10px; color: #2d3748;">' + candidate.electionType + '</td>';
                    row += '<td style="padding: 10px; color: #2d3748;">' + paymentBadge + '</td>';
                    row += '</tr>';
                    
                    tableHTML += row;
                });
                
                tableHTML += '</tbody>';
                tableHTML += '</table>';
                tableHTML += '</div>';
                
                console.log('Table HTML generated, length:', tableHTML.length);
                console.log('Setting modal body innerHTML...');
                console.log('First 500 chars of HTML:', tableHTML.substring(0, 500));
                body.innerHTML = tableHTML;
                console.log('Modal body updated successfully');
                console.log('Modal body innerHTML length after set:', body.innerHTML.length);
                console.log('Modal body first child:', body.firstChild);
            }
            
            modal.style.display = 'block';
            console.log('Modal display set to block');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const usersModal = document.getElementById('usersModal');
            const candidatesModal = document.getElementById('candidatesModal');
            
            if (event.target === usersModal) {
                usersModal.style.display = 'none';
            }
            if (event.target === candidatesModal) {
                candidatesModal.style.display = 'none';
            }
        }
        
        // Close modal on ESC key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeModal('usersModal');
                closeModal('candidatesModal');
            }
        });
    
        function filterTable() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('brokersTable');
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

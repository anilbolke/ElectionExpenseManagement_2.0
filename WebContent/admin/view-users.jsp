<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, com.election.util.PaginationUtil, java.util.List" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get all users
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
    
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
    PaginationUtil pagination = new PaginationUtil(currentPage, pageSize, allUsers.size());
    List<User> displayUsers = pagination.getPaginatedList(allUsers);
    
    // Set pagination attributes for include
    request.setAttribute("pagination", pagination);
    request.setAttribute("paginationBaseUrl", "view-users.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "admin.view.users") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;500;600;700&display=swap" rel="stylesheet">
    <%@ include file="../includes/pagination-style.jsp" %>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Noto Sans Devanagari', 'Inter', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 13px;
            color: #2d3748;
        }
        
        input, textarea, select, button {
            font-family: 'Noto Sans Devanagari', 'Inter', 'Segoe UI', sans-serif !important;
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
        .stat-box:nth-child(2) { border-left-color: #f56565; }
        .stat-box:nth-child(3) { border-left-color: #48bb78; }
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
                <li><a href="view-users.jsp" class="active">Users</a></li>
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
        <div class="page-header">
            <h1>👥 All Users</h1>
            <div class="breadcrumb">Dashboard / Users</div>
        </div>
        
        <%
            int adminCount = 0, userCount = 0, brokerCount = 0;
            if (allUsers != null) {
                for (User u : allUsers) {
                    String role = u.getUserRole();
                    if ("admin".equals(role)) adminCount++;
                    else if ("user".equals(role)) userCount++;
                    else if ("broker".equals(role)) brokerCount++;
                }
            }
        %>
        
        <!-- Statistics Summary -->
        <div class="stats-summary">
            <div class="stat-box">
                <h4>Total Users</h4>
                <div class="value"><%= allUsers != null ? allUsers.size() : 0 %></div>
            </div>
            <div class="stat-box">
                <h4>Admins</h4>
                <div class="value"><%= adminCount %></div>
            </div>
            <div class="stat-box">
                <h4>Regular Users</h4>
                <div class="value"><%= userCount %></div>
            </div>
            <div class="stat-box">
                <h4>Brokers</h4>
                <div class="value"><%= brokerCount %></div>
            </div>
        </div>
        
        <!-- Users Table -->
        <div class="card">
            <div class="card-header">
                <h3>📋 User List (Read-Only)</h3>
            </div>
            <div class="card-body">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="🔍 Search by name, ea	qzmail, username..." onkeyup="filterTable()">
                </div>
                
                <% if (allUsers != null && !allUsers.isEmpty()) { %>
                    <div style="overflow-x: auto;">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : displayUsers) { %>
                                <tr>
                                    <td>#<%= u.getUserId() %></td>
                                    <td><strong><%= u.getUsername() %></strong></td>
                                    <td><%= u.getFullName() != null ? u.getFullName() : "N/A" %></td>
                                    <td><%= u.getEmail() != null ? u.getEmail() : "N/A" %></td>
                                    <td><%= u.getMobile() != null ? u.getMobile() : "N/A" %></td>
                                    <td>
                                        <% 
                                            String role = u.getUserRole();
                                            String badgeClass = "badge-info";
                                            if ("admin".equals(role)) badgeClass = "badge-danger";
                                            else if ("broker".equals(role)) badgeClass = "badge-warning";
                                            else if ("user".equals(role)) badgeClass = "badge-success";
                                        %>
                                        <span class="badge <%= badgeClass %>"><%= role != null ? role.toUpperCase() : "N/A" %></span>
                                    </td>
                                    <td>
                                        <% if (u.isActive()) { %>
                                            <span class="badge badge-success">Active</span>
                                        <% } else { %>
                                            <span class="badge badge-danger">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td style="font-size: 11px;"><%= u.getCreatedDate() != null ? u.getCreatedDate().toString().substring(0, 10) : "N/A" %></td>
                                    <td>
                                        <a href="user-details.jsp?userId=<%= u.getUserId() %>" class="btn btn-primary btn-sm">View</a>
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
                        <div style="font-size: 3rem; margin-bottom: 15px;">👥</div>
                        <h3 style="color: #4a5568; margin-bottom: 8px;">No Users Found</h3>
                        <p>No users found in the system.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        function filterTable() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('usersTable');
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

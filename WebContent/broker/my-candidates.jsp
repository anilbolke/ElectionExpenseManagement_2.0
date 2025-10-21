<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO, com.election.dao.UserDAO" %>
<%@ page import="com.election.util.PaginationUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"broker".equals(user.getUserRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Debug logging
    System.out.println("========== BROKER MY CANDIDATES PAGE DEBUG ==========");
    System.out.println("Broker User ID: " + user.getUserId());
    System.out.println("Broker Name: " + user.getFullName());
    System.out.println("Broker Role: " + user.getUserRole());
    
    CandidateDAO candidateDAO = new CandidateDAO();
    UserDAO userDAO = new UserDAO();
    List<Candidate> assignedCandidates = candidateDAO.getCandidatesByBroker(user.getUserId());
    
    System.out.println("Total candidates fetched: " + (assignedCandidates != null ? assignedCandidates.size() : 0));
    System.out.println("==================================================");
    
    String filterStatus = request.getParameter("status");
    if(filterStatus != null && !filterStatus.isEmpty()) {
        assignedCandidates = assignedCandidates.stream()
            .filter(c -> filterStatus.equals(c.getPaymentStatus()))
            .collect(java.util.stream.Collectors.toList());
    }
    
    // Pagination setup
    int currentPage2 = 1;
    int pageSize2 = 10;
    
    String pageParam2 = request.getParameter("page");
    String pageSizeParam2 = request.getParameter("pageSize");
    
    if (pageParam2 != null) {
        try {
            currentPage2 = Integer.parseInt(pageParam2);
        } catch (NumberFormatException e) {
            currentPage2 = 1;
        }
    }
    
    if (pageSizeParam2 != null) {
        try {
            pageSize2 = Integer.parseInt(pageSizeParam2);
        } catch (NumberFormatException e) {
            pageSize2 = 10;
        }
    }
    
    int totalRecords2 = assignedCandidates != null ? assignedCandidates.size() : 0;
    int totalPages2 = (int) Math.ceil((double) totalRecords2 / pageSize2);
    
    int startIndex2 = (currentPage2 - 1) * pageSize2;
    int endIndex2 = Math.min(startIndex2 + pageSize2, totalRecords2);
    
    List<Candidate> paginatedCandidates = null;
    if (assignedCandidates != null && totalRecords2 > 0) {
        paginatedCandidates = assignedCandidates.subList(startIndex2, endIndex2);
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Candidates - Broker Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 13px;
            color: #2d3748;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            padding: 12px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar h1 {
            font-size: 18px;
            font-weight: 600;
            color: #2563eb;
        }
        
        .navbar ul {
            list-style: none;
            display: flex;
            gap: 20px;
        }
        
        .navbar a {
            text-decoration: none;
            color: #64748b;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
            transition: all 0.2s;
        }
        
        .navbar a:hover, .navbar a.active {
            background: #eff6ff;
            color: #2563eb;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            display: inline-block;
            transition: all 0.2s;
        }
        
        .btn-danger {
            background: #dc2626;
            color: white;
        }
        
        .btn-danger:hover {
            background: #b91c1c;
        }
        
        .container {
            max-width: 1400px;
            margin: 24px auto;
            padding: 0 24px;
        }
        
        .page-header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        
        .page-header h2 {
            font-size: 20px;
            color: #1e293b;
            font-weight: 600;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        
        .filter-bar {
            padding: 16px 20px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            gap: 12px;
        }
        
        .filter-bar a {
            padding: 6px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid #e2e8f0;
            color: #475569;
            transition: all 0.2s;
        }
        
        .filter-bar a:hover {
            border-color: #2563eb;
            color: #2563eb;
        }
        
        .filter-bar a.active {
            background: #2563eb;
            color: white;
            border-color: #2563eb;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }
        
        th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
            font-size: 12px;
            color: #475569;
            text-transform: uppercase;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
        }
        
        tr:hover {
            background: #f8fafc;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-success {
            background: #dcfce7;
            color: #166534;
        }
        
        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }
        
        .empty-state svg {
            width: 64px;
            height: 64px;
            margin-bottom: 16px;
            opacity: 0.3;
        }
        
        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 20px;
            background: white;
            border-top: 1px solid #e2e8f0;
        }
        
        .pagination a, .pagination span {
            padding: 6px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            text-decoration: none;
            color: #475569;
            font-size: 13px;
        }
        
        .pagination a:hover {
            background: #f8fafc;
            border-color: #2563eb;
            color: #2563eb;
        }
        
        .pagination .active {
            background: #2563eb;
            color: white;
            border-color: #2563eb;
        }
        
        .pagination .disabled {
            opacity: 0.4;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div>
            <h1>Election Expense Management</h1>
        </div>
        <div style="display: flex; align-items: center; gap: 30px;">
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="my-users.jsp">My Users</a></li>
                <li><a href="my-candidates.jsp" class="active">My Candidates</a></li>
            </ul>
            <div>
                <span style="margin-right: 15px; color: #64748b;">👤 <%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>🗳️ My Candidates</h2>
            <p style="color: #64748b; margin-top: 6px; font-size: 13px;">Candidates assigned to your users</p>
        </div>

        <div class="card">
            <div class="filter-bar">
                <a href="my-candidates.jsp" class="<%= filterStatus == null ? "active" : "" %>">All Candidates</a>
                <a href="?status=Verified" class="<%= "Verified".equals(filterStatus) ? "active" : "" %>">Verified</a>
                <a href="?status=Pending" class="<%= "Pending".equals(filterStatus) ? "active" : "" %>">Pending</a>
            </div>
            
            <div class="table-container">
                <% if (paginatedCandidates != null && !paginatedCandidates.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Candidate ID</th>
                                <th>Name</th>
                                <th>Party</th>
                                <th>Election Type</th>
                                <th>Constituency</th>
                                <th>User</th>
                                <th>Payment Status</th>
                                <th>Registration Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Candidate c : paginatedCandidates) { 
                                User candidateOwner = userDAO.getUserById(c.getUserId());
                                String ownerName = candidateOwner != null ? candidateOwner.getFullName() : "Unknown";
                            %>
                                <tr>
                                    <td>#<%= c.getCandidateId() %></td>
                                    <td><strong><%= c.getCandidateName() %></strong></td>
                                    <td><%= c.getPartyName() %></td>
                                    <td><%= c.getElectionType() %></td>
                                    <td><%= c.getConstituency() %></td>
                                    <td><%= ownerName %></td>
                                    <td>
                                        <% if (c.isPaymentVerified()) { %>
                                            <span class="badge badge-success">✓ Verified</span>
                                        <% } else { %>
                                            <span class="badge badge-warning">⏳ Pending</span>
                                        <% } %>
                                    </td>
                                    <td><%= c.getCreatedDate() != null ? sdf.format(c.getCreatedDate()) : "N/A" %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                        </svg>
                        <h3 style="margin-bottom: 8px;">No Candidates Found</h3>
                        <p>No candidates are assigned to your users yet.</p>
                    </div>
                <% } %>
            </div>
            
            <% if (totalPages2 > 1) { %>
                <div class="pagination">
                    <% if (currentPage2 > 1) { %>
                        <a href="?page=<%= currentPage2 - 1 %>&pageSize=<%= pageSize2 %><%= filterStatus != null ? "&status=" + filterStatus : "" %>">← Previous</a>
                    <% } else { %>
                        <span class="disabled">← Previous</span>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, currentPage2 - 2);
                    int endPage = Math.min(totalPages2, currentPage2 + 2);
                    
                    if (startPage > 1) { %>
                        <a href="?page=1&pageSize=<%= pageSize2 %><%= filterStatus != null ? "&status=" + filterStatus : "" %>">1</a>
                        <% if (startPage > 2) { %>
                            <span>...</span>
                        <% } %>
                    <% } %>
                    
                    <% for (int i = startPage; i <= endPage; i++) { %>
                        <% if (i == currentPage2) { %>
                            <span class="active"><%= i %></span>
                        <% } else { %>
                            <a href="?page=<%= i %>&pageSize=<%= pageSize2 %><%= filterStatus != null ? "&status=" + filterStatus : "" %>"><%= i %></a>
                        <% } %>
                    <% } %>
                    
                    <% if (endPage < totalPages2) { %>
                        <% if (endPage < totalPages2 - 1) { %>
                            <span>...</span>
                        <% } %>
                        <a href="?page=<%= totalPages2 %>&pageSize=<%= pageSize2 %><%= filterStatus != null ? "&status=" + filterStatus : "" %>"><%= totalPages2 %></a>
                    <% } %>
                    
                    <% if (currentPage2 < totalPages2) { %>
                        <a href="?page=<%= currentPage2 + 1 %>&pageSize=<%= pageSize2 %><%= filterStatus != null ? "&status=" + filterStatus : "" %>">Next →</a>
                    <% } else { %>
                        <span class="disabled">Next →</span>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

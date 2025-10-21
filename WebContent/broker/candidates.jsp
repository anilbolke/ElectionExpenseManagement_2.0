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
    System.out.println("========== BROKER CANDIDATES PAGE DEBUG ==========");
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
    PaginationUtil paginationUtil = new PaginationUtil(currentPage, pageSize, assignedCandidates.size());
    List<Candidate> displayCandidates = paginationUtil.getPaginatedList(assignedCandidates);
    
    // Set pagination attributes for include
    StringBuilder paginationUrl = new StringBuilder("candidates.jsp");
    if(filterStatus != null && !filterStatus.isEmpty()) {
        paginationUrl.append("?status=").append(filterStatus);
    }
    request.setAttribute("pagination", paginationUtil);
    request.setAttribute("paginationBaseUrl", paginationUrl.toString());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Candidates - Broker Portal</title>
    <link rel="stylesheet" href="../css/style.css">
    <%@ include file="../includes/pagination-style.jsp" %>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: #f5f5f5;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .navbar-brand {
            font-size: 20px;
            font-weight: bold;
        }
        .navbar-menu {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
            gap: 20px;
        }
        .navbar-menu li a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background 0.3s;
        }
        .navbar-menu li a:hover {
            background: rgba(255,255,255,0.2);
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
        }
        .card {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card h2 {
            color: #333;
            margin: 0 0 20px 0;
            font-size: 24px;
        }
        .filter-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
        }
        .filter-bar select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table thead {
            background: #f8f9fa;
        }
        table th, table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
            color: #333;
        }
        table th {
            font-weight: 600;
            color: #495057;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success {
            background: #28a745;
            color: white;
        }
        .badge-warning {
            background: #ffc107;
            color: #333;
        }
        .badge-danger {
            background: #dc3545;
            color: white;
        }
        .badge-info {
            background: #17a2b8;
            color: white;
        }
        .candidate-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .candidate-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }
        .candidate-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .info-item {
            color: #333;
        }
        .info-item strong {
            color: #666;
            font-size: 12px;
            display: block;
            margin-bottom: 5px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">Election Expense Management - Broker Portal</div>
        <ul class="navbar-menu">
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="candidates.jsp">My Candidates</a></li>
        </ul>
        <div>
            <span>Welcome, <%= user.getFullName() %></span> |
            <a href="../logout" style="color: white; text-decoration: none;">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <h1 style="color: #333; margin-bottom: 30px;">My Candidates</h1>
        
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2 style="margin: 0;">Candidates List (<%= assignedCandidates.size() %>)</h2>
                
                <!-- Filter -->
                <div class="filter-bar">
                    <label style="color: #666;">Filter by Status:</label>
                    <select id="statusFilter" onchange="filterByStatus()">
                        <option value="">All</option>
                        <option value="pending" <%= "pending".equals(filterStatus) ? "selected" : "" %>>Pending</option>
                        <option value="completed" <%= "completed".equals(filterStatus) ? "selected" : "" %>>Completed</option>
                        <option value="failed" <%= "failed".equals(filterStatus) ? "selected" : "" %>>Failed</option>
                    </select>
                </div>
            </div>
            
            <% if(assignedCandidates.isEmpty()) { %>
                <p style="color: #666; text-align: center; padding: 40px;">
                    <% if(filterStatus != null && !filterStatus.isEmpty()) { %>
                        No candidates found with status "<%= filterStatus %>".
                    <% } else { %>
                        No candidates assigned yet. When candidates register through you, they will appear here.
                    <% } %>
                </p>
            <% } else { %>
                <% for(Candidate candidate : displayCandidates) {
                    User candidateUser = userDAO.getUserById(candidate.getUserId());
                %>
                    <div class="candidate-card">
                        <div class="candidate-header">
                            <div>
                                <h3 style="margin: 0 0 10px 0; color: #333;"><%= candidate.getCandidateName() %></h3>
                                <p style="margin: 0; color: #666; font-size: 14px;">
                                    <%= candidate.getConstituency() != null ? candidate.getConstituency() : "N/A" %> | 
                                    <%= candidate.getPartyName() != null ? candidate.getPartyName() : "Independent" %>
                                </p>
                            </div>
                            <div style="text-align: right;">
                                <% 
                                    String paymentStatus = candidate.getPaymentStatus();
                                    String badgeClass = "badge-warning";
                                    String statusText = "Pending";
                                    
                                    if("completed".equals(paymentStatus)) {
                                        if(candidate.isPaymentVerified()) {
                                            badgeClass = "badge-success";
                                            statusText = "Paid & Verified";
                                        } else {
                                            badgeClass = "badge-info";
                                            statusText = "Paid (Awaiting Verification)";
                                        }
                                    } else if("failed".equals(paymentStatus)) {
                                        badgeClass = "badge-danger";
                                        statusText = "Failed";
                                    }
                                %>
                                <span class="badge <%= badgeClass %>"><%= statusText %></span>
                                
                                <% 
                                    String accountStatus = candidate.getAccountStatus();
                                    String accountBadgeClass = "badge-warning";
                                    String accountStatusText = accountStatus != null ? accountStatus.replace("_", " ").toUpperCase() : "INACTIVE";
                                    
                                    if("active".equals(accountStatus)) {
                                        accountBadgeClass = "badge-success";
                                    } else if("suspended".equals(accountStatus)) {
                                        accountBadgeClass = "badge-danger";
                                    }
                                %>
                                <br><br>
                                <span class="badge <%= accountBadgeClass %>"><%= accountStatusText %></span>
                            </div>
                        </div>
                        
                        <div class="candidate-info">
                            <div class="info-item">
                                <strong>CONTACT</strong>
                                <% if(candidateUser != null) { %>
                                    <%= candidateUser.getMobile() %><br>
                                    <small><%= candidateUser.getEmail() %></small>
                                <% } else { %>
                                    N/A
                                <% } %>
                            </div>
                            
                            <div class="info-item">
                                <strong>ELECTION TYPE</strong>
                                <%= candidate.getElectionType() != null ? candidate.getElectionType() : "N/A" %>
                            </div>
                            
                            <div class="info-item">
                                <strong>CITY</strong>
                                <%= candidate.getCity() != null ? candidate.getCity() : "N/A" %>
                            </div>
                            
                            <div class="info-item">
                                <strong>PAYMENT AMOUNT</strong>
                                <%= candidate.getPaymentAmount() != null && candidate.getPaymentAmount().compareTo(java.math.BigDecimal.ZERO) > 0 
                                    ? "₹" + candidate.getPaymentAmount() : "Not Set" %>
                            </div>
                            
                            <div class="info-item">
                                <strong>PAYMENT DATE</strong>
                                <%= candidate.getPaymentDate() != null 
                                    ? new SimpleDateFormat("dd MMM yyyy").format(candidate.getPaymentDate()) 
                                    : "Not Paid" %>
                            </div>
                            
                            <div class="info-item">
                                <strong>REGISTRATION DATE</strong>
                                <%= new SimpleDateFormat("dd MMM yyyy").format(candidate.getCreatedDate()) %>
                            </div>
                            
                            <% if(candidate.getTransactionId() != null && !candidate.getTransactionId().isEmpty()) { %>
                                <div class="info-item">
                                    <strong>TRANSACTION ID</strong>
                                    <%= candidate.getTransactionId() %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
                
                <!-- Pagination -->
                <%@ include file="../includes/pagination.jsp" %>
                
            <% } %>
        </div>
    </div>
    
    <script>
        function filterByStatus() {
            const status = document.getElementById('statusFilter').value;
            if(status) {
                window.location.href = 'candidates.jsp?status=' + status;
            } else {
                window.location.href = 'candidates.jsp';
            }
        }
    </script>
</body>
</html>

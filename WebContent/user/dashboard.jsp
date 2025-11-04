<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.math.BigDecimal" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get user's candidates
    CandidateDAO candidateDAO = new CandidateDAO();
    List<Candidate> allCandidates = candidateDAO.getCandidatesByUserId(user.getUserId());
    
    // Pagination parameters
    int pageSize = 5; // Show 5 candidates per page
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    // Calculate pagination
    int totalCandidates = allCandidates != null ? allCandidates.size() : 0;
    int totalPages = (int) Math.ceil((double) totalCandidates / pageSize);
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
    
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalCandidates);
    
    // Get candidates for current page
    List<Candidate> myCandidates = null;
    if (allCandidates != null && !allCandidates.isEmpty()) {
        myCandidates = allCandidates.subList(startIndex, endIndex);
    }
    
    // Get currently selected candidate (if any)
    Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
    
    // Calculate statistics (using all candidates)
    List<Candidate> candidatesForStats = allCandidates;
    int activeCandidates = 0;
    int pendingPayments = 0;
    BigDecimal totalExpenses = BigDecimal.ZERO;
    
    if (candidatesForStats != null) {
        ExpenseDAO expenseDAO = new ExpenseDAO();
        for (Candidate c : candidatesForStats) {
            if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) {
                activeCandidates++;
                try {
                    BigDecimal candidateExpenses = expenseDAO.getTotalExpensesByCandidate(c.getCandidateId());
                    if (candidateExpenses != null) {
                        totalExpenses = totalExpenses.add(candidateExpenses);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                pendingPayments++;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "user.dashboard") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: #48bb78;
            color: white;
        }
        .btn-warning {
            background: #ed8936;
            color: white;
        }
        .btn-danger {
            background: #f56565;
            color: white;
        }
        .btn-outline {
            background: white;
            color: #667eea;
            border: 1px solid #667eea;
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
        .alert-warning { background: #fffbeb; color: #78350f; border-left-color: #f59e0b; }
        .alert-danger { background: #fef2f2; color: #991b1b; border-left-color: #ef4444; }
        .alert-critical { background: #7f1d1d; color: #fff; border-left-color: #dc2626; font-weight: 600; }
        
        /* Fund Alert Box */
        .fund-alert-box {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: none;
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.85; }
        }
        .fund-alert-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            font-weight: 700;
            font-size: 13px;
        }
        .fund-alert-details {
            font-size: 12px;
            line-height: 1.6;
        }
        .fund-stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 8px;
        }
        .fund-stat-item {
            background: rgba(255,255,255,0.5);
            padding: 6px;
            border-radius: 4px;
            text-align: center;
        }
        .fund-stat-label {
            font-size: 10px;
            opacity: 0.8;
            text-transform: uppercase;
        }
        .fund-stat-value {
            font-size: 14px;
            font-weight: 700;
            margin-top: 2px;
        }
        .progress-bar {
            width: 100%;
            height: 20px;
            background: rgba(255,255,255,0.3);
            border-radius: 10px;
            overflow: hidden;
            margin-top: 8px;
            position: relative;
        }
        .progress-fill {
            height: 100%;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 11px;
            font-weight: 700;
        }
        
        /* Compact Candidate Cards */
        .candidates-list {
            display: grid;
            gap: 10px;
        }
        .candidate-compact {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            padding: 12px;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .candidate-compact:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }
        .candidate-compact.selected {
            border-color: #48bb78;
            background: #f0fdf4;
        }
        .candidate-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 8px;
        }
        .candidate-name {
            font-size: 1rem;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 4px;
        }
        .candidate-info {
            font-size: 11px;
            color: #64748b;
            line-height: 1.5;
        }
        .candidate-actions {
            display: flex;
            gap: 5px;
            margin-top: 8px;
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
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #718096;
        }
        .empty-state .icon {
            font-size: 3rem;
            margin-bottom: 12px;
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
        
        /* Pagination Styles */
        .pagination-container {
            margin-top: 20px;
            padding: 15px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .page-link {
            display: inline-block;
            padding: 8px 14px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            color: #4a5568;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
            min-width: 40px;
            text-align: center;
        }
        
        .page-link:hover {
            background: #f7fafc;
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-1px);
        }
        
        .page-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
        }
        
        .page-link.active:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: translateY(-1px);
        }
        
        .page-ellipsis {
            padding: 8px 4px;
            color: #a0aec0;
            font-weight: 600;
        }
        
        @media (max-width: 480px) {
            .page-link {
                padding: 6px 10px;
                font-size: 12px;
                min-width: 35px;
            }
        }
    </style>
</head>
<body>
    <!-- Multi-Language Navigation -->
    <jsp:include page="/includes/user-navbar.jsp" />

    <!-- Main Container -->
    <div class="main-container">
        <div class="dashboard-grid">
            <!-- Left Sidebar -->
            <div class="sidebar">
                <!-- Compact Stats -->
                <div class="stats-compact">
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "candidate.total") %></h4>
                        <div class="value"><%= totalCandidates %></div>
                    </div>
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "status.active") %></h4>
                        <div class="value"><%= activeCandidates %></div>
                    </div>
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "payment.pending") %></h4>
                        <div class="value"><%= pendingPayments %></div>
                    </div>
                    <div class="stat-mini">
                        <h4><%= MessageBundle.getMessage(request, "expense.total") %></h4>
                        <div class="value" style="font-size: 1rem;">₹<%= String.format("%.0f", totalExpenses) %></div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions-compact">
                    <h3>⚡ <%= MessageBundle.getMessage(request, "action.quickactions") %></h3>
                    <a href="add-candidate.jsp" class="action-btn">➕ <%= MessageBundle.getMessage(request, "candidate.add") %></a>
                    <a href="change-password.jsp" class="action-btn" style="background: #f56565;">🔒 <%= MessageBundle.getMessage(request, "user.change.password") %></a>
                    <a href="map-referral-code.jsp" class="action-btn" style="background: #667eea;">🎁 <%= MessageBundle.getMessage(request, "referral.map.title") %></a>
                    <% if (selectedCandidate != null && selectedCandidate.isPaymentVerified()) { %>
                    <a href="<%=request.getContextPath()%>/generateProforma2?candidateId=<%= selectedCandidate.getCandidateId() %>" class="action-btn" style="background: #f57c00;" target="_blank">📑 Proforma-2 (Template)</a>
                    <a href="manage-funds.jsp" class="action-btn" style="background: #48bb78;">💰 Manage Funds</a>
                    <a href="add-expense.jsp" class="action-btn secondary">💸 <%= MessageBundle.getMessage(request, "expense.add") %></a>
                    <a href="expenses.jsp" class="action-btn secondary">📊 <%= MessageBundle.getMessage(request, "expense.view") %></a>
                    <% } %>
                </div>
                
                <!-- Social Media Links -->
                <jsp:include page="/includes/social-media-footer.jsp" />
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">✅ <%= request.getParameter("success") %></div>
                <% } %>
                
                <!-- Expense Limit Warnings for All Candidates -->
                <% 
                if (myCandidates != null && !myCandidates.isEmpty()) {
                    for (Candidate c : myCandidates) {
                        if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) {
                            boolean needsExpenseLimit = (c.getExpenseLimit() == null || c.getExpenseLimit().compareTo(java.math.BigDecimal.ZERO) <= 0);
                            if (needsExpenseLimit) {
                %>
                    <div class="alert" style="background: #fff3cd; border-left-color: #ffc107; color: #856404; display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <strong>⚠️ Action Required:</strong> Candidate <strong><%= c.getCandidateName() %></strong> does not have an expense limit set. Please set the expense limit to track expenses properly.
                        </div>
                        <a href="edit-candidate.jsp?candidateId=<%= c.getCandidateId() %>&focusLimit=true" class="btn btn-warning btn-sm" style="white-space: nowrap; margin-left: 10px;">Set Limit</a>
                    </div>
                <%
                            }
                        }
                    }
                }
                %>
                
                <% if (selectedCandidate != null) { %>
                    <div class="alert alert-info">
                        📌 <%= MessageBundle.getMessage(request, "user.managing") %>: <strong><%= selectedCandidate.getCandidateName() %><% if(selectedCandidate.getNominationId() != null && !selectedCandidate.getNominationId().trim().isEmpty()) { %> - <%= selectedCandidate.getNominationId() %><% } %></strong> 
                        <a href="<%=request.getContextPath()%>/select-candidate?action=clear" style="margin-left: 10px; color: #1e3a8a; text-decoration: underline; font-weight: 600;"><%= MessageBundle.getMessage(request, "user.switch.candidate") %></a>
                    </div>
                    
                    <%
                    // Check if selected candidate needs expense limit
                    boolean selectedNeedsLimit = (selectedCandidate.getExpenseLimit() == null || 
                                                  selectedCandidate.getExpenseLimit().compareTo(java.math.BigDecimal.ZERO) <= 0);
                    if (selectedNeedsLimit) {
                    %>
                    <div class="alert" style="background: #fef2f2; border-left-color: #ef4444; color: #991b1b; animation: pulse 2s infinite;">
                        <div style="display: flex; align-items: center; justify-content: space-between;">
                            <div style="flex: 1;">
                                <strong>🚨 Critical:</strong> Expense limit is not set for <strong><%= selectedCandidate.getCandidateName() %></strong>. 
                                You cannot add expenses or track spending without setting an expense limit first.
                            </div>
                            <a href="edit-candidate.jsp?candidateId=<%= selectedCandidate.getCandidateId() %>&focusLimit=true" 
                               class="btn" style="background: #dc2626; color: white; white-space: nowrap; margin-left: 15px; font-weight: 600;">
                                Set Expense Limit Now
                            </a>
                        </div>
                    </div>
                    <% } %>
                    
                    <!-- Fund Alert Notification (Dynamic via AJAX) -->
                    <div id="fundAlertBox" class="fund-alert-box"></div>
                <% } %>
                
                <div class="content-header">
                    <h2><%= MessageBundle.getMessage(request, "user.candidates") %></h2>
                    <a href="add-candidate.jsp" class="btn btn-success btn-sm">➕ <%= MessageBundle.getMessage(request, "candidate.add") %></a>
                </div>
                
                <div class="candidates-list">
                    <% if (myCandidates != null && !myCandidates.isEmpty()) { %>
                        <% for (Candidate c : myCandidates) { %>
                            <div class="candidate-compact <%= (selectedCandidate != null && selectedCandidate.getCandidateId() == c.getCandidateId()) ? "selected" : "" %>">
                                <div class="candidate-header">
                                    <div style="flex: 1;">
                                        <div class="candidate-name"><%= c.getCandidateName() %><% if(c.getNominationId() != null && !c.getNominationId().trim().isEmpty()) { %> - <strong><%= c.getNominationId() %></strong><% } %></div>
                                        <div class="candidate-info">
                                            <strong><%= MessageBundle.getMessage(request, "candidate.party") %>:</strong> <%= c.getPartyName() != null ? c.getPartyName() : "Independent" %> | 
                                            <strong><%= MessageBundle.getMessage(request, "candidate.constituency") %>:</strong> <%= c.getConstituency() != null ? c.getConstituency() : "N/A" %>
                                        </div>
                                    </div>
                                    <div>
                                        <% if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) { %>
                                            <span class="badge badge-success"><%= MessageBundle.getMessage(request, "status.active") %></span>
                                        <% } else if ("pending_payment".equals(c.getAccountStatus())) { %>
                                            <span class="badge badge-warning"><%= MessageBundle.getMessage(request, "payment.pending") %></span>
                                        <% } else { %>
                                            <span class="badge badge-danger"><%= MessageBundle.getMessage(request, "status.inactive") %></span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="candidate-actions">
                                    <% if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) { %>
                                        <a href="<%=request.getContextPath()%>/select-candidate?candidateId=<%= c.getCandidateId() %>" class="btn btn-primary btn-sm"><%= MessageBundle.getMessage(request, "action.select") %></a>
                                        <a href="manage-funds.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-success btn-sm">💰 Funds</a>
                                    <% } else { %>
                                        <a href="candidate-payment.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-warning btn-sm"><%= MessageBundle.getMessage(request, "payment.paynow") %></a>
                                    <% } %>
                                    <a href="edit-candidate.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-outline btn-sm"><%= MessageBundle.getMessage(request, "action.edit") %></a>
                                </div>
                            </div>
                        <% } %>
                        
                        <!-- Pagination -->
                        <% if (totalPages > 1) { %>
                        <div class="pagination-container" style="margin-top: 20px; text-align: center;">
                            <div class="pagination">
                                <% if (currentPage > 1) { %>
                                    <a href="?page=<%= currentPage - 1 %>" class="page-link">← <%= MessageBundle.getMessage(request, "pagination.previous") %></a>
                                <% } %>
                                
                                <% 
                                int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);
                                
                                if (startPage > 1) { %>
                                    <a href="?page=1" class="page-link">1</a>
                                    <% if (startPage > 2) { %>
                                        <span class="page-ellipsis">...</span>
                                    <% } %>
                                <% }
                                
                                for (int i = startPage; i <= endPage; i++) { %>
                                    <a href="?page=<%= i %>" class="page-link <%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                                <% }
                                
                                if (endPage < totalPages) { 
                                    if (endPage < totalPages - 1) { %>
                                        <span class="page-ellipsis">...</span>
                                    <% } %>
                                    <a href="?page=<%= totalPages %>" class="page-link"><%= totalPages %></a>
                                <% } %>
                                
                                <% if (currentPage < totalPages) { %>
                                    <a href="?page=<%= currentPage + 1 %>" class="page-link"><%= MessageBundle.getMessage(request, "pagination.next") %> →</a>
                                <% } %>
                            </div>
                            <div style="margin-top: 10px; color: #718096; font-size: 13px;">
                                <%= MessageBundle.getMessage(request, "pagination.showing") %> <%= startIndex + 1 %>-<%= endIndex %> <%= MessageBundle.getMessage(request, "pagination.of") %> <%= totalCandidates %>
                            </div>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state">
                            <div class="icon">🗳️</div>
                            <h3 style="color: #4a5568; margin-bottom: 8px;"><%= MessageBundle.getMessage(request, "message.no.data") %></h3>
                            <p style="margin-bottom: 15px;"><%= MessageBundle.getMessage(request, "candidate.addnew") %></p>
                            <a href="add-candidate.jsp" class="btn btn-success">➕ <%= MessageBundle.getMessage(request, "candidate.add") %></a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Social Media Footer -->
        <jsp:include page="/includes/social-media-footer.jsp" />
    </div>
    
    <% if (selectedCandidate != null) { %>
    <script>
        // Fetch fund statistics when candidate is selected
        function loadFundStatistics() {
            fetch('<%=request.getContextPath()%>/getFundStatistics')
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        console.log('No fund statistics available:', data.error);
                        return;
                    }
                    
                    // Check if expense limit is set
                    if (!data.totalFunds || parseFloat(data.totalFunds) <= 0) {
                        console.log('Expense limit not set for this candidate');
                        return;
                    }
                    
                    // Only show alert if usage >= 50%
                    if (data.hasAlert) {
                        displayFundAlert(data);
                    }
                })
                .catch(error => console.error('Error loading fund statistics:', error));
        }
        
        function displayFundAlert(stats) {
            const alertBox = document.getElementById('fundAlertBox');
            if (!alertBox) return;
            
            let alertClass = 'alert-warning';
            let icon = '⚠️';
            let title = 'Expense Limit Warning';
            let progressColor = '#f59e0b';
            
            if (stats.usagePercentage >= 90) {
                alertClass = 'alert-critical';
                icon = '🚨';
                title = 'CRITICAL: Expense Limit Exceeded';
                progressColor = '#dc2626';
            } else if (stats.usagePercentage >= 75) {
                alertClass = 'alert-danger';
                icon = '⛔';
                title = 'High Expense Usage Alert';
                progressColor = '#ef4444';
            }
            
            const formatCurrency = (amount) => {
                return '₹' + parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            };
            
            alertBox.className = 'fund-alert-box alert ' + alertClass;
            alertBox.style.display = 'block';
            alertBox.innerHTML = 
                '<div class="fund-alert-header">' +
                    '<span style="font-size: 18px;">' + icon + '</span>' +
                    '<span>' + title + '</span>' +
                '</div>' +
                '<div class="fund-alert-details">' +
                    '<strong>' + stats.candidateName + '</strong> has used <strong>' + stats.usagePercentage.toFixed(2) + '%</strong> of expense limit.' +
                    '<div class="fund-stats-row">' +
                        '<div class="fund-stat-item">' +
                            '<div class="fund-stat-label">Expense Limit</div>' +
                            '<div class="fund-stat-value">' + formatCurrency(stats.totalFunds) + '</div>' +
                        '</div>' +
                        '<div class="fund-stat-item">' +
                            '<div class="fund-stat-label">Used</div>' +
                            '<div class="fund-stat-value">' + formatCurrency(stats.totalExpenses) + '</div>' +
                        '</div>' +
                        '<div class="fund-stat-item">' +
                            '<div class="fund-stat-label">Remaining</div>' +
                            '<div class="fund-stat-value">' + formatCurrency(stats.remainingFunds) + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="progress-bar">' +
                        '<div class="progress-fill" style="width: ' + Math.min(stats.usagePercentage, 100) + '%; background: ' + progressColor + ';">' +
                            stats.usagePercentage.toFixed(1) + '%' +
                        '</div>' +
                    '</div>' +
                '</div>';
        }
        
        // Load statistics on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadFundStatistics();
            // Refresh every 30 seconds
            setInterval(loadFundStatistics, 30000);
        });
    </script>
    <% } %>
</body>
</html>

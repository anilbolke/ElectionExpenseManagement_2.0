<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO" %>
<%@ page import="com.election.util.PaginationUtil" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.stream.Collectors" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Get search parameters
    String searchQuery = request.getParameter("search");
    String filterStatus = request.getParameter("status");
    String filterElectionType = request.getParameter("electionType");
    
    // Get all candidates for this user
    CandidateDAO candidateDAO = new CandidateDAO();
    List<Candidate> allCandidates = candidateDAO.getCandidatesByUserId(user.getUserId());
    List<Candidate> candidates = new ArrayList<>(allCandidates);
    
    // Apply search filter
    if(searchQuery != null && !searchQuery.trim().isEmpty()) {
        String query = searchQuery.toLowerCase().trim();
        candidates = candidates.stream()
            .filter(c -> 
                (c.getCandidateName() != null && c.getCandidateName().toLowerCase().contains(query)) ||
                (c.getConstituency() != null && c.getConstituency().toLowerCase().contains(query)) ||
                (c.getPartyName() != null && c.getPartyName().toLowerCase().contains(query)) ||
                (c.getCity() != null && c.getCity().toLowerCase().contains(query))
            )
            .collect(Collectors.toList());
    }
    
    // Apply status filter
    if(filterStatus != null && !filterStatus.trim().isEmpty() && !"all".equals(filterStatus)) {
        candidates = candidates.stream()
            .filter(c -> filterStatus.equals(c.getAccountStatus()))
            .collect(Collectors.toList());
    }
    
    // Apply election type filter
    if(filterElectionType != null && !filterElectionType.trim().isEmpty() && !"all".equals(filterElectionType)) {
        candidates = candidates.stream()
            .filter(c -> filterElectionType.equals(c.getElectionType()))
            .collect(Collectors.toList());
    }
    
    String message = request.getParameter("message");
    String error = request.getParameter("error");
    
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
    PaginationUtil pagination = new PaginationUtil(currentPage, pageSize, candidates.size());
    List<Candidate> displayCandidates = pagination.getPaginatedList(candidates);
    
    // Build pagination URL with search parameters
    StringBuilder paginationBaseUrlBuilder = new StringBuilder("manage-candidates.jsp?");
    if(searchQuery != null && !searchQuery.isEmpty()) {
        paginationBaseUrlBuilder.append("search=").append(java.net.URLEncoder.encode(searchQuery, "UTF-8")).append("&");
    }
    if(filterStatus != null && !filterStatus.isEmpty()) {
        paginationBaseUrlBuilder.append("status=").append(filterStatus).append("&");
    }
    if(filterElectionType != null && !filterElectionType.isEmpty()) {
        paginationBaseUrlBuilder.append("electionType=").append(filterElectionType).append("&");
    }
    
    // Set pagination attributes for include
    request.setAttribute("pagination", pagination);
    request.setAttribute("paginationBaseUrl", paginationBaseUrlBuilder.toString());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Candidates - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <%@ include file="../includes/pagination-style.jsp" %>
    <style>
        .search-filter-section {
            background: white;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .search-filter-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }
        
        .search-group {
            position: relative;
        }
        
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 16px;
        }
        
        .search-input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0,123,255,0.1);
        }
        
        .filter-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-select:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0,123,255,0.1);
        }
        
        .btn-filter {
            padding: 12px 25px;
            white-space: nowrap;
        }
        
        .results-summary {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
            color: #666;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .clear-filters {
            color: #007bff;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        
        .clear-filters:hover {
            text-decoration: underline;
        }
        
        .candidate-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }
        
        .candidate-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transform: translateX(5px);
            border-left-color: #007bff;
        }
        
        .candidate-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .candidate-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .candidate-id {
            font-size: 14px;
            color: #999;
            font-weight: normal;
        }
        
        .candidate-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 6px;
            transition: background 0.2s ease;
        }
        
        .info-item:hover {
            background: #e9ecef;
        }
        
        .info-label {
            font-weight: 600;
            color: #666;
            margin-right: 8px;
            min-width: 120px;
        }
        
        .info-value {
            color: #333;
            word-break: break-word;
        }
        
        .candidate-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: #666;
            margin-bottom: 15px;
        }
        
        .add-candidate-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border: none;
            font-size: 28px;
            box-shadow: 0 4px 12px rgba(0,123,255,0.4);
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 1000;
        }
        
        .add-candidate-btn:hover {
            background: linear-gradient(135deg, #0056b3, #003d82);
            transform: scale(1.1) rotate(90deg);
            box-shadow: 0 6px 16px rgba(0,123,255,0.6);
        }
        
        @media (max-width: 1024px) {
            .search-filter-row {
                grid-template-columns: 1fr 1fr;
            }
            
            .search-group {
                grid-column: 1 / -1;
            }
        }
        
        @media (max-width: 768px) {
            .search-filter-row {
                grid-template-columns: 1fr;
            }
            
            .candidate-info {
                grid-template-columns: 1fr;
            }
            
            .candidate-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .candidate-actions {
                margin-top: 10px;
                width: 100%;
            }
            
            .results-summary {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body class="dashboard">
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ Election Expense</div>
            <ul class="navbar-menu">
                <li><a href="manage-candidates.jsp" class="active">My Candidates</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container" style="margin-top: 80px; padding-bottom: 100px;">
        <h1 style="margin-bottom: 30px;">Manage Candidates</h1>
        
        <% if(message != null) { %>
            <div class="alert alert-success"><%= message %></div>
        <% } %>
        
        <% if(error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <!-- Search and Filter Section -->
        <div class="search-filter-section">
            <form method="get" action="manage-candidates.jsp">
                <div class="search-filter-row">
                    <div class="search-group">
                        <span class="search-icon">🔍</span>
                        <input type="text" 
                               name="search" 
                               class="search-input" 
                               placeholder="Search by name, constituency, party, or city..." 
                               value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>
                    
                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #666;">Status</label>
                        <select name="status" class="filter-select">
                            <option value="all" <%= "all".equals(filterStatus) || filterStatus == null ? "selected" : "" %>>All Status</option>
                            <option value="active" <%= "active".equals(filterStatus) ? "selected" : "" %>>Active</option>
                            <option value="pending_payment" <%= "pending_payment".equals(filterStatus) ? "selected" : "" %>>Pending Payment</option>
                            <option value="inactive" <%= "inactive".equals(filterStatus) ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>
                    
                    <div>
                        <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #666;">Election Type</label>
                        <select name="electionType" class="filter-select">
                            <option value="all" <%= "all".equals(filterElectionType) || filterElectionType == null ? "selected" : "" %>>All Types</option>
                            <option value="Lok Sabha" <%= "Lok Sabha".equals(filterElectionType) ? "selected" : "" %>>Lok Sabha</option>
                            <option value="Vidhan Sabha" <%= "Vidhan Sabha".equals(filterElectionType) ? "selected" : "" %>>Vidhan Sabha</option>
                            <option value="Municipal" <%= "Municipal".equals(filterElectionType) ? "selected" : "" %>>Municipal</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-filter">🔍 Search</button>
                </div>
                
                <% if((searchQuery != null && !searchQuery.isEmpty()) || 
                      (filterStatus != null && !"all".equals(filterStatus)) || 
                      (filterElectionType != null && !"all".equals(filterElectionType))) { %>
                    <div class="results-summary">
                        <span>Found <%= candidates.size() %> candidate(s) matching your criteria</span>
                        <a href="manage-candidates.jsp" class="clear-filters">✖ Clear All Filters</a>
                    </div>
                <% } else { %>
                    <div class="results-summary">
                        <span>Total: <%= allCandidates.size() %> candidate(s)</span>
                    </div>
                <% } %>
            </form>
        </div>
        
        <% if(candidates.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-state-icon">👤</div>
                <% if(searchQuery != null || filterStatus != null || filterElectionType != null) { %>
                    <h3>No Candidates Found</h3>
                    <p>No candidates match your search criteria. Try adjusting your filters.</p>
                    <a href="manage-candidates.jsp" class="btn btn-primary" style="margin-top: 15px;">Clear Filters</a>
                <% } else { %>
                    <h3>No Candidates Found</h3>
                    <p>You haven't added any candidates yet. Click the + button below to add your first candidate.</p>
                <% } %>
            </div>
        <% } else { %>
            <% for(Candidate candidate : displayCandidates) {
                String statusClass = "status-inactive";
                String statusText = "Inactive";
                
                if("active".equals(candidate.getAccountStatus())) {
                    statusClass = "status-active";
                    statusText = "Active";
                } else if("pending_payment".equals(candidate.getAccountStatus())) {
                    statusClass = "status-pending";
                    statusText = "Payment Pending";
                }
            %>
                <div class="candidate-card">
                    <div class="candidate-header">
                        <div class="candidate-name">
                            <%= candidate.getCandidateName() %>
                            <span class="candidate-id">(ID: #<%= candidate.getCandidateId() %>)</span>
                        </div>
                        <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                    </div>
                    
                    <div class="candidate-info">
                        <div class="info-item">
                            <span class="info-label">👤 Father's Name:</span>
                            <span class="info-value"><%= candidate.getFatherName() != null ? candidate.getFatherName() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">📅 Age:</span>
                            <span class="info-value"><%= candidate.getAge() %> years</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">🏛️ Constituency:</span>
                            <span class="info-value"><%= candidate.getConstituency() != null ? candidate.getConstituency() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">🎯 Party:</span>
                            <span class="info-value"><%= candidate.getPartyName() != null ? candidate.getPartyName() : "Independent" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">📍 City:</span>
                            <span class="info-value"><%= candidate.getCity() != null ? candidate.getCity() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">🗳️ Election Type:</span>
                            <span class="info-value"><%= candidate.getElectionType() != null ? candidate.getElectionType() : "N/A" %></span>
                        </div>
                    </div>
                    
                    <div class="candidate-actions">
                        <% if("active".equals(candidate.getAccountStatus()) && candidate.isPaymentVerified()) { %>
                            <form action="<%=request.getContextPath()%>/candidate" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="selectCandidate">
                                <input type="hidden" name="candidateId" value="<%= candidate.getCandidateId() %>">
                                <button type="submit" class="btn btn-success">📊 View Dashboard</button>
                            </form>
                        <% } else if("pending_payment".equals(candidate.getAccountStatus())) { %>
                            <a href="candidate-payment.jsp?candidateId=<%= candidate.getCandidateId() %>" class="btn btn-warning">💳 Complete Payment</a>
                        <% } %>
                        
                        <a href="edit-candidate.jsp?candidateId=<%= candidate.getCandidateId() %>" class="btn btn-secondary">✏️ Edit Details</a>
                    </div>
                </div>
            <% } %>
            
            <!-- Pagination -->
            <%@ include file="../includes/pagination.jsp" %>
            
        <% } %>
    </div>
    
    <!-- Floating Add Button -->
    <button class="add-candidate-btn" onclick="window.location.href='add-candidate.jsp'" title="Add New Candidate">+</button>
</body>
</html>

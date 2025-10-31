<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate, com.election.model.FundDetail" %>
<%@ page import="com.election.dao.CandidateDAO, com.election.dao.FundDetailDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Check if a candidate is selected
    Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
    if(selectedCandidate == null) {
        response.sendRedirect("dashboard.jsp?error=Please select a candidate first to manage fund details");
        return;
    }
    
    FundDetailDAO fundDetailDAO = new FundDetailDAO();
    
    // Get funds for the selected candidate
    int candidateId = selectedCandidate.getCandidateId();
    List<FundDetail> funds = fundDetailDAO.getFundDetailsByCandidate(candidateId);
    double totalFunds = fundDetailDAO.getTotalFundsByCandidate(candidateId);
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Fund Details - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        body.dashboard {
            background: #f5f7fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        
        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .main-content {
            width: 100%;
        }
        
        .page-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            color: #666;
        }
        
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-label {
            font-weight: 600;
            color: #333;
        }
        
        .filter-select {
            flex: 1;
            min-width: 250px;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .funds-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table-header {
            padding: 20px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .table-title {
            font-size: 18px;
            font-weight: 700;
            color: #333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f8f9fa;
        }
        
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        td {
            padding: 15px;
            border-top: 1px solid #f0f0f0;
            color: #666;
            font-size: 14px;
        }
        
        tbody tr:hover {
            background: #f8f9fa;
        }
        
        .fund-type-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .badge-cash { background: #d4edda; color: #155724; }
        .badge-bank { background: #cce5ff; color: #004085; }
        .badge-loan { background: #fff3cd; color: #856404; }
        .badge-donation { background: #f8d7da; color: #721c24; }
        .badge-other { background: #e2e3e5; color: #383d41; }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            border: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        @media (max-width: 768px) {
            .filter-section {
                flex-direction: column;
            }
            
            .filter-select {
                width: 100%;
            }
            
            table {
                font-size: 12px;
            }
            
            th, td {
                padding: 10px 8px;
            }
        }
    </style>
</head>
<body class="dashboard">
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>
    
    <div class="main-container">
        <main class="main-content">
            <div class="page-header">
                <h1 class="page-title">💰 Manage Fund Details</h1>
                <p class="page-subtitle">View and manage financial records for your candidates</p>
            </div>
            
            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <strong>Error!</strong> <%= error %>
                </div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <strong>Success!</strong> <%= success %>
                </div>
            <% } %>
            
            <div class="filter-section">
                <div style="flex: 1;">
                    <strong>📌 Selected Candidate:</strong> <%= selectedCandidate.getCandidateName() %>
                    <% if(selectedCandidate.getNominationId() != null && !selectedCandidate.getNominationId().trim().isEmpty()) { %>
                        - <%= selectedCandidate.getNominationId() %>
                    <% } %>
                    | <%= selectedCandidate.getConstituency() %>
                </div>
                <a href="add-fund.jsp" class="btn-primary btn-sm">+ Add Fund</a>
            </div>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value"><%= currencyFormat.format(totalFunds) %></div>
                        <div class="stat-label">Total Funds</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value"><%= funds != null ? funds.size() : 0 %></div>
                        <div class="stat-label">Total Entries</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value"><%= selectedCandidate.getCandidateName() %></div>
                        <div class="stat-label">Selected Candidate</div>
                    </div>
                </div>
                
                <div class="funds-table">
                    <div class="table-header">
                        <span class="table-title">Fund Records</span>
                    </div>
                    
                    <% if (funds != null && !funds.isEmpty()) { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Fund Type</th>
                                    <th>Amount</th>
                                    <th>Funder Name</th>
                                    <th>Mobile</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (FundDetail fund : funds) { 
                                    String badgeClass = "";
                                    switch(fund.getFundType()) {
                                        case "Cash in Hand": badgeClass = "badge-cash"; break;
                                        case "Bank Balance": badgeClass = "badge-bank"; break;
                                        case "Hand Loan": badgeClass = "badge-loan"; break;
                                        case "Donation": badgeClass = "badge-donation"; break;
                                        default: badgeClass = "badge-other";
                                    }
                                %>
                                    <tr>
                                        <td><%= fund.getFundDate() %></td>
                                        <td><span class="fund-type-badge <%= badgeClass %>"><%= fund.getFundType() %></span></td>
                                        <td><strong><%= currencyFormat.format(fund.getAmount()) %></strong></td>
                                        <td><%= fund.getFunderName() %></td>
                                        <td><%= fund.getFunderMobile() %></td>
                                        <td><%= fund.getDescription() != null && !fund.getDescription().isEmpty() ? fund.getDescription() : "-" %></td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="edit-fund.jsp?fundId=<%= fund.getFundId() %>" class="btn-primary btn-sm">Edit</a>
                                                <button onclick="deleteFund(<%= fund.getFundId() %>)" class="btn-danger btn-sm">Delete</button>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div class="empty-state">
                            <div class="empty-icon">💸</div>
                            <h3>No Fund Records</h3>
                            <p>No fund details added yet for this candidate.</p>
                            <br>
                            <a href="add-fund.jsp" class="btn-primary btn-sm">Add First Fund</a>
                        </div>
                    <% } %>
                </div>
        </main>
    </div>
    
    <footer style="background: #2d3748; color: #e2e8f0; padding: 20px; text-align: center; margin-top: 50px;">
        <p>&copy; 2024 Election Expense Management. All rights reserved.</p>
    </footer>
    
    <script>
        function deleteFund(fundId) {
            if (confirm('Are you sure you want to delete this fund record? This action cannot be undone.')) {
                window.location.href = '<%=request.getContextPath()%>/fundDetail?action=delete&fundId=' + fundId;
            }
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>

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
    List<Candidate> myCandidates = candidateDAO.getCandidatesByUserId(user.getUserId());
    
    // Get currently selected candidate (if any)
    Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
    
    // Calculate statistics
    int totalCandidates = myCandidates != null ? myCandidates.size() : 0;
    int activeCandidates = 0;
    int pendingPayments = 0;
    BigDecimal totalExpenses = BigDecimal.ZERO;
    
    if (myCandidates != null) {
        ExpenseDAO expenseDAO = new ExpenseDAO();
        for (Candidate c : myCandidates) {
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
        }
        
        .dashboard-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .page-header {
            margin-bottom: 25px;
        }
        
        .page-header h1 {
            font-size: 24px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 5px;
        }
        
        .page-header p {
            color: #718096;
            font-size: 14px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            gap: 15px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .stat-icon.purple { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .stat-icon.green { background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white; }
        .stat-icon.orange { background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%); color: white; }
        .stat-icon.blue { background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%); color: white; }
        
        .stat-content {
            flex: 1;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #1a202c;
            line-height: 1;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #718096;
            font-size: 13px;
            font-weight: 500;
        }
        
        /* Quick Actions */
        .quick-actions {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 15px;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-btn {
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .action-btn.primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .action-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .action-btn.secondary {
            background: #e2e8f0;
            color: #2d3748;
        }
        
        .action-btn.secondary:hover {
            background: #cbd5e0;
        }
        
        /* Recent Candidates */
        .recent-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }
        
        .table-responsive {
            overflow-x: auto;
            margin-top: 15px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        
        th {
            background: #f7fafc;
            font-weight: 600;
            color: #2d3748;
        }
        
        tr:hover {
            background: #f7fafc;
        }
        
        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge.success {
            background: #c6f6d5;
            color: #22543d;
        }
        
        .badge.warning {
            background: #feebc8;
            color: #7c2d12;
        }
        
        .badge.danger {
            background: #fed7d7;
            color: #742a2a;
        }
        
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 15px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Multi-Language Navigation -->
    <jsp:include page="/includes/user-navbar.jsp" />
    
    <div class="dashboard-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1><%= MessageBundle.getMessage(request, "user.dashboard") %></h1>
            <p><%= MessageBundle.getMessage(request, "app.welcome") %>, <%= user.getFullName() %>!</p>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon purple">👥</div>
                <div class="stat-content">
                    <div class="stat-value"><%= totalCandidates %></div>
                    <div class="stat-label"><%= MessageBundle.getMessage(request, "candidate.total") %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon green">✓</div>
                <div class="stat-content">
                    <div class="stat-value"><%= activeCandidates %></div>
                    <div class="stat-label"><%= MessageBundle.getMessage(request, "status.active") %> <%= MessageBundle.getMessage(request, "nav.candidates") %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon orange">⏳</div>
                <div class="stat-content">
                    <div class="stat-value"><%= pendingPayments %></div>
                    <div class="stat-label"><%= MessageBundle.getMessage(request, "payment.pending") %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon blue">₹</div>
                <div class="stat-content">
                    <div class="stat-value">₹<%= String.format("%,.2f", totalExpenses) %></div>
                    <div class="stat-label"><%= MessageBundle.getMessage(request, "expense.total") %></div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <h2 class="section-title"><%= MessageBundle.getMessage(request, "nav.dashboard") %> - <%= MessageBundle.getMessage(request, "action.quickactions") %></h2>
            <div class="action-buttons">
                <a href="add-candidate.jsp" class="action-btn primary">
                    ➕ <%= MessageBundle.getMessage(request, "candidate.add") %>
                </a>
                <a href="add-expense.jsp" class="action-btn primary">
                    💰 <%= MessageBundle.getMessage(request, "expense.add") %>
                </a>
                <a href="manage-candidates.jsp" class="action-btn secondary">
                    📋 <%= MessageBundle.getMessage(request, "candidate.manage") %>
                </a>
                <a href="expenses.jsp" class="action-btn secondary">
                    📊 <%= MessageBundle.getMessage(request, "expense.view") %>
                </a>
            </div>
        </div>
        
        <!-- Recent Candidates -->
        <div class="recent-section">
            <h2 class="section-title"><%= MessageBundle.getMessage(request, "candidate.list") %></h2>
            
            <% if (myCandidates != null && !myCandidates.isEmpty()) { %>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th><%= MessageBundle.getMessage(request, "table.sno") %></th>
                                <th><%= MessageBundle.getMessage(request, "candidate.name") %></th>
                                <th><%= MessageBundle.getMessage(request, "candidate.party") %></th>
                                <th><%= MessageBundle.getMessage(request, "candidate.constituency") %></th>
                                <th><%= MessageBundle.getMessage(request, "table.status") %></th>
                                <th><%= MessageBundle.getMessage(request, "table.actions") %></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int count = 0;
                            for (Candidate c : myCandidates) {
                                if (count >= 5) break; // Show only 5 recent
                                count++;
                            %>
                            <tr>
                                <td><%= count %></td>
                                <td><strong><%= c.getCandidateName() %></strong></td>
                                <td><%= c.getPartyName() %></td>
                                <td><%= c.getConstituency() %></td>
                                <td>
                                    <% if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) { %>
                                        <span class="badge success"><%= MessageBundle.getMessage(request, "status.active") %></span>
                                    <% } else if (!c.isPaymentVerified()) { %>
                                        <span class="badge warning"><%= MessageBundle.getMessage(request, "payment.pending") %></span>
                                    <% } else { %>
                                        <span class="badge danger"><%= MessageBundle.getMessage(request, "status.inactive") %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="edit-candidate.jsp?id=<%= c.getCandidateId() %>" class="action-btn secondary" style="padding: 5px 10px; font-size: 11px;">
                                        <%= MessageBundle.getMessage(request, "action.view") %>
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <% if (myCandidates.size() > 5) { %>
                    <div style="text-align: center; margin-top: 15px;">
                        <a href="manage-candidates.jsp" class="action-btn secondary">
                            <%= MessageBundle.getMessage(request, "action.viewall") %> (<%= myCandidates.size() %>)
                        </a>
                    </div>
                <% } %>
            <% } else { %>
                <p style="text-align: center; padding: 40px; color: #718096;">
                    <%= MessageBundle.getMessage(request, "message.no.data") %>
                </p>
            <% } %>
        </div>
    </div>
</body>
</html>

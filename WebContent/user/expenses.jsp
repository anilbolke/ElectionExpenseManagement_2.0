<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate, com.election.model.Expense, com.election.dao.ExpenseDAO, java.util.List" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.i18n.LocaleManager" %>
<%
    User user = (User) session.getAttribute("user");
    Candidate candidate = (Candidate) session.getAttribute("candidate");
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    if (candidate == null) {
        response.sendRedirect("dashboard.jsp?error=Please select a candidate first");
        return;
    }
    
    ExpenseDAO expenseDAO = new ExpenseDAO();
    List<Expense> expenses = expenseDAO.getExpensesByCandidate(candidate.getCandidateId());
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "heading.view.expenses") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Noto Sans Devanagari', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .main-content {
            flex: 1;
            padding: 40px 30px 40px;
            min-height: auto;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding-bottom: 40px;
        }
        
        footer {
            background: #2d3748;
            color: #e2e8f0;
            padding: 20px 30px;
            text-align: center;
            margin-top: auto;
        }
        
        footer p {
            margin: 0;
            font-size: 14px;
        }
        
        .btn {
            padding: 10px 24px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .btn-sm {
            padding: 8px 16px;
            font-size: 13px;
        }
        
        h1 {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 20px;
        }
        
        .expense-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #667eea;
        }
        
        .summary-card h4 {
            font-size: 12px;
            color: #718096;
            text-transform: uppercase;
            margin-bottom: 10px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .summary-card .value {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #e2e8f0;
            background: #f7fafc;
        }
        
        .card-header h3 {
            font-size: 20px;
            font-weight: 600;
            color: #2d3748;
            margin: 0;
        }
        
        .card-body {
            padding: 0;
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        table th {
            background: #f7fafc;
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
            white-space: nowrap;
        }
        
        table td {
            padding: 14px 16px;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
            font-size: 14px;
            vertical-align: middle;
        }
        
        table tbody tr:hover {
            background: #f7fafc;
        }
        
        table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }
        
        .badge-info {
            background: #bee3f8;
            color: #2c5282;
        }
        
        .badge-success {
            background: #c6f6d5;
            color: #22543d;
        }
        
        .action-buttons {
            display: flex;
            gap: 6px;
            flex-wrap: nowrap;
        }
        
        .action-buttons .btn {
            padding: 6px 12px;
            font-size: 13px;
            white-space: nowrap;
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background: #f0fff4;
            border: 1px solid #9ae6b4;
            color: #22543d;
        }
        
        .alert-danger {
            background: #fff5f5;
            border: 1px solid #feb2b2;
            color: #c53030;
        }
        
        @media (max-width: 1200px) {
            table {
                font-size: 13px;
            }
            
            table th,
            table td {
                padding: 10px 12px;
            }
        }
        
        @media (max-width: 768px) {
            .expense-summary {
                grid-template-columns: 1fr;
            }
            
            .card-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .card-header .btn {
                width: 100%;
            }
            
            .action-buttons {
                flex-direction: column;
                width: 100%;
            }
            
            .action-buttons .btn,
            .action-buttons form {
                width: 100%;
            }
            
            .action-buttons button {
                width: 100%;
            }
            
            h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>

    <div class="main-content">
        <div class="container">
        <h1 style="margin-bottom: 20px;"><%= MessageBundle.getMessage(request, "expense.summary") %></h1>
        <p style="margin-bottom: 25px; color: #64748b;">
            <%= MessageBundle.getMessage(request, "candidate.name") %>: <strong><%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <%= candidate.getNominationId() %><% } %></strong> | 
            <a href="<%=request.getContextPath()%>/select-candidate?action=clear" style="color: #667eea;"><%= MessageBundle.getMessage(request, "user.switch.candidate") %></a>
        </p>
        
        <% if (success != null) { %>
            <div class="alert alert-success">✅ <%= success %></div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-danger">❌ <%= error %></div>
        <% } %>
        
        <!-- Expense Summary -->
        <% 
            int totalExpenses = expenses != null ? expenses.size() : 0;
            double totalAmount = 0;
            if (expenses != null) {
                for (Expense e : expenses) {
                    totalAmount += e.getExpenseAmount().doubleValue();
                }
            }
        %>
        <div class="expense-summary">
            <div class="summary-card">
                <h4><%= MessageBundle.getMessage(request, "expense.total") %></h4>
                <div class="value"><%= totalExpenses %></div>
            </div>
            <div class="summary-card" style="border-left-color: #48bb78;">
                <h4><%= MessageBundle.getMessage(request, "expense.amount") %> (<%= MessageBundle.getMessage(request, "text.total") %>)</h4>
                <div class="value">₹<%= String.format("%.2f", totalAmount) %></div>
            </div>
            <div class="summary-card" style="border-left-color: #ed8936;">
                <h4><%= MessageBundle.getMessage(request, "expense.average") %></h4>
                <div class="value">₹<%= totalExpenses > 0 ? String.format("%.2f", totalAmount / totalExpenses) : "0.00" %></div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h3><%= MessageBundle.getMessage(request, "expense.list") %></h3>
                <a href="add-expense.jsp" class="btn btn-success btn-sm">➕ <%= MessageBundle.getMessage(request, "expense.add") %></a>
            </div>
            <div class="card-body">
                <% if (expenses != null && !expenses.isEmpty()) { %>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th><%= MessageBundle.getMessage(request, "expense.date") %></th>
                                    <th><%= MessageBundle.getMessage(request, "expense.category") %></th>
                                    <th><%= MessageBundle.getMessage(request, "expense.description") %></th>
                                    <th><%= MessageBundle.getMessage(request, "expense.vendor.name") %></th>
                                    <th><%= MessageBundle.getMessage(request, "expense.payment.mode") %></th>
                                    <th><%= MessageBundle.getMessage(request, "expense.amount") %></th>
                                    <th><%= MessageBundle.getMessage(request, "expense.receipt") %></th>
                                    <th><%= MessageBundle.getMessage(request, "table.actions") %></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Expense expense : expenses) { %>
                                    <tr>
                                        <td><%= expense.getExpenseDate() %></td>
                                        <td><span class="badge badge-info"><%= expense.getExpenseCategory() %></span></td>
                                        <td><%= expense.getExpenseDescription() %></td>
                                        <td><%= expense.getVendorName() != null ? expense.getVendorName() : "-" %></td>
                                        <td><%= expense.getPaymentMode() != null ? expense.getPaymentMode() : "-" %></td>
                                        <td><strong>₹<%= String.format("%.2f", expense.getExpenseAmount()) %></strong></td>
                                        <td>
                                            <% if (expense.getReceiptNumber() != null && !expense.getReceiptNumber().isEmpty()) { %>
                                                <span class="badge badge-success"><%= expense.getReceiptNumber() %></span>
                                            <% } else { %>
                                                <span style="color: #a0aec0;">-</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="edit-expense.jsp?expenseId=<%= expense.getExpenseId() %>" class="btn btn-primary btn-sm" title="Edit">
                                                    ✏️ <%= MessageBundle.getMessage(request, "action.edit") %>
                                                </a>
                                                <form action="<%=request.getContextPath()%>/expense" method="post" style="display:inline; margin: 0;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="expenseId" value="<%= expense.getExpenseId() %>">
                                                    <button type="submit" class="btn btn-danger btn-sm" 
                                                            onclick="return confirm('<%= MessageBundle.getMessage(request, "confirm.delete.expense") %>')" title="Delete">
                                                        🗑️ <%= MessageBundle.getMessage(request, "action.delete") %>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div style="text-align: center; padding: 60px 20px; color: #718096;">
                        <div style="font-size: 4rem; margin-bottom: 20px;">📊</div>
                        <h3 style="color: #4a5568; margin-bottom: 10px;"><%= MessageBundle.getMessage(request, "empty.no.expenses") %></h3>
                        <p style="margin-bottom: 20px;"><%= MessageBundle.getMessage(request, "expense.track.message") %></p>
                        <a href="add-expense.jsp" class="btn btn-success">➕ <%= MessageBundle.getMessage(request, "expense.add.first") %></a>
                    </div>
                <% } %>
            </div>
        </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2024 <%= MessageBundle.getMessage(request, "app.title") %>. <%= MessageBundle.getMessage(request, "footer.rights") %></p>
    </footer>

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() { alert.remove(); }, 500);
            });
        }, 5000);
    </script>
</body>
</html>

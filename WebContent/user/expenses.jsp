<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate, com.election.model.Expense, com.election.dao.ExpenseDAO, java.util.List" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.i18n.LocaleManager" %>
<%@ page import="java.math.BigDecimal" %>
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
    List<Expense> allExpenses = expenseDAO.getExpensesByCandidate(candidate.getCandidateId());
    
    // Get filter parameters
    String filterCategory = request.getParameter("category");
    String filterPaymentMode = request.getParameter("paymentMode");
    String filterDateFrom = request.getParameter("dateFrom");
    String filterDateTo = request.getParameter("dateTo");
    String filterMinAmount = request.getParameter("minAmount");
    String filterMaxAmount = request.getParameter("maxAmount");
    String searchQuery = request.getParameter("search");
    
    // Apply filters
    List<Expense> expenses = new java.util.ArrayList<>();
    if (allExpenses != null) {
        for (Expense exp : allExpenses) {
            boolean includeExpense = true;
            
            // Category filter
            if (filterCategory != null && !filterCategory.isEmpty() && !filterCategory.equals("all")) {
                if (exp.getExpenseCategory() == null || !exp.getExpenseCategory().equals(filterCategory)) {
                    includeExpense = false;
                }
            }
            
            // Payment mode filter
            if (filterPaymentMode != null && !filterPaymentMode.isEmpty() && !filterPaymentMode.equals("all")) {
                if (exp.getPaymentMode() == null || !exp.getPaymentMode().equals(filterPaymentMode)) {
                    includeExpense = false;
                }
            }
            
            // Date range filter
            if (filterDateFrom != null && !filterDateFrom.isEmpty()) {
                if (exp.getExpenseDate() == null || exp.getExpenseDate().toString().compareTo(filterDateFrom) < 0) {
                    includeExpense = false;
                }
            }
            if (filterDateTo != null && !filterDateTo.isEmpty()) {
                if (exp.getExpenseDate() == null || exp.getExpenseDate().toString().compareTo(filterDateTo) > 0) {
                    includeExpense = false;
                }
            }
            
            // Amount range filter
            if (filterMinAmount != null && !filterMinAmount.isEmpty()) {
                try {
                    BigDecimal minAmt = new BigDecimal(filterMinAmount);
                    if (exp.getExpenseAmount() != null && exp.getExpenseAmount().compareTo(minAmt) < 0) {
                        includeExpense = false;
                    }
                } catch (NumberFormatException e) {}
            }
            if (filterMaxAmount != null && !filterMaxAmount.isEmpty()) {
                try {
                    BigDecimal maxAmt = new BigDecimal(filterMaxAmount);
                    if (exp.getExpenseAmount() != null && exp.getExpenseAmount().compareTo(maxAmt) > 0) {
                        includeExpense = false;
                    }
                } catch (NumberFormatException e) {}
            }
            
            // Search query filter (vendor name, description, receipt)
            if (searchQuery != null && !searchQuery.isEmpty()) {
                String query = searchQuery.toLowerCase();
                boolean matchFound = false;
                
                if (exp.getVendorName() != null && exp.getVendorName().toLowerCase().contains(query)) {
                    matchFound = true;
                }
                if (exp.getExpenseDescription() != null && exp.getExpenseDescription().toLowerCase().contains(query)) {
                    matchFound = true;
                }
                if (exp.getReceiptNumber() != null && exp.getReceiptNumber().toLowerCase().contains(query)) {
                    matchFound = true;
                }
                
                if (!matchFound) {
                    includeExpense = false;
                }
            }
            
            if (includeExpense) {
                expenses.add(exp);
            }
        }
    }
    
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
        
        .form-control {
            font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
            transition: all 0.2s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-info {
            background: #bee3f8;
            color: #2c5282;
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
        
        <!-- Filter Section -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="card-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                <h3 style="color: white; margin: 0;">🔍 <%= MessageBundle.getMessage(request, "filter.expenses") %></h3>
                <button type="button" class="btn" onclick="toggleFilters()" 
                        style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                    <span id="filterToggleIcon">▼</span> <%= MessageBundle.getMessage(request, "filter.toggle") %>
                </button>
            </div>
            <div class="card-body" id="filterSection" style="display: block;">
                <form method="get" action="expenses.jsp" id="filterForm">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-bottom: 15px;">
                        <!-- Search Box -->
                        <div>
                            <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                🔎 <%= MessageBundle.getMessage(request, "search") %>
                            </label>
                            <input type="text" name="search" class="form-control" 
                                   placeholder="<%= MessageBundle.getMessage(request, "search.placeholder") %>"
                                   value="<%= searchQuery != null ? searchQuery : "" %>"
                                   style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                        </div>
                        
                        <!-- Category Filter -->
                        <div>
                            <%-- <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                📁 <%= MessageBundle.getMessage(request, "expense.category") %>
                            </label>
                            <select name="category" class="form-control" style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                                <option value="all" <%= (filterCategory == null || filterCategory.equals("all")) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "filter.all") %>
                                </option>
                                <option value="Advertising" <%= "Advertising".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.advertising") %>
                                </option>
                                <option value="Travel" <%= "Travel".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.travel") %>
                                </option>
                                <option value="Accommodation" <%= "Accommodation".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.accommodation") %>
                                </option>
                                <option value="Food" <%= "Food".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.food") %>
                                </option>
                                <option value="Printing" <%= "Printing".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.printing") %>
                                </option>
                                <option value="Events" <%= "Events".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.events") %>
                                </option>
                                <option value="Salaries" <%= "Salaries".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.salaries") %>
                                </option>
                                <option value="Office Supplies" <%= "Office Supplies".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.office.supplies") %>
                                </option>
                                <option value="Communication" <%= "Communication".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.communication") %>
                                </option>
                                <option value="Other" <%= "Other".equals(filterCategory) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "category.other") %>
                                </option>
                            </select> --%>
                        </div>
                        
                        <!-- Payment Mode Filter -->
                        <div>
                            <%-- <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                💳 <%= MessageBundle.getMessage(request, "expense.payment.mode") %>
                            </label>
                            <select name="paymentMode" class="form-control" style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                                <option value="all" <%= (filterPaymentMode == null || filterPaymentMode.equals("all")) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "filter.all") %>
                                </option>
                                <option value="Cash" <%= "Cash".equals(filterPaymentMode) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "payment.cash") %>
                                </option>
                                <option value="UPI" <%= "UPI".equals(filterPaymentMode) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "payment.upi") %>
                                </option>
                                <option value="Bank Transfer" <%= "Bank Transfer".equals(filterPaymentMode) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "payment.bank.transfer") %>
                                </option>
                                <option value="Cheque" <%= "Cheque".equals(filterPaymentMode) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "payment.cheque") %>
                                </option>
                                <option value="Credit Card" <%= "Credit Card".equals(filterPaymentMode) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "payment.credit.card") %>
                                </option>
                                <option value="Debit Card" <%= "Debit Card".equals(filterPaymentMode) ? "selected" : "" %>>
                                    <%= MessageBundle.getMessage(request, "payment.debit.card") %>
                                </option>
                            </select> --%>
                        </div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 15px;">
                        <!-- Date From -->
                        <div>
                            <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                📅 <%= MessageBundle.getMessage(request, "date.from") %>
                            </label>
                            <input type="date" name="dateFrom" class="form-control" 
                                   value="<%= filterDateFrom != null ? filterDateFrom : "" %>"
                                   style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                        </div>
                        
                        <!-- Date To -->
                        <div>
                            <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                📅 <%= MessageBundle.getMessage(request, "date.to") %>
                            </label>
                            <input type="date" name="dateTo" class="form-control" 
                                   value="<%= filterDateTo != null ? filterDateTo : "" %>"
                                   style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                        </div>
                        
                        <!-- Min Amount -->
                        <div>
                            <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                💰 <%= MessageBundle.getMessage(request, "amount.min") %>
                            </label>
                            <input type="number" name="minAmount" class="form-control" 
                                   placeholder="₹ 0" step="0.01" min="0"
                                   value="<%= filterMinAmount != null ? filterMinAmount : "" %>"
                                   style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                        </div>
                        
                        <!-- Max Amount -->
                        <div>
                            <label style="display: block; margin-bottom: 5px; font-weight: 600; color: #4a5568;">
                                💰 <%= MessageBundle.getMessage(request, "amount.max") %>
                            </label>
                            <input type="number" name="maxAmount" class="form-control" 
                                   placeholder="₹ 999999" step="0.01" min="0"
                                   value="<%= filterMaxAmount != null ? filterMaxAmount : "" %>"
                                   style="width: 100%; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px;">
                        </div>
                    </div>
                    
                    <!-- Filter Buttons -->
                    <div style="display: flex; gap: 10px; justify-content: flex-end; flex-wrap: wrap;">
                        <button type="submit" class="btn btn-primary">
                            🔍 <%= MessageBundle.getMessage(request, "button.apply.filters") %>
                        </button>
                        <button type="button" class="btn" onclick="clearFilters()" 
                                style="background: #e2e8f0; color: #4a5568;">
                            🔄 <%= MessageBundle.getMessage(request, "button.clear.filters") %>
                        </button>
                        <a href="expenses.jsp" class="btn" style="background: #f56565; color: white;">
                            ❌ <%= MessageBundle.getMessage(request, "button.reset") %>
                        </a>
                    </div>
                </form>
                
                <!-- Active Filters Display -->
                <% 
                boolean hasActiveFilters = (filterCategory != null && !filterCategory.equals("all")) ||
                                          (filterPaymentMode != null && !filterPaymentMode.equals("all")) ||
                                          (filterDateFrom != null && !filterDateFrom.isEmpty()) ||
                                          (filterDateTo != null && !filterDateTo.isEmpty()) ||
                                          (filterMinAmount != null && !filterMinAmount.isEmpty()) ||
                                          (filterMaxAmount != null && !filterMaxAmount.isEmpty()) ||
                                          (searchQuery != null && !searchQuery.isEmpty());
                
                if (hasActiveFilters) { 
                %>
                    <div style="margin-top: 15px; padding: 10px; background: #ebf8ff; border-left: 4px solid #4299e1; border-radius: 4px;">
                        <strong style="color: #2c5282;">🔖 <%= MessageBundle.getMessage(request, "active.filters") %>:</strong>
                        <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px;">
                            <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    🔎 <%= MessageBundle.getMessage(request, "search") %>: <%= searchQuery %>
                                </span>
                            <% } %>
                            <% if (filterCategory != null && !filterCategory.equals("all")) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    📁 <%= filterCategory %>
                                </span>
                            <% } %>
                            <% if (filterPaymentMode != null && !filterPaymentMode.equals("all")) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    💳 <%= filterPaymentMode %>
                                </span>
                            <% } %>
                            <% if (filterDateFrom != null && !filterDateFrom.isEmpty()) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    📅 From: <%= filterDateFrom %>
                                </span>
                            <% } %>
                            <% if (filterDateTo != null && !filterDateTo.isEmpty()) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    📅 To: <%= filterDateTo %>
                                </span>
                            <% } %>
                            <% if (filterMinAmount != null && !filterMinAmount.isEmpty()) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    💰 Min: ₹<%= filterMinAmount %>
                                </span>
                            <% } %>
                            <% if (filterMaxAmount != null && !filterMaxAmount.isEmpty()) { %>
                                <span class="badge badge-info" style="padding: 6px 12px; font-size: 13px;">
                                    💰 Max: ₹<%= filterMaxAmount %>
                                </span>
                            <% } %>
                        </div>
                        <p style="margin: 8px 0 0 0; color: #2c5282; font-size: 13px;">
                            <%= MessageBundle.getMessage(request, "showing") %> <strong><%= expenses.size() %></strong> 
                            <%= MessageBundle.getMessage(request, "of") %> <strong><%= allExpenses != null ? allExpenses.size() : 0 %></strong> 
                            <%= MessageBundle.getMessage(request, "expenses") %>
                        </p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h3><%= MessageBundle.getMessage(request, "expense.list") %> 
                    <span style="color: #718096; font-size: 14px; font-weight: normal;">
                        (<%= expenses != null ? expenses.size() : 0 %> <%= MessageBundle.getMessage(request, "items") %>)
                    </span>
                </h3>
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
        
        // Toggle filter section
        function toggleFilters() {
            var filterSection = document.getElementById('filterSection');
            var toggleIcon = document.getElementById('filterToggleIcon');
            
            if (filterSection.style.display === 'none') {
                filterSection.style.display = 'block';
                toggleIcon.textContent = '▼';
            } else {
                filterSection.style.display = 'none';
                toggleIcon.textContent = '▶';
            }
        }
        
        // Clear all filters
        function clearFilters() {
            document.querySelector('input[name="search"]').value = '';
            document.querySelector('select[name="category"]').value = 'all';
            document.querySelector('select[name="paymentMode"]').value = 'all';
            document.querySelector('input[name="dateFrom"]').value = '';
            document.querySelector('input[name="dateTo"]').value = '';
            document.querySelector('input[name="minAmount"]').value = '';
            document.querySelector('input[name="maxAmount"]').value = '';
        }
        
        // Quick date filters
        function setDateFilter(days) {
            var today = new Date();
            var fromDate = new Date();
            fromDate.setDate(today.getDate() - days);
            
            document.querySelector('input[name="dateFrom"]').value = formatDate(fromDate);
            document.querySelector('input[name="dateTo"]').value = formatDate(today);
        }
        
        function formatDate(date) {
            var year = date.getFullYear();
            var month = String(date.getMonth() + 1).padStart(2, '0');
            var day = String(date.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }
        
        // Auto-submit on filter change (optional)
        function enableAutoFilter() {
            var filterInputs = document.querySelectorAll('#filterForm select, #filterForm input[type="date"]');
            filterInputs.forEach(function(input) {
                input.addEventListener('change', function() {
                    document.getElementById('filterForm').submit();
                });
            });
        }
        
        // Uncomment to enable auto-filter
        // enableAutoFilter();
    </script>
</body>
</html>

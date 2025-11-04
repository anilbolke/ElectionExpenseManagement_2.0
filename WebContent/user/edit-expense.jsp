<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate, com.election.model.Expense, com.election.dao.ExpenseDAO" %>
<%
    User user = (User) session.getAttribute("user");
    Candidate candidate = (Candidate) session.getAttribute("candidate");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    if(candidate == null || !candidate.isPaymentVerified()) {
        response.sendRedirect("dashboard.jsp?error=Please select an active candidate first");
        return;
    }
    
    String expenseIdStr = request.getParameter("expenseId");
    if(expenseIdStr == null || expenseIdStr.trim().isEmpty()) {
        response.sendRedirect("expenses.jsp?error=Invalid expense ID");
        return;
    }
    
    Expense expense = null;
    try {
        int expenseId = Integer.parseInt(expenseIdStr);
        ExpenseDAO expenseDAO = new ExpenseDAO();
        expense = expenseDAO.getExpenseById(expenseId);
        
        if(expense == null) {
            response.sendRedirect("expenses.jsp?error=Expense not found");
            return;
        }
        
        if(expense.getCandidateId() != candidate.getCandidateId()) {
            response.sendRedirect("expenses.jsp?error=Unauthorized access to expense");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("expenses.jsp?error=Invalid expense ID format");
        return;
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("expenses.jsp?error=Error loading expense: " + e.getMessage());
        return;
    }
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Expense - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-header {
            margin-bottom: 25px;
        }
        .page-header h1 {
            color: #2d3748;
            font-size: 2rem;
            margin-bottom: 8px;
        }
        .candidate-badge {
            display: inline-block;
            padding: 8px 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .card-body {
            padding: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #2d3748;
        }
        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -10px;
        }
        .col-md-6 {
            flex: 0 0 50%;
            max-width: 50%;
            padding: 0 10px;
        }
        .col-md-4 {
            flex: 0 0 33.333%;
            max-width: 33.333%;
            padding: 0 10px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 14px;
            text-align: center;
            display: inline-block;
            text-decoration: none;
        }
        .btn-block {
            display: block;
            width: 100%;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        .btn-danger {
            background: #f56565;
            color: white;
        }
        .btn-danger:hover {
            background: #e53e3e;
        }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #f0fff4;
            color: #2f855a;
            border-left: 4px solid #48bb78;
        }
        .alert-error {
            background: #fff5f5;
            color: #c53030;
            border-left: 4px solid #f56565;
        }
        @media (max-width: 768px) {
            .col-md-6, .col-md-4 {
                flex: 0 0 100%;
                max-width: 100%;
                margin-bottom: 15px;
            }
            .row {
                margin: 0;
            }
        }
    </style>
</head>
<body class="dashboard">
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ Election Expense</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="manage-candidates.jsp">My Candidates</a></li>
                <li><a href="add-expense.jsp">Add Expense</a></li>
                <li><a href="expenses.jsp">View Expenses</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="page-header">
            <h1>✏️ Edit Expense</h1>
            <div class="candidate-badge">
                📌 Candidate: <%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <strong><%= candidate.getNominationId() %></strong><% } %>
            </div>
        </div>
        
        <% if(success != null) { %>
            <div class="alert alert-success">
                ✅ <%= success %>
            </div>
        <% } %>
        
        <% if(error != null) { %>
            <div class="alert alert-error">
                ❌ <%= error %>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-body">
                <form action="<%=request.getContextPath()%>/expense" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="expenseId" value="<%= expense.getExpenseId() %>">
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="category">Expense Category: *</label>
                                <select id="category" name="category" class="form-control" required>
                                    <option value="">Select Category</option>
                                    <option value="Advertisement" <%= "Advertisement".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Advertisement</option>
                                    <option value="Travel" <%= "Travel".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Travel</option>
                                    <option value="Meeting" <%= "Meeting".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Meeting/Rally</option>
                                    <option value="Printing" <%= "Printing".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Printing & Publicity</option>
                                    <option value="Food" <%= "Food".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Food & Refreshments</option>
                                    <option value="Venue" <%= "Venue".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Venue Booking</option>
                                    <option value="Staff" <%= "Staff".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Staff Salary</option>
                                    <option value="Miscellaneous" <%= "Miscellaneous".equals(expense.getExpenseCategory()) ? "selected" : "" %>>Miscellaneous</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="amount">Amount (₹): *</label>
                                <input type="number" id="amount" name="amount" class="form-control" step="0.01" min="0" value="<%= expense.getExpenseAmount() %>" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="date">Expense Date: *</label>
                                <input type="date" id="date" name="date" class="form-control" value="<%= expense.getExpenseDate() %>" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="paymentMode">Payment Mode: *</label>
                                <select id="paymentMode" name="paymentMode" class="form-control" required>
                                    <option value="">Select Payment Mode</option>
                                    <option value="Cash" <%= "Cash".equals(expense.getPaymentMode()) ? "selected" : "" %>>Cash</option>
                                    <option value="Online" <%= "Online".equals(expense.getPaymentMode()) ? "selected" : "" %>>Online</option>
                                    <option value="Cheque" <%= "Cheque".equals(expense.getPaymentMode()) ? "selected" : "" %>>Cheque</option>
                                    <option value="UPI" <%= "UPI".equals(expense.getPaymentMode()) ? "selected" : "" %>>UPI</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="vendorName">Vendor/Payee Name:</label>
                                <input type="text" id="vendorName" name="vendorName" class="form-control" value="<%= expense.getVendorName() != null ? expense.getVendorName() : "" %>">
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="receiptNumber">Receipt Number:</label>
                                <input type="text" id="receiptNumber" name="receiptNumber" class="form-control" value="<%= expense.getReceiptNumber() != null ? expense.getReceiptNumber() : "" %>">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description: *</label>
                        <textarea id="description" name="description" class="form-control" rows="3" required><%= expense.getExpenseDescription() %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="remarks">Remarks:</label>
                        <textarea id="remarks" name="remarks" class="form-control" rows="2"><%= expense.getRemarks() != null ? expense.getRemarks() : "" %></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <button type="submit" class="btn btn-primary btn-block">💾 Update Expense</button>
                        </div>
                        <div class="col-md-4">
                            <a href="expenses.jsp" class="btn btn-secondary btn-block">Cancel</a>
                        </div>
                        <div class="col-md-4">
                            <button type="button" class="btn btn-danger btn-block" onclick="deleteExpense()">🗑️ Delete</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function deleteExpense() {
            if(confirm('Are you sure you want to delete this expense? This action cannot be undone.')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%=request.getContextPath()%>/expense';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'expenseId';
                idInput.value = '<%= expense.getExpenseId() %>';
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Auto-hide success/error messages after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.i18n.LocaleManager" %>
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
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "heading.add.expense") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
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
            max-width: 1000px;
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
        
        .page-header {
            margin-bottom: 25px;
        }
        
        .page-header h1 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .candidate-badge {
            display: inline-block;
            padding: 10px 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .form-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 0;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #4a5568;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 14px;
            color: #2d3748;
            background-color: #fff;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #4299e1;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%234a5568' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 12px;
            padding-right: 40px;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
            font-family: inherit;
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
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
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .page-header h1 {
                font-size: 24px;
            }
            
            .form-section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <div class="page-header">
                <h1><%= MessageBundle.getMessage(request, "heading.add.expense") %></h1>
                <div class="candidate-badge">
                    📌 <%= MessageBundle.getMessage(request, "candidate.name") %>: <%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <strong><%= candidate.getNominationId() %></strong><% } %>
                </div>
            </div>
        
        <% if(success != null) { %>
            <div class="alert alert-success">
                ✅ <%= success %>
            </div>
        <% } %>
        
        <% if(error != null) { %>
            <div class="alert alert-danger">
                ❌ <%= error %>
            </div>
        <% } %>
        
        <div class="form-section">
            <form action="<%=request.getContextPath()%>/expense" method="post">
                <input type="hidden" name="action" value="add">
                
                <div style="display: grid; gap: 20px;">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="category"><%= MessageBundle.getMessage(request, "expense.category") %> *</label>
                            <select id="category" name="category" class="form-control" required>
                                <option value=""><%= MessageBundle.getMessage(request, "form.placeholder.select") %></option>
                                <option value="Advertisement"><%= MessageBundle.getMessage(request, "expense.category.advertisement") %></option>
                                <option value="Travel"><%= MessageBundle.getMessage(request, "expense.category.travel") %></option>
                                <option value="Meeting"><%= MessageBundle.getMessage(request, "expense.category.meeting") %></option>
                                <option value="Printing"><%= MessageBundle.getMessage(request, "expense.category.printing") %></option>
                                <option value="Food"><%= MessageBundle.getMessage(request, "expense.category.food") %></option>
                                <option value="Venue"><%= MessageBundle.getMessage(request, "expense.category.venue") %></option>
                                <option value="Staff"><%= MessageBundle.getMessage(request, "expense.category.staff") %></option>
                                <option value="Miscellaneous"><%= MessageBundle.getMessage(request, "expense.category.miscellaneous") %></option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="amount"><%= MessageBundle.getMessage(request, "expense.amount") %> (₹) *</label>
                            <input type="number" id="amount" name="amount" class="form-control" step="0.01" min="0" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="date"><%= MessageBundle.getMessage(request, "expense.date") %> *</label>
                            <input type="date" id="date" name="date" class="form-control" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="paymentMode"><%= MessageBundle.getMessage(request, "expense.payment.mode") %> *</label>
                            <select id="paymentMode" name="paymentMode" class="form-control" required>
                                <option value=""><%= MessageBundle.getMessage(request, "form.placeholder.select") %></option>
                                <option value="Cash"><%= MessageBundle.getMessage(request, "expense.payment.mode.cash") %></option>
                                <option value="Online"><%= MessageBundle.getMessage(request, "expense.payment.mode.online") %></option>
                                <option value="Cheque"><%= MessageBundle.getMessage(request, "expense.payment.mode.cheque") %></option>
                                <option value="UPI"><%= MessageBundle.getMessage(request, "expense.payment.mode.upi") %></option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="vendorName"><%= MessageBundle.getMessage(request, "expense.vendor.name") %></label>
                            <input type="text" id="vendorName" name="vendorName" class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="receiptNumber"><%= MessageBundle.getMessage(request, "expense.receipt") %> <%= MessageBundle.getMessage(request, "table.id") %></label>
                            <input type="text" id="receiptNumber" name="receiptNumber" class="form-control">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description"><%= MessageBundle.getMessage(request, "expense.description") %> *</label>
                        <textarea id="description" name="description" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="remarks"><%= MessageBundle.getMessage(request, "expense.remarks") %></label>
                        <textarea id="remarks" name="remarks" class="form-control" rows="2"></textarea>
                    </div>
                </div>
                
                <div class="form-actions">
                    <a href="expenses.jsp" class="btn btn-secondary"><%= MessageBundle.getMessage(request, "action.cancel") %></a>
                    <button type="submit" class="btn btn-primary">💰 <%= MessageBundle.getMessage(request, "expense.submit") %></button>
                </div>
            </form>
        </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2024 <%= MessageBundle.getMessage(request, "app.title") %>. <%= MessageBundle.getMessage(request, "footer.rights") %></p>
    </footer>
    
    <script>
        // Set today's date as default
        document.getElementById('date').valueAsDate = new Date();
        
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

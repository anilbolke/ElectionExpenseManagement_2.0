<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate, com.election.model.Expense, com.election.dao.ExpenseDAO" %>
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
    
    // Preserve form data if there's an error
    String prevCategory = request.getParameter("category") != null ? request.getParameter("category") : "";
    String prevDate = request.getParameter("date") != null ? request.getParameter("date") : "";
    String prevVendorName = request.getParameter("vendorName") != null ? request.getParameter("vendorName") : "";
    String prevReceiptNumber = request.getParameter("receiptNumber") != null ? request.getParameter("receiptNumber") : "";
    String prevAreaSizeQuantity = request.getParameter("areaSizeQuantity") != null ? request.getParameter("areaSizeQuantity") : "";
    String prevRate = request.getParameter("rate") != null ? request.getParameter("rate") : "";
    String prevAmount = request.getParameter("amount") != null ? request.getParameter("amount") : "";
    String prevPaymentMode = request.getParameter("paymentMode") != null ? request.getParameter("paymentMode") : "";
    String prevPartyMobile = request.getParameter("partyMobile") != null ? request.getParameter("partyMobile") : "";
    String prevExpenseSource = request.getParameter("expenseSource") != null ? request.getParameter("expenseSource") : "";
    String prevDescription = request.getParameter("description") != null ? request.getParameter("description") : "";
    String prevRemarks = request.getParameter("remarks") != null ? request.getParameter("remarks") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "heading.edit.expense") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
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
        
        .alert-warning {
            background: #fffbeb;
            border: 1px solid #fcd34d;
            color: #78350f;
        }
        
        .alert-critical {
            background: #7f1d1d;
            border: 1px solid #dc2626;
            color: #fff;
            font-weight: 600;
        }
        
        .fund-alert-box {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .fund-alert-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-weight: 700;
            font-size: 14px;
        }
        
        .fund-alert-details {
            font-size: 13px;
            line-height: 1.6;
        }
        
        .fund-stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-top: 12px;
        }
        
        .fund-stat-item {
            background: rgba(255,255,255,0.5);
            padding: 8px;
            border-radius: 6px;
            text-align: center;
        }
        
        .fund-stat-label {
            font-size: 11px;
            opacity: 0.9;
            text-transform: uppercase;
        }
        
        .fund-stat-value {
            font-size: 16px;
            font-weight: 700;
            margin-top: 4px;
        }
        
        .progress-bar {
            width: 100%;
            height: 24px;
            background: rgba(255,255,255,0.3);
            border-radius: 12px;
            overflow: hidden;
            margin-top: 12px;
        }
        
        .progress-fill {
            height: 100%;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: 700;
        }
        
        /* Voice Input Styles */
        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .form-control-voice {
            padding-right: 45px !important;
        }
        .voice-btn {
            position: absolute;
            right: 12px;
            background: none;
            border: none;
            cursor: pointer;
            padding: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 10;
        }
        .voice-btn:hover {
            transform: scale(1.1);
        }
        .voice-btn svg {
            width: 20px;
            height: 20px;
            fill: #718096;
            transition: fill 0.3s ease;
        }
        .voice-btn:hover svg {
            fill: #667eea;
        }
        .voice-btn.listening svg {
            fill: #e53e3e;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.2); opacity: 0.7; }
        }
        .voice-status {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 25px;
            border-radius: 50px;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            display: none;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 14px;
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateY(100px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .voice-status.active {
            display: flex;
        }
        .voice-status .pulse-dot {
            width: 10px;
            height: 10px;
            background: #fff;
            border-radius: 50%;
            animation: pulseDot 1s infinite;
        }
        @keyframes pulseDot {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }
        .voice-not-supported {
            background: #fed7d7;
            color: #c53030;
            padding: 10px 15px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            display: none;
        }
        .voice-not-supported.show {
            display: block;
        }
        
        /* Language Toggle Buttons */
        .lang-toggle-container {
            text-align: center;
            margin: 20px 0;
            padding: 15px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .lang-btn {
            padding: 8px 20px;
            margin: 0 5px;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            background: white;
            color: #4a5568;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .lang-btn:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }
        .lang-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .voice-info-banner {
            margin-top: 10px;
            padding: 12px 20px;
            background: #ebf8ff;
            border: 1px solid #bee3f8;
            border-radius: 8px;
            font-size: 13px;
            color: #2c5282;
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
            <!-- Voice Input Not Supported Warning -->
            <div class="voice-not-supported" id="voiceNotSupported">
                ⚠️ Voice input is not supported in your browser. Please use Chrome, Edge, or Safari for voice typing feature.
            </div>
            
            <!-- Language Toggle -->
            <div class="lang-toggle-container" id="langToggleContainer">
                <label style="font-size: 14px; color: #718096; margin-right: 10px;">🎤 Voice Input Language:</label>
                <button type="button" id="langMarathi" class="lang-btn active" onclick="setLanguage('mr-IN')">🇮🇳 मराठी</button>
                <button type="button" id="langEnglish" class="lang-btn" onclick="setLanguage('en-US')">🇬🇧 English</button>
                <div class="voice-info-banner">
                    <strong>💡 टीप:</strong> मायक्रोफोन आयकॉन 🎤 वर क्लिक करून आवाजात माहिती भरा | 
                    <strong>Tip:</strong> Click the microphone icon 🎤 to fill information by voice
                </div>
            </div>
            
            <div class="page-header">
                <h1><%= MessageBundle.getMessage(request, "heading.edit.expense") %></h1>
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
        
        <%
        // Check if candidate needs expense limit
        boolean needsExpenseLimit = (candidate.getExpenseLimit() == null || 
                                    candidate.getExpenseLimit().compareTo(java.math.BigDecimal.ZERO) <= 0);
        if (needsExpenseLimit) {
        %>
        <div class="alert" style="background: #fef2f2; border: 2px solid #ef4444; color: #991b1b; margin-bottom: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <div style="font-size: 24px;">🚨</div>
                <div style="flex: 1;">
                    <strong>Cannot Update Expense:</strong> Expense limit is not set for <%= candidate.getCandidateName() %>. 
                    Please set the expense limit before adding expenses.
                </div>
                <a href="edit-candidate.jsp?candidateId=<%= candidate.getCandidateId() %>" 
                   class="btn" style="background: #dc2626; color: white; white-space: nowrap; font-weight: 600;">
                    Set Expense Limit
                </a>
            </div>
        </div>
        <% } %>
        
        <!-- Fund Alert Notification -->
        <div id="fundAlertBox" class="fund-alert-box" style="display: none;"></div>
        
        <div class="form-section" <%= needsExpenseLimit ? "style='opacity: 0.5; pointer-events: none;'" : "" %>>
            <form action="<%=request.getContextPath()%>/expense" method="post" onsubmit="return validateExpenseForm(event)" id="expenseForm">
                <input type="hidden" name="action" value="update">    <input type="hidden" name="expenseId" value="<%= expense.getExpenseId() %>">
                
                <div style="display: grid; gap: 20px;">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="category"><%= MessageBundle.getMessage(request, "expense.category") %> *</label>
                            <select id="category" name="category" class="form-control" required>
                                <option value=""><%= MessageBundle.getMessage(request, "form.select") %></option>
                                <option value="Advertisement" <%= "Advertisement".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.advertisement") %></option>
                                <option value="Travel" <%= "Travel".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.travel") %></option>
                                <option value="Meeting" <%= "Meeting".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.meeting") %></option>
                                <option value="Printing" <%= "Printing".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.printing") %></option>
                                <option value="Food" <%= "Food".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.food") %></option>
                                <option value="Venue" <%= "Venue".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.venue") %></option>
                                <option value="Staff" <%= "Staff".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.staff") %></option>
                                <option value="Miscellaneous" <%= "Miscellaneous".equals(expense.getExpenseCategory()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.category.miscellaneous") %></option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="date"><%= MessageBundle.getMessage(request, "expense.date") %> *</label>
                            <input type="date" id="date" name="date" class="form-control" value="<%= expense.getExpenseDate() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="vendorName"><%= MessageBundle.getMessage(request, "expense.vendor.name") %></label>
                            <div class="input-wrapper">
                                <input type="text" id="vendorName" name="vendorName" class="form-control form-control-voice" value="<%= expense.getVendorName() != null ? expense.getVendorName() : "" %>">
                                <button type="button" class="voice-btn" data-field="vendorName" title="Voice Input">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                        <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                        <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="receiptNumber"><%= MessageBundle.getMessage(request, "expense.receipt.number") %></label>
                            <div class="input-wrapper">
                                <input type="text" id="receiptNumber" name="receiptNumber" class="form-control form-control-voice" value="<%= expense.getReceiptNumber() != null ? expense.getReceiptNumber() : "" %>">
                                <button type="button" class="voice-btn" data-field="receiptNumber" title="Voice Input">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                        <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                        <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="areaSizeQuantity"><%= MessageBundle.getMessage(request, "expense.area.size.quantity") %></label>
                            <div class="input-wrapper">
                                <input type="text" id="areaSizeQuantity" name="areaSizeQuantity" class="form-control form-control-voice" value="<%= expense.getAreaSizeQuantity() != null ? expense.getAreaSizeQuantity() : "" %>">
                                <button type="button" class="voice-btn" data-field="areaSizeQuantity" title="Voice Input">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                        <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                        <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="rate"><%= MessageBundle.getMessage(request, "expense.rate") %> (₹)</label>
                            <input type="number" id="rate" name="rate" class="form-control" step="0.01" min="0" value="<%= expense.getRate() != null ? expense.getRate() : "" %>">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="amount"><%= MessageBundle.getMessage(request, "expense.total.amount") %> (₹) *</label>
                            <input type="number" id="amount" name="amount" class="form-control" step="0.01" min="0" required value="<%= expense.getExpenseAmount() %>" readonly style="background-color: #f0f0f0;">
                        </div>
                        
                        <div class="form-group">
                            <label for="paymentMode"><%= MessageBundle.getMessage(request, "expense.payment.mode") %> *</label>
                            <select id="paymentMode" name="paymentMode" class="form-control" required>
                                <option value=""><%= MessageBundle.getMessage(request, "form.select") %></option>
                                <option value="Cash" <%= "Cash".equals(expense.getPaymentMode()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.payment.mode.cash") %></option>
                                <option value="Online Transfer" <%= "Online Transfer".equals(expense.getPaymentMode()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.payment.mode.online") %></option>
                                <option value="Cheque" <%= "Cheque".equals(expense.getPaymentMode()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.payment.mode.cheque") %></option>
                                <option value="UPI" <%= "UPI".equals(expense.getPaymentMode()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.payment.mode.upi") %></option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="partyMobile"><%= MessageBundle.getMessage(request, "expense.party.mobile") %></label>
                            <input type="tel" id="partyMobile" name="partyMobile" class="form-control" pattern="[0-9]{10}" maxlength="10" value="<%= expense.getPartyMobile() != null ? expense.getPartyMobile() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="expenseSource"><%= MessageBundle.getMessage(request, "expense.source") %></label>
                            <select id="expenseSource" name="expenseSource" class="form-control">
                                <option value=""><%= MessageBundle.getMessage(request, "form.select") %></option>
                                <option value="Self" <%= "Self".equals(expense.getExpenseSource()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.source.self") %></option>
                                <option value="By Party" <%= "By Party".equals(expense.getExpenseSource()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.source.party") %></option>
                                <option value="By Other" <%= "By Other".equals(expense.getExpenseSource()) ? "selected" : "" %>><%= MessageBundle.getMessage(request, "expense.source.other") %></option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description"><%= MessageBundle.getMessage(request, "expense.description") %> *</label>
                        <div class="input-wrapper">
                            <textarea id="description" name="description" class="form-control form-control-voice" rows="3" required><%= expense.getExpenseDescription() %></textarea>
                            <button type="button" class="voice-btn" data-field="description" title="Voice Input" style="top: 12px;">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                    <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                    <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="remarks"><%= MessageBundle.getMessage(request, "expense.remarks") %></label>
                        <div class="input-wrapper">
                            <textarea id="remarks" name="remarks" class="form-control form-control-voice" rows="2"><%= expense.getRemarks() != null ? expense.getRemarks() : "" %></textarea>
                            <button type="button" class="voice-btn" data-field="remarks" title="Voice Input" style="top: 12px;">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                    <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                    <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <a href="expenses.jsp" class="btn btn-secondary"><%= MessageBundle.getMessage(request, "action.cancel") %></a>
                    <button type="submit" class="btn btn-primary">💾 <%= MessageBundle.getMessage(request, "expense.update") %></button>
                        <button type="button" class="btn btn-danger" onclick="deleteExpense()">🗑️ <%= MessageBundle.getMessage(request, "action.delete") %></button>
                </div>
            </form>
        </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2024 <%= MessageBundle.getMessage(request, "app.title") %>. <%= MessageBundle.getMessage(request, "footer.rights") %></p>
    </footer>
    
    <!-- Voice Status Indicator -->
    <div class="voice-status" id="voiceStatus">
        <div class="pulse-dot"></div>
        <span>🎤 मराठीत बोला...</span>
    </div>
    
    <script>
        // Language Settings
        let currentLanguage = 'mr-IN'; // Default to Marathi
        const languageNames = {
            'mr-IN': '🇮🇳 मराठी',
            'en-US': '🇬🇧 English'
        };
        const listeningTexts = {
            'mr-IN': '🎤 मराठीत बोला...',
            'en-US': '🎤 Speak now...'
        };
        
        // Set Language Function
        function setLanguage(lang) {
            currentLanguage = lang;
            if (recognition) {
                recognition.lang = lang;
            }
            
            // Update button states
            document.querySelectorAll('.lang-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            if (lang === 'mr-IN') {
                document.getElementById('langMarathi').classList.add('active');
            } else {
                document.getElementById('langEnglish').classList.add('active');
            }
            
            // Update voice status text
            const statusSpan = document.querySelector('#voiceStatus span');
            if (statusSpan) {
                statusSpan.textContent = listeningTexts[lang];
            }
            
            console.log('Language changed to:', languageNames[lang]);
        }
        
        // Voice Recognition Setup with Marathi Support
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        let recognition = null;
        let currentField = null;
        
        if (SpeechRecognition) {
            recognition = new SpeechRecognition();
            recognition.continuous = true;
            recognition.interimResults = true;
            recognition.lang = currentLanguage; // Marathi by default
            recognition.maxAlternatives = 1;
            
            recognition.onstart = function() {
                console.log('Voice recognition started for field:', currentField, 'in', languageNames[currentLanguage]);
                document.getElementById('voiceStatus').classList.add('active');
                const statusSpan = document.querySelector('#voiceStatus span');
                if (statusSpan) {
                    statusSpan.textContent = listeningTexts[currentLanguage];
                }
                if (currentField) {
                    const btn = document.querySelector(`button[data-field="${currentField}"]`);
                    if (btn) btn.classList.add('listening');
                }
            };
            
            recognition.onresult = function(event) {
                const resultIndex = event.resultIndex;
                const transcript = event.results[resultIndex][0].transcript;
                const isFinal = event.results[resultIndex].isFinal;
                
                console.log('Transcript:', transcript, 'Final:', isFinal);
                
                const field = document.getElementById(currentField);
                
                if (field && isFinal) {
                    // For text fields, just set the value
                    if (field.tagName === 'TEXTAREA') {
                        field.value += (field.value ? ' ' : '') + transcript;
                    } else {
                        field.value = transcript;
                    }
                    
                    // Trigger input event for validation
                    field.dispatchEvent(new Event('input', { bubbles: true }));
                    field.dispatchEvent(new Event('change', { bubbles: true }));
                    
                    // Stop recognition after successful transcription
                    setTimeout(() => {
                        recognition.stop();
                    }, 500);
                }
            };
            
            recognition.onerror = function(event) {
                console.error('Speech recognition error:', event.error);
                document.getElementById('voiceStatus').classList.remove('active');
                if (currentField) {
                    const btn = document.querySelector(`button[data-field="${currentField}"]`);
                    if (btn) btn.classList.remove('listening');
                }
                
                // Language-specific error messages
                const errorMessages = {
                    'mr-IN': {
                        'not-allowed': '🎤 मायक्रोफोन प्रवेश नाकारला. कृपया ब्राउझर सेटिंग्जमध्ये मायक्रोफोन प्रवेशास परवानगी द्या.',
                        'no-speech': '🎤 आवाज शोधला नाही. कृपया पुन्हा बोलण्याचा प्रयत्न करा.',
                        'network': '🎤 नेटवर्क त्रुटी. कृपया आपले इंटरनेट कनेक्शन तपासा.',
                        'default': '🎤 त्रुटी: {error}. कृपया पुन्हा प्रयत्न करा.'
                    },
                    'en-US': {
                        'not-allowed': '🎤 Microphone access denied. Please allow microphone access in your browser settings.',
                        'no-speech': '🎤 No speech detected. Please try speaking again.',
                        'network': '🎤 Network error. Please check your internet connection.',
                        'default': '🎤 Error: {error}. Please try again.'
                    }
                };
                
                const msgs = errorMessages[currentLanguage] || errorMessages['en-US'];
                
                if (event.error === 'not-allowed' || event.error === 'permission-denied') {
                    alert(msgs['not-allowed']);
                } else if (event.error === 'no-speech') {
                    alert(msgs['no-speech']);
                } else if (event.error === 'network') {
                    alert(msgs['network']);
                } else if (event.error !== 'aborted') {
                    alert(msgs['default'].replace('{error}', event.error));
                }
            };
            
            recognition.onend = function() {
                console.log('Voice recognition ended');
                document.getElementById('voiceStatus').classList.remove('active');
                if (currentField) {
                    const btn = document.querySelector(`button[data-field="${currentField}"]`);
                    if (btn) btn.classList.remove('listening');
                }
            };
            
            recognition.onspeechstart = function() {
                console.log('Speech detected!');
            };
            
            recognition.onspeechend = function() {
                console.log('Speech ended');
            };
            
            // Add click event to all voice buttons
            document.querySelectorAll('.voice-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const fieldId = this.getAttribute('data-field');
                    
                    // If already listening to this field, stop
                    if (currentField === fieldId && this.classList.contains('listening')) {
                        recognition.stop();
                        return;
                    }
                    
                    // Stop any ongoing recognition
                    try {
                        recognition.stop();
                    } catch (e) {}
                    
                    // Start new recognition
                    currentField = fieldId;
                    
                    setTimeout(() => {
                        try {
                            recognition.start();
                        } catch (e) {
                            console.error('Failed to start recognition:', e);
                        }
                    }, 100);
                });
            });
        } else {
            // Show not supported message
            document.getElementById('voiceNotSupported').classList.add('show');
            // Hide all voice buttons
            document.querySelectorAll('.voice-btn').forEach(btn => {
                btn.style.display = 'none';
            });
            // Hide language toggle
            const langToggle = document.getElementById('langToggleContainer');
            if (langToggle) langToggle.style.display = 'none';
        }
    
        // Set today's date as default
        document.getElementById('date').valueAsDate = new Date();
        
        // Validation rules for text fields to support Marathi
        const validationRules = {
            vendorName: {
                pattern: /^[a-zA-Z\u0900-\u097F\s.&,-]{0,100}$/,
                message: 'Vendor name can contain letters, spaces, and basic punctuation only'
            },
            areaSizeQuantity: {
                pattern: /^[a-zA-Z\u0900-\u097F\s0-9.×xXम²\/\-]+$/,
                message: 'Area/Size/Quantity can contain letters, numbers, spaces, and measurement units'
            },
            description: {
                pattern: /^[a-zA-Z\u0900-\u097F\s0-9.,;:()\-&'"!?]+$/,
                message: 'Description contains invalid characters'
            },
            remarks: {
                pattern: /^[a-zA-Z\u0900-\u097F\s0-9.,;:()\-&'"!?]*$/,
                message: 'Remarks contains invalid characters'
            }
        };
        
        // Validate field
        function validateField(field) {
            const fieldId = field.id;
            const fieldValue = field.value.trim();
            
            if (validationRules[fieldId] && fieldValue) {
                const rule = validationRules[fieldId];
                if (rule.pattern && !rule.pattern.test(fieldValue)) {
                    field.style.borderColor = '#e74c3c';
                    alert(rule.message);
                    return false;
                } else {
                    field.style.borderColor = '#27ae60';
                }
            }
            return true;
        }
        
        // Add validation listeners
        ['vendorName', 'areaSizeQuantity', 'description', 'remarks'].forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (field) {
                field.addEventListener('blur', function() {
                    validateField(this);
                });
                field.addEventListener('input', function() {
                    this.style.borderColor = '';
                });
            }
        });
        
        // Auto-calculate Total Amount based on Area/Size/Quantity and Rate
        function calculateTotalAmount() {
            const areaField = document.getElementById('areaSizeQuantity');
            const rateField = document.getElementById('rate');
            const amountField = document.getElementById('amount');
            
            if (areaField && rateField && amountField) {
                const areaValue = areaField.value.trim();
                const rateValue = parseFloat(rateField.value);
                
                // Extract numeric value from area/size/quantity field
                const areaMatch = areaValue.match(/[\d.]+/);
                const areaNumeric = areaMatch ? parseFloat(areaMatch[0]) : 0;
                
                if (areaNumeric > 0 && rateValue > 0) {
                    const totalAmount = (areaNumeric * rateValue).toFixed(2);
                    amountField.value = totalAmount;
                    amountField.style.backgroundColor = '#e8f5e9';
                    
                    // Check expense limit immediately after calculation
                    checkExpenseLimitOnAmount();
                } else {
                    // If either field is empty, make amount field editable
                    if (!areaValue && !rateValue) {
                        amountField.readOnly = false;
                        amountField.style.backgroundColor = '#ffffff';
                    }
                }
            }
        }
        
        // Check expense limit when amount is entered/calculated
        function checkExpenseLimitOnAmount() {
            const amountField = document.getElementById('amount');
            const amountValue = parseFloat(amountField.value);
            
            if (!amountValue || amountValue <= 0) {
                return;
            }
            
            // Fetch current expense statistics
            fetch('<%=request.getContextPath()%>/getFundStatistics')
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        return;
                    }
                    
                    const remainingFunds = parseFloat(data.remainingFunds);
                    const totalFunds = parseFloat(data.totalFunds);
                    const usagePercentage = parseFloat(data.usagePercentage);
                    
                    // Check if this expense will exceed the limit
                    if (amountValue > remainingFunds) {
                        const exceededBy = (amountValue - remainingFunds).toFixed(2);
                        amountField.style.backgroundColor = '#fee2e2';
                        amountField.style.borderColor = '#dc2626';
                        
                        // Show inline error message
                        var errorMsg = '\u26A0\uFE0F Amount exceeds remaining limit by \u20B9' + exceededBy + '. Remaining: \u20B9' + remainingFunds.toFixed(2);
                        showAmountError(errorMsg);
                    } else if ((usagePercentage + ((amountValue/totalFunds) * 100)) >= 90) {
                        amountField.style.backgroundColor = '#fef3c7';
                        amountField.style.borderColor = '#f59e0b';
                        
                        const newPercentage = (usagePercentage + ((amountValue/totalFunds) * 100)).toFixed(2);
                        var warningMsg = '\u26A0\uFE0F Warning: This expense will bring usage to ' + newPercentage + '%';
                        showAmountError(warningMsg, 'warning');
                    } else {
                        amountField.style.backgroundColor = '#e8f5e9';
                        amountField.style.borderColor = '';
                        hideAmountError();
                    }
                })
                .catch(error => console.error('Error checking expense limit:', error));
        }
        
        // Show inline error message below amount field
        function showAmountError(message, type) {
            if (typeof type == 'undefined') type = 'error';
            hideAmountError(); // Remove any existing error
            
            const amountField = document.getElementById('amount');
            const errorDiv = document.createElement('div');
            errorDiv.id = 'amountLimitError';
            
            var styleText = 'margin-top: 8px; padding: 10px 15px; border-radius: 6px; font-size: 13px; font-weight: 600;';
            if (type == 'error') {
                styleText += ' background: #fee2e2; color: #991b1b; border: 1px solid #dc2626;';
            } else {
                styleText += ' background: #fef3c7; color: #78350f; border: 1px solid #f59e0b;';
            }
            
            errorDiv.style.cssText = styleText;
            errorDiv.textContent = message;
            
            amountField.parentElement.appendChild(errorDiv);
        }
        
        // Hide inline error message
        function hideAmountError() {
            const errorDiv = document.getElementById('amountLimitError');
            if (errorDiv) {
                errorDiv.remove();
            }
        }
        
        // Add event listeners for auto-calculation
        const areaField = document.getElementById('areaSizeQuantity');
        const rateField = document.getElementById('rate');
        const amountField = document.getElementById('amount');
        
        if (areaField && rateField && amountField) {
            // Make amount readonly initially only if no previous value
            if (!amountField.value) {
                amountField.readOnly = true;
                amountField.style.backgroundColor = '#f0f0f0';
            }
            
            // Add input listeners
            areaField.addEventListener('input', calculateTotalAmount);
            rateField.addEventListener('input', calculateTotalAmount);
            
            // Add blur listener to amount field for manual entry validation
            amountField.addEventListener('blur', function() {
                if (this.value) {
                    checkExpenseLimitOnAmount();
                }
            });
            
            // Add input listener to amount field to clear error on change
            amountField.addEventListener('input', function() {
                if (this.value) {
                    hideAmountError();
                }
            });
            
            // Allow manual entry if both fields are empty
            areaField.addEventListener('blur', function() {
                if (!this.value.trim() && !rateField.value) {
                    amountField.readOnly = false;
                    amountField.style.backgroundColor = '#ffffff';
                }
            });
            
            rateField.addEventListener('blur', function() {
                if (!this.value && !areaField.value.trim()) {
                    amountField.readOnly = false;
                    amountField.style.backgroundColor = '#ffffff';
                }
            });
            
            // Check on page load if amount already has value
            if (amountField.value) {
                checkExpenseLimitOnAmount();
            }
        }
        
        // Auto-hide success/error messages after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert:not(#fundAlertBox)');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
        
        // Load fund statistics
        function loadFundStatistics() {
            fetch('<%=request.getContextPath()%>/getFundStatistics')
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        return;
                    }
                    
                    if (data.hasAlert) {
                        displayFundAlert(data);
                    }
                })
                .catch(error => console.error('Error:', error));
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
                    '<span style="font-size: 20px;">' + icon + '</span>' +
                    '<span>' + title + '</span>' +
                '</div>' +
                '<div class="fund-alert-details">' +
                    '<strong><%= candidate.getCandidateName() %></strong> has used <strong>' + stats.usagePercentage.toFixed(2) + '%</strong> of expense limit.' +
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
        
        // Load on page load
        loadFundStatistics();
        
        // Form validation before submission
        function validateExpenseForm(event) {
            <% if (needsExpenseLimit) { %>
                event.preventDefault();
                return false;
            <% } %>
            
            const amountField = document.getElementById('amount');
            const amountValue = parseFloat(amountField.value);
            
            if (!amountValue || amountValue <= 0) {
                alert('Please enter a valid amount');
                event.preventDefault();
                return false;
            }
            
            // Check if there's an error message displayed
            const errorDiv = document.getElementById('amountLimitError');
            if (errorDiv && errorDiv.textContent.includes('exceeds remaining limit')) {
                const confirmSubmit = confirm('⚠️ This expense exceeds the remaining limit. Do you still want to submit?');
                if (!confirmSubmit) {
                    event.preventDefault();
                    return false;
                }
            }
            
            return true;
        }
    </script>


    <script>
        // Delete expense function
        function deleteExpense() {
            if(confirm('<%= MessageBundle.getMessage(request, "confirm.delete.expense") %>')) {
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
    </script>
</body>
</html>


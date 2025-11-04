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
                    <strong>Cannot Add Expense:</strong> Expense limit is not set for <%= candidate.getCandidateName() %>. 
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
            <form action="<%=request.getContextPath()%>/expense" method="post" onsubmit="return <%= !needsExpenseLimit %>">
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
                                <option value="Online Transfer"><%= MessageBundle.getMessage(request, "expense.payment.mode.online") %></option>
                                <option value="Cheque"><%= MessageBundle.getMessage(request, "expense.payment.mode.cheque") %></option>
                                <option value="UPI"><%= MessageBundle.getMessage(request, "expense.payment.mode.upi") %></option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="vendorName"><%= MessageBundle.getMessage(request, "expense.vendor.name") %></label>
                            <div class="input-wrapper">
                                <input type="text" id="vendorName" name="vendorName" class="form-control form-control-voice">
                                <button type="button" class="voice-btn" data-field="vendorName" title="Voice Input">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                        <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                        <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="receiptNumber"><%= MessageBundle.getMessage(request, "expense.receipt") %> <%= MessageBundle.getMessage(request, "table.id") %></label>
                            <div class="input-wrapper">
                                <input type="text" id="receiptNumber" name="receiptNumber" class="form-control form-control-voice">
                                <button type="button" class="voice-btn" data-field="receiptNumber" title="Voice Input">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                        <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
                                        <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description"><%= MessageBundle.getMessage(request, "expense.description") %> *</label>
                        <div class="input-wrapper">
                            <textarea id="description" name="description" class="form-control form-control-voice" rows="3" required></textarea>
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
                            <textarea id="remarks" name="remarks" class="form-control form-control-voice" rows="2"></textarea>
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
                    <button type="submit" class="btn btn-primary">💰 <%= MessageBundle.getMessage(request, "expense.submit") %></button>
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
        <span>Listening...</span>
    </div>
    
    <script>
        // Voice Recognition Setup
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        let recognition = null;
        let currentField = null;
        
        if (SpeechRecognition) {
            recognition = new SpeechRecognition();
            recognition.continuous = true;
            recognition.interimResults = true;
            recognition.lang = 'en-US';
            recognition.maxAlternatives = 1;
            
            recognition.onstart = function() {
                console.log('Voice recognition started for field:', currentField);
                document.getElementById('voiceStatus').classList.add('active');
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
                
                if (event.error === 'not-allowed' || event.error === 'permission-denied') {
                    alert('🎤 Microphone access denied. Please allow microphone access in your browser settings.');
                } else if (event.error === 'no-speech') {
                    alert('🎤 No speech detected. Please try speaking again.');
                } else if (event.error === 'network') {
                    alert('🎤 Network error. Please check your internet connection.');
                } else if (event.error !== 'aborted') {
                    alert('🎤 Error: ' + event.error + '. Please try again.');
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
        }
    
        // Set today's date as default
        document.getElementById('date').valueAsDate = new Date();
        
        // Validation rules for text fields to support Marathi
        const validationRules = {
            vendorName: {
                pattern: /^[a-zA-Z\u0900-\u097F\s.&,-]{0,100}$/,
                message: 'Vendor name can contain letters, spaces, and basic punctuation only'
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
        ['vendorName', 'description', 'remarks'].forEach(fieldId => {
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
    </script>
</body>
</html>

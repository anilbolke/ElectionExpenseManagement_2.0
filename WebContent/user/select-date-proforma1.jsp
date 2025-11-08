<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String candidateIdStr = request.getParameter("candidateId");
    if(candidateIdStr == null) {
        response.sendRedirect("manage-candidates.jsp?error=Invalid candidate");
        return;
    }
    
    int candidateId = Integer.parseInt(candidateIdStr);
    CandidateDAO candidateDAO = new CandidateDAO();
    Candidate candidate = candidateDAO.getCandidateById(candidateId);
    
    if(candidate == null || candidate.getUserId() != user.getUserId()) {
        response.sendRedirect("manage-candidates.jsp?error=Candidate not found");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proforma-1 Date Selection - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 40px;
            max-width: 600px;
            width: 100%;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #2d3748;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #718096;
            font-size: 16px;
        }
        
        .candidate-info {
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .candidate-info h3 {
            color: #2d3748;
            font-size: 18px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #718096;
            font-weight: 500;
        }
        
        .info-value {
            color: #2d3748;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 15px;
        }
        
        .form-group input[type="date"] {
            width: 100%;
            padding: 14px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s;
        }
        
        .form-group input[type="date"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .helper-text {
            color: #718096;
            font-size: 13px;
            margin-top: 8px;
        }
        
        .alert-info {
            background: #ebf8ff;
            border: 1px solid #bee3f8;
            color: #2c5282;
            padding: 14px 18px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 25px;
        }
        
        .buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 14px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        @media (max-width: 640px) {
            .container {
                padding: 25px;
            }
            
            .header h1 {
                font-size: 24px;
            }
            
            .buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📅 Proforma-1 Date Selection</h1>
            <p>Select date to generate expense report<br>दिनांक निवडा खर्च अहवाल तयार करण्यासाठी</p>
        </div>
        
        <div class="candidate-info">
            <h3>👤 Candidate Information</h3>
            <div class="info-row">
                <span class="info-label">Candidate Name:</span>
                <span class="info-value"><%= candidate.getCandidateName() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Nomination ID:</span>
                <span class="info-value"><%= candidate.getNominationId() != null ? candidate.getNominationId() : "N/A" %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Constituency:</span>
                <span class="info-value"><%= candidate.getConstituency() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Party:</span>
                <span class="info-value"><%= candidate.getPartyName() != null ? candidate.getPartyName() : "Independent" %></span>
            </div>
        </div>
        
        <div class="alert-info">
            <strong>ℹ️ About Proforma-1:</strong> This report will show all expenses incurred on the selected date. 
            You can generate multiple reports for different dates.
        </div>
        
        <form action="<%=request.getContextPath()%>/generateProforma1" method="GET" id="dateForm">
            <input type="hidden" name="candidateId" value="<%= candidateId %>">
            
            <div class="form-group">
                <label for="expenseDate">
                    Select Expense Date / खर्चाची तारीख निवडा
                    <span style="color: #e53e3e;">*</span>
                </label>
                <input type="date" 
                       id="expenseDate" 
                       name="expenseDate" 
                       required
                       max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                <div class="helper-text">
                    Select the date for which you want to generate the expense report
                </div>
            </div>
            
            <div class="buttons">
                <a href="dashboard.jsp" class="btn btn-secondary">
                    ← Back to Dashboard
                </a>
                <button type="submit" class="btn btn-primary">
                    📄 Generate Proforma-1
                </button>
            </div>
        </form>
    </div>
    
    <script>
        // Set max date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('expenseDate').setAttribute('max', today);
        
        // Form validation and popup opening
        document.getElementById('dateForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const dateInput = document.getElementById('expenseDate');
            
            if (!dateInput.value) {
                alert('⚠️ Please select a date\nकृपया तारीख निवडा');
                dateInput.focus();
                return false;
            }
            
            // Check if date is not in future
            const selectedDate = new Date(dateInput.value);
            const todayDate = new Date(today);
            
            if (selectedDate > todayDate) {
                alert('⚠️ Future date not allowed\nभविष्याची तारीख अनुमत नाही');
                dateInput.focus();
                return false;
            }
            
            // Open report in modal (if in iframe) or new window (if standalone)
            const candidateId = document.querySelector('input[name="candidateId"]').value;
            const expenseDate = dateInput.value;
            const url = '<%=request.getContextPath()%>/generateProforma1?candidateId=' + candidateId + '&expenseDate=' + expenseDate;
            
            // Check if we're in an iframe (modal)
            if (window.parent !== window) {
                // We're in iframe, open report in parent modal
                window.parent.postMessage({
                    action: 'openProforma',
                    url: url,
                    title: 'Proforma-1 Report'
                }, '*');
            } else {
                // We're standalone, open in new modal
                if (typeof openModalPopup === 'function') {
                    openModalPopup(url, 'Proforma-1 Report');
                } else {
                    // Fallback to direct navigation
                    window.location.href = url;
                }
            }
        });
    </script>
    
    <!-- Footer with emsonline.in URL -->
    <div style="position: fixed; bottom: 0; left: 0; right: 0; background: rgba(255,255,255,0.95); padding: 10px; text-align: center; font-size: 12px; color: #666; border-top: 1px solid #e2e8f0; box-shadow: 0 -2px 10px rgba(0,0,0,0.1); z-index: 1000;">
        <span style="font-weight: 600;">Powered by</span> 
        <a href="https://emsonline.in" target="_blank" style="color: #667eea; text-decoration: none; font-weight: 700; margin-left: 5px;">emsonline.in</a>
    </div>
</body>
</html>

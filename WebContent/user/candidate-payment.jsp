<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO, com.election.dao.SystemSettingsDAO" %>
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
    
    // Check if already paid
    if("active".equals(candidate.getAccountStatus()) && candidate.isPaymentVerified()) {
        response.sendRedirect("manage-candidates.jsp?message=Payment already completed");
        return;
    }
    
    // Get registration fee from database
    SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
    double registrationFee = settingsDAO.getSettingAsDouble("candidate_registration_fee", 5000.00);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Registration Payment - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .payment-container {
            max-width: 800px;
            margin: 80px auto 50px;
            padding: 0 20px;
        }
        
        .payment-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .payment-icon {
            font-size: 64px;
            margin-bottom: 15px;
        }
        
        .candidate-details {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        
        .detail-value {
            color: #333;
        }
        
        .amount-section {
            background: #e7f3ff;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .amount-label {
            font-size: 16px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .amount-value {
            font-size: 36px;
            font-weight: bold;
            color: #007bff;
        }
        
        .payment-methods {
            margin-bottom: 30px;
        }
        
        .payment-method {
            border: 2px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-method:hover {
            border-color: #007bff;
            background: #f8f9fa;
        }
        
        .payment-method.selected {
            border-color: #007bff;
            background: #e7f3ff;
        }
        
        .payment-method input[type="radio"] {
            margin-right: 10px;
        }
        
        .payment-method-label {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .payment-method-icon {
            font-size: 24px;
            margin-right: 10px;
        }
        
        .payment-method-info {
            flex: 1;
        }
        
        .payment-method-name {
            font-weight: 600;
            color: #333;
        }
        
        .payment-method-desc {
            font-size: 12px;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
            }
            
            .detail-label {
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body class="dashboard">
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ Election Expense</div>
            <ul class="navbar-menu">
                <li><a href="manage-candidates.jsp">My Candidates</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span><%= user.getFullName() %></span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="payment-container">
        <div class="payment-card">
            <div class="payment-header">
                <div class="payment-icon">💳</div>
                <h2>Candidate Registration Payment</h2>
                <p>Complete the payment to activate candidate account</p>
            </div>
            
            <div class="candidate-details">
                <h4 style="margin-bottom: 15px;">Candidate Details</h4>
                <div class="detail-row">
                    <span class="detail-label">Candidate Name:</span>
                    <span class="detail-value"><%= candidate.getCandidateName() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Constituency:</span>
                    <span class="detail-value"><%= candidate.getConstituency() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Party:</span>
                    <span class="detail-value"><%= candidate.getPartyName() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Election Type:</span>
                    <span class="detail-value"><%= candidate.getElectionType() %></span>
                </div>
            </div>
            
            <div class="amount-section">
                <div class="amount-label">Registration Fee</div>
                <div class="amount-value">₹<%= String.format("%.2f", registrationFee) %></div>
            </div>
            
            <form action="<%=request.getContextPath()%>/candidate" method="post" id="paymentForm">
                <input type="hidden" name="action" value="processPayment">
                <input type="hidden" name="candidateId" value="<%= candidateId %>">
                <input type="hidden" name="amount" value="<%= registrationFee %>">
                
                <div class="payment-methods">
                    <h4 style="margin-bottom: 20px;">Select Payment Method</h4>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('upi')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="upi" required>
                            <span class="payment-method-icon">📱</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">UPI Payment</div>
                                <div class="payment-method-desc">Pay using Google Pay, PhonePe, Paytm, etc.</div>
                            </div>
                        </label>
                    </div>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('card')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="card" required>
                            <span class="payment-method-icon">💳</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">Credit/Debit Card</div>
                                <div class="payment-method-desc">Pay using your Visa, Mastercard, or Rupay card</div>
                            </div>
                        </label>
                    </div>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('netbanking')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="netbanking" required>
                            <span class="payment-method-icon">🏦</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">Net Banking</div>
                                <div class="payment-method-desc">Pay directly from your bank account</div>
                            </div>
                        </label>
                    </div>
                    
                    <div class="payment-method" onclick="selectPaymentMethod('wallet')">
                        <label class="payment-method-label">
                            <input type="radio" name="paymentMethod" value="wallet" required>
                            <span class="payment-method-icon">👛</span>
                            <div class="payment-method-info">
                                <div class="payment-method-name">Wallet</div>
                                <div class="payment-method-desc">Pay using Paytm Wallet, MobiKwik, etc.</div>
                            </div>
                        </label>
                    </div>
                </div>
                
                <div class="alert alert-info" style="margin-bottom: 20px;">
                    <strong>📌 Important:</strong> Your candidate account will be activated immediately after successful payment. 
                    You will receive a confirmation email with the transaction details.
                </div>
                
                <div style="display: flex; gap: 15px; justify-content: space-between;">
                    <a href="manage-candidates.jsp" class="btn btn-secondary" style="flex: 1;">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="flex: 2;">Proceed to Pay ₹<%= String.format("%.2f", registrationFee) %></button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function selectPaymentMethod(method) {
            // Remove selected class from all methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked method
            event.currentTarget.classList.add('selected');
            
            // Check the radio button
            document.querySelector(`input[value="${method}"]`).checked = true;
        }
    </script>
</body>
</html>

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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .payment-container {
            flex: 1;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px 40px;
            width: 100%;
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
        
        .alert-info {
            background: #ebf8ff;
            border: 1px solid #bee3f8;
            color: #2c5282;
            padding: 14px 18px;
            border-radius: 8px;
            font-size: 14px;
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
<body>
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>
    
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
                    <span class="detail-value"><%= candidate.getCandidateName() %><% if(candidate.getNominationId() != null && !candidate.getNominationId().trim().isEmpty()) { %> - <strong><%= candidate.getNominationId() %></strong><% } %></span>
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
    
    <footer>
        <p>&copy; 2024 <%= MessageBundle.getMessage(request, "app.title") %>. <%= MessageBundle.getMessage(request, "footer.rights") %></p>
    </footer>
    
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

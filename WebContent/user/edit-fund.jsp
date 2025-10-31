<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate, com.election.model.FundDetail" %>
<%@ page import="com.election.dao.FundDetailDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Check if a candidate is selected
    Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
    if(selectedCandidate == null) {
        response.sendRedirect("dashboard.jsp?error=Please select a candidate first");
        return;
    }
    
    // Get fund ID from parameter
    String fundIdParam = request.getParameter("fundId");
    if(fundIdParam == null || fundIdParam.isEmpty()) {
        response.sendRedirect("manage-funds.jsp?error=Invalid fund ID");
        return;
    }
    
    int fundId = Integer.parseInt(fundIdParam);
    FundDetailDAO fundDetailDAO = new FundDetailDAO();
    FundDetail fund = fundDetailDAO.getFundDetailById(fundId);
    
    // Verify fund exists and belongs to the selected candidate
    if(fund == null) {
        response.sendRedirect("manage-funds.jsp?error=Fund not found");
        return;
    }
    
    if(fund.getCandidateId() != selectedCandidate.getCandidateId()) {
        response.sendRedirect("manage-funds.jsp?error=Unauthorized access");
        return;
    }
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Fund Details - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        body.dashboard {
            background: #f5f7fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        
        .main-container {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
            margin-left: 0;
        }
        
        .form-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-title {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 10px;
        }
        
        .form-subtitle {
            color: #718096;
            margin-bottom: 30px;
        }
        
        .alert {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-danger {
            background: #fff5f5;
            border-left: 4px solid #f56565;
            color: #c53030;
        }
        
        .alert-success {
            background: #f0fff4;
            border-left: 4px solid #48bb78;
            color: #2f855a;
        }
        
        .alert-info {
            background: #ebf8ff;
            border-left: 4px solid #4299e1;
            color: #2c5282;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .required {
            color: #f56565;
        }
        
        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
            font-family: inherit;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-input.error, .form-select.error {
            border-color: #dc3545;
            background-color: #fff5f5;
        }
        
        .form-input.success, .form-select.success {
            border-color: #28a745;
            background-color: #f0fff4;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .error-message:before {
            content: "⚠️";
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
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
    </style>
</head>
<body class="dashboard">
    <%@ include file="../includes/user-navbar.jsp" %>
    
    <div class="main-container">
        <main class="main-content">
            <div class="form-container">
                <h1 class="form-title">✏️ Edit Fund Details</h1>
                <p class="form-subtitle">Update fund information for <%= selectedCandidate.getCandidateName() %></p>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <strong>Error!</strong> <%= error %>
                    </div>
                <% } %>
                
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <strong>Success!</strong> <%= success %>
                    </div>
                <% } %>
                
                <div class="alert alert-info">
                    <strong>📌 Selected Candidate:</strong> <%= selectedCandidate.getCandidateName() %>
                    <% if(selectedCandidate.getNominationId() != null && !selectedCandidate.getNominationId().trim().isEmpty()) { %>
                        - <%= selectedCandidate.getNominationId() %>
                    <% } %>
                    | <%= selectedCandidate.getConstituency() %>
                </div>
                
                <form action="<%=request.getContextPath()%>/fundDetail?action=update" method="post" id="fundForm">
                    <!-- Hidden field for fund ID -->
                    <input type="hidden" name="fundId" value="<%= fund.getFundId() %>">
                    <input type="hidden" name="candidateId" value="<%= selectedCandidate.getCandidateId() %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date <span class="required">*</span></label>
                            <input type="date" name="fundDate" id="fundDate" class="form-input" required 
                                   value="<%= fund.getFundDate() %>">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Fund Type <span class="required">*</span></label>
                            <select name="fundType" id="fundType" class="form-select" required>
                                <option value="">-- Select Type --</option>
                                <option value="Cash in Hand" <%= "Cash in Hand".equals(fund.getFundType()) ? "selected" : "" %>>💵 Cash in Hand</option>
                                <option value="Bank Balance" <%= "Bank Balance".equals(fund.getFundType()) ? "selected" : "" %>>🏦 Bank Balance</option>
                                <option value="Hand Loan" <%= "Hand Loan".equals(fund.getFundType()) ? "selected" : "" %>>🤝 Hand Loan</option>
                                <option value="Donation" <%= "Donation".equals(fund.getFundType()) ? "selected" : "" %>>🎁 Donation</option>
                                <option value="Other" <%= "Other".equals(fund.getFundType()) ? "selected" : "" %>>📋 Other</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Amount (₹) <span class="required">*</span></label>
                        <input type="number" name="amount" id="amount" class="form-input" 
                               placeholder="Enter amount" required min="1" step="0.01"
                               value="<%= fund.getAmount() %>">
                        <small style="color: #666; font-size: 11px; display: block; margin-top: 5px;">
                            💵 Enter amount greater than zero (e.g., 5000.00)
                        </small>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Funder Name <span class="required">*</span></label>
                            <input type="text" name="funderName" id="funderName" class="form-input" 
                                   placeholder="Enter funder name" required pattern="[a-zA-Z\s.]{2,100}"
                                   title="Name should contain only letters and spaces (2-100 characters)"
                                   value="<%= fund.getFunderName() %>">
                            <small style="color: #666; font-size: 11px; display: block; margin-top: 5px;">
                                📝 Only letters, spaces, and dots allowed (2-100 characters)
                            </small>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Funder Mobile <span class="required">*</span></label>
                            <input type="tel" name="funderMobile" id="funderMobile" class="form-input" 
                                   placeholder="Enter 10-digit mobile number" required pattern="[6-9][0-9]{9}"
                                   title="Please enter a valid 10-digit mobile number starting with 6-9" maxlength="10"
                                   value="<%= fund.getFunderMobile() %>">
                            <small style="color: #666; font-size: 11px; display: block; margin-top: 5px;">
                                📱 10-digit number starting with 6, 7, 8, or 9
                            </small>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Description (Optional)</label>
                        <textarea name="description" id="description" class="form-textarea" 
                                  placeholder="Enter any additional notes or description"><%= fund.getDescription() != null ? fund.getDescription() : "" %></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <a href="manage-funds.jsp" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">💾 Update Fund Details</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <footer style="background: #2d3748; color: #e2e8f0; padding: 20px; text-align: center; margin-top: 50px;">
        <p>&copy; 2024 Election Expense Management. All rights reserved.</p>
    </footer>
    
    <script>
        // Validation helper functions
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            field.style.borderColor = '#dc3545';
            field.style.backgroundColor = '#fff5f5';
        }
        
        function showSuccess(fieldId) {
            const field = document.getElementById(fieldId);
            field.style.borderColor = '#28a745';
            field.style.backgroundColor = '#f0fff4';
        }
        
        function clearValidation(fieldId) {
            const field = document.getElementById(fieldId);
            field.style.borderColor = '#e2e8f0';
            field.style.backgroundColor = 'white';
        }
        
        // Real-time validation
        // Date validation
        document.getElementById('fundDate').addEventListener('change', function() {
            if (!this.value) {
                showError('fundDate', 'Date is required');
            } else {
                showSuccess('fundDate');
            }
        });
        
        // Fund type validation
        document.getElementById('fundType').addEventListener('change', function() {
            if (this.value) {
                showSuccess('fundType');
            } else {
                showError('fundType', 'Please select a fund type');
            }
        });
        
        // Amount validation
        document.getElementById('amount').addEventListener('input', function() {
            const value = parseFloat(this.value);
            
            if (!this.value || this.value.trim() === '') {
                showError('amount', 'Amount is required');
            } else if (isNaN(value) || value <= 0) {
                showError('amount', 'Amount must be greater than zero');
            } else if (value > 999999999.99) {
                showError('amount', 'Amount is too large');
            } else {
                showSuccess('amount');
            }
        });
        
        // Format amount on blur
        document.getElementById('amount').addEventListener('blur', function() {
            if (this.value && !isNaN(this.value)) {
                const value = parseFloat(this.value);
                if (value > 0) {
                    this.value = value.toFixed(2);
                }
            }
        });
        
        // Funder name validation
        document.getElementById('funderName').addEventListener('input', function() {
            // Remove invalid characters
            this.value = this.value.replace(/[^a-zA-Z\s.]/g, '');
            
            const value = this.value.trim();
            if (!value) {
                showError('funderName', 'Funder name is required');
            } else if (value.length < 2) {
                showError('funderName', 'Name must be at least 2 characters');
            } else if (value.length > 100) {
                showError('funderName', 'Name must not exceed 100 characters');
            } else {
                showSuccess('funderName');
            }
        });
        
        // Mobile validation
        document.getElementById('funderMobile').addEventListener('input', function() {
            // Remove non-digits
            this.value = this.value.replace(/\D/g, '');
            
            // Limit to 10 digits
            if (this.value.length > 10) {
                this.value = this.value.substring(0, 10);
            }
            
            const value = this.value;
            if (!value) {
                showError('funderMobile', 'Mobile number is required');
            } else if (value.length !== 10) {
                showError('funderMobile', 'Mobile number must be 10 digits');
            } else if (!/^[6-9]/.test(value)) {
                showError('funderMobile', 'Mobile number must start with 6, 7, 8, or 9');
            } else {
                showSuccess('funderMobile');
            }
        });
        
        // Form submission validation
        document.getElementById('fundForm').addEventListener('submit', function(e) {
            let isValid = true;
            const errors = [];
            
            // Validate date
            const fundDate = document.getElementById('fundDate').value;
            if (!fundDate) {
                showError('fundDate', 'Date is required');
                errors.push('Date is required');
                isValid = false;
            }
            
            // Validate fund type
            const fundType = document.getElementById('fundType').value;
            if (!fundType) {
                showError('fundType', 'Please select a fund type');
                errors.push('Fund type is required');
                isValid = false;
            }
            
            // Validate amount
            const amount = parseFloat(document.getElementById('amount').value);
            if (!document.getElementById('amount').value || isNaN(amount) || amount <= 0) {
                showError('amount', 'Amount must be greater than zero');
                errors.push('Valid amount is required');
                isValid = false;
            }
            
            // Validate funder name
            const funderName = document.getElementById('funderName').value.trim();
            if (!funderName || funderName.length < 2) {
                showError('funderName', 'Funder name is required (min 2 characters)');
                errors.push('Funder name is required');
                isValid = false;
            }
            
            // Validate mobile
            const mobile = document.getElementById('funderMobile').value;
            if (!mobile || mobile.length !== 10 || !/^[6-9]/.test(mobile)) {
                showError('funderMobile', 'Valid 10-digit mobile number is required');
                errors.push('Valid mobile number is required');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
                alert('❌ Please fix the following errors:\n\n' + errors.join('\n'));
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.textContent = '⏳ Updating...';
            
            return true;
        });
    </script>
</body>
</html>

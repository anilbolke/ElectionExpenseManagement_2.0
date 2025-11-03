<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Check if a candidate is selected
    Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
    if(selectedCandidate == null) {
        response.sendRedirect("dashboard.jsp?error=Please select a candidate first to add fund details");
        return;
    }
    
    CandidateDAO candidateDAO = new CandidateDAO();
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Fund Details - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        body.dashboard {
            background: #f5f7fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .main-content {
            width: 100%;
        }
        
        .form-container {
            max-width: 800px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-title {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }
        
        .form-subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-label .required {
            color: #dc3545;
        }
        
        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s;
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
        
        .form-input:invalid {
            border-color: #ffc107;
        }
        
        .form-group.has-error .form-label {
            color: #dc3545;
        }
        
        .form-group.has-success .form-label {
            color: #28a745;
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            flex: 1;
            text-align: center;
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
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body class="dashboard">
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>
    
    <div class="main-container">
        <main class="main-content">
            <div class="form-container">
                <h1 class="form-title">💰 Add Fund Details</h1>
                <p class="form-subtitle">Add financial details for your candidate</p>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <strong>Error!</strong> <%= error %>
                    </div>
                <% } %>
                
                <div class="alert alert-info">
                    <strong>📌 Selected Candidate:</strong> <%= selectedCandidate.getCandidateName() %> 
                    <% if(selectedCandidate.getNominationId() != null && !selectedCandidate.getNominationId().trim().isEmpty()) { %>
                        - <%= selectedCandidate.getNominationId() %>
                    <% } %>
                    | <%= selectedCandidate.getConstituency() %>
                </div>
                
                <form action="<%=request.getContextPath()%>/fundDetail?action=add" method="post" id="fundForm">
                    <!-- Hidden field for selected candidate -->
                    <input type="hidden" name="candidateId" id="candidateId" value="<%= selectedCandidate.getCandidateId() %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date <span class="required">*</span></label>
                            <input type="date" name="fundDate" id="fundDate" class="form-input" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Fund Type <span class="required">*</span></label>
                            <select name="fundType" id="fundType" class="form-select" required>
                                <option value="">-- Select Fund Type --</option>
                                <option value="Cash in Hand">💵 Cash in Hand</option>
                                <option value="Bank Balance">🏦 Bank Balance</option>
                                <option value="Hand Loan">🤝 Hand Loan</option>
                                <option value="Donation">🎁 Donation</option>
                                <option value="Other">📋 Other</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Amount (₹) <span class="required">*</span></label>
                        <input type="number" name="amount" id="amount" class="form-input" 
                               placeholder="Enter amount" required min="1" step="0.01">
                        <small style="color: #666; font-size: 11px; display: block; margin-top: 5px;">
                            💵 Enter amount greater than zero (e.g., 5000.00)
                        </small>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Funder Name <span class="required">*</span></label>
                            <input type="text" name="funderName" id="funderName" class="form-input" 
                                   placeholder="Enter funder name" required pattern="[a-zA-Z\s.]{2,100}"
                                   title="Name should contain only letters and spaces (2-100 characters)">
                            <small style="color: #666; font-size: 11px; display: block; margin-top: 5px;">
                                📝 Only letters, spaces, and dots allowed (2-100 characters)
                            </small>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Funder Mobile <span class="required">*</span></label>
                            <input type="tel" name="funderMobile" id="funderMobile" class="form-input" 
                                   placeholder="Enter 10-digit mobile number" required pattern="[6-9][0-9]{9}"
                                   title="Please enter a valid 10-digit mobile number starting with 6-9" maxlength="10">
                            <small style="color: #666; font-size: 11px; display: block; margin-top: 5px;">
                                📱 10-digit number starting with 6, 7, 8, or 9
                            </small>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Description (Optional)</label>
                        <textarea name="description" id="description" class="form-textarea" 
                                  placeholder="Enter additional details about this fund..."></textarea>
                    </div>
                    
                    <div class="alert alert-info">
                        <strong>💡 Note:</strong> All fields marked with <span class="required">*</span> are mandatory. 
                        Please ensure all information is accurate.
                    </div>
                    
                    <div class="form-actions">
                        <a href="manage-funds.jsp" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">💾 Save Fund Details</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <footer style="background: #2d3748; color: #e2e8f0; padding: 20px; text-align: center; margin-top: 50px;">
        <p>&copy; 2024 Election Expense Management. All rights reserved.</p>
    </footer>
    
    <script>
        // Set today's date as default
        document.getElementById('fundDate').valueAsDate = new Date();
        
        // Validation helper functions
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            field.style.borderColor = '#dc3545';
            
            // Remove existing error message
            const existingError = field.parentElement.querySelector('.error-message');
            if (existingError) {
                existingError.remove();
            }
            
            // Add new error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.style.color = '#dc3545';
            errorDiv.style.fontSize = '12px';
            errorDiv.style.marginTop = '5px';
            errorDiv.textContent = message;
            field.parentElement.appendChild(errorDiv);
            
            field.focus();
        }
        
        function clearError(fieldId) {
            const field = document.getElementById(fieldId);
            field.style.borderColor = '#ddd';
            
            const existingError = field.parentElement.querySelector('.error-message');
            if (existingError) {
                existingError.remove();
            }
        }
        
        function showSuccess(fieldId) {
            const field = document.getElementById(fieldId);
            field.style.borderColor = '#28a745';
            clearError(fieldId);
        }
        
        // Real-time validation
        // Candidate is pre-selected from session, no need to validate
        
        document.getElementById('fundDate').addEventListener('change', function() {
            if (!this.value) {
                showError('fundDate', 'Date is required');
            } else {
                showSuccess('fundDate');
            }
        });
        
        document.getElementById('fundType').addEventListener('change', function() {
            if (this.value) {
                showSuccess('fundType');
            } else {
                showError('fundType', 'Please select a fund type');
            }
        });
        
        document.getElementById('amount').addEventListener('input', function() {
            const amount = parseFloat(this.value);
            
            if (!this.value || this.value.trim() === '') {
                showError('amount', 'Amount is required');
            } else if (isNaN(amount) || amount <= 0) {
                showError('amount', 'Amount must be greater than zero');
            } else if (amount > 999999999.99) {
                showError('amount', 'Amount is too large (max: ₹99,99,99,999.99)');
            } else {
                showSuccess('amount');
                // Format display
                this.value = amount.toFixed(2);
            }
        });
        
        document.getElementById('funderName').addEventListener('input', function() {
            const name = this.value.trim();
            
            // Remove numbers and special characters except dots and spaces
            this.value = this.value.replace(/[^a-zA-Z\s.]/g, '');
            
            if (!name) {
                showError('funderName', 'Funder name is required');
            } else if (name.length < 2) {
                showError('funderName', 'Name must be at least 2 characters');
            } else if (name.length > 100) {
                showError('funderName', 'Name must not exceed 100 characters');
                this.value = this.value.substring(0, 100);
            } else if (!/^[a-zA-Z\s.]{2,100}$/.test(name)) {
                showError('funderName', 'Name should contain only letters, spaces, and dots');
            } else {
                showSuccess('funderName');
            }
        });
        
        document.getElementById('funderMobile').addEventListener('input', function() {
            // Remove non-digits
            this.value = this.value.replace(/\D/g, '').substring(0, 10);
            
            const mobile = this.value;
            
            if (!mobile) {
                showError('funderMobile', 'Mobile number is required');
            } else if (mobile.length < 10) {
                showError('funderMobile', 'Mobile number must be 10 digits');
            } else if (!/^[6-9]/.test(mobile)) {
                showError('funderMobile', 'Mobile number must start with 6, 7, 8, or 9');
            } else if (mobile.length === 10) {
                showSuccess('funderMobile');
            }
        });
        
        // Validate mobile on blur
        document.getElementById('funderMobile').addEventListener('blur', function() {
            const mobile = this.value;
            if (mobile && !/^[6-9]\d{9}$/.test(mobile)) {
                showError('funderMobile', 'Please enter a valid 10-digit mobile number starting with 6-9');
            }
        });
        
        // Form submission validation
        document.getElementById('fundForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            let isValid = true;
            const errors = [];
            
            // Candidate is pre-selected from session
            
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
            const amount = document.getElementById('amount').value;
            if (!amount || amount.trim() === '') {
                showError('amount', 'Amount is required');
                errors.push('Amount is required');
                isValid = false;
            } else {
                const amountNum = parseFloat(amount);
                if (isNaN(amountNum) || amountNum <= 0) {
                    showError('amount', 'Amount must be greater than zero');
                    errors.push('Amount must be greater than zero');
                    isValid = false;
                } else if (amountNum > 999999999.99) {
                    showError('amount', 'Amount is too large');
                    errors.push('Amount is too large');
                    isValid = false;
                }
            }
            
            // Validate funder name
            const funderName = document.getElementById('funderName').value.trim();
            if (!funderName) {
                showError('funderName', 'Funder name is required');
                errors.push('Funder name is required');
                isValid = false;
            } else if (funderName.length < 2) {
                showError('funderName', 'Name must be at least 2 characters');
                errors.push('Name must be at least 2 characters');
                isValid = false;
            } else if (funderName.length > 100) {
                showError('funderName', 'Name must not exceed 100 characters');
                errors.push('Name must not exceed 100 characters');
                isValid = false;
            } else if (!/^[a-zA-Z\s.]{2,100}$/.test(funderName)) {
                showError('funderName', 'Name should contain only letters, spaces, and dots');
                errors.push('Invalid name format');
                isValid = false;
            }
            
            // Validate mobile
            const mobile = document.getElementById('funderMobile').value;
            if (!mobile) {
                showError('funderMobile', 'Mobile number is required');
                errors.push('Mobile number is required');
                isValid = false;
            } else if (!/^[6-9]\d{9}$/.test(mobile)) {
                showError('funderMobile', 'Please enter a valid 10-digit mobile number starting with 6-9');
                errors.push('Invalid mobile number');
                isValid = false;
            }
            
            // If validation fails, show summary alert
            if (!isValid) {
                const errorMessage = '❌ Please fix the following errors:\n\n' + errors.join('\n');
                alert(errorMessage);
                
                // Focus on first error field
                const firstErrorField = document.querySelector('.form-input[style*="border-color: rgb(220, 53, 69)"]');
                if (firstErrorField) {
                    firstErrorField.focus();
                }
                
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '⏳ Saving...';
            submitBtn.disabled = true;
            
            // Submit the form
            this.submit();
        });
        
        // Clear error on focus
        document.querySelectorAll('.form-input, .form-select').forEach(function(element) {
            element.addEventListener('focus', function() {
                clearError(this.id);
            });
        });
        
        // Prevent form submission on Enter key (except for submit button)
        document.getElementById('fundForm').addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && e.target.type !== 'submit') {
                e.preventDefault();
                return false;
            }
        });
        
        // Amount formatting on blur
        document.getElementById('amount').addEventListener('blur', function() {
            if (this.value && !isNaN(this.value)) {
                const amount = parseFloat(this.value);
                if (amount > 0) {
                    this.value = amount.toFixed(2);
                }
            }
        });
        
        // Trim text inputs on blur
        document.querySelectorAll('.form-input[type="text"]').forEach(function(input) {
            input.addEventListener('blur', function() {
                this.value = this.value.trim();
            });
        });
    </script>
</body>
</html>

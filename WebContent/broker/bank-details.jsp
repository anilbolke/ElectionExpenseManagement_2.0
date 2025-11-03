<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.dao.UserDAO" %>
<%
    User user = (User) session.getAttribute("user");
    
    if (user == null || !"broker".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get existing bank details
    UserDAO userDAO = new UserDAO();
    User bankDetails = userDAO.getBankDetails(user.getUserId());
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Details - Broker Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        /* Navigation */
        .navbar {
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar-content {
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar-brand {
            font-size: 1.2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .navbar-menu {
            display: flex;
            list-style: none;
            gap: 5px;
        }
        .navbar-menu a {
            color: #4a5568;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.2s;
            font-weight: 500;
            font-size: 13px;
        }
        .navbar-menu a:hover, .navbar-menu a.active {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 40px;
            animation: slideUp 0.4s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .card-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .card-header h1 {
            font-size: 1.8rem;
            color: #1a202c;
            margin-bottom: 10px;
        }
        .card-header p {
            color: #718096;
            font-size: 14px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2d3748;
            font-size: 14px;
        }
        .required {
            color: #e53e3e;
        }
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
        }
        .form-control:focus {
            outline: none;
            border-color: #f093fb;
            box-shadow: 0 0 0 3px rgba(240, 147, 251, 0.1);
        }
        .form-control.error {
            border-color: #e53e3e;
        }
        
        .error-message {
            color: #e53e3e;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        .error-message.show {
            display: block;
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid;
        }
        .alert-danger {
            background: #fee;
            color: #c53030;
            border-left-color: #e53e3e;
        }
        .alert-success {
            background: #f0fdf4;
            color: #22543d;
            border-left-color: #48bb78;
        }
        .alert-info {
            background: #eff6ff;
            color: #1e3a8a;
            border-left-color: #3b82f6;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            width: 100%;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(240, 147, 251, 0.4);
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }
        
        .help-text {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }
        
        .account-match {
            font-size: 12px;
            margin-top: 5px;
            font-weight: 600;
        }
        .account-match.match {
            color: #48bb78;
        }
        .account-match.no-match {
            color: #e53e3e;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🏦 Bank Details</div>
            <ul class="navbar-menu">
                <li><a href="<%= request.getContextPath() %>/broker/dashboard.jsp">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/broker/my-users.jsp">My Users</a></li>
                <li><a href="<%= request.getContextPath() %>/broker/my-candidates.jsp">Candidates</a></li>
                <li><a href="<%= request.getContextPath() %>/broker/bank-details.jsp" class="active">Bank Details</a></li>
            </ul>
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span style="font-weight: 500; font-size: 13px;"><%= user.getFullName() %></span>
                <a href="<%= request.getContextPath() %>/logout" style="margin-left: 10px; color: #e53e3e; text-decoration: none; font-weight: 600; font-size: 13px;">Logout</a>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h1>🏦 Bank Account Details</h1>
                <p>Manage your bank account information for commission payments</p>
            </div>
            
            <% if (bankDetails != null && bankDetails.getBankName() != null) { %>
                <div class="alert alert-info">
                    ℹ️ You have already saved your bank details. You can update them using the form below.
                </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-danger">❌ <%= error %></div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success">✅ <%= success %></div>
            <% } %>
            
            <form id="bankDetailsForm" action="<%= request.getContextPath() %>/broker/update-bank-details" method="post">
                <div class="form-group">
                    <label for="bankName">Bank Name <span class="required">*</span></label>
                    <input type="text" class="form-control" id="bankName" name="bankName" 
                           value="<%= bankDetails != null && bankDetails.getBankName() != null ? bankDetails.getBankName() : "" %>" 
                           placeholder="e.g., State Bank of India" required>
                    <div class="error-message" id="bankName-error"></div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="accountNumber">Account Number <span class="required">*</span></label>
                        <input type="text" class="form-control" id="accountNumber" name="accountNumber" 
                               value="<%= bankDetails != null && bankDetails.getAccountNumber() != null ? bankDetails.getAccountNumber() : "" %>" 
                               placeholder="9-18 digits" maxlength="18" required>
                        <div class="help-text">Enter 9-18 digit account number</div>
                        <div class="error-message" id="accountNumber-error"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmAccountNumber">Confirm Account Number <span class="required">*</span></label>
                        <input type="text" class="form-control" id="confirmAccountNumber" name="confirmAccountNumber" 
                               placeholder="Re-enter account number" maxlength="18" required>
                        <div class="account-match" id="accountMatch"></div>
                        <div class="error-message" id="confirmAccountNumber-error"></div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="ifscCode">IFSC Code <span class="required">*</span></label>
                        <input type="text" class="form-control" id="ifscCode" name="ifscCode" 
                               value="<%= bankDetails != null && bankDetails.getIfscCode() != null ? bankDetails.getIfscCode() : "" %>" 
                               placeholder="e.g., SBIN0001234" maxlength="11" required>
                        <div class="help-text">11 character IFSC code</div>
                        <div class="error-message" id="ifscCode-error"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="branchName">Branch Name <span class="required">*</span></label>
                        <input type="text" class="form-control" id="branchName" name="branchName" 
                               value="<%= bankDetails != null && bankDetails.getBranchName() != null ? bankDetails.getBranchName() : "" %>" 
                               placeholder="e.g., Main Branch, Mumbai" required>
                        <div class="error-message" id="branchName-error"></div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="panNumber">PAN Number <span class="required">*</span></label>
                    <input type="text" class="form-control" id="panNumber" name="panNumber" 
                           value="<%= bankDetails != null && bankDetails.getPanNumber() != null ? bankDetails.getPanNumber() : "" %>" 
                           placeholder="e.g., ABCDE1234F" maxlength="10" required>
                    <div class="help-text">10 character PAN number (Format: ABCDE1234F)</div>
                    <div class="error-message" id="panNumber-error"></div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">💾 Save Bank Details</button>
                </div>
                
                <div style="margin-top: 20px; text-align: center;">
                    <a href="dashboard.jsp" style="color: #f093fb; text-decoration: none; font-size: 14px;">← Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        const form = document.getElementById('bankDetailsForm');
        
        // Validation function
        function validateField(field) {
            const fieldId = field.id;
            const value = field.value.trim();
            const errorElement = document.getElementById(fieldId + '-error');
            
            let errorMessage = '';
            
            switch(fieldId) {
                case 'bankName':
                    if (!value) {
                        errorMessage = 'Bank name is required';
                    } else if (value.length < 3) {
                        errorMessage = 'Bank name must be at least 3 characters';
                    }
                    break;
                    
                case 'accountNumber':
                    if (!value) {
                        errorMessage = 'Account number is required';
                    } else if (!/^\d{9,18}$/.test(value)) {
                        errorMessage = 'Account number must be 9-18 digits';
                    }
                    break;
                    
                case 'confirmAccountNumber':
                    const accountNumber = document.getElementById('accountNumber').value.trim();
                    if (!value) {
                        errorMessage = 'Please confirm your account number';
                    } else if (value !== accountNumber) {
                        errorMessage = 'Account numbers do not match';
                    }
                    break;
                    
                case 'ifscCode':
                    if (!value) {
                        errorMessage = 'IFSC code is required';
                    } else if (!/^[A-Z]{4}0[A-Z0-9]{6}$/.test(value)) {
                        errorMessage = 'Invalid IFSC format (e.g., SBIN0001234)';
                    }
                    break;
                    
                case 'branchName':
                    if (!value) {
                        errorMessage = 'Branch name is required';
                    } else if (value.length < 3) {
                        errorMessage = 'Branch name must be at least 3 characters';
                    }
                    break;
                    
                case 'panNumber':
                    if (!value) {
                        errorMessage = 'PAN number is required';
                    } else if (!/^[A-Z]{5}[0-9]{4}[A-Z]{1}$/.test(value)) {
                        errorMessage = 'Invalid PAN format (e.g., ABCDE1234F)';
                    }
                    break;
            }
            
            if (errorMessage) {
                field.classList.add('error');
                if (errorElement) {
                    errorElement.textContent = errorMessage;
                    errorElement.classList.add('show');
                }
                return false;
            } else {
                field.classList.remove('error');
                if (errorElement) {
                    errorElement.classList.remove('show');
                }
                return true;
            }
        }
        
        // Auto-uppercase IFSC code with validation
        document.getElementById('ifscCode').addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
            validateField(this);
        });
        
        // Auto-uppercase PAN number with validation
        document.getElementById('panNumber').addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
            validateField(this);
        });
        
        // Only allow numbers in account number with validation
        document.getElementById('accountNumber').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
            validateField(this);
            
            // Also validate confirm field if it has value
            const confirmField = document.getElementById('confirmAccountNumber');
            if (confirmField.value) {
                validateField(confirmField);
            }
        });
        
        // Validate bank name on input
        document.getElementById('bankName').addEventListener('input', function(e) {
            validateField(this);
        });
        
        // Validate branch name on input
        document.getElementById('branchName').addEventListener('input', function(e) {
            validateField(this);
        });
        
        // Confirm account number with validation and match indicator
        document.getElementById('confirmAccountNumber').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
            
            const accountNumber = document.getElementById('accountNumber').value;
            const confirmAccountNumber = this.value;
            const matchIndicator = document.getElementById('accountMatch');
            
            if (confirmAccountNumber) {
                if (accountNumber === confirmAccountNumber) {
                    matchIndicator.textContent = '✓ Account numbers match';
                    matchIndicator.className = 'account-match match';
                } else {
                    matchIndicator.textContent = '✗ Account numbers do not match';
                    matchIndicator.className = 'account-match no-match';
                }
            } else {
                matchIndicator.textContent = '';
                matchIndicator.className = 'account-match';
            }
            
            validateField(this);
        });
        
        // Add blur event listeners to all form fields for validation
        const formFields = form.querySelectorAll('input[required]');
        formFields.forEach(field => {
            field.addEventListener('blur', function() {
                validateField(this);
            });
            
            field.addEventListener('input', function() {
                // Clear error on input if field was in error state
                if (this.classList.contains('error')) {
                    const errorElement = document.getElementById(this.id + '-error');
                    if (errorElement) {
                        errorElement.classList.remove('show');
                    }
                    this.classList.remove('error');
                }
            });
        });
        
        // Form validation on submit
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            let isValid = true;
            
            // Clear previous errors
            document.querySelectorAll('.error-message').forEach(el => el.classList.remove('show'));
            document.querySelectorAll('.form-control').forEach(el => el.classList.remove('error'));
            
            // Validate all required fields
            formFields.forEach(field => {
                if (!validateField(field)) {
                    isValid = false;
                }
            });
            
            if (isValid) {
                form.submit();
            } else {
                // Show error alert
                alert('❌ Please fix all errors before submitting!');
                
                // Scroll to first error
                const firstError = form.querySelector('.error');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstError.focus();
                }
            }
            
            return false;
        });
    </script>
</body>
</html>

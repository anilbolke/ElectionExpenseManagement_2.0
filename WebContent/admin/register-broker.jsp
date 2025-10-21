<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%
    // Authentication check - only admin can register brokers
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
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
    <title>Register Broker - Admin Portal</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        .navbar-menu a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        /* Container */
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* Card */
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
            font-size: 2rem;
            color: #1a202c;
            margin-bottom: 10px;
        }
        .card-header p {
            color: #718096;
            font-size: 14px;
        }
        
        /* Form */
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
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .form-control.error {
            border-color: #e53e3e;
        }
        .helper-text {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }
        .error-message {
            font-size: 12px;
            color: #e53e3e;
            margin-top: 5px;
            display: none;
        }
        .error-message.show {
            display: block;
        }
        .form-control.error {
            border-color: #e53e3e;
            background: #fff5f5;
        }
        .form-control.success {
            border-color: #48bb78;
        }
        
        /* Password strength indicator */
        .password-strength {
            height: 4px;
            background: #e2e8f0;
            border-radius: 2px;
            margin-top: 8px;
            overflow: hidden;
        }
        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s;
        }
        .password-strength-bar.weak {
            width: 33%;
            background: #fc8181;
        }
        .password-strength-bar.medium {
            width: 66%;
            background: #f6ad55;
        }
        .password-strength-bar.strong {
            width: 100%;
            background: #48bb78;
        }
        
        /* Password match indicator */
        .password-match {
            font-size: 12px;
            margin-top: 5px;
        }
        .password-match.match {
            color: #48bb78;
        }
        .password-match.no-match {
            color: #e53e3e;
        }
        
        /* Alerts */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background: #f0fdf4;
            color: #22543d;
            border-left: 4px solid #48bb78;
        }
        .alert-error {
            background: #fff5f5;
            color: #742a2a;
            border-left: 4px solid #e53e3e;
        }
        
        /* Buttons */
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'Inter', sans-serif;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100%;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #2d3748;
        }
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        /* Special field highlighting */
        .referral-field {
            position: relative;
        }
        .referral-field::after {
            content: "🎯 Unique Code";
            position: absolute;
            right: 15px;
            top: 42px;
            font-size: 11px;
            color: #667eea;
            font-weight: 600;
        }
        
        /* Action buttons */
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            .navbar-menu {
                display: none;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">👑 Admin Portal</div>
            <ul class="navbar-menu">
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="view-users.jsp">Users</a></li>
                <li><a href="view-candidates.jsp">Candidates</a></li>
                <li><a href="view-brokers.jsp">Brokers</a></li>
            </ul>
            <div>
                <a href="dashboard.jsp" class="btn btn-secondary" style="padding: 6px 12px; font-size: 13px;">← Back</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h1>🤝 Register New Broker</h1>
                <p>Create a broker account with unique referral code</p>
            </div>
            
            <% if (success != null) { %>
                <div class="alert alert-success">
                    ✅ <%= success %>
                </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    ❌ <%= error %>
                </div>
            <% } %>
            
            <form action="<%=request.getContextPath()%>/register-broker" method="post" id="brokerForm">
                <!-- Personal Information -->
                <h3 style="margin-bottom: 20px; color: #1a202c; font-size: 1.1rem;">Personal Information</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>First Name <span class="required">*</span></label>
                        <input type="text" id="firstName" name="firstName" class="form-control" required maxlength="50">
                        <div class="helper-text">2-50 characters, letters only</div>
                        <div class="error-message" id="firstName-error">First name is required</div>
                    </div>
                    <div class="form-group">
                        <label>Last Name <span class="required">*</span></label>
                        <input type="text" id="lastName" name="lastName" class="form-control" required maxlength="50">
                        <div class="helper-text">2-50 characters, letters only</div>
                        <div class="error-message" id="lastName-error">Last name is required</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Mobile Number <span class="required">*</span></label>
                        <input type="text" id="mobileNumber" name="mobileNumber" class="form-control" required 
                               pattern="[6-9][0-9]{9}" maxlength="10" placeholder="10 digits">
                        <div class="helper-text">Starting with 6-9, 10 digits</div>
                        <div class="error-message" id="mobileNumber-error">Invalid mobile number</div>
                    </div>
                    <div class="form-group">
                        <label>Email Address <span class="required">*</span></label>
                        <input type="email" id="emailId" name="emailId" class="form-control" required maxlength="100">
                        <div class="helper-text">Valid email format</div>
                        <div class="error-message" id="emailId-error">Invalid email address</div>
                    </div>
                </div>
                
                <!-- Account Credentials -->
                <h3 style="margin: 30px 0 20px 0; color: #1a202c; font-size: 1.1rem;">Account Credentials</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Username <span class="required">*</span></label>
                        <input type="text" id="username" name="username" class="form-control" required 
                               minlength="4" maxlength="30" pattern="[a-zA-Z0-9_]+">
                        <div class="helper-text">4-30 characters (letters, numbers, underscore)</div>
                        <div class="error-message" id="username-error">Invalid username</div>
                    </div>
                    <div class="form-group referral-field">
                        <label>Referral Code <span class="required">*</span></label>
                        <input type="text" id="referralCode" name="referralCode" class="form-control" required 
                               minlength="6" maxlength="20" pattern="[A-Z0-9]+" 
                               style="text-transform: uppercase;" placeholder="e.g., BROKER123">
                        <div class="helper-text">Unique code (A-Z, 0-9, 6-20 characters)</div>
                        <div class="error-message" id="referralCode-error">Invalid referral code</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Password <span class="required">*</span></label>
                        <input type="password" id="password" name="password" class="form-control" 
                               required minlength="6" maxlength="100">
                        <div class="password-strength">
                            <div class="password-strength-bar" id="passwordStrengthBar"></div>
                        </div>
                        <div class="helper-text">Minimum 6 characters</div>
                        <div class="error-message" id="password-error">Password must be at least 6 characters</div>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password <span class="required">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               class="form-control" required minlength="6">
                        <div class="password-match" id="passwordMatch"></div>
                        <div class="error-message" id="confirmPassword-error">Passwords do not match</div>
                    </div>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" style="flex: 2;">
                        ✓ Register Broker
                    </button>
                    <a href="view-brokers.jsp" class="btn btn-secondary" style="flex: 1; text-align: center; line-height: 1.5; text-decoration: none;">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Form validation - Same as user registration
        const form = document.getElementById('brokerForm');
        const submitBtn = form.querySelector('button[type="submit"]');
        
        // Validation rules
        const validationRules = {
            firstName: {
                pattern: /^[a-zA-Z\s]{2,50}$/,
                message: 'First name must be 2-50 characters (letters only)'
            },
            lastName: {
                pattern: /^[a-zA-Z\s]{2,50}$/,
                message: 'Last name must be 2-50 characters (letters only)'
            },
            mobileNumber: {
                pattern: /^[6-9][0-9]{9}$/,
                message: 'Mobile number must start with 6-9 and be 10 digits'
            },
            emailId: {
                pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                message: 'Please enter a valid email address'
            },
            username: {
                pattern: /^[a-zA-Z0-9_]{4,30}$/,
                message: 'Username must be 4-30 characters (letters, numbers, underscore only)'
            },
            referralCode: {
                pattern: /^[A-Z0-9]{6,20}$/,
                message: 'Referral code must be 6-20 characters (A-Z, 0-9 only)'
            },
            password: {
                minLength: 6,
                message: 'Password must be at least 6 characters long'
            }
        };
        
        // Validate individual field
        function validateField(field) {
            const fieldId = field.id;
            const fieldValue = field.value.trim();
            const errorElement = document.getElementById(fieldId + '-error');
            
            // Remove previous error state
            field.classList.remove('error', 'success');
            if (errorElement) {
                errorElement.classList.remove('show');
            }
            
            // Check if field is required and empty
            if (field.hasAttribute('required') && !fieldValue) {
                field.classList.add('error');
                if (errorElement) {
                    errorElement.textContent = 'This field is required';
                    errorElement.classList.add('show');
                }
                return false;
            }
            
            // Skip validation if field is not required and empty
            if (!field.hasAttribute('required') && !fieldValue) {
                return true;
            }
            
            // Apply specific validation rules
            if (validationRules[fieldId]) {
                const rule = validationRules[fieldId];
                
                if (rule.pattern && !rule.pattern.test(fieldValue)) {
                    field.classList.add('error');
                    if (errorElement) {
                        errorElement.textContent = rule.message;
                        errorElement.classList.add('show');
                    }
                    return false;
                }
                
                if (rule.minLength && fieldValue.length < rule.minLength) {
                    field.classList.add('error');
                    if (errorElement) {
                        errorElement.textContent = rule.message;
                        errorElement.classList.add('show');
                    }
                    return false;
                }
            }
            
            // Special validation for confirm password
            if (fieldId === 'confirmPassword') {
                const password = document.getElementById('password').value;
                if (fieldValue !== password) {
                    field.classList.add('error');
                    if (errorElement) {
                        errorElement.textContent = 'Passwords do not match';
                        errorElement.classList.add('show');
                    }
                    return false;
                }
            }
            
            // Field is valid
            if (fieldValue) {
                field.classList.add('success');
            }
            return true;
        }
        
        // Password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrengthBar');
            
            // Calculate strength
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            // Update bar
            strengthBar.className = 'password-strength-bar';
            if (strength <= 2) {
                strengthBar.classList.add('weak');
                strengthBar.style.width = '33%';
            } else if (strength <= 4) {
                strengthBar.classList.add('medium');
                strengthBar.style.width = '66%';
            } else {
                strengthBar.classList.add('strong');
                strengthBar.style.width = '100%';
            }
            
            // Also validate password field
            validateField(this);
            
            // Check confirm password if it has value
            const confirmPassword = document.getElementById('confirmPassword');
            if (confirmPassword.value) {
                validateField(confirmPassword);
            }
        });
        
        // Password match indicator
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const matchIndicator = document.getElementById('passwordMatch');
            
            if (confirmPassword) {
                if (password === confirmPassword) {
                    matchIndicator.textContent = '✓ Passwords match';
                    matchIndicator.className = 'password-match match';
                } else {
                    matchIndicator.textContent = '✗ Passwords do not match';
                    matchIndicator.className = 'password-match no-match';
                }
            } else {
                matchIndicator.textContent = '';
                matchIndicator.className = 'password-match';
            }
            
            validateField(this);
        });
        
        // Auto-uppercase referral code
        document.getElementById('referralCode').addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
            validateField(this);
        });
        
        // Add blur event listeners to all form fields
        const formFields = form.querySelectorAll('input[required], input[type="email"]');
        formFields.forEach(field => {
            field.addEventListener('blur', function() {
                validateField(this);
            });
            
            field.addEventListener('input', function() {
                // Clear error on input
                if (this.classList.contains('error')) {
                    const errorElement = document.getElementById(this.id + '-error');
                    if (errorElement) {
                        errorElement.classList.remove('show');
                    }
                    this.classList.remove('error');
                }
            });
        });
        
        // Form submission validation
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            let isValid = true;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Validate all required fields
            formFields.forEach(field => {
                if (!validateField(field)) {
                    isValid = false;
                }
            });
            
            // Password match validation
            if (password !== confirmPassword) {
                isValid = false;
                const confirmField = document.getElementById('confirmPassword');
                confirmField.classList.add('error');
                const errorElement = document.getElementById('confirmPassword-error');
                if (errorElement) {
                    errorElement.textContent = 'Passwords do not match';
                    errorElement.classList.add('show');
                }
            }
            
            // Password length validation
            if (password.length < 6) {
                isValid = false;
                const passwordField = document.getElementById('password');
                passwordField.classList.add('error');
                const errorElement = document.getElementById('password-error');
                if (errorElement) {
                    errorElement.textContent = 'Password must be at least 6 characters';
                    errorElement.classList.add('show');
                }
            }
            
            if (isValid) {
                // Submit the form
                this.submit();
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

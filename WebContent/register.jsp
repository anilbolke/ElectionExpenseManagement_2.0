<%@page import="com.election.util.DatabaseConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration - Election Expense Management</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .registration-container {
            max-width: 600px;
            width: 100%;
            margin: 0 auto;
        }
        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            animation: slideUp 0.5s ease-out;
        }
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .card-title {
            text-align: center;
            margin-bottom: 10px;
            color: #333;
            font-size: 28px;
            font-weight: 700;
        }
        .card-subtitle {
            text-align: center;
            margin-bottom: 30px;
            color: #666;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        .form-control {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            width: 100%;
            font-size: 14px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }
        .required {
            color: #e74c3c;
            margin-left: 2px;
        }
        .error-message {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        .error-message.show {
            display: block;
        }
        .form-control.error {
            border-color: #e74c3c;
            background-color: #fff5f5;
        }
        .form-control.success {
            border-color: #27ae60;
            background-color: #f0fff4;
        }
        .field-hint {
            font-size: 11px;
            color: #999;
            margin-top: 4px;
            font-style: italic;
        }
        .btn {
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-top: 10px;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        .alert-success {
            background: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        .text-center {
            text-align: center;
            margin-top: 20px;
        }
        .text-center a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .text-center a:hover {
            text-decoration: underline;
        }
        .password-strength {
            height: 4px;
            border-radius: 2px;
            background: #e0e0e0;
            margin-top: 8px;
            overflow: hidden;
        }
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
        }
        .password-strength-bar.weak {
            width: 33%;
            background: #e74c3c;
        }
        .password-strength-bar.medium {
            width: 66%;
            background: #f39c12;
        }
        .password-strength-bar.strong {
            width: 100%;
            background: #27ae60;
        }
        .password-match {
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        .password-match.match {
            color: #27ae60;
            display: block;
        }
        .password-match.nomatch {
            color: #e74c3c;
            display: block;
        }
        select.form-control {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="registration-container">
        <div class="card">
            <h2 class="card-title">Create Account</h2>
            <p class="card-subtitle">Join Election Expense Management System</p>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <form id="registrationForm" action="register" method="post">
                <!-- First Name -->
                <div class="form-group">
                    <label for="firstName">First Name <span class="required">*</span></label>
                    <input type="text" id="firstName" name="firstName" class="form-control" required>
                    <div class="field-hint">Enter your first name</div>
                    <div class="error-message" id="firstName-error">First name is required</div>
                </div>
                
                <!-- Last Name -->
                <div class="form-group">
                    <label for="lastName">Last Name <span class="required">*</span></label>
                    <input type="text" id="lastName" name="lastName" class="form-control" required>
                    <div class="field-hint">Enter your last name</div>
                    <div class="error-message" id="lastName-error">Last name is required</div>
                </div>
                
                <!-- Mobile Number -->
                <div class="form-group">
                    <label for="mobileNumber">Mobile Number <span class="required">*</span></label>
                    <input type="text" id="mobileNumber" name="mobileNumber" class="form-control" 
                           maxlength="10" pattern="[6-9][0-9]{9}" required>
                    <div class="field-hint">10 digits starting with 6-9</div>
                    <div class="error-message" id="mobileNumber-error">Invalid mobile number</div>
                </div>
                
                <!-- Email ID -->
                <div class="form-group">
                    <label for="emailId">Email ID <span class="required">*</span></label>
                    <input type="email" id="emailId" name="emailId" class="form-control" required>
                    <div class="field-hint">Enter a valid email address</div>
                    <div class="error-message" id="emailId-error">Invalid email address</div>
                </div>
                
                
                <!-- Username -->
                <div class="form-group">
                    <label for="username">Username <span class="required">*</span></label>
                    <input type="text" id="username" name="username" class="form-control" 
                           minlength="4" maxlength="30" required>
                    <div class="field-hint">4-30 characters (letters, numbers, underscore only)</div>
                    <div class="error-message" id="username-error">Username must be 4-30 characters</div>
                </div>
                
                <!-- Referral Code (Optional) -->
                <div class="form-group">
                    <label for="referralCode">Referral Code (Optional)</label>
                    <input type="text" id="referralCode" name="referralCode" class="form-control" 
                           minlength="6" maxlength="20" style="text-transform: uppercase;">
                    <div class="field-hint" id="referralHint">Enter broker's referral code if you have one</div>
                    <div class="field-hint" id="brokerName" style="color: #48bb78; font-weight: 600; display: none;">
                        ✓ Referred by: <span id="brokerFullName"></span>
                    </div>
                    <div class="error-message" id="referralCode-error">Invalid referral code</div>
                </div>
                
                <!-- Password -->
                <div class="form-group">
                    <label for="password">Password <span class="required">*</span></label>
                    <input type="password" id="password" name="password" class="form-control" 
                           minlength="6" required>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="passwordStrengthBar"></div>
                    </div>
                    <div class="field-hint">Minimum 6 characters</div>
                    <div class="error-message" id="password-error">Password must be at least 6 characters</div>
                </div>
                
                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           minlength="6" required>
                    <div class="password-match" id="passwordMatch"></div>
                    <div class="error-message" id="confirmPassword-error">Passwords do not match</div>
                </div>
                
                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    Register
                </button>
            </form>
            
            <div class="text-center">
                <p style="color: #666;">Already have an account? <a href="login.jsp">Login here</a></p>
            </div>
        </div>
    </div>
    
    <script>
        // Form validation
        const form = document.getElementById('registrationForm');
        const submitBtn = document.getElementById('submitBtn');
        
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
            } else if (strength <= 4) {
                strengthBar.classList.add('medium');
            } else {
                strengthBar.classList.add('strong');
            }
        });
        
        // Password match indicator
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const matchElement = document.getElementById('passwordMatch');
            
            if (confirmPassword.length > 0) {
                if (password === confirmPassword) {
                    matchElement.textContent = '✓ Passwords match';
                    matchElement.className = 'password-match match';
                } else {
                    matchElement.textContent = '✗ Passwords do not match';
                    matchElement.className = 'password-match nomatch';
                }
            } else {
                matchElement.className = 'password-match';
            }
        });
        
        // Referral code validation (AJAX)
        let validReferralCode = false;
        let referralCodeChecked = false;
        
        document.getElementById('referralCode').addEventListener('input', function(e) {
            // Auto-uppercase
            e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        });
        
        document.getElementById('referralCode').addEventListener('blur', function() {
            const referralCode = this.value.trim();
            const errorElement = document.getElementById('referralCode-error');
            const brokerNameDiv = document.getElementById('brokerName');
            const brokerFullNameSpan = document.getElementById('brokerFullName');
            const referralHint = document.getElementById('referralHint');
            
            // Reset states
            this.classList.remove('error', 'success');
            errorElement.classList.remove('show');
            brokerNameDiv.style.display = 'none';
            referralHint.style.display = 'block';
            validReferralCode = false;
            referralCodeChecked = false;
            
            // If empty, it's optional, so it's valid
            if (!referralCode) {
                validReferralCode = true;
                referralCodeChecked = true;
                return;
            }
            
            // Check length
            if (referralCode.length < 6 || referralCode.length > 20) {
                this.classList.add('error');
                errorElement.textContent = 'Referral code must be 6-20 characters';
                errorElement.classList.add('show');
                referralCodeChecked = true;
                return;
            }
            
            // AJAX call to validate referral code
            const xhr = new XMLHttpRequest();
            xhr.open('GET', 'validate-referral?code=' + encodeURIComponent(referralCode), true);
            xhr.onload = function() {
                if (xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    referralCodeChecked = true;
                    
                    if (response.valid) {
                        // Valid referral code
                        validReferralCode = true;
                        document.getElementById('referralCode').classList.add('success');
                        brokerFullNameSpan.textContent = response.brokerName;
                        brokerNameDiv.style.display = 'block';
                        referralHint.style.display = 'none';
                    } else {
                        // Invalid referral code
                        validReferralCode = false;
                        document.getElementById('referralCode').classList.add('error');
                        errorElement.textContent = 'Invalid referral code. Please check and try again.';
                        errorElement.classList.add('show');
                    }
                }
            };
            xhr.onerror = function() {
                referralCodeChecked = true;
                validReferralCode = false;
                document.getElementById('referralCode').classList.add('error');
                errorElement.textContent = 'Unable to validate referral code. Please try again.';
                errorElement.classList.add('show');
            };
            xhr.send();
        });
        
        // Add real-time validation on blur
        document.querySelectorAll('input, select').forEach(field => {
            field.addEventListener('blur', function() {
                if (this.value.trim()) {
                    validateField(this);
                }
            });
            
            field.addEventListener('input', function() {
                // Remove error state when user starts typing
                this.classList.remove('error');
                const errorEl = document.getElementById(this.id + '-error');
                if (errorEl) {
                    errorEl.classList.remove('show');
                }
            });
        });
        
        // Form submission
        form.addEventListener('submit', function(e) {
            let isValid = true;
            const fields = form.querySelectorAll('input, select');
            
            fields.forEach(field => {
                if (!validateField(field)) {
                    isValid = false;
                }
            });
            
            // Check referral code if provided
            const referralCode = document.getElementById('referralCode').value.trim();
            if (referralCode && !validReferralCode) {
                e.preventDefault();
                alert('Please wait for referral code validation or use a valid referral code.');
                return false;
            }
            
            if (!isValid) {
                e.preventDefault();
                alert('Please fill all required fields correctly.');
                return false;
            }
            
            // Disable submit button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.textContent = 'Registering...';
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Candidate - Election Expense Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .form-section {
            background: white;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #007bff;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        /* Validation Styles - Same as user registration */
        .form-control.error {
            border-color: #e53e3e;
            background: #fff5f5;
        }
        
        .form-control.success {
            border-color: #48bb78;
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
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
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
    
    <div class="container" style="margin-top: 80px; padding-bottom: 50px;">
        <h1 style="margin-bottom: 30px;">Add New Candidate</h1>
        
        <% if(error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <form action="<%=request.getContextPath()%>/candidate" method="post" id="candidateForm">
            <input type="hidden" name="action" value="addCandidate">
            
            <!-- Personal Information -->
            <div class="form-section">
                <div class="section-title">📋 Personal Information</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="candidateName">Candidate Name *</label>
                        <input type="text" class="form-control" id="candidateName" name="candidateName" required maxlength="100">
                        <div class="helper-text">Full name of the candidate</div>
                        <div class="error-message" id="candidateName-error">Candidate name is required</div>
                    </div>
                    <div class="form-group">
                        <label for="fatherName">Father's Name *</label>
                        <input type="text" class="form-control" id="fatherName" name="fatherName" required maxlength="100">
                        <div class="helper-text">Father's full name</div>
                        <div class="error-message" id="fatherName-error">Father's name is required</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="age">Age *</label>
                        <input type="number" class="form-control" id="age" name="age" min="25" max="100" required>
                        <div class="helper-text">Minimum 25 years required</div>
                        <div class="error-message" id="age-error">Age must be between 25-100</div>
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender *</label>
                        <select class="form-control" id="gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                        <div class="error-message" id="gender-error">Please select gender</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="mobile">Mobile Number *</label>
                        <input type="tel" class="form-control" id="mobile" name="mobile" pattern="[6-9][0-9]{9}" maxlength="10" required>
                        <div class="helper-text">Starting with 6-9, 10 digits</div>
                        <div class="error-message" id="mobile-error">Invalid mobile number</div>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" maxlength="100">
                        <div class="helper-text">Optional, valid email format</div>
                        <div class="error-message" id="email-error">Invalid email address</div>
                    </div>
                </div>
            </div>
            
            <!-- Address Information -->
            <div class="form-section">
                <div class="section-title">📍 Address Information</div>
                <div class="form-group">
                    <label for="address">Address *</label>
                    <textarea class="form-control" id="address" name="address" rows="2" required maxlength="200"></textarea>
                    <div class="helper-text">Complete residential address</div>
                    <div class="error-message" id="address-error">Address is required</div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="city">City *</label>
                        <input type="text" class="form-control" id="city" name="city" required maxlength="50">
                        <div class="helper-text">City name</div>
                        <div class="error-message" id="city-error">City is required</div>
                    </div>
                    <div class="form-group">
                        <label for="state">State *</label>
                        <input type="text" class="form-control" id="state" name="state" required maxlength="50">
                        <div class="helper-text">State name</div>
                        <div class="error-message" id="state-error">State is required</div>
                    </div>
                    <div class="form-group">
                        <label for="pincode">Pincode *</label>
                        <input type="text" class="form-control" id="pincode" name="pincode" pattern="[0-9]{6}" maxlength="6" required>
                        <div class="helper-text">6 digits</div>
                        <div class="error-message" id="pincode-error">Invalid pincode</div>
                    </div>
                </div>
            </div>
            
            <!-- Identity Documents -->
            <div class="form-section">
                <div class="section-title">🆔 Identity Documents</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="aadharNumber">Aadhar Number *</label>
                        <input type="text" class="form-control" id="aadharNumber" name="aadharNumber" pattern="[0-9]{12}" maxlength="12" required>
                        <div class="helper-text">12 digits</div>
                        <div class="error-message" id="aadharNumber-error">Invalid Aadhar number</div>
                    </div>
                    <div class="form-group">
                        <label for="voterId">Voter ID *</label>
                        <input type="text" class="form-control" id="voterId" name="voterId" required maxlength="20">
                        <div class="helper-text">Voter ID card number</div>
                        <div class="error-message" id="voterId-error">Voter ID is required</div>
                    </div>
                </div>
            </div>
            
            <!-- Election Details -->
            <div class="form-section">
                <div class="section-title">🗳️ Election Program Details</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="constituency">Constituency *</label>
                        <input type="text" class="form-control" id="constituency" name="constituency" required maxlength="100">
                        <div class="helper-text">Electoral constituency name</div>
                        <div class="error-message" id="constituency-error">Constituency is required</div>
                    </div>
                    <div class="form-group">
                        <label for="nominationId">Nomination ID *</label>
                        <input type="text" class="form-control" id="nominationId" name="nominationId" required maxlength="50">
                        <div class="helper-text">Official nomination number/ID</div>
                        <div class="error-message" id="nominationId-error">Nomination ID is required</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="electionType">Election Type *</label>
                        <select class="form-control" id="electionType" name="electionType" required>
                            <option value="">Select Election Type</option>
                            <option value="Municipal Elections">Municipal Elections</option>
                            <option value="Municipal Council Elections">Municipal Council Elections</option>
                            <option value="Panchayat Samiti Elections">Panchayat Samiti Elections</option>
                            <option value="Zilla Parishad Elections">Zilla Parishad Elections</option>
                            <option value="Assembly Elections">Assembly Elections</option>
                            <option value="Teachers' Constituency Elections">Teachers' Constituency Elections</option>
                            <option value="Graduate Constituency Elections">Graduate Constituency Elections</option>
                            <option value="Lok Sabha Elections">Lok Sabha Elections</option>
                        </select>
                        <div class="error-message" id="electionType-error">Please select election type</div>
                    </div>
                    <div class="form-group">
                        <label for="partyName">Party Name *</label>
                        <input type="text" class="form-control" id="partyName" name="partyName" required maxlength="100">
                        <div class="helper-text">Enter "Independent" if not affiliated</div>
                        <div class="error-message" id="partyName-error">Party name is required</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="partySymbol">Party Symbol</label>
                        <input type="text" class="form-control" id="partySymbol" name="partySymbol" maxlength="50">
                        <div class="helper-text">Optional</div>
                    </div>
                        <label for="electionDate">Election Date</label>
                        <input type="date" class="form-control" id="electionDate" name="electionDate">
                        <div class="helper-text">Optional</div>
                    </div>
                    <div class="form-group">
                        <label for="boothNumber">Booth Number</label>
                        <input type="text" class="form-control" id="boothNumber" name="boothNumber" maxlength="20">
                        <div class="helper-text">Optional</div>
                    </div>
                </div>
            </div>
            
            <div class="alert alert-info">
                <strong>Note:</strong> After submitting this form, you will be redirected to the payment page. 
                Payment of registration fee is mandatory to activate the candidate account.
            </div>
            
            <div class="form-actions">
                <a href="manage-candidates.jsp" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Proceed to Payment</button>
            </div>
        </form>
    </div>
    
    <script>
        // Form validation - Same patterns as user registration
        const form = document.getElementById('candidateForm');
        
        // Validation rules
        const validationRules = {
            candidateName: {
                pattern: /^[a-zA-Z\s]{2,100}$/,
                message: 'Name must be 2-100 characters (letters only)'
            },
            fatherName: {
                pattern: /^[a-zA-Z\s]{2,100}$/,
                message: 'Name must be 2-100 characters (letters only)'
            },
            age: {
                min: 25,
                max: 100,
                message: 'Age must be between 25 and 100'
            },
            mobile: {
                pattern: /^[6-9][0-9]{9}$/,
                message: 'Mobile must start with 6-9 and be 10 digits'
            },
            email: {
                pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                message: 'Please enter a valid email address',
                optional: true
            },
            city: {
                pattern: /^[a-zA-Z\s]{2,50}$/,
                message: 'City name must be 2-50 characters (letters only)'
            },
            state: {
                pattern: /^[a-zA-Z\s]{2,50}$/,
                message: 'State name must be 2-50 characters (letters only)'
            },
            pincode: {
                pattern: /^[0-9]{6}$/,
                message: 'Pincode must be exactly 6 digits'
            },
            aadharNumber: {
                pattern: /^[0-9]{12}$/,
                message: 'Aadhar must be exactly 12 digits'
            },
            voterId: {
                minLength: 3,
                message: 'Voter ID must be at least 3 characters'
            },
            constituency: {
                minLength: 2,
                message: 'Constituency name is required'
            },
            nominationId: {
                minLength: 3,
                message: 'Nomination ID must be at least 3 characters'
            },
            partyName: {
                minLength: 2,
                message: 'Party name is required'
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
            
            // Skip validation if field is optional and empty
            const rule = validationRules[fieldId];
            if (rule && rule.optional && !fieldValue) {
                return true;
            }
            
            // Apply specific validation rules
            if (validationRules[fieldId]) {
                const rule = validationRules[fieldId];
                
                // Pattern validation
                if (rule.pattern && fieldValue && !rule.pattern.test(fieldValue)) {
                    field.classList.add('error');
                    if (errorElement) {
                        errorElement.textContent = rule.message;
                        errorElement.classList.add('show');
                    }
                    return false;
                }
                
                // Min length validation
                if (rule.minLength && fieldValue.length < rule.minLength) {
                    field.classList.add('error');
                    if (errorElement) {
                        errorElement.textContent = rule.message;
                        errorElement.classList.add('show');
                    }
                    return false;
                }
                
                // Age validation (min/max)
                if (rule.min !== undefined && rule.max !== undefined) {
                    const numValue = parseInt(fieldValue);
                    if (isNaN(numValue) || numValue < rule.min || numValue > rule.max) {
                        field.classList.add('error');
                        if (errorElement) {
                            errorElement.textContent = rule.message;
                            errorElement.classList.add('show');
                        }
                        return false;
                    }
                }
            }
            
            // Select validation
            if (field.tagName === 'SELECT' && field.hasAttribute('required') && !fieldValue) {
                field.classList.add('error');
                if (errorElement) {
                    errorElement.textContent = 'Please make a selection';
                    errorElement.classList.add('show');
                }
                return false;
            }
            
            // Field is valid
            if (fieldValue) {
                field.classList.add('success');
            }
            return true;
        }
        
        // Add event listeners to all form fields
        const formFields = form.querySelectorAll('input, select, textarea');
        formFields.forEach(field => {
            // Validate on blur
            field.addEventListener('blur', function() {
                if (this.id && validationRules[this.id]) {
                    validateField(this);
                }
            });
            
            // Clear error on input
            field.addEventListener('input', function() {
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
            let firstError = null;
            
            // Validate all required fields
            formFields.forEach(field => {
                if (field.id && validationRules[field.id]) {
                    if (!validateField(field)) {
                        isValid = false;
                        if (!firstError) {
                            firstError = field;
                        }
                    }
                }
            });
            
            // Additional validation
            const age = parseInt(document.getElementById('age').value);
            if (age < 25 || age > 100) {
                isValid = false;
                const ageField = document.getElementById('age');
                ageField.classList.add('error');
                const errorElement = document.getElementById('age-error');
                if (errorElement) {
                    errorElement.textContent = 'Age must be between 25 and 100';
                    errorElement.classList.add('show');
                }
                if (!firstError) firstError = ageField;
            }
            
            // Gender validation
            const gender = document.getElementById('gender').value;
            if (!gender) {
                isValid = false;
                const genderField = document.getElementById('gender');
                genderField.classList.add('error');
                const errorElement = document.getElementById('gender-error');
                if (errorElement) {
                    errorElement.textContent = 'Please select gender';
                    errorElement.classList.add('show');
                }
                if (!firstError) firstError = genderField;
            }
            
            // Election type validation
            const electionType = document.getElementById('electionType').value;
            if (!electionType) {
                isValid = false;
                const electionField = document.getElementById('electionType');
                electionField.classList.add('error');
                const errorElement = document.getElementById('electionType-error');
                if (errorElement) {
                    errorElement.textContent = 'Please select election type';
                    errorElement.classList.add('show');
                }
                if (!firstError) firstError = electionField;
            }
            
            if (isValid) {
                // Submit the form
                this.submit();
            } else {
                // Show error alert
                alert('❌ Please fix all errors before submitting!');
                
                // Scroll to first error
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

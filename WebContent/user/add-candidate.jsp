<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.i18n.LocaleManager" %>
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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "heading.add.new.candidate") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
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
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
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
        
        .btn-danger {
            background: #fc8181;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background: #f56565;
        }
        
        .btn-sm {
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .form-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 25px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 0;
        }
        
        .form-row.three-col {
            grid-template-columns: repeat(3, 1fr);
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
        
        .form-control.error {
            border-color: #fc8181;
            background: #fff5f5;
        }
        
        .form-control.success {
            border-color: #68d391;
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
        
        .helper-text {
            font-size: 12px;
            color: #718096;
            margin-top: 4px;
        }
        
        .error-message {
            font-size: 12px;
            color: #e53e3e;
            margin-top: 4px;
            display: none;
        }
        
        .error-message.show {
            display: block;
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
        
        .alert-info {
            background: #ebf8ff;
            border: 1px solid #bee3f8;
            color: #2c5282;
        }
        
        .alert-danger {
            background: #fff5f5;
            border: 1px solid #feb2b2;
            color: #c53030;
        }
        
        h1 {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 30px;
        }
        
        @media (max-width: 992px) {
            .form-row,
            .form-row.three-col {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .form-section {
                padding: 20px;
            }
            
            h1 {
                font-size: 24px;
            }
            
            .container {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <%@ include file="../includes/user-navbar.jsp" %>
    
    <div class="main-content">
            <h1 style="margin-bottom: 30px;"><%= MessageBundle.getMessage(request, "heading.add.new.candidate") %></h1>
        
        <% if(error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <form action="<%=request.getContextPath()%>/candidate" method="post" id="candidateForm">
            <input type="hidden" name="action" value="addCandidate">
            
            <!-- Personal Information -->
            <div class="form-section">
                <div class="section-title">📋 <%= MessageBundle.getMessage(request, "profile.personal.info") %></div>
                <div style="display: grid; gap: 20px;">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="candidateName"><%= MessageBundle.getMessage(request, "candidate.name") %> *</label>
                            <input type="text" class="form-control" id="candidateName" name="candidateName" required maxlength="100">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="candidateName-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                        <div class="form-group">
                            <label for="fatherName"><%= MessageBundle.getMessage(request, "candidate.father.name") %> *</label>
                            <input type="text" class="form-control" id="fatherName" name="fatherName" required maxlength="100">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="fatherName-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="age"><%= MessageBundle.getMessage(request, "candidate.age") %> *</label>
                            <input type="number" class="form-control" id="age" name="age" min="25" max="100" required>
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "candidate.age.min") %></div>
                            <div class="error-message" id="age-error"><%= MessageBundle.getMessage(request, "validation.age") %></div>
                        </div>
                        <div class="form-group">
                            <label for="gender"><%= MessageBundle.getMessage(request, "candidate.gender") %> *</label>
                            <select class="form-control" id="gender" name="gender" required>
                                <option value=""><%= MessageBundle.getMessage(request, "gender.select") %></option>
                                <option value="Male"><%= MessageBundle.getMessage(request, "gender.male") %></option>
                                <option value="Female"><%= MessageBundle.getMessage(request, "gender.female") %></option>
                                <option value="Other"><%= MessageBundle.getMessage(request, "gender.other") %></option>
                            </select>
                            <div class="error-message" id="gender-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="mobile"><%= MessageBundle.getMessage(request, "candidate.mobile") %> *</label>
                            <input type="tel" class="form-control" id="mobile" name="mobile" pattern="[6-9][0-9]{9}" maxlength="10" required>
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.phone") %></div>
                            <div class="error-message" id="mobile-error"><%= MessageBundle.getMessage(request, "validation.phone.invalid") %></div>
                        </div>
                        <div class="form-group">
                            <label for="email"><%= MessageBundle.getMessage(request, "candidate.email") %></label>
                            <input type="email" class="form-control" id="email" name="email" maxlength="100">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "form.optional") %></div>
                            <div class="error-message" id="email-error"><%= MessageBundle.getMessage(request, "validation.email.invalid") %></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Address Information -->
            <div class="form-section">
                <div class="section-title">📍 <%= MessageBundle.getMessage(request, "profile.address.info") %></div>
                <div style="display: grid; gap: 20px;">
                    <div class="form-group">
                        <label for="address"><%= MessageBundle.getMessage(request, "candidate.address") %> *</label>
                        <textarea class="form-control" id="address" name="address" rows="2" required maxlength="200"></textarea>
                        <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        <div class="error-message" id="address-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                    </div>
                    
                    <div class="form-row three-col">
                        <div class="form-group">
                            <label for="city"><%= MessageBundle.getMessage(request, "candidate.city") %> *</label>
                            <input type="text" class="form-control" id="city" name="city" required maxlength="50">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="city-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                        <div class="form-group">
                            <label for="state"><%= MessageBundle.getMessage(request, "candidate.state") %> *</label>
                            <input type="text" class="form-control" id="state" name="state" required maxlength="50">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="state-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                        <div class="form-group">
                            <label for="pincode"><%= MessageBundle.getMessage(request, "candidate.pincode") %> *</label>
                            <input type="text" class="form-control" id="pincode" name="pincode" pattern="[0-9]{6}" maxlength="6" required>
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="pincode-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Identity Documents -->
            <div class="form-section">
                <div class="section-title">🆔 <%= MessageBundle.getMessage(request, "candidate.identity.documents") %></div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="aadharNumber"><%= MessageBundle.getMessage(request, "candidate.aadhar") %> *</label>
                        <input type="text" class="form-control" id="aadharNumber" name="aadharNumber" pattern="[0-9]{12}" maxlength="12" required>
                        <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        <div class="error-message" id="aadharNumber-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                    </div>
                    <div class="form-group">
                        <label for="voterId"><%= MessageBundle.getMessage(request, "candidate.voterid") %> *</label>
                        <input type="text" class="form-control" id="voterId" name="voterId" required maxlength="20">
                        <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        <div class="error-message" id="voterId-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                    </div>
                </div>
            </div>
            
            <!-- Election Details -->
            <div class="form-section">
                <div class="section-title">🗳️ <%= MessageBundle.getMessage(request, "candidate.election.program") %></div>
                <div style="display: grid; gap: 20px;">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="constituency"><%= MessageBundle.getMessage(request, "candidate.constituency") %> *</label>
                            <input type="text" class="form-control" id="constituency" name="constituency" required maxlength="100">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="constituency-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                        <div class="form-group">
                            <label for="nominationId"><%= MessageBundle.getMessage(request, "candidate.nomination.id") %> *</label>
                            <input type="text" class="form-control" id="nominationId" name="nominationId" required maxlength="50">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                            <div class="error-message" id="nominationId-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="electionType"><%= MessageBundle.getMessage(request, "candidate.election.type") %> *</label>
                            <select class="form-control" id="electionType" name="electionType" required>
                                <option value=""><%= MessageBundle.getMessage(request, "election.type.select") %></option>
                                <option value="Municipal Elections"><%= MessageBundle.getMessage(request, "election.type.municipal") %></option>
                                <option value="Municipal Council Elections"><%= MessageBundle.getMessage(request, "election.type.municipal.council") %></option>
                                <option value="Panchayat Samiti Elections"><%= MessageBundle.getMessage(request, "election.type.panchayat.samiti") %></option>
                                <option value="Zilla Parishad Elections"><%= MessageBundle.getMessage(request, "election.type.zilla.parishad") %></option>
                                <option value="Assembly Elections"><%= MessageBundle.getMessage(request, "election.type.assembly") %></option>
                                <option value="Teachers' Constituency Elections"><%= MessageBundle.getMessage(request, "election.type.teachers") %></option>
                                <option value="Graduate Constituency Elections"><%= MessageBundle.getMessage(request, "election.type.graduate") %></option>
                                <option value="Lok Sabha Elections"><%= MessageBundle.getMessage(request, "election.type.lok.sabha") %></option>
                            </select>
                            <div class="error-message" id="electionType-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                        <div class="form-group">
                            <label for="partyName"><%= MessageBundle.getMessage(request, "candidate.party") %> *</label>
                            <input type="text" class="form-control" id="partyName" name="partyName" required maxlength="100">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "candidate.party.independent") %></div>
                            <div class="error-message" id="partyName-error"><%= MessageBundle.getMessage(request, "validation.required") %></div>
                        </div>
                    </div>
                    
                    <div class="form-row three-col">
                        <div class="form-group">
                            <label for="partySymbol"><%= MessageBundle.getMessage(request, "candidate.symbol") %></label>
                            <input type="text" class="form-control" id="partySymbol" name="partySymbol" maxlength="50">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "form.optional") %></div>
                        </div>
                        <div class="form-group">
                            <label for="electionDate"><%= MessageBundle.getMessage(request, "candidate.election.date") %></label>
                            <input type="date" class="form-control" id="electionDate" name="electionDate">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "form.optional") %></div>
                        </div>
                        <div class="form-group">
                            <label for="boothNumber">Ward/Prabhag/ZP/PS/VS/LS Number</label>
                            <input type="text" class="form-control" id="boothNumber" name="boothNumber" maxlength="20">
                            <div class="helper-text"><%= MessageBundle.getMessage(request, "form.optional") %></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="alert alert-info">
                <strong><%= MessageBundle.getMessage(request, "info.note") %>:</strong> <%= MessageBundle.getMessage(request, "info.payment.redirect") %> 
            </div>
            
            <div class="form-actions">
                <a href="manage-candidates.jsp" class="btn btn-secondary"><%= MessageBundle.getMessage(request, "action.cancel") %></a>
                <button type="submit" class="btn btn-primary"><%= MessageBundle.getMessage(request, "payment.proceed") %></button>
            </div>
        </form>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2024 <%= MessageBundle.getMessage(request, "app.title") %>. <%= MessageBundle.getMessage(request, "footer.rights") %></p>
    </footer>
    
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

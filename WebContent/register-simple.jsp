<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Register - Test</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <div class="card">
            <h2 class="card-title">Simple Registration (Test)</h2>
            <h3 class="text-center mb-3">Register</h3>
            
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
            
            <form action="register" method="post" onsubmit="console.log('Form submitting...'); return true;">
                <div class="form-group">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" class="form-control" minlength="6" required>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="6" required>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="mobile">Mobile Number *</label>
                    <input type="text" id="mobile" name="mobile" class="form-control" pattern="[6-9][0-9]{9}" maxlength="10" required>
                    <small style="color: #666;">10 digits starting with 6-9</small>
                </div>
                
                <div class="form-group">
                    <label for="userRole">Register as *</label>
                    <select id="userRole" name="userRole" class="form-control" required>
                        <option value="">Select Role</option>
                        <option value="user">Candidate</option>
                        <option value="broker">Broker</option>
                    </select>
                </div>
                
                <!-- Hidden fields for servlet compatibility -->
                <input type="hidden" name="constituency" value="Test">
                <input type="hidden" name="partyName" value="Test Party">
                <input type="hidden" name="electionType" value="Test">
                
                <button type="submit" class="btn btn-primary btn-block">Register</button>
            </form>
            
            <div class="text-center mt-3">
                <p>Already have an account? <a href="login.jsp">Login here</a></p>
                <p><a href="register.jsp">Use Full Registration Form</a></p>
            </div>
        </div>
    </div>
    
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            console.log('Form validation passed, submitting...');
        });
    </script>
</body>
</html>

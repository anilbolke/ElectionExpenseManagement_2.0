<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List" %>
<%
    // Authentication check
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get all users and brokers for dropdown
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send SMS - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f5f7fa;
            color: #2d3748;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 15px;
        }
        
        .header {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        
        .header h1 {
            font-size: 20px;
            color: #1a202c;
            margin-bottom: 5px;
        }
        
        .header p {
            color: #718096;
            font-size: 13px;
        }
        
        .back-button {
            display: inline-block;
            padding: 8px 16px;
            background: #e2e8f0;
            color: #2d3748;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 15px;
            transition: background 0.2s;
        }
        
        .back-button:hover {
            background: #cbd5e0;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #2d3748;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4299e1;
        }
        
        .char-count {
            text-align: right;
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background: #4299e1;
            color: white;
        }
        
        .btn-primary:hover {
            background: #3182ce;
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #2d3748;
            margin-left: 10px;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: none;
        }
        
        .alert-success {
            background: #c6f6d5;
            color: #22543d;
            border-left: 4px solid #38a169;
        }
        
        .alert-error {
            background: #fed7d7;
            color: #742a2a;
            border-left: 4px solid #e53e3e;
        }
        
        .templates {
            margin-top: 30px;
        }
        
        .templates h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #2d3748;
        }
        
        .template-btn {
            display: inline-block;
            padding: 8px 16px;
            background: #edf2f7;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            margin: 5px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.2s;
        }
        
        .template-btn:hover {
            background: #e2e8f0;
            border-color: #4299e1;
        }
        
        .quick-select {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        
        .quick-select-btn {
            padding: 6px 12px;
            background: #e2e8f0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.2s;
        }
        
        .quick-select-btn:hover {
            background: #cbd5e0;
        }
        
        .user-table {
            margin-top: 30px;
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
        }
        
        .user-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .user-table th,
        .user-table td {
            padding: 8px 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            font-size: 13px;
        }
        
        .user-table th {
            background: #f7fafc;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        
        .user-table tr:hover {
            background: #f7fafc;
        }
        
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-user { background: #bee3f8; color: #2c5282; }
        .badge-broker { background: #feebc8; color: #7c2d12; }
        .badge-admin { background: #fed7d7; color: #742a2a; }
        
        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header {
                padding: 12px;
                margin-bottom: 12px;
            }
            
            .header h1 {
                font-size: 18px;
            }
            
            .header p {
                font-size: 12px;
            }
            
            .back-button {
                padding: 6px 12px;
                font-size: 13px;
                margin-bottom: 10px;
            }
            
            .card {
                padding: 15px;
                border-radius: 6px;
            }
            
            .form-group {
                margin-bottom: 15px;
            }
            
            .form-group label {
                font-size: 13px;
                margin-bottom: 6px;
            }
            
            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 8px;
                font-size: 14px;
            }
            
            .form-group textarea {
                min-height: 100px;
            }
            
            .quick-select {
                flex-direction: column;
                gap: 8px;
            }
            
            .quick-select-btn {
                width: 100%;
                padding: 8px;
                font-size: 13px;
            }
            
            .btn {
                width: 100%;
                padding: 12px;
                font-size: 14px;
                margin-bottom: 8px;
            }
            
            .btn-secondary {
                margin-left: 0;
            }
            
            .templates {
                margin-top: 20px;
            }
            
            .templates h3 {
                font-size: 16px;
                margin-bottom: 12px;
            }
            
            .template-btn {
                display: block;
                width: 100%;
                margin: 8px 0;
                padding: 10px 16px;
                text-align: center;
                font-size: 13px;
            }
            
            .user-table {
                margin-top: 20px;
                max-height: 250px;
                border-radius: 6px;
            }
            
            .user-table table {
                font-size: 12px;
            }
            
            .user-table th,
            .user-table td {
                padding: 6px 8px;
                font-size: 12px;
            }
            
            .user-table th {
                position: sticky;
                top: 0;
                background: #f7fafc;
                z-index: 10;
            }
            
            /* Hide table columns on very small screens */
            .user-table .hide-mobile {
                display: none;
            }
            
            /* Show badge in name column on mobile */
            .user-table td .badge {
                display: inline-block !important;
                margin-left: 6px;
                vertical-align: middle;
            }
            
            .badge {
                padding: 2px 6px;
                font-size: 10px;
            }
            
            .alert {
                padding: 10px 12px;
                font-size: 13px;
                margin-bottom: 15px;
            }
            
            .char-count {
                font-size: 11px;
            }
        }
        
        @media (max-width: 480px) {
            .header h1 {
                font-size: 16px;
            }
            
            .header p {
                font-size: 11px;
            }
            
            .card {
                padding: 12px;
            }
            
            .form-group {
                margin-bottom: 12px;
            }
            
            .form-group label {
                font-size: 12px;
            }
            
            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 8px;
                font-size: 13px;
            }
            
            .user-table {
                max-height: 200px;
            }
            
            .user-table table {
                font-size: 11px;
            }
            
            .user-table th,
            .user-table td {
                padding: 5px 6px;
            }
        }
        
        /* Landscape mode for mobile */
        @media (max-width: 768px) and (orientation: landscape) {
            .user-table {
                max-height: 180px;
            }
            
            .form-group textarea {
                min-height: 80px;
            }
        }
        
        /* Touch-friendly improvements */
        @media (hover: none) and (pointer: coarse) {
            .btn,
            .quick-select-btn,
            .template-btn,
            .back-button {
                min-height: 44px;
                touch-action: manipulation;
            }
            
            .form-group input,
            .form-group select {
                min-height: 44px;
            }
            
            select {
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 8px center;
                background-size: 16px;
                padding-right: 32px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/admin-navbar.jsp" />
    
    <div class="container">
        <a href="dashboard.jsp" class="back-button">← Back to Dashboard</a>
        
        <div class="header">
            <h1>📱 Send SMS</h1>
            <p>Send SMS notifications to users and brokers</p>
        </div>
        
        <div id="alertBox" class="alert"></div>
        
        <div class="card">
            <form id="smsForm">
                <div class="form-group">
                    <label>Select Recipient *</label>
                    <div class="quick-select">
                        <button type="button" class="quick-select-btn" onclick="filterUsers('all')">All Users</button>
                        <button type="button" class="quick-select-btn" onclick="filterUsers('user')">Only Users</button>
                        <button type="button" class="quick-select-btn" onclick="filterUsers('broker')">Only Brokers</button>
                    </div>
                    <select id="recipientSelect" name="recipient" onchange="updateMobile()">
                        <option value="">-- Select User/Broker --</option>
                        <% if (allUsers != null) {
                            for (User u : allUsers) {
                                if (!"admin".equals(u.getUserRole())) { %>
                                    <option value="<%= u.getUserId() %>" 
                                            data-mobile="<%= u.getMobile() != null ? u.getMobile() : "" %>"
                                            data-role="<%= u.getUserRole() %>"
                                            data-name="<%= u.getFullName() != null ? u.getFullName() : u.getUsername() %>">
                                        <%= u.getFullName() != null ? u.getFullName() : u.getUsername() %> 
                                        (<%= u.getMobile() != null ? u.getMobile() : "No Mobile" %>) 
                                        - <%= u.getUserRole() %>
                                    </option>
                        <%      }
                            }
                        } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Mobile Number *</label>
                    <input type="text" id="mobile" name="mobile" placeholder="Enter 10-digit mobile number" 
                           pattern="[0-9]{10}" required>
                    <small style="color: #718096;">Enter 10-digit mobile number without country code</small>
                </div>
                
                <div class="form-group">
                    <label>Message *</label>
                    <textarea id="message" name="message" placeholder="Enter your message here..." 
                              maxlength="160" required></textarea>
                    <div class="char-count">
                        <span id="charCount">0</span>/160 characters
                    </div>
                </div>
                
                <div>
                    <button type="submit" class="btn btn-primary">📤 Send SMS</button>
                    <button type="reset" class="btn btn-secondary">🔄 Clear</button>
                </div>
            </form>
            
            <div class="templates">
                <h3>📝 Quick Templates</h3>
                <button class="template-btn" onclick="useTemplate('welcome')">Welcome Message</button>
                <button class="template-btn" onclick="useTemplate('reminder')">Payment Reminder</button>
                <button class="template-btn" onclick="useTemplate('thankyou')">Thank You</button>
                <button class="template-btn" onclick="useTemplate('update')">Account Update</button>
            </div>
            
            <div class="user-table">
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th class="hide-mobile">Mobile</th>
                            <th class="hide-mobile">Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="userTableBody">
                        <% if (allUsers != null) {
                            for (User u : allUsers) {
                                if (!"admin".equals(u.getUserRole())) { %>
                                    <tr data-role="<%= u.getUserRole() %>">
                                        <td>
                                            <%= u.getFullName() != null ? u.getFullName() : u.getUsername() %>
                                            <span class="badge badge-<%= u.getUserRole() %>" style="display: none;">
                                                <%= u.getUserRole() %>
                                            </span>
                                        </td>
                                        <td class="hide-mobile"><%= u.getMobile() != null ? u.getMobile() : "N/A" %></td>
                                        <td class="hide-mobile">
                                            <span class="badge badge-<%= u.getUserRole() %>">
                                                <%= u.getUserRole() %>
                                            </span>
                                        </td>
                                        <td>
                                            <button type="button" class="quick-select-btn" 
                                                    onclick="selectUser(<%= u.getUserId() %>)">
                                                Select
                                            </button>
                                        </td>
                                    </tr>
                        <%      }
                            }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        const messageArea = document.getElementById('message');
        const charCount = document.getElementById('charCount');
        const recipientSelect = document.getElementById('recipientSelect');
        const mobileInput = document.getElementById('mobile');
        const alertBox = document.getElementById('alertBox');
        
        // Character counter
        messageArea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });
        
        // Update mobile when recipient changes
        function updateMobile() {
            const selected = recipientSelect.options[recipientSelect.selectedIndex];
            const mobile = selected.getAttribute('data-mobile');
            if (mobile) {
                mobileInput.value = mobile;
            }
        }
        
        // Select user from table
        function selectUser(userId) {
            recipientSelect.value = userId;
            updateMobile();
        }
        
        // Filter users by role
        function filterUsers(role) {
            const rows = document.querySelectorAll('#userTableBody tr');
            const options = recipientSelect.querySelectorAll('option');
            
            rows.forEach(row => {
                const userRole = row.getAttribute('data-role');
                if (role === 'all' || userRole === role) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            options.forEach(option => {
                const userRole = option.getAttribute('data-role');
                if (option.value === '' || role === 'all' || userRole === role) {
                    option.style.display = '';
                } else {
                    option.style.display = 'none';
                }
            });
        }
        
        // Message templates
        function useTemplate(type) {
            const templates = {
                welcome: 'Welcome to EMS Online! Your account is now active. For support, contact us at EMSonline.in\nShree IT Solutions',
                reminder: 'Reminder: Your payment is pending. Please complete payment to continue using our services.\nEMS Online\nShree IT Solutions',
                thankyou: 'Thank you for using EMS Online! We appreciate your trust in our services.\nShree IT Solutions',
                update: 'Your account has been updated successfully. For queries, visit EMSonline.in\nShree IT Solutions'
            };
            
            if (templates[type]) {
                messageArea.value = templates[type];
                charCount.textContent = templates[type].length;
            }
        }
        
        // Form submission
        document.getElementById('smsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const mobile = mobileInput.value.trim();
            const message = messageArea.value.trim();
            
            if (!mobile || !message) {
                showAlert('Please fill all required fields', 'error');
                return;
            }
            
            // Validate mobile number
            if (!/^[6-9][0-9]{9}$/.test(mobile)) {
                showAlert('Please enter a valid 10-digit mobile number starting with 6-9', 'error');
                return;
            }
            
            // Send SMS
            const btn = this.querySelector('.btn-primary');
            const originalText = btn.textContent;
            btn.textContent = '📤 Sending...';
            btn.disabled = true;
            
            fetch('<%= request.getContextPath() %>/SendSMSServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'mobile=' + encodeURIComponent(mobile) + '&message=' + encodeURIComponent(message)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('✓ ' + data.message, 'success');
                    this.reset();
                    charCount.textContent = '0';
                } else {
                    showAlert('✗ ' + data.message, 'error');
                }
            })
            .catch(error => {
                showAlert('✗ Error sending SMS: ' + error.message, 'error');
            })
            .finally(() => {
                btn.textContent = originalText;
                btn.disabled = false;
            });
        });
        
        function showAlert(message, type) {
            alertBox.textContent = message;
            alertBox.className = 'alert alert-' + type;
            alertBox.style.display = 'block';
            
            setTimeout(() => {
                alertBox.style.display = 'none';
            }, 5000);
        }
    </script>
</body>
</html>

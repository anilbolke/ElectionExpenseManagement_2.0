<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get all subscription plans
    SubscriptionDAO subscriptionDAO = new SubscriptionDAO();
    List<SubscriptionPlan> allPlans = subscriptionDAO.getAllPlans();
    
    // Get candidate registration fee from database
    SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
    String candidateFee = settingsDAO.getSetting("candidate_registration_fee", "5000.00");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Activity - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 14px;
            color: #2d3748;
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
            max-width: 1600px;
            margin: 0 auto;
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
        }
        .navbar-menu a:hover, .navbar-menu a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 5px;
        }
        .breadcrumb {
            font-size: 13px;
            color: #64748b;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }
        .alert-error {
            background: #fecaca;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header h3 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
        }
        .card-body {
            padding: 25px;
        }
        
        .fee-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .fee-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e2e8f0;
        }
        .fee-row:last-child {
            border-bottom: none;
        }
        
        .fee-label {
            font-weight: 600;
            font-size: 1.1rem;
            color: #333;
        }
        .fee-value {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .fee-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table th {
            background: #f7fafc;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 12px;
            text-transform: uppercase;
        }
        table td {
            padding: 15px 12px;
            border-bottom: 1px solid #e2e8f0;
        }
        table tr:hover {
            background: #f7fafc;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            font-size: 13px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: #10b981;
            color: white;
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .btn-sm {
            padding: 5px 12px;
            font-size: 12px;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-success { background: #d1fae5; color: #065f46; }
        .badge-warning { background: #fed7aa; color: #78350f; }
        .badge-danger { background: #fecaca; color: #991b1b; }
        .badge-info { background: #dbeafe; color: #1e3a8a; }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            animation: fadeIn 0.3s;
        }
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            max-width: 500px;
            width: 90%;
            animation: slideUp 0.3s;
        }
        .modal-header {
            margin-bottom: 20px;
        }
        .modal-header h2 {
            font-size: 1.5rem;
            color: #333;
        }
        .modal-body {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }
        .modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .price-highlight {
            font-size: 1.8rem;
            font-weight: 700;
            color: #667eea;
        }
        
        .info-box {
            background: #e0e7ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .info-box strong {
            color: #4338ca;
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
                <li><a href="manage-payments.jsp" class="active">Payment Activity</a></li>
            </ul>
            <div>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container">
        <div class="page-header">
            <h1>💳 Payment Activity</h1>
            <div class="breadcrumb">Dashboard / Payment Activity</div>
        </div>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                ✓ <%= request.getParameter("success") %>
            </div>
        <% } %>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                ✗ <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <div class="info-box">
            <strong>ℹ️ Information:</strong> Changes to payment amounts will take effect immediately for new transactions. Existing subscriptions will not be affected.
        </div>
        
        <!-- Candidate Registration Fee -->
        <div class="card">
            <div class="card-header">
                <h3>🎫 Candidate Registration Fee</h3>
                <button class="btn btn-warning btn-sm" onclick="editCandidateFee()">✏️ Edit Amount</button>
            </div>
            <div class="card-body">
                <div class="fee-section">
                    <div class="fee-row">
                        <div class="fee-label">One-Time Registration Fee</div>
                        <div class="fee-value">
                            <span class="fee-amount">₹<span id="candidateFeeDisplay"><%= candidateFee %></span></span>
                        </div>
                    </div>
                </div>
                <p style="color: #666; font-size: 13px;">
                    <strong>Note:</strong> This fee is charged when a user adds a new candidate to their account.
                    Currently hardcoded in: <code>WebContent/user/candidate-payment.jsp:34</code>
                </p>
            </div>
        </div>
        
        <!-- Subscription Plans -->
        <div class="card">
            <div class="card-header">
                <h3>📦 Subscription Plans</h3>
            </div>
            <div class="card-body">
                <% if (allPlans != null && !allPlans.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Plan ID</th>
                                <th>Plan Name</th>
                                <th>Type</th>
                                <th>Price</th>
                                <th>Duration</th>
                                <th>Max Candidates</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (SubscriptionPlan plan : allPlans) { %>
                                <tr>
                                    <td>#<%= plan.getPlanId() %></td>
                                    <td><strong><%= plan.getPlanName() %></strong></td>
                                    <td>
                                        <% 
                                            String type = plan.getPlanType();
                                            String typeClass = "badge-info";
                                            if ("monthly".equals(type)) typeClass = "badge-success";
                                            else if ("quarterly".equals(type)) typeClass = "badge-warning";
                                            else if ("yearly".equals(type)) typeClass = "badge-danger";
                                        %>
                                        <span class="badge <%= typeClass %>"><%= type != null ? type.toUpperCase() : "N/A" %></span>
                                    </td>
                                    <td>
                                        <span class="price-highlight">₹<%= String.format("%.2f", plan.getPriceDouble()) %></span>
                                    </td>
                                    <td><%= plan.getDurationDays() %> days</td>
                                    <td><%= plan.getMaxCandidates() %> candidates</td>
                                    <td>
                                        <% if (plan.isActive()) { %>
                                            <span class="badge badge-success">Active</span>
                                        <% } else { %>
                                            <span class="badge badge-danger">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <button class="btn btn-primary btn-sm" 
                                                onclick="editPlan(<%= plan.getPlanId() %>, '<%= plan.getPlanName() %>', <%= plan.getPriceDouble() %>)">
                                            ✏️ Edit
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <p style="text-align: center; padding: 40px; color: #999;">No subscription plans found</p>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Edit Subscription Plan Modal -->
    <div id="editPlanModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>✏️ Edit Subscription Plan</h2>
            </div>
            <form action="update-plan-action.jsp" method="post">
                <div class="modal-body">
                    <input type="hidden" name="planId" id="editPlanId">
                    <div class="form-group">
                        <label>Plan Name</label>
                        <input type="text" class="form-control" id="editPlanName" readonly>
                    </div>
                    <div class="form-group">
                        <label>New Price (₹)</label>
                        <input type="number" step="0.01" min="0" class="form-control" name="price" id="editPlanPrice" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-success btn-sm">💾 Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Edit Candidate Fee Modal -->
    <div id="editCandidateFeeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>✏️ Edit Candidate Registration Fee</h2>
            </div>
            <form action="update-candidate-fee-action.jsp" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label>Registration Fee Amount (₹)</label>
                        <input type="number" step="0.01" min="0" class="form-control" name="fee" id="editCandidateFeeInput" value="<%= candidateFee %>" required>
                    </div>
                    <p style="color: #666; font-size: 12px;">
                        <strong>Note:</strong> This will show you the update message. To make it permanent, update candidate-payment.jsp file.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm" onclick="closeCandidateFeeModal()">Cancel</button>
                    <button type="submit" class="btn btn-success btn-sm">💾 Update Fee</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function editPlan(planId, planName, price) {
            document.getElementById('editPlanId').value = planId;
            document.getElementById('editPlanName').value = planName;
            document.getElementById('editPlanPrice').value = price;
            document.getElementById('editPlanModal').classList.add('show');
        }
        
        function closeModal() {
            document.getElementById('editPlanModal').classList.remove('show');
        }
        
        function editCandidateFee() {
            document.getElementById('editCandidateFeeModal').classList.add('show');
        }
        
        function closeCandidateFeeModal() {
            document.getElementById('editCandidateFeeModal').classList.remove('show');
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const planModal = document.getElementById('editPlanModal');
            const feeModal = document.getElementById('editCandidateFeeModal');
            if (event.target == planModal) {
                closeModal();
            }
            if (event.target == feeModal) {
                closeCandidateFeeModal();
            }
        }
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.QRPayment" %>
<%@ page import="com.election.dao.QRPaymentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    QRPaymentDAO qrPaymentDAO = new QRPaymentDAO();
    
    // Get filter parameter
    String statusFilter = request.getParameter("status");
    if (statusFilter == null || statusFilter.trim().isEmpty()) {
        statusFilter = "pending";
    }
    
    // Get payments
    List<QRPayment> payments = qrPaymentDAO.getAllPayments(statusFilter);
    
    // Get counts
    int pendingCount = qrPaymentDAO.getPaymentCountByStatus("pending");
    int verifiedCount = qrPaymentDAO.getPaymentCountByStatus("verified");
    int rejectedCount = qrPaymentDAO.getPaymentCountByStatus("rejected");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify QR Payments - Admin Panel</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        .admin-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .page-header h1 {
            font-size: 28px;
            color: #2d3748;
            margin-bottom: 10px;
        }
        
        .page-header p {
            color: #718096;
            font-size: 14px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        
        .stat-card.pending {
            border-left-color: #ffc107;
        }
        
        .stat-card.verified {
            border-left-color: #28a745;
        }
        
        .stat-card.rejected {
            border-left-color: #dc3545;
        }
        
        .stat-label {
            font-size: 14px;
            color: #718096;
            margin-bottom: 8px;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #2d3748;
        }
        
        .filter-section {
            background: white;
            padding: 20px 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 10px 20px;
            border-radius: 6px;
            border: 2px solid #e2e8f0;
            background: white;
            color: #4a5568;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            font-size: 14px;
        }
        
        .filter-btn:hover {
            border-color: #667eea;
            color: #667eea;
        }
        
        .filter-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
        }
        
        .payments-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f7fafc;
        }
        
        th {
            padding: 15px 20px;
            text-align: left;
            font-weight: 600;
            color: #2d3748;
            font-size: 13px;
            text-transform: uppercase;
            border-bottom: 2px solid #e2e8f0;
        }
        
        td {
            padding: 15px 20px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
            color: #4a5568;
        }
        
        tr:hover {
            background: #f7fafc;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-verified {
            background: #d4edda;
            color: #155724;
        }
        
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }
        
        .btn-action {
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            font-size: 12px;
            margin-right: 5px;
            transition: all 0.3s;
        }
        
        .btn-verify {
            background: #28a745;
            color: white;
        }
        
        .btn-verify:hover {
            background: #218838;
        }
        
        .btn-reject {
            background: #dc3545;
            color: white;
        }
        
        .btn-reject:hover {
            background: #c82333;
        }
        
        .btn-view {
            background: #667eea;
            color: white;
        }
        
        .btn-view:hover {
            background: #5568d3;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .no-records {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }
        
        .no-records-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow: auto;
        }
        
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .modal-header {
            padding: 20px 30px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-body {
            padding: 30px;
        }
        
        .modal-footer {
            padding: 20px 30px;
            border-top: 1px solid #e2e8f0;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #000;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2d3748;
        }
        
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            resize: vertical;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .detail-label {
            font-weight: 600;
            color: #4a5568;
        }
        
        .detail-value {
            color: #2d3748;
        }
        
        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }
            
            th, td {
                padding: 10px;
            }
            
            .filter-section {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../includes/admin-navbar.jsp" %>
    
    <div class="admin-container">
        <div class="page-header">
            <h1>📱 Verify QR Code Payments</h1>
            <p>Review and approve pending QR code payment submissions</p>
        </div>
        
        <% 
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");
        if (message != null) {
            session.removeAttribute("message");
        %>
            <div class="alert alert-success">✓ <%= message %></div>
        <% } %>
        <% if (error != null) {
            session.removeAttribute("error");
        %>
            <div class="alert alert-error">⚠ <%= error %></div>
        <% } %>
        
        <div class="stats-grid">
            <div class="stat-card pending">
                <div class="stat-label">⏳ Pending Verification</div>
                <div class="stat-value"><%= pendingCount %></div>
            </div>
            <div class="stat-card verified">
                <div class="stat-label">✓ Verified Payments</div>
                <div class="stat-value"><%= verifiedCount %></div>
            </div>
            <div class="stat-card rejected">
                <div class="stat-label">✗ Rejected Payments</div>
                <div class="stat-value"><%= rejectedCount %></div>
            </div>
        </div>
        
        <div class="filter-section">
            <strong style="color: #2d3748;">Filter by Status:</strong>
            <a href="?status=pending" class="filter-btn <%= "pending".equals(statusFilter) ? "active" : "" %>">
                Pending (<%= pendingCount %>)
            </a>
            <a href="?status=verified" class="filter-btn <%= "verified".equals(statusFilter) ? "active" : "" %>">
                Verified (<%= verifiedCount %>)
            </a>
            <a href="?status=rejected" class="filter-btn <%= "rejected".equals(statusFilter) ? "active" : "" %>">
                Rejected (<%= rejectedCount %>)
            </a>
            <a href="?status=" class="filter-btn <%= statusFilter.isEmpty() ? "active" : "" %>">
                All Payments
            </a>
        </div>
        
        <div class="payments-table">
            <% if (payments.isEmpty()) { %>
                <div class="no-records">
                    <div class="no-records-icon">📭</div>
                    <h3>No <%= statusFilter %> payments found</h3>
                    <p>There are no QR code payments with status: <%= statusFilter %></p>
                </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>User</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Transaction ID</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (QRPayment payment : payments) { %>
                    <tr>
                        <td>#<%= payment.getPaymentId() %></td>
                        <td><%= dateFormat.format(payment.getSubmittedDate()) %></td>
                        <td>
                            <strong><%= payment.getUserFullName() %></strong><br>
                            <small><%= payment.getUserEmail() %></small>
                        </td>
                        <td>
                            <%= payment.getPaymentType() %><br>
                            <% if (payment.getPlanName() != null) { %>
                                <small><%= payment.getPlanName() %></small>
                            <% } %>
                            <% if (payment.getCandidateName() != null) { %>
                                <small><%= payment.getCandidateName() %></small>
                            <% } %>
                        </td>
                        <td><strong>₹<%= String.format("%.2f", payment.getAmount()) %></strong></td>
                        <td>
                            <code style="background: #f7fafc; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                                <%= payment.getTransactionId() %>
                            </code>
                        </td>
                        <td>
                            <span class="status-badge status-<%= payment.getPaymentStatus() %>">
                                <% if (payment.isPending()) { %>
                                    ⏳ Pending
                                <% } else if (payment.isVerified()) { %>
                                    ✓ Verified
                                <% } else { %>
                                    ✗ Rejected
                                <% } %>
                            </span>
                        </td>
                        <td>
                            <button class="btn-action btn-view" onclick="viewPayment(<%= payment.getPaymentId() %>)">
                                👁️ View
                            </button>
                            <% if (payment.isPending()) { %>
                                <button class="btn-action btn-verify" onclick="verifyPayment(<%= payment.getPaymentId() %>)">
                                    ✓ Verify
                                </button>
                                <button class="btn-action btn-reject" onclick="rejectPayment(<%= payment.getPaymentId() %>)">
                                    ✗ Reject
                                </button>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
    
    <!-- View Payment Modal -->
    <div id="viewModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Payment Details</h3>
                <span class="close" onclick="closeModal('viewModal')">&times;</span>
            </div>
            <div class="modal-body" id="viewModalBody">
                <!-- Content will be loaded dynamically -->
            </div>
        </div>
    </div>
    
    <!-- Verify Payment Modal -->
    <div id="verifyModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>✓ Verify Payment</h3>
                <span class="close" onclick="closeModal('verifyModal')">&times;</span>
            </div>
            <form action="<%=request.getContextPath()%>/qrpayment" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="verifyPayment">
                    <input type="hidden" name="paymentId" id="verifyPaymentId">
                    
                    <p>Are you sure you want to verify this payment? This will activate the user's account/candidate.</p>
                    
                    <div class="form-group">
                        <label>Admin Notes (Optional)</label>
                        <textarea name="notes" rows="3" placeholder="Add any notes about this verification..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-action btn-reject" onclick="closeModal('verifyModal')">Cancel</button>
                    <button type="submit" class="btn-action btn-verify">✓ Confirm Verification</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Reject Payment Modal -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>✗ Reject Payment</h3>
                <span class="close" onclick="closeModal('rejectModal')">&times;</span>
            </div>
            <form action="<%=request.getContextPath()%>/qrpayment" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="rejectPayment">
                    <input type="hidden" name="paymentId" id="rejectPaymentId">
                    
                    <p style="color: #dc3545; font-weight: 600;">⚠️ Are you sure you want to reject this payment?</p>
                    
                    <div class="form-group">
                        <label>Rejection Reason <span style="color: red;">*</span></label>
                        <textarea name="notes" rows="4" placeholder="Please provide a reason for rejection..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-action btn-view" onclick="closeModal('rejectModal')">Cancel</button>
                    <button type="submit" class="btn-action btn-reject">✗ Confirm Rejection</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function viewPayment(paymentId) {
            // For now, just show payment ID in modal
            // TODO: Create API endpoint to fetch payment details
            var html = '<div class="detail-row">';
            html += '<span class="detail-label">Payment ID:</span>';
            html += '<span class="detail-value">#' + paymentId + '</span>';
            html += '</div>';
            html += '<div class="detail-row">';
            html += '<span class="detail-label">Status:</span>';
            html += '<span class="detail-value">View details by verifying or rejecting the payment</span>';
            html += '</div>';
            html += '<p style="margin-top: 20px; color: #718096;">Full payment details will be available once the API endpoint is implemented.</p>';
            
            document.getElementById('viewModalBody').innerHTML = html;
            document.getElementById('viewModal').style.display = 'block';
        }
        
        function verifyPayment(paymentId) {
            document.getElementById('verifyPaymentId').value = paymentId;
            document.getElementById('verifyModal').style.display = 'block';
        }
        
        function rejectPayment(paymentId) {
            document.getElementById('rejectPaymentId').value = paymentId;
            document.getElementById('rejectModal').style.display = 'block';
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }
    </script>
</body>
</html>

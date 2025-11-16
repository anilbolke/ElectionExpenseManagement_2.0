<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO, com.election.dao.SystemSettingsDAO" %>
<%
    User user = (User) session.getAttribute("user");
    
    if(user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String candidateIdStr = request.getParameter("candidateId");
    if(candidateIdStr == null) {
        response.sendRedirect("manage-candidates.jsp?error=Invalid candidate");
        return;
    }
    
    int candidateId = Integer.parseInt(candidateIdStr);
    CandidateDAO candidateDAO = new CandidateDAO();
    Candidate candidate = candidateDAO.getCandidateById(candidateId);
    
    if(candidate == null || candidate.getUserId() != user.getUserId()) {
        response.sendRedirect("manage-candidates.jsp?error=Candidate not found");
        return;
    }
    
    // Check if already paid
    if("active".equals(candidate.getAccountStatus()) && candidate.isPaymentVerified()) {
        response.sendRedirect("manage-candidates.jsp?message=Payment already completed");
        return;
    }
    
    // Get registration fee
    SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
    double registrationFee = settingsDAO.getSettingAsDouble("candidate_registration_fee", 5000.00);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Options - Election Expense Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        .payment-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .payment-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .payment-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .payment-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        .payment-body {
            padding: 40px;
        }
        .amount-display {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            margin-bottom: 30px;
            border: 3px solid #667eea;
        }
        .amount-display .amount {
            font-size: 48px;
            font-weight: bold;
            color: #667eea;
        }
        .option-card {
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
        }
        .option-card:hover {
            border-color: #667eea;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }
        .option-card h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 22px;
        }
        .option-card p {
            color: #666;
            margin-bottom: 20px;
        }
        .btn-option {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border-radius: 10px;
            border: none;
            transition: all 0.3s;
        }
        .btn-payment {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-payment:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-license {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-license:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        .license-form {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .license-form.show {
            display: block;
        }
        .license-input {
            font-family: 'Courier New', monospace;
            font-size: 18px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 2px;
            padding: 15px;
            text-align: center;
        }
        .badge-recommended {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #ffc107;
            color: #000;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container payment-container">
        <div class="payment-card">
            <!-- Header -->
            <div class="payment-header">
                <h1><i class="fas fa-credit-card"></i> Payment Options</h1>
                <p>Choose your preferred payment method</p>
            </div>
            
            <!-- Body -->
            <div class="payment-body">
                <!-- Success/Error Messages -->
                <% 
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <!-- Amount Display -->
                <div class="amount-display">
                    <div style="color: #666; font-size: 16px; margin-bottom: 10px;">Registration Fee</div>
                    <div class="amount">₹ <%= String.format("%.2f", registrationFee) %></div>
                    <div style="color: #666; font-size: 14px; margin-top: 10px;">
                        For: <%= candidate.getCandidateName() %>
                    </div>
                </div>
                
                <!-- Option 1: Regular Payment -->
                <div class="option-card">
                    <span class="badge-recommended">RECOMMENDED</span>
                    <h3><i class="fas fa-qrcode"></i> Pay with QR Code</h3>
                    <p>Scan QR code and make payment using UPI, Net Banking, or any payment app</p>
                    <a href="<%= request.getContextPath() %>/qr-payment.jsp?paymentType=candidate&candidateId=<%= candidateId %>&amount=<%= registrationFee %>" 
                       class="btn btn-option btn-payment">
                        <i class="fas fa-arrow-right"></i> Proceed to Payment
                    </a>
                </div>
                
                <!-- Option 2: License -->
                <div class="option-card">
                    <h3><i class="fas fa-key"></i> Already Have a License?</h3>
                    <p>If you have a valid license key, you can bypass the payment process</p>
                    <button type="button" class="btn btn-option btn-license" onclick="toggleLicenseForm()">
                        <i class="fas fa-unlock"></i> Use License Key
                    </button>
                    
                    <!-- License Form -->
                    <div id="licenseForm" class="license-form">
                        <form action="<%= request.getContextPath() %>/LicenseServlet" method="post">
                            <input type="hidden" name="action" value="verify">
                            <input type="hidden" name="candidateId" value="<%= candidateId %>">
                            
                            <div class="mb-3">
                                <label for="licenseKey" class="form-label">
                                    <i class="fas fa-key"></i> Enter Your License Key
                                </label>
                                <input type="text" 
                                       class="form-control license-input" 
                                       id="licenseKey" 
                                       name="licenseKey" 
                                       placeholder="EMS12345" 
                                       required
                                       maxlength="8"
                                       pattern="EMS[0-9]{5}"
                                       title="License key must start with EMS followed by 5 digits">
                                <small class="form-text text-muted">
                                    Format: EMS followed by 5 digits (e.g., EMS12345)
                                </small>
                            </div>
                            
                            <button type="submit" class="btn btn-option btn-license">
                                <i class="fas fa-check-circle"></i> Verify & Activate
                            </button>
                        </form>
                    </div>
                </div>
                
                <!-- Back Button -->
                <div class="text-center mt-4">
                    <a href="manage-candidates.jsp" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Candidates
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleLicenseForm() {
            const form = document.getElementById('licenseForm');
            form.classList.toggle('show');
            
            if (form.classList.contains('show')) {
                document.getElementById('licenseKey').focus();
            }
        }
        
        // Auto-format license key input
        document.getElementById('licenseKey').addEventListener('input', function(e) {
            let value = e.target.value.toUpperCase();
            
            // Remove any non-alphanumeric characters
            value = value.replace(/[^A-Z0-9]/g, '');
            
            // Ensure it starts with EMS
            if (value && !value.startsWith('EMS')) {
                if (value.startsWith('E')) {
                    value = 'EMS' + value.substring(1);
                } else if (value.startsWith('EM')) {
                    value = 'EMS' + value.substring(2);
                } else {
                    value = 'EMS' + value;
                }
            }
            
            // Limit to 8 characters (EMS + 5 digits)
            value = value.substring(0, 8);
            
            e.target.value = value;
        });
    </script>
</body>
</html>

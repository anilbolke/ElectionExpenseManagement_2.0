<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO" %>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.i18n.LocaleManager" %>
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
    
    String error = request.getParameter("error");
    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Candidate - Election Expense Management System</title>
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
        
        /* Navbar Styles */
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }
        
        .navbar-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            height: 70px;
        }
        
        .navbar-brand {
            font-size: 24px;
            font-weight: 800;
            color: white;
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        
        .navbar-menu {
            display: flex;
            list-style: none;
            gap: 5px;
            margin: 0;
            padding: 0;
        }
        
        .navbar-menu li a {
            color: white;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 6px;
            font-weight: 500;
            transition: background 0.3s;
            display: block;
        }
        
        .navbar-menu li a:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
        }
        
        .user-info span {
            font-weight: 500;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            padding: 100px 30px 40px;
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .main-content h1 {
            color: #1a202c;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 30px;
        }
        
        /* Alert Styles */
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .alert-danger {
            background: #fee;
            color: #c33;
            border-left: 4px solid #c33;
        }
        
        .alert-success {
            background: #efe;
            color: #3c3;
            border-left: 4px solid #3c3;
        }
        
        /* Form Styles */
        .form-section {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 25px;
            padding-bottom: 12px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 5px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #4a5568;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }
        
        /* Button Styles */
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 15px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .btn-danger {
            background: #f56565;
            color: white;
        }
        
        .btn-danger:hover {
            background: #e53e3e;
        }
        
        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
        }
        
        /* Footer Styles */
        footer {
            background: #2d3748;
            color: #e2e8f0;
            padding: 25px 30px;
            text-align: center;
            margin-top: auto;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
        }
        
        footer p {
            margin: 0;
            font-size: 14px;
            font-weight: 500;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar-content {
                flex-wrap: wrap;
                height: auto;
                padding: 15px 20px;
            }
            
            .navbar-menu {
                order: 3;
                width: 100%;
                flex-direction: column;
                margin-top: 15px;
                gap: 5px;
            }
            
            .main-content {
                padding: 140px 20px 30px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-section {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🗳️ EEM</div>
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
    
    <div class="main-content">
        <h1 style="margin-bottom: 30px;">Edit Candidate</h1>
        
        <% if(error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <% if(message != null) { %>
            <div class="alert alert-success"><%= message %></div>
        <% } %>
        
        <form action="<%=request.getContextPath()%>/candidate" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="updateCandidate">
            <input type="hidden" name="candidateId" value="<%= candidate.getCandidateId() %>">
            
            <!-- Personal Information -->
            <div class="form-section">
                <div class="section-title">📋 Personal Information</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="candidateName">Candidate Name *</label>
                        <input type="text" class="form-control" id="candidateName" name="candidateName" value="<%= candidate.getCandidateName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="fatherName">Father's Name *</label>
                        <input type="text" class="form-control" id="fatherName" name="fatherName" value="<%= candidate.getFatherName() != null ? candidate.getFatherName() : "" %>" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="age">Age *</label>
                        <input type="number" class="form-control" id="age" name="age" min="25" max="100" value="<%= candidate.getAge() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select class="form-control" id="gender" name="gender">
                            <option value="">Select Gender</option>
                            <option value="Male" <%= "Male".equals(candidate.getGender()) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equals(candidate.getGender()) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= "Other".equals(candidate.getGender()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="mobile">Mobile</label>
                        <input type="tel" class="form-control" id="mobile" name="mobile" pattern="[0-9]{10}" value="<%= candidate.getMobile() != null ? candidate.getMobile() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="<%= candidate.getEmail() != null ? candidate.getEmail() : "" %>">
                    </div>
                </div>
            </div>
            
            <!-- Address Information -->
            <div class="form-section">
                <div class="section-title">📍 Address Information</div>
                <div class="form-group">
                    <label for="address">Address *</label>
                    <textarea class="form-control" id="address" name="address" rows="2" required><%= candidate.getAddress() != null ? candidate.getAddress() : "" %></textarea>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="city">City *</label>
                        <input type="text" class="form-control" id="city" name="city" value="<%= candidate.getCity() != null ? candidate.getCity() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="state">State *</label>
                        <input type="text" class="form-control" id="state" name="state" value="<%= candidate.getState() != null ? candidate.getState() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="pincode">Pincode *</label>
                        <input type="text" class="form-control" id="pincode" name="pincode" pattern="[0-9]{6}" value="<%= candidate.getPincode() != null ? candidate.getPincode() : "" %>" required>
                    </div>
                </div>
            </div>
            
            <!-- Identity Documents -->
            <div class="form-section">
                <div class="section-title">🆔 Identity Documents</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="aadharNumber">Aadhar Number *</label>
                        <input type="text" class="form-control" id="aadharNumber" name="aadharNumber" pattern="[0-9]{12}" value="<%= candidate.getAadharNumber() != null ? candidate.getAadharNumber() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="voterId">Voter ID *</label>
                        <input type="text" class="form-control" id="voterId" name="voterId" value="<%= candidate.getVoterId() != null ? candidate.getVoterId() : "" %>" required>
                    </div>
                </div>
            </div>
            
            <!-- Election Details -->
            <div class="form-section">
                <div class="section-title">🗳️ Election Details</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="constituency">Constituency *</label>
                        <input type="text" class="form-control" id="constituency" name="constituency" value="<%= candidate.getConstituency() != null ? candidate.getConstituency() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="nominationId">Nomination ID *</label>
                        <input type="text" class="form-control" id="nominationId" name="nominationId" value="<%= candidate.getNominationId() != null ? candidate.getNominationId() : "" %>" required maxlength="50">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="electionType">Election Type *</label>
                        <select class="form-control" id="electionType" name="electionType" required>
                            <option value="">Select Election Type</option>
                            <option value="Lok Sabha (General / Parliamentary) elections" <%= "Lok Sabha (General / Parliamentary) elections".equals(candidate.getElectionType()) ? "selected" : "" %>>Lok Sabha (General / Parliamentary) elections</option>
                            <option value="State Legislative Assembly (Vidhan Sabha) elections" <%= "State Legislative Assembly (Vidhan Sabha) elections".equals(candidate.getElectionType()) ? "selected" : "" %>>State Legislative Assembly (Vidhan Sabha) elections</option>
                            <option value="Rajya Sabha elections (for upper house of Parliament)" <%= "Rajya Sabha elections (for upper house of Parliament)".equals(candidate.getElectionType()) ? "selected" : "" %>>Rajya Sabha elections (for upper house of Parliament)</option>
                            <option value="State Legislative Council (Vidhan Parishad) elections (in states which have them)" <%= "State Legislative Council (Vidhan Parishad) elections (in states which have them)".equals(candidate.getElectionType()) ? "selected" : "" %>>State Legislative Council (Vidhan Parishad) elections (in states which have them)</option>
                            <option value="Municipal / Local body elections (Municipal Corporation, Municipality, Nagar Panchayat)" <%= "Municipal / Local body elections (Municipal Corporation, Municipality, Nagar Panchayat)".equals(candidate.getElectionType()) ? "selected" : "" %>>Municipal / Local body elections (Municipal Corporation, Municipality, Nagar Panchayat)</option>
                            <option value="Panchayat elections (Gram Panchayat, Panchayat Samiti, Zilla Parishad)" <%= "Panchayat elections (Gram Panchayat, Panchayat Samiti, Zilla Parishad)".equals(candidate.getElectionType()) ? "selected" : "" %>>Panchayat elections (Gram Panchayat, Panchayat Samiti, Zilla Parishad)</option>
                            <option value="By-elections (to fill vacancies in Lok Sabha, State Assembly etc.)" <%= "By-elections (to fill vacancies in Lok Sabha, State Assembly etc.)".equals(candidate.getElectionType()) ? "selected" : "" %>>By-elections (to fill vacancies in Lok Sabha, State Assembly etc.)</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="partyName">Party Name *</label>
                        <input type="text" class="form-control" id="partyName" name="partyName" value="<%= candidate.getPartyName() != null ? candidate.getPartyName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="partySymbol">Party Symbol</label>
                        <input type="text" class="form-control" id="partySymbol" name="partySymbol" value="<%= candidate.getPartySymbol() != null ? candidate.getPartySymbol() : "" %>">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="electionDate">Election Date</label>
                        <input type="date" class="form-control" id="electionDate" name="electionDate" value="<%= candidate.getElectionDate() != null ? candidate.getElectionDate().toString() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="boothNumber">Ward/Prabhag/ZP/PS/VS/LS Number</label>
                        <input type="text" class="form-control" id="boothNumber" name="boothNumber" value="<%= candidate.getBoothNumber() != null ? candidate.getBoothNumber() : "" %>">
                    </div>
                </div>
            </div>
            
            <div class="form-actions">
                <a href="manage-candidates.jsp" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Update Candidate</button>
            </div>
        </form>
    </div>
    
    <footer>
        <p>&copy; 2024 Election Expense Management System. All Rights Reserved.</p>
    </footer>
    
    <script>
        function validateForm() {
            const age = document.getElementById('age').value;
            if(age < 25) {
                alert('Candidate age must be at least 25 years.');
                return false;
            }
            
            const mobile = document.getElementById('mobile').value;
            if(mobile && mobile.length !== 10) {
                alert('Please enter a valid 10-digit mobile number.');
                return false;
            }
            
            const aadhar = document.getElementById('aadharNumber').value;
            if(aadhar.length !== 12) {
                alert('Please enter a valid 12-digit Aadhar number.');
                return false;
            }
            
            const pincode = document.getElementById('pincode').value;
            if(pincode.length !== 6) {
                alert('Please enter a valid 6-digit pincode.');
                return false;
            }
            
            const nominationId = document.getElementById('nominationId').value;
            if(nominationId.length < 3) {
                alert('Nomination ID must be at least 3 characters.');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>

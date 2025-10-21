<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.model.Candidate" %>
<%@ page import="com.election.dao.CandidateDAO" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Candidate - Election Expense Management</title>
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
        <h1 style="margin-bottom: 30px;">Edit Candidate Details</h1>
        
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
                        <label for="mobile">Mobile Number</label>
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
                <div class="section-title">🗳️ Election Program Details</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="constituency">Constituency *</label>
                        <input type="text" class="form-control" id="constituency" name="constituency" value="<%= candidate.getConstituency() != null ? candidate.getConstituency() : "" %>" required>
                    </div>
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
                        <label for="boothNumber">Booth Number</label>
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
    
    <script>
        function validateForm() {
            const age = document.getElementById('age').value;
            if(age < 25) {
                alert('Candidate must be at least 25 years old.');
                return false;
            }
            
            const mobile = document.getElementById('mobile').value;
            if(mobile && mobile.length !== 10) {
                alert('Please enter a valid 10 digit mobile number.');
                return false;
            }
            
            const aadhar = document.getElementById('aadharNumber').value;
            if(aadhar.length !== 12) {
                alert('Please enter a valid 12 digit Aadhar number.');
                return false;
            }
            
            const pincode = document.getElementById('pincode').value;
            if(pincode.length !== 6) {
                alert('Please enter a valid 6 digit pincode.');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>

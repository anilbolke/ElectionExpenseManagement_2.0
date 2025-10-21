<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User" %>
<%@ page import="com.election.dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"user".equals(user.getUserRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    UserDAO userDAO = new UserDAO();
    List<User> brokers = userDAO.getAllBrokers();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile - Candidate Registration</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="dashboard">
        <div class="navbar">
            <div class="navbar-brand">Election Expense Management</div>
            <div>
                <span style="color: #000;">Welcome, <%= user.getFullName() %></span> |
                <a href="../logout">Logout</a>
            </div>
        </div>
        
        <div class="container">
            <div class="card">
                <h2 class="card-title">Complete Your Candidate Profile</h2>
                <p style="text-align: center; color: #000; margin-bottom: 20px;">Please fill in all the details to complete your registration</p>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <form action="../candidate" method="post">
                    <input type="hidden" name="action" value="create">
                    
                    <h3 style="color: #667eea; margin-top: 20px;">Personal Details</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="candidateName">Candidate Name: *</label>
                                <input type="text" id="candidateName" name="candidateName" class="form-control" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="fatherName">Father's Name:</label>
                                <input type="text" id="fatherName" name="fatherName" class="form-control">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="age">Age:</label>
                                <input type="number" id="age" name="age" class="form-control" min="18" max="120">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="aadharNumber">Aadhar Number:</label>
                                <input type="text" id="aadharNumber" name="aadharNumber" class="form-control" maxlength="12" pattern="[0-9]{12}">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="voterId">Voter ID:</label>
                                <input type="text" id="voterId" name="voterId" class="form-control">
                            </div>
                        </div>
                    </div>
                    
                    <h3 style="color: #667eea; margin-top: 20px;">Address Details</h3>
                    <div class="form-group">
                        <label for="address">Address: *</label>
                        <textarea id="address" name="address" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="city">City: *</label>
                                <input type="text" id="city" name="city" class="form-control" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="state">State: *</label>
                                <input type="text" id="state" name="state" class="form-control" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="pincode">Pincode:</label>
                                <input type="text" id="pincode" name="pincode" class="form-control" maxlength="6" pattern="[0-9]{6}">
                            </div>
                        </div>
                    </div>
                    
                    <h3 style="color: #667eea; margin-top: 20px;">Election Program Details</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="constituency">Constituency:</label>
                                <input type="text" id="constituency" name="constituency" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="partyName">Party Name:</label>
                                <input type="text" id="partyName" name="partyName" class="form-control">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="partySymbol">Party Symbol:</label>
                                <input type="text" id="partySymbol" name="partySymbol" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="electionType">Election Type:</label>
                                <select id="electionType" name="electionType" class="form-control">
                                    <option value="">Select Type</option>
                                    <option value="Assembly">Assembly</option>
                                    <option value="Parliamentary">Parliamentary</option>
                                    <option value="Local">Local</option>
                                    <option value="Panchayat">Panchayat</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="electionDate">Election Date:</label>
                                <input type="date" id="electionDate" name="electionDate" class="form-control">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="boothNumber">Booth Number:</label>
                                <input type="text" id="boothNumber" name="boothNumber" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="brokerId">Select Broker (Optional):</label>
                                <select id="brokerId" name="brokerId" class="form-control">
                                    <option value="">No Broker</option>
                                    <% for(User broker : brokers) { %>
                                        <option value="<%= broker.getUserId() %>"><%= broker.getFullName() %> - <%= broker.getMobile() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">Submit & Proceed to Payment</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>

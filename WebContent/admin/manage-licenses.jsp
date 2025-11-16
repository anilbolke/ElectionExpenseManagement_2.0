<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get license statistics
    LicenseDAO licenseDAO = new LicenseDAO();
    List<License> allLicenses = licenseDAO.getAllLicenses();
    int totalLicenses = allLicenses != null ? allLicenses.size() : 0;
    int unusedLicenses = licenseDAO.getUnusedLicensesCount();
    int usedLicenses = licenseDAO.getUsedLicensesCount();
    
    // Get recently generated licenses from session
    @SuppressWarnings("unchecked")
    List<String> generatedLicenses = (List<String>) session.getAttribute("generatedLicenses");
    if (generatedLicenses != null) {
        session.removeAttribute("generatedLicenses");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Licenses - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .main-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            padding: 30px;
            margin: 20px auto;
            max-width: 1200px;
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
        }
        .stats-card h3 {
            font-size: 2.5rem;
            margin-bottom: 5px;
        }
        .stats-card p {
            margin: 0;
            font-size: 1rem;
        }
        .license-key {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            color: #667eea;
            background: #f0f4ff;
            padding: 5px 10px;
            border-radius: 5px;
            display: inline-block;
        }
        .table-hover tbody tr:hover {
            background-color: #f0f4ff;
        }
        .btn-generate {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            font-size: 1rem;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        .badge-unused {
            background-color: #28a745;
            padding: 5px 10px;
        }
        .badge-used {
            background-color: #dc3545;
            padding: 5px 10px;
        }
        .copy-btn {
            cursor: pointer;
            margin-left: 5px;
            color: #667eea;
        }
        .copy-btn:hover {
            color: #764ba2;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-container">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-key"></i> License Management</h2>
                <a href="dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
            
            <!-- Success/Error Messages -->
            <% 
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null) {
            %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } 
                if (error != null) {
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <!-- Statistics with Download Button -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><%= totalLicenses %></h3>
                        <p><i class="fas fa-key"></i> Total Licenses</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                        <h3><%= unusedLicenses %></h3>
                        <p><i class="fas fa-check-circle"></i> Available</p>
                        <% if (unusedLicenses > 0) { %>
                        <div class="mt-2">
                            <a href="<%= request.getContextPath() %>/ExportLicensesServlet?format=excel" 
                               class="btn btn-sm btn-light" 
                               style="font-size: 12px;">
                                <i class="fas fa-file-excel"></i> Download Excel
                            </a>
                        </div>
                        <% } %>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
                        <h3><%= usedLicenses %></h3>
                        <p><i class="fas fa-times-circle"></i> Used</p>
                    </div>
                </div>
            </div>
            
            <!-- Export Unused Licenses Section -->
            <% if (unusedLicenses > 0) { %>
            <div class="card mb-4" style="border-left: 4px solid #28a745;">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5 class="mb-1"><i class="fas fa-download text-success"></i> Export Unused Licenses</h5>
                            <p class="mb-0 text-muted">Download <%= unusedLicenses %> available licenses that have not been assigned to any user yet.</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="<%= request.getContextPath() %>/ExportLicensesServlet?format=excel" 
                               class="btn btn-success">
                                <i class="fas fa-file-excel"></i> Download Excel
                            </a>
                            <a href="<%= request.getContextPath() %>/ExportLicensesServlet?format=csv" 
                               class="btn btn-outline-success">
                                <i class="fas fa-file-csv"></i> Download CSV
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
            
            <!-- Generate Licenses Form -->
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Generate New Licenses</h5>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/LicenseServlet" method="post" class="row g-3">
                        <input type="hidden" name="action" value="generate">
                        <div class="col-md-8">
                            <label for="count" class="form-label">Number of Licenses to Generate</label>
                            <input type="number" class="form-control" id="count" name="count" 
                                   min="1" max="1000" value="10" required>
                            <small class="form-text text-muted">Enter a number between 1 and 1000</small>
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <button type="submit" class="btn btn-generate w-100">
                                <i class="fas fa-magic"></i> Generate Licenses
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Recently Generated Licenses -->
            <% if (generatedLicenses != null && !generatedLicenses.isEmpty()) { %>
            <div class="card mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-check-circle"></i> Recently Generated Licenses</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> Copy and distribute these licenses to users. They will not be shown again.
                    </div>
                    <div class="row">
                        <% for (String key : generatedLicenses) { %>
                        <div class="col-md-4 mb-2">
                            <div class="license-key">
                                <%= key %>
                                <i class="fas fa-copy copy-btn" onclick="copyToClipboard('<%= key %>')"></i>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
            
            <!-- All Licenses Table -->
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-list"></i> All Licenses</h5>
                </div>
                <div class="card-body">
                    <% if (allLicenses != null && !allLicenses.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>License Key</th>
                                    <th>Status</th>
                                    <th>Generated Date</th>
                                    <th>Generated By</th>
                                    <th>Mapped To</th>
                                    <th>Candidate</th>
                                    <th>Used Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (License license : allLicenses) { %>
                                <tr>
                                    <td>
                                        <span class="license-key">
                                            <%= license.getLicenseKey() %>
                                            <i class="fas fa-copy copy-btn" onclick="copyToClipboard('<%= license.getLicenseKey() %>')"></i>
                                        </span>
                                    </td>
                                    <td>
                                        <% if ("active".equals(license.getStatus())) { %>
                                            <span class="badge badge-unused">Available</span>
                                        <% } else { %>
                                            <span class="badge badge-used">Used</span>
                                        <% } %>
                                    </td>
                                    <td><%= license.getGeneratedDate() != null ? 
                                        new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(license.getGeneratedDate()) : "-" %></td>
                                    <td><%= license.getGeneratedByName() != null ? license.getGeneratedByName() : "-" %></td>
                                    <td><%= license.getMappedUserName() != null ? license.getMappedUserName() : "-" %></td>
                                    <td><%= license.getMappedCandidateName() != null ? license.getMappedCandidateName() : "-" %></td>
                                    <td><%= license.getUsedDate() != null ? 
                                        new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(license.getUsedDate()) : "-" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i> No licenses generated yet. Generate some licenses to get started.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(function() {
                // Show temporary success message
                const btn = event.target;
                const originalClass = btn.className;
                btn.className = 'fas fa-check copy-btn';
                btn.style.color = '#28a745';
                
                setTimeout(function() {
                    btn.className = originalClass;
                    btn.style.color = '';
                }, 1000);
            }).catch(function(err) {
                alert('Failed to copy: ' + err);
            });
        }
    </script>
</body>
</html>

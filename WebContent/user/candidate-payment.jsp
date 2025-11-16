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
    
    // Get registration fee and check payment modes
    SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
    double registrationFee = settingsDAO.getSettingAsDouble("candidate_registration_fee", 5000.00);
    
    // Check which payment method is enabled (Priority: Cashfree Local MCP > Cashfree > QR)
    String cashfreeLocalMCPEnabledStr = settingsDAO.getSetting("cashfree_local_mcp_enabled", "false");
    String cashfreeEnabledStr = settingsDAO.getSetting("cashfree_enabled", "false");
    String qrEnabledStr = settingsDAO.getSetting("qr_payment_enabled", "true");
    
    boolean cashfreeLocalMCPEnabled = "true".equalsIgnoreCase(cashfreeLocalMCPEnabledStr);
    boolean cashfreeEnabled = "true".equalsIgnoreCase(cashfreeEnabledStr);
    boolean qrEnabled = "true".equalsIgnoreCase(qrEnabledStr);
    
    // Redirect to payment options page (includes both QR payment and license option)
    response.sendRedirect(request.getContextPath() + "/user/payment-with-license.jsp?candidateId=" + candidateId);
%>

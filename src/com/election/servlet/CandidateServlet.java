package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.model.Candidate;
import com.election.model.User;
import com.election.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.UUID;

public class CandidateServlet extends HttpServlet {
    
    private CandidateDAO candidateDAO;
    
    @Override
    public void init() throws ServletException {
        candidateDAO = new CandidateDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createCandidateProfile(request, response);
        } else if ("update".equals(action)) {
            updateCandidateProfile(request, response);
        } else if ("addCandidate".equals(action)) {
            addNewCandidate(request, response);
        } else if ("selectCandidate".equals(action)) {
            selectCandidate(request, response);
        } else if ("processPayment".equals(action)) {
            processPayment(request, response);
        } else if ("updateCandidate".equals(action)) {
            updateCandidateDetails(request, response);
        }
    }
    
    private void createCandidateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null || user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String candidateName = request.getParameter("candidateName");
        String fatherName = request.getParameter("fatherName");
        String ageStr = request.getParameter("age");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String aadharNumber = request.getParameter("aadharNumber");
        String voterId = request.getParameter("voterId");
        String constituency = request.getParameter("constituency");
        String partyName = request.getParameter("partyName");
        String partySymbol = request.getParameter("partySymbol");
        String electionType = request.getParameter("electionType");
        String electionDateStr = request.getParameter("electionDate");
        String boothNumber = request.getParameter("boothNumber");
        
        // Validation
        if (!ValidationUtil.isNotEmpty(candidateName) || !ValidationUtil.isNotEmpty(address) ||
            !ValidationUtil.isNotEmpty(city) || !ValidationUtil.isNotEmpty(state)) {
            request.setAttribute("error", "Required fields cannot be empty");
            request.getRequestDispatcher("user/complete-profile.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidPincode(pincode)) {
            request.setAttribute("error", "Invalid pincode");
            request.getRequestDispatcher("user/complete-profile.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidAadhar(aadharNumber)) {
            request.setAttribute("error", "Invalid Aadhar number");
            request.getRequestDispatcher("user/complete-profile.jsp").forward(request, response);
            return;
        }
        
        // Create candidate object
        Candidate candidate = new Candidate();
        candidate.setUserId(userId);
        candidate.setCandidateName(candidateName);
        candidate.setFatherName(fatherName);
        
        try {
            candidate.setAge(Integer.parseInt(ageStr));
        } catch (NumberFormatException e) {
            candidate.setAge(0);
        }
        
        candidate.setAddress(address);
        candidate.setCity(city);
        candidate.setState(state);
        candidate.setPincode(pincode);
        candidate.setAadharNumber(aadharNumber);
        candidate.setVoterId(voterId);
        candidate.setConstituency(constituency);
        candidate.setPartyName(partyName);
        candidate.setPartySymbol(partySymbol);
        candidate.setElectionType(electionType);
        
        if (electionDateStr != null && !electionDateStr.isEmpty()) {
            candidate.setElectionDate(Date.valueOf(electionDateStr));
        }
        
        candidate.setBoothNumber(boothNumber);
        
        // Inherit broker_id from user (if user was registered through a broker)
        candidate.setBrokerId(user.getBrokerId());
        
        // Save candidate
        int candidateId = candidateDAO.createCandidate(candidate);
        
        if (candidateId > 0) {
            candidate.setCandidateId(candidateId);
            session.setAttribute("candidate", candidate);
            session.setAttribute("candidateId", candidateId);
            
            // Redirect to payment page
            response.sendRedirect("user/payment-required.jsp");
        } else {
            request.setAttribute("error", "Failed to create profile. Please try again.");
            request.getRequestDispatcher("user/complete-profile.jsp").forward(request, response);
        }
    }
    
    private void updateCandidateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer candidateId = (Integer) session.getAttribute("candidateId");
        
        if (candidateId == null) {
            response.sendRedirect("user/dashboard.jsp");
            return;
        }
        
        Candidate candidate = candidateDAO.getCandidateById(candidateId);
        if (candidate == null) {
            response.sendRedirect("user/dashboard.jsp");
            return;
        }
        
        // Update candidate details
        candidate.setCandidateName(request.getParameter("candidateName"));
        candidate.setFatherName(request.getParameter("fatherName"));
        
        try {
            candidate.setAge(Integer.parseInt(request.getParameter("age")));
        } catch (NumberFormatException e) {
            // Keep existing age
        }
        
        candidate.setAddress(request.getParameter("address"));
        candidate.setCity(request.getParameter("city"));
        candidate.setState(request.getParameter("state"));
        candidate.setPincode(request.getParameter("pincode"));
        candidate.setAadharNumber(request.getParameter("aadharNumber"));
        candidate.setVoterId(request.getParameter("voterId"));
        candidate.setConstituency(request.getParameter("constituency"));
        candidate.setPartyName(request.getParameter("partyName"));
        candidate.setPartySymbol(request.getParameter("partySymbol"));
        candidate.setElectionType(request.getParameter("electionType"));
        
        String electionDateStr = request.getParameter("electionDate");
        if (electionDateStr != null && !electionDateStr.isEmpty()) {
            candidate.setElectionDate(Date.valueOf(electionDateStr));
        }
        
        candidate.setBoothNumber(request.getParameter("boothNumber"));
        
        if (candidateDAO.updateCandidate(candidate)) {
            session.setAttribute("candidate", candidate);
            request.setAttribute("success", "Profile updated successfully");
        } else {
            request.setAttribute("error", "Failed to update profile");
        }
        
        request.getRequestDispatcher("user/profile.jsp").forward(request, response);
    }
    
    // Add new candidate by existing user
    private void addNewCandidate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String candidateName = request.getParameter("candidateName");
        String fatherName = request.getParameter("fatherName");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String aadharNumber = request.getParameter("aadharNumber");
        String voterId = request.getParameter("voterId");
        String constituency = request.getParameter("constituency");
        String nominationId = request.getParameter("nominationId");
        String partyName = request.getParameter("partyName");
        String partySymbol = request.getParameter("partySymbol");
        String electionType = request.getParameter("electionType");
        String electionDateStr = request.getParameter("electionDate");
        String boothNumber = request.getParameter("boothNumber");
        
        // Validation
        if (!ValidationUtil.isNotEmpty(candidateName) || !ValidationUtil.isNotEmpty(address) ||
            !ValidationUtil.isNotEmpty(city) || !ValidationUtil.isNotEmpty(state)) {
            response.sendRedirect("user/add-candidate.jsp?error=Required fields cannot be empty");
            return;
        }
        
        if (!ValidationUtil.isValidPincode(pincode)) {
            response.sendRedirect("user/add-candidate.jsp?error=Invalid pincode");
            return;
        }
        
        if (!ValidationUtil.isValidAadhar(aadharNumber)) {
            response.sendRedirect("user/add-candidate.jsp?error=Invalid Aadhar number");
            return;
        }
        
        // Create candidate object
        Candidate candidate = new Candidate();
        candidate.setUserId(user.getUserId());
        candidate.setCandidateName(candidateName);
        candidate.setFatherName(fatherName);
        candidate.setGender(gender);
        candidate.setMobile(mobile);
        candidate.setEmail(email);
        
        try {
            candidate.setAge(Integer.parseInt(ageStr));
        } catch (NumberFormatException e) {
            candidate.setAge(0);
        }
        
        candidate.setAddress(address);
        candidate.setCity(city);
        candidate.setState(state);
        candidate.setPincode(pincode);
        candidate.setAadharNumber(aadharNumber);
        candidate.setVoterId(voterId);
        candidate.setConstituency(constituency);
        candidate.setNominationId(nominationId);
        candidate.setPartyName(partyName);
        candidate.setPartySymbol(partySymbol);
        candidate.setElectionType(electionType);
        
        if (electionDateStr != null && !electionDateStr.isEmpty()) {
            candidate.setElectionDate(Date.valueOf(electionDateStr));
        }
        
        candidate.setBoothNumber(boothNumber);
        candidate.setBrokerId(user.getBrokerId()); // Inherit broker from user
        
        // Save candidate
        int candidateId = candidateDAO.createCandidate(candidate);
        
        if (candidateId > 0) {
            // Redirect to payment page for this candidate
            response.sendRedirect("user/candidate-payment.jsp?candidateId=" + candidateId);
        } else {
            response.sendRedirect("user/add-candidate.jsp?error=Failed to create candidate. Please try again.");
        }
    }
    
    // Select a candidate to work with
    private void selectCandidate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String candidateIdStr = request.getParameter("candidateId");
        if (candidateIdStr == null) {
            response.sendRedirect("user/manage-candidates.jsp?error=Invalid candidate");
            return;
        }
        
        int candidateId = Integer.parseInt(candidateIdStr);
        Candidate candidate = candidateDAO.getCandidateById(candidateId);
        
        // Verify candidate belongs to this user
        if (candidate == null || candidate.getUserId() != user.getUserId()) {
            response.sendRedirect("user/manage-candidates.jsp?error=Candidate not found");
            return;
        }
        
        // Verify payment is completed
        if (!"active".equals(candidate.getAccountStatus()) || !candidate.isPaymentVerified()) {
            response.sendRedirect("user/manage-candidates.jsp?error=Please complete payment first");
            return;
        }
        
        // Set this candidate as selected
        session.setAttribute("candidate", candidate);
        session.setAttribute("candidateId", candidateId);
        
        // Redirect to dashboard
        response.sendRedirect("user/dashboard.jsp");
    }
    
    // Process payment for candidate registration
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String candidateIdStr = request.getParameter("candidateId");
        String amountStr = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        
        if (candidateIdStr == null || amountStr == null || paymentMethod == null) {
            response.sendRedirect("user/manage-candidates.jsp?error=Invalid payment details");
            return;
        }
        
        int candidateId = Integer.parseInt(candidateIdStr);
        double amount = Double.parseDouble(amountStr);
        
        Candidate candidate = candidateDAO.getCandidateById(candidateId);
        
        // Verify candidate belongs to this user
        if (candidate == null || candidate.getUserId() != user.getUserId()) {
            response.sendRedirect("user/manage-candidates.jsp?error=Candidate not found");
            return;
        }
        
        // Generate transaction ID
        String transactionId = "TXN" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        // Update candidate with payment details
        candidate.setPaymentStatus("completed");
        candidate.setPaymentAmount(BigDecimal.valueOf(amount));
        candidate.setPaymentDate(new Timestamp(System.currentTimeMillis()));
        candidate.setTransactionId(transactionId);
        candidate.setPaymentMethod(paymentMethod);
        candidate.setPaymentVerified(true);
        candidate.setAccountStatus("active");
        
        // Update in database
        boolean paymentUpdated = candidateDAO.updatePaymentStatus(candidateId, "completed", transactionId);
        boolean verifyUpdated = candidateDAO.verifyPayment(candidateId, true);
        
        if (paymentUpdated && verifyUpdated) {
            // Store transaction details in session for confirmation page
            session.setAttribute("transactionId", transactionId);
            session.setAttribute("paymentAmount", amount);
            session.setAttribute("candidateName", candidate.getCandidateName());
            
            response.sendRedirect("user/payment-success-candidate.jsp");
        } else {
            response.sendRedirect("user/candidate-payment.jsp?candidateId=" + candidateId + "&error=Payment failed. Please try again.");
        }
    }
    
    // Update candidate details from edit form
    private void updateCandidateDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String candidateIdStr = request.getParameter("candidateId");
        if (candidateIdStr == null) {
            response.sendRedirect("user/manage-candidates.jsp?error=Invalid candidate");
            return;
        }
        
        int candidateId = Integer.parseInt(candidateIdStr);
        Candidate candidate = candidateDAO.getCandidateById(candidateId);
        
        // Verify candidate belongs to this user
        if (candidate == null || candidate.getUserId() != user.getUserId()) {
            response.sendRedirect("user/manage-candidates.jsp?error=Candidate not found");
            return;
        }
        
        // Debug: Log received parameters
        System.out.println("========== UPDATE CANDIDATE REQUEST DEBUG ==========");
        System.out.println("Candidate ID: " + candidateId);
        System.out.println("Gender from form: [" + request.getParameter("gender") + "]");
        System.out.println("Mobile from form: [" + request.getParameter("mobile") + "]");
        System.out.println("Email from form: [" + request.getParameter("email") + "]");
        System.out.println("Before update - Gender: [" + candidate.getGender() + "]");
        System.out.println("Before update - Mobile: [" + candidate.getMobile() + "]");
        System.out.println("Before update - Email: [" + candidate.getEmail() + "]");
        System.out.println("==================================================");
        
        // Update candidate details - only update if value is provided
        String candidateName = request.getParameter("candidateName");
        if (candidateName != null && !candidateName.trim().isEmpty()) {
            candidate.setCandidateName(candidateName);
        }
        
        String fatherName = request.getParameter("fatherName");
        if (fatherName != null && !fatherName.trim().isEmpty()) {
            candidate.setFatherName(fatherName);
        }
        
        String ageStr = request.getParameter("age");
        try {
            candidate.setAge(Integer.parseInt(ageStr));
        } catch (NumberFormatException e) {
            // Keep existing age
        }
        
        // Update gender - only if value is selected (not empty)
        String gender = request.getParameter("gender");
        if (gender != null && !gender.trim().isEmpty()) {
            candidate.setGender(gender);
        }
        
        // Update mobile - only if value is provided
        String mobile = request.getParameter("mobile");
        if (mobile != null && !mobile.trim().isEmpty()) {
            candidate.setMobile(mobile);
        }
        
        // Update email - only if value is provided
        String email = request.getParameter("email");
        if (email != null && !email.trim().isEmpty()) {
            candidate.setEmail(email);
        }
        
        String address = request.getParameter("address");
        if (address != null && !address.trim().isEmpty()) {
            candidate.setAddress(address);
        }
        
        String city = request.getParameter("city");
        if (city != null && !city.trim().isEmpty()) {
            candidate.setCity(city);
        }
        
        String state = request.getParameter("state");
        if (state != null && !state.trim().isEmpty()) {
            candidate.setState(state);
        }
        
        String pincode = request.getParameter("pincode");
        if (pincode != null && !pincode.trim().isEmpty()) {
            candidate.setPincode(pincode);
        }
        
        String aadharNumber = request.getParameter("aadharNumber");
        if (aadharNumber != null && !aadharNumber.trim().isEmpty()) {
            candidate.setAadharNumber(aadharNumber);
        }
        
        String voterId = request.getParameter("voterId");
        if (voterId != null && !voterId.trim().isEmpty()) {
            candidate.setVoterId(voterId);
        }
        
        String constituency = request.getParameter("constituency");
        if (constituency != null && !constituency.trim().isEmpty()) {
            candidate.setConstituency(constituency);
        }
        
        String nominationId = request.getParameter("nominationId");
        if (nominationId != null && !nominationId.trim().isEmpty()) {
            candidate.setNominationId(nominationId);
        }
        
        String partyName = request.getParameter("partyName");
        if (partyName != null && !partyName.trim().isEmpty()) {
            candidate.setPartyName(partyName);
        }
        
        String partySymbol = request.getParameter("partySymbol");
        if (partySymbol != null && !partySymbol.trim().isEmpty()) {
            candidate.setPartySymbol(partySymbol);
        }
        
        String electionType = request.getParameter("electionType");
        if (electionType != null && !electionType.trim().isEmpty()) {
            candidate.setElectionType(electionType);
        }
        
        String electionDateStr = request.getParameter("electionDate");
        if (electionDateStr != null && !electionDateStr.isEmpty()) {
            candidate.setElectionDate(Date.valueOf(electionDateStr));
        }
        
        String boothNumber = request.getParameter("boothNumber");
        if (boothNumber != null && !boothNumber.trim().isEmpty()) {
            candidate.setBoothNumber(boothNumber);
        }
        
        System.out.println("After update - Gender: [" + candidate.getGender() + "]");
        System.out.println("After update - Mobile: [" + candidate.getMobile() + "]");
        System.out.println("After update - Email: [" + candidate.getEmail() + "]");
        System.out.println("Calling DAO updateCandidate...");
        
        if (candidateDAO.updateCandidate(candidate)) {
            System.out.println("DAO returned success, redirecting...");
            response.sendRedirect("user/edit-candidate.jsp?candidateId=" + candidateId + "&message=Candidate details updated successfully");
        } else {
            System.out.println("DAO returned failure!");
            response.sendRedirect("user/edit-candidate.jsp?candidateId=" + candidateId + "&error=Failed to update candidate details");
        }
    }
}

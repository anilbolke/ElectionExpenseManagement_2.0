package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.dao.FundDetailDAO;
import com.election.model.Candidate;
import com.election.model.FundDetail;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.regex.Pattern;

public class FundDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FundDetailDAO fundDetailDAO;
    private CandidateDAO candidateDAO;
    
    private static final Pattern MOBILE_PATTERN = Pattern.compile("^[6-9]\\d{9}$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z\\s.]{2,100}$");
    
    @Override
    public void init() throws ServletException {
        super.init();
        fundDetailDAO = new FundDetailDAO();
        candidateDAO = new CandidateDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "add";
        }
        
        switch (action) {
            case "add":
                addFundDetail(request, response, user);
                break;
            case "update":
                updateFundDetail(request, response, user);
                break;
            case "delete":
                deleteFundDetail(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp");
                break;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    private void addFundDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Get and validate parameters
            String candidateIdStr = request.getParameter("candidateId");
            String fundDateStr = request.getParameter("fundDate");
            String fundType = request.getParameter("fundType");
            String amountStr = request.getParameter("amount");
            String funderName = request.getParameter("funderName");
            String funderMobile = request.getParameter("funderMobile");
            String description = request.getParameter("description");
            
            // Validation
            StringBuilder errors = new StringBuilder();
            
            if (candidateIdStr == null || candidateIdStr.trim().isEmpty()) {
                errors.append("Please select a candidate. ");
            }
            
            if (fundDateStr == null || fundDateStr.trim().isEmpty()) {
                errors.append("Fund date is required. ");
            }
            
            if (fundType == null || fundType.trim().isEmpty()) {
                errors.append("Fund type is required. ");
            }
            
            if (amountStr == null || amountStr.trim().isEmpty()) {
                errors.append("Amount is required. ");
            }
            
            if (funderName == null || funderName.trim().isEmpty()) {
                errors.append("Funder name is required. ");
            } else if (!NAME_PATTERN.matcher(funderName.trim()).matches()) {
                errors.append("Funder name should contain only letters and spaces (2-100 characters). ");
            }
            
            if (funderMobile == null || funderMobile.trim().isEmpty()) {
                errors.append("Funder mobile is required. ");
            } else if (!MOBILE_PATTERN.matcher(funderMobile.trim()).matches()) {
                errors.append("Please enter a valid 10-digit mobile number. ");
            }
            
            if (errors.length() > 0) {
                response.sendRedirect(request.getContextPath() + "/user/add-fund.jsp?candidateId=" + 
                                    candidateIdStr + "&error=" + errors.toString());
                return;
            }
            
            // Parse values
            int candidateId = Integer.parseInt(candidateIdStr.trim());
            Date fundDate = Date.valueOf(fundDateStr.trim());
            BigDecimal amount = new BigDecimal(amountStr.trim());
            
            // Validate amount
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + "/user/add-fund.jsp?candidateId=" + 
                                    candidateId + "&error=Amount must be greater than zero");
                return;
            }
            
            // Verify candidate belongs to user
            Candidate candidate = candidateDAO.getCandidateById(candidateId);
            if (candidate == null || candidate.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid candidate");
                return;
            }
            
            // Create fund detail
            FundDetail fund = new FundDetail();
            fund.setCandidateId(candidateId);
            fund.setUserId(user.getUserId());
            fund.setFundDate(fundDate);
            fund.setFundType(fundType.trim());
            fund.setAmount(amount);
            fund.setFunderName(funderName.trim());
            fund.setFunderMobile(funderMobile.trim());
            fund.setDescription(description != null ? description.trim() : "");
            
            boolean success = fundDetailDAO.addFundDetail(fund);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?candidateId=" + 
                                    candidateId + "&success=Fund detail added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/add-fund.jsp?candidateId=" + 
                                    candidateId + "&error=Failed to add fund detail");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/add-fund.jsp?error=Invalid number format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/add-fund.jsp?error=An error occurred: " + e.getMessage());
        }
    }
    
    private void updateFundDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            String fundIdStr = request.getParameter("fundId");
            String fundDateStr = request.getParameter("fundDate");
            String fundType = request.getParameter("fundType");
            String amountStr = request.getParameter("amount");
            String funderName = request.getParameter("funderName");
            String funderMobile = request.getParameter("funderMobile");
            String description = request.getParameter("description");
            
            // Validation
            StringBuilder errors = new StringBuilder();
            
            if (fundIdStr == null || fundIdStr.trim().isEmpty()) {
                errors.append("Invalid fund ID. ");
            }
            
            if (fundDateStr == null || fundDateStr.trim().isEmpty()) {
                errors.append("Fund date is required. ");
            }
            
            if (fundType == null || fundType.trim().isEmpty()) {
                errors.append("Fund type is required. ");
            }
            
            if (amountStr == null || amountStr.trim().isEmpty()) {
                errors.append("Amount is required. ");
            }
            
            if (funderName == null || funderName.trim().isEmpty()) {
                errors.append("Funder name is required. ");
            } else if (!NAME_PATTERN.matcher(funderName.trim()).matches()) {
                errors.append("Funder name should contain only letters and spaces. ");
            }
            
            if (funderMobile == null || funderMobile.trim().isEmpty()) {
                errors.append("Funder mobile is required. ");
            } else if (!MOBILE_PATTERN.matcher(funderMobile.trim()).matches()) {
                errors.append("Please enter a valid 10-digit mobile number. ");
            }
            
            if (errors.length() > 0) {
                response.sendRedirect(request.getContextPath() + "/user/edit-fund.jsp?fundId=" + 
                                    fundIdStr + "&error=" + errors.toString());
                return;
            }
            
            int fundId = Integer.parseInt(fundIdStr.trim());
            
            // Verify fund belongs to user
            FundDetail existingFund = fundDetailDAO.getFundDetailById(fundId);
            if (existingFund == null || existingFund.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?error=Invalid fund detail");
                return;
            }
            
            // Update fund detail
            FundDetail fund = new FundDetail();
            fund.setFundId(fundId);
            fund.setFundDate(Date.valueOf(fundDateStr.trim()));
            fund.setFundType(fundType.trim());
            fund.setAmount(new BigDecimal(amountStr.trim()));
            fund.setFunderName(funderName.trim());
            fund.setFunderMobile(funderMobile.trim());
            fund.setDescription(description != null ? description.trim() : "");
            
            boolean success = fundDetailDAO.updateFundDetail(fund);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?success=Fund detail updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/edit-fund.jsp?fundId=" + 
                                    fundId + "&error=Failed to update fund detail");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?error=An error occurred");
        }
    }
    
    private void deleteFundDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            String fundIdStr = request.getParameter("fundId");
            
            if (fundIdStr == null || fundIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?error=Invalid fund ID");
                return;
            }
            
            int fundId = Integer.parseInt(fundIdStr.trim());
            
            // Verify fund belongs to user
            FundDetail existingFund = fundDetailDAO.getFundDetailById(fundId);
            if (existingFund == null || existingFund.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?error=Invalid fund detail");
                return;
            }
            
            boolean success = fundDetailDAO.deleteFundDetail(fundId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?candidateId=" + 
                                    existingFund.getCandidateId() + "&success=Fund detail deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?candidateId=" + 
                                    existingFund.getCandidateId() + "&error=Failed to delete fund detail");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/manage-funds.jsp?error=An error occurred");
        }
    }
}

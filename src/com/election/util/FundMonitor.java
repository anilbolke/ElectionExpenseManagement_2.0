package com.election.util;

import com.election.dao.CandidateDAO;
import com.election.dao.ExpenseDAO;
import com.election.model.Candidate;
import com.election.model.FundStatistics;

import java.math.BigDecimal;

/**
 * Utility class to monitor expense limit usage and generate alerts
 */
public class FundMonitor {
    
    private final CandidateDAO candidateDAO;
    private final ExpenseDAO expenseDAO;
    
    public FundMonitor() {
        this.candidateDAO = new CandidateDAO();
        this.expenseDAO = new ExpenseDAO();
    }
    
    /**
     * Get expense statistics for a candidate
     * @param candidateId The candidate ID
     * @param candidateName The candidate name
     * @return FundStatistics object with all calculations
     */
    public FundStatistics getFundStatistics(int candidateId, String candidateName) {
        // Get candidate to retrieve expense limit
        Candidate candidate = candidateDAO.getCandidateById(candidateId);
        
        // Get expense limit (total allowed)
        BigDecimal expenseLimit = BigDecimal.ZERO;
        if (candidate != null && candidate.getExpenseLimit() != null) {
            expenseLimit = candidate.getExpenseLimit();
        }
        
        // Get total expenses
        BigDecimal totalExpenses = expenseDAO.getTotalExpensesByCandidate(candidateId);
        if (totalExpenses == null) {
            totalExpenses = BigDecimal.ZERO;
        }
        
        // Create and return statistics
        return new FundStatistics(candidateId, candidateName, expenseLimit, totalExpenses);
    }
    
    /**
     * Check if candidate has exceeded threshold percentage
     * @param candidateId The candidate ID
     * @param thresholdPercentage The threshold percentage (e.g., 50 for 50%)
     * @return true if expenses exceed threshold
     */
    public boolean hasExceededThreshold(int candidateId, double thresholdPercentage) {
        FundStatistics stats = getFundStatistics(candidateId, null);
        return stats.getUsagePercentage() >= thresholdPercentage;
    }
    
    /**
     * Get alert message for candidate if threshold exceeded
     * @param candidateId The candidate ID
     * @param candidateName The candidate name
     * @return Alert message or null if no alert
     */
    public String getAlertMessage(int candidateId, String candidateName) {
        FundStatistics stats = getFundStatistics(candidateId, candidateName);
        return stats.getAlertMessage();
    }
}

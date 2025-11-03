package com.election.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Model to hold expense limit and expense statistics for a candidate
 */
public class FundStatistics {
    private int candidateId;
    private String candidateName;
    private BigDecimal totalFunds; // Actually expense limit
    private BigDecimal totalExpenses;
    private BigDecimal remainingFunds; // Actually remaining expense limit
    private double usagePercentage;
    private String alertLevel; // SAFE, WARNING, DANGER, CRITICAL
    private String alertMessage;
    
    public FundStatistics() {
        this.totalFunds = BigDecimal.ZERO;
        this.totalExpenses = BigDecimal.ZERO;
        this.remainingFunds = BigDecimal.ZERO;
        this.usagePercentage = 0.0;
        this.alertLevel = "SAFE";
    }
    
    public FundStatistics(int candidateId, String candidateName, BigDecimal expenseLimit, BigDecimal totalExpenses) {
        this.candidateId = candidateId;
        this.candidateName = candidateName;
        this.totalFunds = expenseLimit != null ? expenseLimit : BigDecimal.ZERO;
        this.totalExpenses = totalExpenses != null ? totalExpenses : BigDecimal.ZERO;
        calculateStats();
    }
    
    private void calculateStats() {
        // Calculate remaining expense limit
        this.remainingFunds = this.totalFunds.subtract(this.totalExpenses);
        
        // Calculate usage percentage against expense limit
        if (this.totalFunds.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal percentage = this.totalExpenses
                .multiply(BigDecimal.valueOf(100))
                .divide(this.totalFunds, 2, RoundingMode.HALF_UP);
            this.usagePercentage = percentage.doubleValue();
        } else {
            this.usagePercentage = 0.0;
        }
        
        // Determine alert level
        determineAlertLevel();
    }
    
    private void determineAlertLevel() {
        if (this.usagePercentage < 50) {
            this.alertLevel = "SAFE";
            this.alertMessage = null;
        } else if (this.usagePercentage >= 50 && this.usagePercentage < 75) {
            this.alertLevel = "WARNING";
            this.alertMessage = String.format("Warning: %.2f%% of expense limit used. Remaining: ₹%.2f", 
                this.usagePercentage, this.remainingFunds);
        } else if (this.usagePercentage >= 75 && this.usagePercentage < 90) {
            this.alertLevel = "DANGER";
            this.alertMessage = String.format("Alert: %.2f%% of expense limit used. Remaining: ₹%.2f", 
                this.usagePercentage, this.remainingFunds);
        } else {
            this.alertLevel = "CRITICAL";
            this.alertMessage = String.format("Critical: %.2f%% of expense limit used. Remaining: ₹%.2f", 
                this.usagePercentage, this.remainingFunds);
        }
    }
    
    // Getters and Setters
    public int getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }
    
    public String getCandidateName() {
        return candidateName;
    }
    
    public void setCandidateName(String candidateName) {
        this.candidateName = candidateName;
    }
    
    public BigDecimal getTotalFunds() {
        return totalFunds;
    }
    
    public void setTotalFunds(BigDecimal totalFunds) {
        this.totalFunds = totalFunds;
        calculateStats();
    }
    
    public BigDecimal getTotalExpenses() {
        return totalExpenses;
    }
    
    public void setTotalExpenses(BigDecimal totalExpenses) {
        this.totalExpenses = totalExpenses;
        calculateStats();
    }
    
    public BigDecimal getRemainingFunds() {
        return remainingFunds;
    }
    
    public double getUsagePercentage() {
        return usagePercentage;
    }
    
    public String getAlertLevel() {
        return alertLevel;
    }
    
    public String getAlertMessage() {
        return alertMessage;
    }
    
    public boolean hasAlert() {
        return this.usagePercentage >= 50;
    }
    
    public boolean isCritical() {
        return this.usagePercentage >= 90;
    }
    
    public boolean isDanger() {
        return this.usagePercentage >= 75;
    }
    
    public boolean isWarning() {
        return this.usagePercentage >= 50 && this.usagePercentage < 75;
    }
    
    @Override
    public String toString() {
        return "FundStatistics{" +
                "candidateId=" + candidateId +
                ", candidateName='" + candidateName + '\'' +
                ", totalFunds=" + totalFunds +
                ", totalExpenses=" + totalExpenses +
                ", remainingFunds=" + remainingFunds +
                ", usagePercentage=" + usagePercentage +
                ", alertLevel='" + alertLevel + '\'' +
                '}';
    }
}

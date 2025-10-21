package com.election.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SubscriptionPlan {
    private int planId;
    private String planName;
    private String planDescription;
    private BigDecimal price;
    private int durationDays;
    private String planType; // monthly, quarterly, yearly
    private int maxCandidates;
    private boolean expenseTracking;
    private boolean fundManagement;
    private boolean reportGeneration;
    private boolean prioritySupport;
    private boolean isActive;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    
    // Constructors
    public SubscriptionPlan() {}
    
    public SubscriptionPlan(String planName, BigDecimal price, int durationDays, int maxCandidates) {
        this.planName = planName;
        this.price = price;
        this.durationDays = durationDays;
        this.maxCandidates = maxCandidates;
    }
    
    // Getters and Setters
    public int getPlanId() {
        return planId;
    }
    
    public void setPlanId(int planId) {
        this.planId = planId;
    }
    
    public String getPlanName() {
        return planName;
    }
    
    public void setPlanName(String planName) {
        this.planName = planName;
    }
    
    public String getPlanDescription() {
        return planDescription;
    }
    
    public void setPlanDescription(String planDescription) {
        this.planDescription = planDescription;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    // For JSP compatibility - returns double value (overloaded for backward compatibility)
    public double getPriceValue() {
        return price != null ? price.doubleValue() : 0.0;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public void setPrice(double price) {
        this.price = BigDecimal.valueOf(price);
    }
    
    // Additional getter that returns primitive double for JSP EL
    public double getPriceDouble() {
        return price != null ? price.doubleValue() : 0.0;
    }
    
    public int getDurationDays() {
        return durationDays;
    }
    
    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }
    
    public String getPlanType() {
        return planType;
    }
    
    public void setPlanType(String planType) {
        this.planType = planType;
    }
    
    public int getMaxCandidates() {
        return maxCandidates;
    }
    
    public void setMaxCandidates(int maxCandidates) {
        this.maxCandidates = maxCandidates;
    }
    
    public boolean isExpenseTracking() {
        return expenseTracking;
    }
    
    public void setExpenseTracking(boolean expenseTracking) {
        this.expenseTracking = expenseTracking;
    }
    
    public boolean isFundManagement() {
        return fundManagement;
    }
    
    public void setFundManagement(boolean fundManagement) {
        this.fundManagement = fundManagement;
    }
    
    public boolean isReportGeneration() {
        return reportGeneration;
    }
    
    public void setReportGeneration(boolean reportGeneration) {
        this.reportGeneration = reportGeneration;
    }
    
    public boolean isPrioritySupport() {
        return prioritySupport;
    }
    
    public void setPrioritySupport(boolean prioritySupport) {
        this.prioritySupport = prioritySupport;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public Timestamp getUpdatedDate() {
        return updatedDate;
    }
    
    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }
    
    // Additional method to get features as a string (for JSP compatibility)
    public String getFeatures() {
        StringBuilder features = new StringBuilder();
        
        if (maxCandidates > 0) {
            features.append("Up to ").append(maxCandidates).append(" Candidates,");
        }
        if (expenseTracking) {
            features.append("Expense Tracking,");
        }
        if (fundManagement) {
            features.append("Fund Management,");
        }
        if (reportGeneration) {
            features.append("Report Generation,");
        }
        if (prioritySupport) {
            features.append("Priority Support,");
        }
        
        // Remove trailing comma if exists
        if (features.length() > 0 && features.charAt(features.length() - 1) == ',') {
            features.setLength(features.length() - 1);
        }
        
        return features.toString();
    }
    
    public void setFeatures(String features) {
        // Parse features string and set individual properties
        if (features != null && !features.isEmpty()) {
            String[] featureArray = features.split(",");
            for (String feature : featureArray) {
                String trimmedFeature = feature.trim().toLowerCase();
                if (trimmedFeature.contains("expense tracking")) {
                    this.expenseTracking = true;
                } else if (trimmedFeature.contains("fund management")) {
                    this.fundManagement = true;
                } else if (trimmedFeature.contains("report generation")) {
                    this.reportGeneration = true;
                } else if (trimmedFeature.contains("priority support")) {
                    this.prioritySupport = true;
                }
            }
        }
    }
}

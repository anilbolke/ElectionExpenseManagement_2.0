package com.election.model;

import java.sql.Timestamp;

/**
 * Model class for QR Code payments that require manual verification
 */
public class QRPayment {
    private int paymentId;
    private int userId;
    private Integer candidateId;
    private String paymentType; // 'subscription' or 'candidate_registration'
    private String planName;
    private double amount;
    private String transactionId;
    private String paymentMethod;
    private String screenshotPath;
    private String paymentStatus; // 'pending', 'verified', 'rejected'
    private Timestamp submittedDate;
    private Timestamp verifiedDate;
    private Integer verifiedBy;
    private String adminNotes;
    private boolean termsAccepted;
    private String termsVersion;
    private Timestamp termsTimestamp;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private String userFullName;
    private String userEmail;
    private String candidateName;
    private String verifiedByName;
    
    // Constructors
    public QRPayment() {
    }
    
    public QRPayment(int userId, String paymentType, double amount, String transactionId) {
        this.userId = userId;
        this.paymentType = paymentType;
        this.amount = amount;
        this.transactionId = transactionId;
        this.paymentStatus = "pending";
        this.paymentMethod = "QR Code";
    }
    
    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Integer getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(Integer candidateId) {
        this.candidateId = candidateId;
    }
    
    public String getPaymentType() {
        return paymentType;
    }
    
    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }
    
    public String getPlanName() {
        return planName;
    }
    
    public void setPlanName(String planName) {
        this.planName = planName;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getScreenshotPath() {
        return screenshotPath;
    }
    
    public void setScreenshotPath(String screenshotPath) {
        this.screenshotPath = screenshotPath;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public Timestamp getSubmittedDate() {
        return submittedDate;
    }
    
    public void setSubmittedDate(Timestamp submittedDate) {
        this.submittedDate = submittedDate;
    }
    
    public Timestamp getVerifiedDate() {
        return verifiedDate;
    }
    
    public void setVerifiedDate(Timestamp verifiedDate) {
        this.verifiedDate = verifiedDate;
    }
    
    public Integer getVerifiedBy() {
        return verifiedBy;
    }
    
    public void setVerifiedBy(Integer verifiedBy) {
        this.verifiedBy = verifiedBy;
    }
    
    public String getAdminNotes() {
        return adminNotes;
    }
    
    public void setAdminNotes(String adminNotes) {
        this.adminNotes = adminNotes;
    }
    
    public boolean isTermsAccepted() {
        return termsAccepted;
    }
    
    public void setTermsAccepted(boolean termsAccepted) {
        this.termsAccepted = termsAccepted;
    }
    
    public String getTermsVersion() {
        return termsVersion;
    }
    
    public void setTermsVersion(String termsVersion) {
        this.termsVersion = termsVersion;
    }
    
    public Timestamp getTermsTimestamp() {
        return termsTimestamp;
    }
    
    public void setTermsTimestamp(Timestamp termsTimestamp) {
        this.termsTimestamp = termsTimestamp;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Display fields
    public String getUserFullName() {
        return userFullName;
    }
    
    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public String getCandidateName() {
        return candidateName;
    }
    
    public void setCandidateName(String candidateName) {
        this.candidateName = candidateName;
    }
    
    public String getVerifiedByName() {
        return verifiedByName;
    }
    
    public void setVerifiedByName(String verifiedByName) {
        this.verifiedByName = verifiedByName;
    }
    
    // Helper methods
    public boolean isPending() {
        return "pending".equalsIgnoreCase(this.paymentStatus);
    }
    
    public boolean isVerified() {
        return "verified".equalsIgnoreCase(this.paymentStatus);
    }
    
    public boolean isRejected() {
        return "rejected".equalsIgnoreCase(this.paymentStatus);
    }
    
    @Override
    public String toString() {
        return "QRPayment{" +
                "paymentId=" + paymentId +
                ", userId=" + userId +
                ", paymentType='" + paymentType + '\'' +
                ", amount=" + amount +
                ", transactionId='" + transactionId + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                '}';
    }
}

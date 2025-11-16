package com.election.model;

import java.sql.Timestamp;

/**
 * License Model - Represents a license key for payment bypass
 * License keys start with "EMS" followed by 5 random numbers
 * 
 * @author System Generated
 * @date 2025-11-16
 */
public class License {
    private int licenseId;
    private String licenseKey;
    private boolean isUsed;
    private Integer mappedUserId;
    private Integer mappedCandidateId;
    private int generatedBy;
    private Timestamp generatedDate;
    private Timestamp usedDate;
    private String status; // active, used, expired
    private String notes;
    
    // Additional fields for display
    private String generatedByName;
    private String mappedUserName;
    private String mappedCandidateName;
    
    // Constructors
    public License() {
    }
    
    public License(String licenseKey, int generatedBy) {
        this.licenseKey = licenseKey;
        this.generatedBy = generatedBy;
        this.isUsed = false;
        this.status = "active";
    }
    
    // Getters and Setters
    public int getLicenseId() {
        return licenseId;
    }
    
    public void setLicenseId(int licenseId) {
        this.licenseId = licenseId;
    }
    
    public String getLicenseKey() {
        return licenseKey;
    }
    
    public void setLicenseKey(String licenseKey) {
        this.licenseKey = licenseKey;
    }
    
    public boolean isUsed() {
        return isUsed;
    }
    
    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }
    
    public Integer getMappedUserId() {
        return mappedUserId;
    }
    
    public void setMappedUserId(Integer mappedUserId) {
        this.mappedUserId = mappedUserId;
    }
    
    public Integer getMappedCandidateId() {
        return mappedCandidateId;
    }
    
    public void setMappedCandidateId(Integer mappedCandidateId) {
        this.mappedCandidateId = mappedCandidateId;
    }
    
    public int getGeneratedBy() {
        return generatedBy;
    }
    
    public void setGeneratedBy(int generatedBy) {
        this.generatedBy = generatedBy;
    }
    
    public Timestamp getGeneratedDate() {
        return generatedDate;
    }
    
    public void setGeneratedDate(Timestamp generatedDate) {
        this.generatedDate = generatedDate;
    }
    
    public Timestamp getUsedDate() {
        return usedDate;
    }
    
    public void setUsedDate(Timestamp usedDate) {
        this.usedDate = usedDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getGeneratedByName() {
        return generatedByName;
    }
    
    public void setGeneratedByName(String generatedByName) {
        this.generatedByName = generatedByName;
    }
    
    public String getMappedUserName() {
        return mappedUserName;
    }
    
    public void setMappedUserName(String mappedUserName) {
        this.mappedUserName = mappedUserName;
    }
    
    public String getMappedCandidateName() {
        return mappedCandidateName;
    }
    
    public void setMappedCandidateName(String mappedCandidateName) {
        this.mappedCandidateName = mappedCandidateName;
    }
    
    @Override
    public String toString() {
        return "License{" +
                "licenseId=" + licenseId +
                ", licenseKey='" + licenseKey + '\'' +
                ", isUsed=" + isUsed +
                ", status='" + status + '\'' +
                ", generatedDate=" + generatedDate +
                '}';
    }
}

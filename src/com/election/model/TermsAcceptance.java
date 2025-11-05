package com.election.model;

import java.sql.Timestamp;

/**
 * Model class for Terms and Conditions Acceptance tracking
 * Stores information about when and by whom terms were accepted
 */
public class TermsAcceptance {
    
    private int acceptanceId;
    private int userId;
    private Integer candidateId;
    private Timestamp acceptedOn;
    private String ipAddress;
    private String userAgent;
    private String termsVersion;
    
    // Constructors
    public TermsAcceptance() {
    }
    
    public TermsAcceptance(int userId) {
        this.userId = userId;
        this.acceptedOn = new Timestamp(System.currentTimeMillis());
        this.termsVersion = "v1.0";
    }
    
    // Getters and Setters
    public int getAcceptanceId() {
        return acceptanceId;
    }
    
    public void setAcceptanceId(int acceptanceId) {
        this.acceptanceId = acceptanceId;
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
    
    public Timestamp getAcceptedOn() {
        return acceptedOn;
    }
    
    public void setAcceptedOn(Timestamp acceptedOn) {
        this.acceptedOn = acceptedOn;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public String getTermsVersion() {
        return termsVersion;
    }
    
    public void setTermsVersion(String termsVersion) {
        this.termsVersion = termsVersion;
    }
    
    @Override
    public String toString() {
        return "TermsAcceptance{" +
                "acceptanceId=" + acceptanceId +
                ", userId=" + userId +
                ", candidateId=" + candidateId +
                ", acceptedOn=" + acceptedOn +
                ", ipAddress='" + ipAddress + '\'' +
                ", termsVersion='" + termsVersion + '\'' +
                '}';
    }
}

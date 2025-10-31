package com.election.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class FundDetail {
    private int fundId;
    private int candidateId;
    private int userId;
    private Date fundDate;
    private String fundType;
    private BigDecimal amount;
    private String funderName;
    private String funderMobile;
    private String description;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    
    // Candidate details (for display purposes)
    private String candidateName;
    
    public FundDetail() {
    }
    
    public FundDetail(int candidateId, int userId, Date fundDate, String fundType, 
                     BigDecimal amount, String funderName, String funderMobile) {
        this.candidateId = candidateId;
        this.userId = userId;
        this.fundDate = fundDate;
        this.fundType = fundType;
        this.amount = amount;
        this.funderName = funderName;
        this.funderMobile = funderMobile;
    }
    
    // Getters and Setters
    public int getFundId() {
        return fundId;
    }
    
    public void setFundId(int fundId) {
        this.fundId = fundId;
    }
    
    public int getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Date getFundDate() {
        return fundDate;
    }
    
    public void setFundDate(Date fundDate) {
        this.fundDate = fundDate;
    }
    
    public String getFundType() {
        return fundType;
    }
    
    public void setFundType(String fundType) {
        this.fundType = fundType;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getFunderName() {
        return funderName;
    }
    
    public void setFunderName(String funderName) {
        this.funderName = funderName;
    }
    
    public String getFunderMobile() {
        return funderMobile;
    }
    
    public void setFunderMobile(String funderMobile) {
        this.funderMobile = funderMobile;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
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
    
    public String getCandidateName() {
        return candidateName;
    }
    
    public void setCandidateName(String candidateName) {
        this.candidateName = candidateName;
    }
}

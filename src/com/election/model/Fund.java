package com.election.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Fund Model - Represents fund/income entries for candidates
 */
public class Fund {
    private int fundId;
    private int candidateId;
    private String fundSource;
    private String donorName;
    private String donorContact;
    private BigDecimal fundAmount;
    private Date fundDate;
    private String paymentMode;
    private String receiptNumber;
    private String remarks;
    private String attachmentPath;
    private int createdBy;
    private Timestamp createdDate;

    // Constructors
    public Fund() {
    }

    public Fund(int candidateId, String fundSource, BigDecimal fundAmount, Date fundDate) {
        this.candidateId = candidateId;
        this.fundSource = fundSource;
        this.fundAmount = fundAmount;
        this.fundDate = fundDate;
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

    public String getFundSource() {
        return fundSource;
    }

    public void setFundSource(String fundSource) {
        this.fundSource = fundSource;
    }

    public String getDonorName() {
        return donorName;
    }

    public void setDonorName(String donorName) {
        this.donorName = donorName;
    }

    public String getDonorContact() {
        return donorContact;
    }

    public void setDonorContact(String donorContact) {
        this.donorContact = donorContact;
    }

    public BigDecimal getFundAmount() {
        return fundAmount;
    }

    public void setFundAmount(BigDecimal fundAmount) {
        this.fundAmount = fundAmount;
    }

    public Date getFundDate() {
        return fundDate;
    }

    public void setFundDate(Date fundDate) {
        this.fundDate = fundDate;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

    public String getReceiptNumber() {
        return receiptNumber;
    }

    public void setReceiptNumber(String receiptNumber) {
        this.receiptNumber = receiptNumber;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getAttachmentPath() {
        return attachmentPath;
    }

    public void setAttachmentPath(String attachmentPath) {
        this.attachmentPath = attachmentPath;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Fund{" +
                "fundId=" + fundId +
                ", candidateId=" + candidateId +
                ", fundSource='" + fundSource + '\'' +
                ", donorName='" + donorName + '\'' +
                ", fundAmount=" + fundAmount +
                ", fundDate=" + fundDate +
                ", paymentMode='" + paymentMode + '\'' +
                '}';
    }
}

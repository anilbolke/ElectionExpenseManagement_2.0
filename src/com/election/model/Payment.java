package com.election.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int candidateId;
    private int brokerId;
    private String paymentType;
    private BigDecimal amount;
    private String paymentMethod;
    private String transactionId;
    private String paymentStatus;
    private Timestamp paymentDate;
    private int verifiedBy;
    private Timestamp verificationDate;
    private String remarks;

    // Constructors
    public Payment() {}

    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getCandidateId() {
        return candidateId;
    }

    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }

    public int getBrokerId() {
        return brokerId;
    }

    public void setBrokerId(int brokerId) {
        this.brokerId = brokerId;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public int getVerifiedBy() {
        return verifiedBy;
    }

    public void setVerifiedBy(int verifiedBy) {
        this.verifiedBy = verifiedBy;
    }

    public Timestamp getVerificationDate() {
        return verificationDate;
    }

    public void setVerificationDate(Timestamp verificationDate) {
        this.verificationDate = verificationDate;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }
}

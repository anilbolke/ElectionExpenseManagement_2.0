package com.election.model;

import java.sql.Timestamp;
import java.sql.Date;
import java.math.BigDecimal;

public class User {
    // Basic Authentication
    private int userId;
    private String username;
    private String password;
    private String email;
    private String mobile;
    
    // Personal Information
    private String firstName;
    private String lastName;
    private String fullName;
    private String fatherHusbandName;
    private Date dateOfBirth;
    private int age;
    private String gender;
    
    // Address Information
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private String pincode;
    
    // Election Information
    private String constituency;
    private String assemblyNumber;
    private String partyName;
    private String partySymbol;
    private String electionType;
    private String electionYear;
    
    // Election Program Details
    private String electionSlogan;
    private String manifestoSummary;
    private String keyPromises;
    private String targetAreas;
    
    // Campaign Details
    private BigDecimal campaignBudget;
    private BigDecimal expenseLimit;
    private String campaignManagerName;
    private String campaignManagerContact;
    
    // Social Media & Communication
    private String facebookUrl;
    private String twitterUrl;
    private String instagramUrl;
    private String websiteUrl;
    private String whatsappNumber;
    
    // Documents
    private String photoUrl;
    private String idProofType;
    private String idProofNumber;
    private String idProofDocument;
    private String affidavitDocument;
    
    // User Role and Status
    private String role;
    private String status;
    private String accountType;
    
    // Subscription and Payment
    private String subscriptionStatus;
    private Timestamp subscriptionStartDate;
    private Timestamp subscriptionEndDate;
    private String paymentStatus;
    private Integer subscriptionPlanId;
    
    // Broker Information
    private Integer brokerId;  // For users: references their assigned broker
    private String brokerFirmName;
    private String brokerGstNumber;
    private BigDecimal brokerCommissionRate;
    private String referralCode;  // Unique referral code for brokers
    
    // Timestamps
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp lastLogin;
    
    // Profile Completion
    private boolean profileCompleted;
    private int profileCompletionPercentage;
    
    // Constructors
    public User() {}
    
    public User(String username, String password, String email, String fullName, String mobile, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.mobile = mobile;
        this.role = role;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFullName() {
        if (fullName != null && !fullName.isEmpty()) {
            return fullName;
        }
        // Generate full name from first and last name if not set
        if (firstName != null && lastName != null) {
            return firstName + " " + lastName;
        }
        return firstName != null ? firstName : (lastName != null ? lastName : "");
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFatherHusbandName() {
        return fatherHusbandName;
    }

    public void setFatherHusbandName(String fatherHusbandName) {
        this.fatherHusbandName = fatherHusbandName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }
    
    // Convenience method for address (combines addressLine1 and addressLine2)
    public String getAddress() {
        if (addressLine1 != null && addressLine2 != null && !addressLine2.isEmpty()) {
            return addressLine1 + ", " + addressLine2;
        }
        return addressLine1;
    }
    
    public void setAddress(String address) {
        // Set to addressLine1 for backward compatibility
        this.addressLine1 = address;
    }

    public String getConstituency() {
        return constituency;
    }

    public void setConstituency(String constituency) {
        this.constituency = constituency;
    }

    public String getAssemblyNumber() {
        return assemblyNumber;
    }

    public void setAssemblyNumber(String assemblyNumber) {
        this.assemblyNumber = assemblyNumber;
    }

    public String getPartyName() {
        return partyName;
    }

    public void setPartyName(String partyName) {
        this.partyName = partyName;
    }

    public String getPartySymbol() {
        return partySymbol;
    }

    public void setPartySymbol(String partySymbol) {
        this.partySymbol = partySymbol;
    }

    public String getElectionType() {
        return electionType;
    }

    public void setElectionType(String electionType) {
        this.electionType = electionType;
    }

    public String getElectionYear() {
        return electionYear;
    }

    public void setElectionYear(String electionYear) {
        this.electionYear = electionYear;
    }

    public String getElectionSlogan() {
        return electionSlogan;
    }

    public void setElectionSlogan(String electionSlogan) {
        this.electionSlogan = electionSlogan;
    }

    public String getManifestoSummary() {
        return manifestoSummary;
    }

    public void setManifestoSummary(String manifestoSummary) {
        this.manifestoSummary = manifestoSummary;
    }

    public String getKeyPromises() {
        return keyPromises;
    }

    public void setKeyPromises(String keyPromises) {
        this.keyPromises = keyPromises;
    }

    public String getTargetAreas() {
        return targetAreas;
    }

    public void setTargetAreas(String targetAreas) {
        this.targetAreas = targetAreas;
    }

    public BigDecimal getCampaignBudget() {
        return campaignBudget;
    }

    public void setCampaignBudget(BigDecimal campaignBudget) {
        this.campaignBudget = campaignBudget;
    }

    public BigDecimal getExpenseLimit() {
        return expenseLimit;
    }

    public void setExpenseLimit(BigDecimal expenseLimit) {
        this.expenseLimit = expenseLimit;
    }

    public String getCampaignManagerName() {
        return campaignManagerName;
    }

    public void setCampaignManagerName(String campaignManagerName) {
        this.campaignManagerName = campaignManagerName;
    }

    public String getCampaignManagerContact() {
        return campaignManagerContact;
    }

    public void setCampaignManagerContact(String campaignManagerContact) {
        this.campaignManagerContact = campaignManagerContact;
    }

    public String getFacebookUrl() {
        return facebookUrl;
    }

    public void setFacebookUrl(String facebookUrl) {
        this.facebookUrl = facebookUrl;
    }

    public String getTwitterUrl() {
        return twitterUrl;
    }

    public void setTwitterUrl(String twitterUrl) {
        this.twitterUrl = twitterUrl;
    }

    public String getInstagramUrl() {
        return instagramUrl;
    }

    public void setInstagramUrl(String instagramUrl) {
        this.instagramUrl = instagramUrl;
    }

    public String getWebsiteUrl() {
        return websiteUrl;
    }

    public void setWebsiteUrl(String websiteUrl) {
        this.websiteUrl = websiteUrl;
    }

    public String getWhatsappNumber() {
        return whatsappNumber;
    }

    public void setWhatsappNumber(String whatsappNumber) {
        this.whatsappNumber = whatsappNumber;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public String getIdProofType() {
        return idProofType;
    }

    public void setIdProofType(String idProofType) {
        this.idProofType = idProofType;
    }

    public String getIdProofNumber() {
        return idProofNumber;
    }

    public void setIdProofNumber(String idProofNumber) {
        this.idProofNumber = idProofNumber;
    }

    public String getIdProofDocument() {
        return idProofDocument;
    }

    public void setIdProofDocument(String idProofDocument) {
        this.idProofDocument = idProofDocument;
    }

    public String getAffidavitDocument() {
        return affidavitDocument;
    }

    public void setAffidavitDocument(String affidavitDocument) {
        this.affidavitDocument = affidavitDocument;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public String getSubscriptionStatus() {
        return subscriptionStatus;
    }

    public void setSubscriptionStatus(String subscriptionStatus) {
        this.subscriptionStatus = subscriptionStatus;
    }

    public Timestamp getSubscriptionStartDate() {
        return subscriptionStartDate;
    }

    public void setSubscriptionStartDate(Timestamp subscriptionStartDate) {
        this.subscriptionStartDate = subscriptionStartDate;
    }

    public Timestamp getSubscriptionEndDate() {
        return subscriptionEndDate;
    }

    public void setSubscriptionEndDate(Timestamp subscriptionEndDate) {
        this.subscriptionEndDate = subscriptionEndDate;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Integer getSubscriptionPlanId() {
        return subscriptionPlanId;
    }

    public void setSubscriptionPlanId(Integer subscriptionPlanId) {
        this.subscriptionPlanId = subscriptionPlanId;
    }

    public Integer getBrokerId() {
        return brokerId;
    }

    public void setBrokerId(Integer brokerId) {
        this.brokerId = brokerId;
    }

    public String getBrokerFirmName() {
        return brokerFirmName;
    }

    public void setBrokerFirmName(String brokerFirmName) {
        this.brokerFirmName = brokerFirmName;
    }

    public String getBrokerGstNumber() {
        return brokerGstNumber;
    }

    public void setBrokerGstNumber(String brokerGstNumber) {
        this.brokerGstNumber = brokerGstNumber;
    }

    public BigDecimal getBrokerCommissionRate() {
        return brokerCommissionRate;
    }

    public void setBrokerCommissionRate(BigDecimal brokerCommissionRate) {
        this.brokerCommissionRate = brokerCommissionRate;
    }

    public String getReferralCode() {
        return referralCode;
    }

    public void setReferralCode(String referralCode) {
        this.referralCode = referralCode;
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

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    public boolean isProfileCompleted() {
        return profileCompleted;
    }

    public void setProfileCompleted(boolean profileCompleted) {
        this.profileCompleted = profileCompleted;
    }

    public int getProfileCompletionPercentage() {
        return profileCompletionPercentage;
    }

    public void setProfileCompletionPercentage(int profileCompletionPercentage) {
        this.profileCompletionPercentage = profileCompletionPercentage;
    }
    
    // Legacy support
    public String getUserRole() {
        return role;
    }
    
    public void setUserRole(String role) {
        this.role = role;
    }
    
    public boolean isActive() {
        return "active".equals(status);
    }
    
    public void setActive(boolean active) {
        this.status = active ? "active" : "inactive";
    }
    
    public Timestamp getCreatedDate() {
        return createdAt;
    }
    
    public void setCreatedDate(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

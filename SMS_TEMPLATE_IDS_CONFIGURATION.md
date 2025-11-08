# SMS Template IDs Configuration Guide

## Overview
Each SMS message type uses a different DLT (Distributed Ledger Technology) approved template ID. This is mandatory for SMS compliance in India.

## Template IDs by Message Type

### 1. Broker Registration SMS
**Template ID:** `1207176228666587519`
**Triggered When:** Admin registers a new broker
**Message Format:**
```
Dear {brokerName},
Your registration as a Broker for our Election Expense Mgmt Software is successful.
Your Code is: {referralCode}
Use this code for all sales to track commission accurately.
Start selling now!
EMSonline.in
Shree IT Solutions
```

**Variables:**
- `{brokerName}` - Name of the broker
- `{referralCode}` - Unique referral code

---

### 2. Forgot Password SMS
**Template ID:** `1207176228666587520`
**Triggered When:** User resets their password
**Message Format:**
```
Dear User,
Your password for {username} is {password}
EMS Online
Shree IT Solutions
```

**Variables:**
- `{username}` - User's username
- `{password}` - New password

---

### 3. Payment Success SMS
**Template ID:** `1207176228666587521`
**Triggered When:** Payment is successfully completed
**Message Format:**
```
Success!
Your payment of Rs.{amount} is successful. Subscription is confirmed.
Your service is now active!
Thank you for your purchase.
EMSOnline
Shree IT Solutions
```

**Variables:**
- `{amount}` - Payment amount (e.g., 1999)

---

### 4. Referral Code Mapping SMS
**Template ID:** `1207176228666587522`
**Triggered When:** User maps a referral code to their account
**Sent To:** Broker (not the user)
**Message Format:**
```
Congratulations!
Your referral code {referralCode} has been successfully applied to {username}
Complete payment and start earning now!
EMSOnline
Shree IT Solutions
```

**Variables:**
- `{referralCode}` - Broker's referral code
- `{username}` - User who mapped the code

---

### 5. General/Admin SMS
**Template ID:** `1207176228666587519` (Same as Broker Registration)
**Triggered When:** Admin sends manual SMS from admin panel
**Message Format:** Variable - Admin can type any message

---

## How to Update Template IDs

### Step 1: Get Your Template IDs
1. Login to your SMS provider portal: http://shreeitsms.in
2. Navigate to "DLT Templates" or "Template Management"
3. Find your approved template IDs
4. Copy each template ID for respective message types

### Step 2: Update SMSUtil.java
Open file: `src/com/election/util/SMSUtil.java`

Update these constants (lines 47-51):
```java
// Template IDs for different SMS types (DLT Approved)
private static final String TEMPLATE_ID_BROKER_REGISTRATION = "YOUR_TEMPLATE_ID_1";
private static final String TEMPLATE_ID_FORGOT_PASSWORD = "YOUR_TEMPLATE_ID_2";
private static final String TEMPLATE_ID_PAYMENT_SUCCESS = "YOUR_TEMPLATE_ID_3";
private static final String TEMPLATE_ID_REFERRAL_MAPPING = "YOUR_TEMPLATE_ID_4";
private static final String TEMPLATE_ID_GENERAL = "YOUR_DEFAULT_TEMPLATE_ID";
```

### Step 3: Rebuild and Deploy
```bash
mvn clean package
# Deploy the new WAR file to Tomcat
```

---

## Template Registration Process

### If You Don't Have Template IDs Yet:

#### 1. Register with TRAI DLT Platform
- Visit: https://www.vilpower.in/
- Create account and complete KYC
- Register your business entity

#### 2. Register Templates with SMS Provider
For each message type, submit:
- **Template Content** (exact message text with variables)
- **Template Type** (Transactional)
- **Purpose** (Account notifications)
- **Category** (Service)

#### 3. Wait for Approval
- DLT approval: 2-3 business days
- SMS provider approval: 1 business day
- You'll receive template IDs after approval

#### 4. Update Configuration
- Update template IDs in `SMSUtil.java`
- Test each message type
- Deploy to production

---

## Message Templates for DLT Registration

Use these exact formats when registering with DLT:

### Template 1: Broker Registration
```
Dear {#var#},
Your registration as a Broker for our Election Expense Mgmt Software is successful.
Your Code is: {#var#}
Use this code for all sales to track commission accurately.
Start selling now!
EMSonline.in
Shree IT Solutions
```

### Template 2: Forgot Password
```
Dear User,
Your password for {#var#} is {#var#}
EMS Online
Shree IT Solutions
```

### Template 3: Payment Success
```
Success!
Your payment of Rs.{#var#} is successful. Subscription is confirmed.
Your service is now active!
Thank you for your purchase.
EMSOnline
Shree IT Solutions
```

### Template 4: Referral Mapping
```
Congratulations!
Your referral code {#var#} has been successfully applied to {#var#}
Complete payment and start earning now!
EMSOnline
Shree IT Solutions
```

---

## Template ID Mapping in Code

### Current Implementation:

| SMS Type | Method | Template ID Constant |
|----------|--------|---------------------|
| Broker Registration | `sendBrokerRegistrationSMS()` | `TEMPLATE_ID_BROKER_REGISTRATION` |
| Forgot Password | `sendForgotPasswordSMS()` | `TEMPLATE_ID_FORGOT_PASSWORD` |
| Payment Success | `sendPaymentSuccessSMS()` | `TEMPLATE_ID_PAYMENT_SUCCESS` |
| Referral Mapping | `sendReferralMappedSMS()` | `TEMPLATE_ID_REFERRAL_MAPPING` |
| General/Admin | `sendSMS()` | `TEMPLATE_ID_GENERAL` |

### Code Example:
```java
// Each method now uses its specific template ID
SMSUtil.sendBrokerRegistrationSMS("9876543210", "John Doe", "ABC123");
// Automatically uses TEMPLATE_ID_BROKER_REGISTRATION

SMSUtil.sendPaymentSuccessSMS("9876543210", "1999");
// Automatically uses TEMPLATE_ID_PAYMENT_SUCCESS
```

---

## Testing Template IDs

### Test Each Template:

1. **Broker Registration:**
   ```java
   SMSUtil.sendBrokerRegistrationSMS("9876543210", "Test Broker", "TEST123");
   ```

2. **Forgot Password:**
   ```java
   SMSUtil.sendForgotPasswordSMS("9876543210", "testuser", "Pass@123");
   ```

3. **Payment Success:**
   ```java
   SMSUtil.sendPaymentSuccessSMS("9876543210", "1999");
   ```

4. **Referral Mapping:**
   ```java
   SMSUtil.sendReferralMappedSMS("9876543210", "ABC123", "testuser");
   ```

### Check Console Logs:
```
SMS API Response Code: 200
SMS API Response: {"smslist":{"sms":{"status":"success",...}}}
```

---

## Troubleshooting

### Error: "Invalid Template ID"
**Cause:** Template ID not registered with DLT or SMS provider
**Solution:** 
1. Verify template ID in SMS provider dashboard
2. Ensure template is DLT approved
3. Check if template matches message content exactly

### Error: "Template Content Mismatch"
**Cause:** Message content doesn't match registered template
**Solution:**
1. Message must match DLT template exactly
2. Only variable parts can change
3. Don't modify fixed text

### Error: "DLT Rejection"
**Cause:** Template not approved by DLT
**Solution:**
1. Check DLT portal for rejection reason
2. Modify template as per guidelines
3. Resubmit for approval

---

## Compliance Notes

### TRAI DLT Compliance:
✅ **Required for all commercial SMS in India**
✅ **Each message type needs separate template**
✅ **Templates must be pre-approved**
✅ **Message content must match template exactly**
✅ **Variables allowed only in designated places**

### Best Practices:
1. Keep templates simple and clear
2. Use variables for dynamic content only
3. Don't change fixed text in messages
4. Test thoroughly before production
5. Monitor SMS delivery rates
6. Keep template IDs documented

---

## Support

### SMS Provider Support:
- **Website:** http://shreeitsms.in
- **Email:** support@shreeitsms.in
- **Phone:** Check provider website

### DLT Platform:
- **Website:** https://www.vilpower.in/
- **Help:** DLT portal help section

### System Support:
- **Developer:** Shree IT Solutions
- **Email:** support@emsonline.in

---

## Changelog

### Version 2.0 (Current)
- ✅ Added individual template ID support
- ✅ Each SMS type uses dedicated template
- ✅ Improved DLT compliance
- ✅ Better error handling

### Version 1.0
- ❌ Single template ID for all SMS
- ❌ Not fully DLT compliant

---

**Last Updated:** November 8, 2025
**Configuration File:** `src/com/election/util/SMSUtil.java`
**Status:** ✅ Production Ready with Template ID Support

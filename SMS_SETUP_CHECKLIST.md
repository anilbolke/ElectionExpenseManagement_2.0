# SMS Integration - Setup Checklist

## ⚠️ IMPORTANT: Before Deployment

### 1. Update SMS API Credentials
**File:** `src/com/election/util/SMSUtil.java`

Update these constants with your actual credentials:
```java
private static final String SMS_USER = "emsonline";         // ← Update this
private static final String SMS_PASSWORD = "8a65a0416eXX";  // ← Update this
private static final String SENDER_ID = "INFOSM";          // ← Update if needed
private static final String ENTITY_ID = "1234567891112131415";  // ← Update this
private static final String TEMP_ID = "1034567891112131819";    // ← Update this
```

**Where to find these credentials:**
- Login to: http://shreeitsms.in
- Navigate to API Settings
- Copy your credentials

---

## ✅ Pre-Deployment Checklist

### Configuration
- [ ] Updated SMS_USER in SMSUtil.java
- [ ] Updated SMS_PASSWORD in SMSUtil.java
- [ ] Updated ENTITY_ID (DLT registration)
- [ ] Updated TEMP_ID (Template ID)
- [ ] Verified SENDER_ID is approved

### Dependencies
- [x] org.json library present (json-2*.jar in WEB-INF/lib)
- [ ] Verified Java version compatibility (Java 8+)

### Database
- [ ] Verified `users` table has `mobile` column
- [ ] Checked mobile numbers are properly stored (10 digits)

### Testing Environment
- [ ] SMS API endpoint is accessible
- [ ] Test mobile number available
- [ ] SMS balance/credits available

---

## 🧪 Testing Checklist

### Test Each SMS Scenario

#### 1. Broker Registration SMS
- [ ] Login as admin
- [ ] Register new broker with test mobile
- [ ] Verify SMS received with referral code
- [ ] Check console logs for SMS success

**Expected Message:**
```
Dear [Name],
Your registration as a Broker for our Election Expense Mgmt Software is successful.
Your Code is: [CODE]
Use this code for all sales to track commission accurately.
Start selling now!
EMSonline.in
Shree IT Solutions
```

#### 2. Forgot Password SMS
- [ ] Go to forgot password page
- [ ] Enter username/mobile
- [ ] Reset password
- [ ] Verify SMS received with password
- [ ] Check console logs

**Expected Message:**
```
Dear User,
Your password for [USERNAME] is [PASSWORD]
EMS Online
Shree IT Solutions
```

#### 3. Payment Success SMS
- [ ] Login as user
- [ ] Make test payment (use test card)
- [ ] Verify SMS received after payment
- [ ] Check console logs

**Expected Message:**
```
Success!
Your payment of Rs.[AMOUNT] is successful. Subscription is confirmed.
Your service is now active!
Thank you for your purchase.
EMSOnline
Shree IT Solutions
```

#### 4. Referral Code Mapping SMS
- [ ] Login as user without broker
- [ ] Map valid referral code
- [ ] Broker should receive SMS
- [ ] Check console logs

**Expected Message to Broker:**
```
Congratulations!
Your referral code [CODE] has been successfully applied to [USER]
Complete payment and start earning now!
EMSOnline
Shree IT Solutions
```

#### 5. Admin SMS Panel
- [ ] Login as admin
- [ ] Navigate to "Send SMS" menu
- [ ] Select a user from dropdown
- [ ] Compose test message
- [ ] Send SMS
- [ ] Verify SMS received
- [ ] Test all filter options (All/Users/Brokers)
- [ ] Test message templates

---

## 🔍 Troubleshooting Guide

### SMS Not Received

#### Check 1: Verify Mobile Number
```sql
SELECT user_id, username, mobile FROM users WHERE user_id = X;
```
- Mobile should be 10 digits
- Should start with 6, 7, 8, or 9

#### Check 2: Console Logs
Look for these messages:
```
✓ SUCCESS: SMS sent to broker: 9876543210
✓ SUCCESS: Payment success SMS sent to user: john_doe
✗ ERROR: Failed to send SMS: Connection timeout
```

#### Check 3: API Response
Enable debug mode in SMSUtil.java:
```java
System.out.println("SMS API Response: " + response.toString());
```

#### Check 4: SMS API Status
- Login to SMS provider dashboard
- Check SMS balance
- Verify API is active
- Check DLT registration status

### Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "Connection timeout" | Network issue | Check internet connectivity |
| "Invalid credentials" | Wrong username/password | Update credentials in SMSUtil.java |
| "Invalid template" | Template not approved | Contact SMS provider |
| "Insufficient balance" | No SMS credits | Recharge SMS account |
| "Invalid mobile number" | Wrong format | Verify mobile number format |

---

## 📊 Monitoring

### Console Logs to Monitor
```bash
# Success messages
INFO: SMS sent to broker: [mobile]
INFO: Payment success SMS sent to user: [username]
INFO: Forgot password SMS sent to user: [username]

# Error messages  
ERROR: Failed to send SMS to broker: [error]
ERROR: Failed to send payment SMS: [error]
```

### SMS Delivery Tracking
1. Check SMS provider dashboard
2. View sent messages report
3. Check delivery status
4. Monitor SMS balance

---

## 🔐 Security Notes

### Production Deployment
- [ ] Never commit SMS credentials to Git
- [ ] Add `sms.properties` to `.gitignore`
- [ ] Use environment variables for credentials (recommended)
- [ ] Implement rate limiting to prevent abuse
- [ ] Log SMS activity for audit trail
- [ ] Restrict admin SMS panel to super admin only

### Environment Variables (Recommended)
```java
// Instead of hardcoding, use:
private static final String SMS_USER = System.getenv("SMS_USER");
private static final String SMS_PASSWORD = System.getenv("SMS_PASSWORD");
```

---

## 📝 Post-Deployment Tasks

### Week 1
- [ ] Monitor all SMS sends
- [ ] Check for any failed SMS
- [ ] Verify SMS delivery rate
- [ ] Collect user feedback
- [ ] Check SMS costs

### Monthly
- [ ] Review SMS usage statistics
- [ ] Check SMS balance
- [ ] Verify DLT registration status
- [ ] Update templates if needed
- [ ] Review failed SMS logs

---

## 📞 Support Contacts

### SMS Provider Support
- **Website:** http://shreeitsms.in
- **Support:** [Contact from website]
- **API Docs:** [Available on dashboard]

### System Support
- **Developer:** Shree IT Solutions
- **Email:** support@emsonline.in

---

## ✅ Final Checklist Before Going Live

- [ ] All SMS credentials updated
- [ ] All 5 SMS scenarios tested successfully
- [ ] Admin SMS panel tested
- [ ] Console logs reviewed
- [ ] SMS balance sufficient
- [ ] Backup SMS provider configured (optional)
- [ ] Documentation reviewed by team
- [ ] Stakeholders notified about SMS feature
- [ ] User training completed (for admin SMS panel)
- [ ] Monitoring system in place

---

**Setup Date:** _____________
**Tested By:** _____________
**Approved By:** _____________
**Deployment Date:** _____________

**Status:** ⬜ Pending | ⬜ In Progress | ⬜ Completed

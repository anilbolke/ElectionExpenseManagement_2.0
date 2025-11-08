# SMS Integration Feature

## Overview
The Election Expense Management System now includes SMS notification functionality using Shree IT SMS API.

## Features Implemented

### 1. Automated SMS Notifications

#### Scenario 1: Broker Registration Success
**Trigger:** When admin successfully registers a new broker
**Recipient:** Broker's mobile number
**Message:**
```
Dear [Broker Name],
Your registration as a Broker for our Election Expense Mgmt Software is successful.
Your Code is: [REFERRAL_CODE]
Use this code for all sales to track commission accurately.
Start selling now!
EMSonline.in
Shree IT Solutions
```

#### Scenario 2: Forgot Password
**Trigger:** When user resets password
**Recipient:** User's mobile number
**Message:**
```
Dear User,
Your password for [USERNAME] is [PASSWORD]
EMS Online
Shree IT Solutions
```

#### Scenario 3: Payment Success
**Trigger:** When payment is successfully completed (subscription or candidate registration)
**Recipient:** User's mobile number
**Message:**
```
Success!
Your payment of Rs.[AMOUNT] is successful. Subscription is confirmed.
Your service is now active!
Thank you for your purchase.
EMSOnline
Shree IT Solutions
```

#### Scenario 4: Referral Code Mapping
**Trigger:** When user maps a referral code to their account
**Recipient:** Broker's mobile number
**Message:**
```
Congratulations!
Your referral code [REFERRAL_CODE] has been successfully applied to [USERNAME]
Complete payment and start earning now!
EMSOnline
Shree IT Solutions
```

### 2. Admin SMS Panel
**Location:** Admin Dashboard → Send SMS menu
**Features:**
- Send SMS to specific users or brokers
- Select recipients from dropdown or table
- Filter users by role (All/Users/Brokers only)
- Character counter (160 char limit)
- Quick message templates
- Real-time mobile number validation

## File Structure

### Backend Files
```
src/com/election/util/SMSUtil.java
├── sendSMS() - Send single SMS
├── sendBulkSMS() - Send multiple SMS
├── sendBrokerRegistrationSMS()
├── sendForgotPasswordSMS()
├── sendPaymentSuccessSMS()
└── sendReferralMappedSMS()

src/com/election/servlet/
├── SendSMSServlet.java - Admin SMS panel API
├── RegisterBrokerServlet.java - Updated with SMS integration
├── MapReferralCodeServlet.java - Updated with SMS integration
├── PaymentServlet.java - Updated with SMS integration
└── ForgotPasswordServlet.java - Updated with SMS integration
```

### Frontend Files
```
WebContent/admin/send-sms.jsp - Admin SMS panel UI
WebContent/includes/admin-navbar.jsp - Updated with SMS menu link
```

### Configuration Files
```
src/sms.properties.example - Example SMS configuration
```

## API Configuration

### SMS API Endpoint
```
URL: http://shreeitsms.in/REST/sendsms/
Method: POST
Content-Type: application/json
```

### Request Format
```json
{
  "listsms": [
    {
      "sms": "Your message here",
      "mobiles": "+918909999889",
      "senderid": "INFOSM",
      "clientsmsid": "1947692308",
      "accountusagetypeid": "1",
      "entityid": "1234567891112131415",
      "tempid": "1034567891112131819"
    }
  ],
  "password": "8a65a0416eXX",
  "user": "emsonline"
}
```

### Response Format
```json
{
  "smslist": {
    "sms": [
      {
        "reason": "success",
        "status": "success",
        "messageid": 260299414,
        "clientsmsid": 1947692308,
        "code": "000",
        "mobileno": "+918909999889"
      }
    ]
  }
}
```

## Setup Instructions

### 1. Update SMS Credentials
Edit `SMSUtil.java` with your actual credentials:
```java
private static final String SMS_USER = "your_username";
private static final String SMS_PASSWORD = "your_password";
private static final String SENDER_ID = "your_sender_id";
private static final String ENTITY_ID = "your_entity_id";
private static final String TEMP_ID = "your_template_id";
```

### 2. Add Required Dependencies
Add to `pom.xml` or lib folder:
```xml
<!-- JSON processing -->
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20210307</version>
</dependency>
```

### 3. Database Requirements
Ensure users table has `mobile` column:
```sql
ALTER TABLE users ADD COLUMN IF NOT EXISTS mobile VARCHAR(15);
```

### 4. Deploy and Test
1. Build project: `mvn clean package`
2. Deploy to Tomcat
3. Test admin SMS panel: Login as admin → Send SMS
4. Test automated SMS: Register broker, make payment, etc.

## Usage Guide

### For Admins

#### Accessing SMS Panel
1. Login as admin
2. Navigate to "Send SMS" in the menu
3. Select recipient from dropdown or table
4. Compose message (max 160 characters)
5. Click "Send SMS"

#### Quick Filters
- **All Users** - Show all users and brokers
- **Only Users** - Show only regular users
- **Only Brokers** - Show only brokers

#### Message Templates
- **Welcome Message** - New user welcome
- **Payment Reminder** - Pending payment reminder
- **Thank You** - Post-purchase thank you
- **Account Update** - Account update notification

### Mobile Number Format
The system automatically formats mobile numbers:
- Input: `9876543210` → Formatted: `+919876543210`
- Input: `919876543210` → Formatted: `+919876543210`
- Input: `+919876543210` → No change

## Testing

### Test Broker Registration SMS
1. Login as admin
2. Go to "Register Broker"
3. Fill form with test mobile number
4. Submit - SMS should be sent to broker

### Test Payment Success SMS
1. Login as user
2. Add candidate or select subscription
3. Complete payment
4. SMS should be sent after successful payment

### Test Referral Mapping SMS
1. Login as user
2. Go to "Map Referral Code"
3. Enter valid broker referral code
4. SMS should be sent to broker

### Test Forgot Password SMS
1. Go to "Forgot Password"
2. Enter username or mobile
3. Reset password
4. SMS should be sent with new password

### Test Admin SMS Panel
1. Login as admin
2. Go to "Send SMS"
3. Select any user/broker
4. Send test message

## Error Handling

### Common Issues

#### SMS Not Sending
- Check internet connectivity
- Verify API credentials in `SMSUtil.java`
- Check SMS API balance
- Verify mobile number format

#### Invalid Mobile Number
- Must be 10 digits starting with 6-9
- System auto-formats to +91 prefix

#### API Errors
- Check API endpoint URL
- Verify entity ID and template ID
- Check sender ID approval status

### Debug Logs
SMS operations are logged to console:
```
INFO: SMS sent to broker: 9876543210
INFO: Payment success SMS sent to user: john_doe
ERROR: Failed to send SMS to broker: Connection timeout
```

## Security Considerations

1. **Never commit credentials** - Add `sms.properties` to `.gitignore`
2. **Validate mobile numbers** - Always validate before sending
3. **Rate limiting** - Implement if needed to prevent abuse
4. **Admin-only access** - Only admins can use SMS panel
5. **Log SMS activity** - Keep audit trail of sent messages

## Future Enhancements

### Planned Features
- [ ] SMS templates management UI
- [ ] Scheduled SMS sending
- [ ] Bulk SMS upload via CSV
- [ ] SMS delivery reports
- [ ] SMS cost tracking
- [ ] Custom message variables
- [ ] Multi-language SMS support
- [ ] SMS history/logs page
- [ ] SMS quota management

### API Improvements
- [ ] Async SMS sending (non-blocking)
- [ ] Retry mechanism for failed SMS
- [ ] Queue system for bulk SMS
- [ ] Webhook for delivery status

## Support

### Contact
- **Developer:** Shree IT Solutions
- **Email:** support@emsonline.in
- **SMS API:** http://shreeitsms.in

### Documentation
- SMS API Docs: [Shree IT SMS Documentation]
- System Documentation: [EMS Documentation]

## Changelog

### Version 1.0 (Current)
- Initial SMS integration
- 4 automated scenarios implemented
- Admin SMS panel created
- Basic error handling
- Mobile number formatting

---

**Last Updated:** November 8, 2025
**Version:** 1.0
**Status:** ✅ Production Ready

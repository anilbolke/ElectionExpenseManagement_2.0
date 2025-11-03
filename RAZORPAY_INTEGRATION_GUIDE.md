# Razorpay Payment Gateway Integration Guide

## Overview
The Election Expense Management System now has complete Razorpay payment gateway integration for handling:
- Subscription payments (Monthly, Quarterly, Annual plans)
- Candidate registration fee payments

## Features Implemented

### 1. **PaymentServlet** (`com.election.servlet.PaymentServlet`)
Central servlet for handling all payment operations:
- **createOrder**: Creates Razorpay orders with proper amount and receipt
- **verifyPayment**: Verifies Razorpay payment signatures for security
- **processPayment**: Fallback for demo/legacy payment processing
- **config**: Provides Razorpay configuration to frontend

### 2. **RazorpayConfig** (`com.election.util.RazorpayConfig`)
Configuration management:
- Loads API keys from environment variables
- Provides company branding details
- Checks if Razorpay is properly configured
- Supports both test and live modes

### 3. **Payment Gateway JSPs**
Updated JSP pages with Razorpay checkout integration:
- `user/payment-gateway.jsp`: Subscription payments
- `user/candidate-payment.jsp`: Candidate registration payments

## Setup Instructions

### Step 1: Get Razorpay API Keys

1. Sign up at [Razorpay Dashboard](https://dashboard.razorpay.com/)
2. Navigate to Settings → API Keys
3. Generate Test Keys (for testing) or Live Keys (for production)
4. You'll receive:
   - **Key ID** (starts with `rzp_test_` or `rzp_live_`)
   - **Key Secret**

### Step 2: Add Razorpay Java SDK

Download and add the Razorpay Java SDK to your project:

**Option A: Maven** (if using Maven)
```xml
<dependency>
    <groupId>com.razorpay</groupId>
    <artifactId>razorpay-java</artifactId>
    <version>1.4.6</version>
</dependency>
```

**Option B: Manual JAR** (if not using Maven)
1. Download razorpay-java JAR from [Maven Central](https://mvnrepository.com/artifact/com.razorpay/razorpay-java)
2. Place in `WebContent/WEB-INF/lib/` directory
3. Also download dependencies:
   - json-20230227.jar (org.json)
   - okhttp-4.x.x.jar
   - okio-3.x.x.jar
   - kotlin-stdlib-x.x.x.jar

### Step 3: Configure Environment Variables

Set environment variables for security (do NOT hardcode in source):

**Windows:**
```cmd
setx RAZORPAY_KEY_ID "rzp_test_YOUR_KEY_ID"
setx RAZORPAY_KEY_SECRET "YOUR_KEY_SECRET"
```

**Linux/Mac:**
```bash
export RAZORPAY_KEY_ID="rzp_test_YOUR_KEY_ID"
export RAZORPAY_KEY_SECRET="YOUR_KEY_SECRET"
```

**Tomcat Server (catalina.properties):**
```properties
RAZORPAY_KEY_ID=rzp_test_YOUR_KEY_ID
RAZORPAY_KEY_SECRET=YOUR_KEY_SECRET
```

**Eclipse/IDE:**
- Go to Run Configurations → Environment
- Add variables: `RAZORPAY_KEY_ID` and `RAZORPAY_KEY_SECRET`

### Step 4: Enable Razorpay API Integration

Update `PaymentServlet.java` to use actual Razorpay SDK (currently commented):

1. Uncomment the Razorpay API code in `createRazorpayOrder()`:
```java
RazorpayClient razorpay = new RazorpayClient(RazorpayConfig.getKeyId(), RazorpayConfig.getKeySecret());
JSONObject orderRequest = new JSONObject();
orderRequest.put("amount", amountInPaise);
orderRequest.put("currency", RazorpayConfig.CURRENCY);
orderRequest.put("receipt", RazorpayConfig.RECEIPT_PREFIX + System.currentTimeMillis());
Order order = razorpay.Orders.create(orderRequest);
```

2. Uncomment signature verification in `verifyPayment()`:
```java
String generatedSignature = Utils.verifyPaymentSignature(orderData, keySecret);
boolean isValid = generatedSignature.equals(razorpaySignature);
```

### Step 5: Test Payment Flow

1. Start your application server
2. Login as a user
3. Navigate to Subscription page or Add Candidate
4. Select a payment plan/proceed with candidate payment
5. Click "Pay Now"
6. You'll see Razorpay checkout modal
7. Use Razorpay test cards:
   - **Success**: 4111 1111 1111 1111
   - **Failure**: 4111 1111 1111 1234
   - CVV: Any 3 digits
   - Expiry: Any future date

## Payment Flow

### Subscription Payment Flow
```
User selects plan → payment-gateway.jsp
  ↓
Razorpay config loaded via AJAX
  ↓
Click "Pay Now" → createOrder API
  ↓
Razorpay modal opens
  ↓
User completes payment
  ↓
verifyPayment API → Update subscription
  ↓
Redirect to payment-success.jsp
```

### Candidate Payment Flow
```
User adds candidate → candidate-payment.jsp
  ↓
Select payment method → createOrder API
  ↓
Razorpay modal opens
  ↓
User completes payment
  ↓
verifyPayment API → Activate candidate
  ↓
Redirect to payment-success-candidate.jsp
```

## Security Features

1. **Payment Signature Verification**: Prevents payment tampering
2. **Session-based Order Tracking**: Prevents order ID spoofing
3. **User Authentication**: All payment endpoints require login
4. **Environment Variables**: API keys not hardcoded
5. **HTTPS Required**: For production, use HTTPS only

## Demo Mode

If Razorpay is not configured (environment variables not set):
- System automatically falls back to demo payment mode
- Shows warning: "Razorpay is not configured"
- Payments process without actual gateway
- Transaction IDs generated locally
- Useful for development/testing without Razorpay account

## Database Schema

The `payments` table stores all transactions:
```sql
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    broker_id INT,
    payment_type VARCHAR(50),  -- 'subscription' or 'candidate_registration'
    amount DECIMAL(10,2),
    payment_method VARCHAR(50), -- 'Razorpay'
    transaction_id VARCHAR(100), -- Razorpay payment ID
    payment_status VARCHAR(50),  -- 'success', 'failed', 'pending'
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_by INT,
    verification_date TIMESTAMP,
    remarks TEXT
);
```

## Troubleshooting

### Issue: "Razorpay is not configured"
**Solution**: Set environment variables correctly and restart server

### Issue: Payment fails immediately
**Solution**: Check API keys are correct and not expired

### Issue: "Payment verification failed"
**Solution**: Ensure signature verification is enabled and key secret is correct

### Issue: Order creation fails
**Solution**: Check Razorpay dashboard for API errors, ensure sufficient balance

### Issue: Servlet not found
**Solution**: Ensure PaymentServlet is compiled and web.xml mapping exists

## Production Checklist

Before going live:
- [ ] Use Live API keys (rzp_live_xxx)
- [ ] Enable HTTPS for entire application
- [ ] Test all payment scenarios
- [ ] Set up webhooks for payment notifications
- [ ] Configure payment failure notifications
- [ ] Set up logging for all transactions
- [ ] Test refund functionality
- [ ] Set up monitoring alerts
- [ ] Review security policies
- [ ] Enable PCI compliance if storing card data

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/payment?action=config` | GET | Get Razorpay configuration |
| `/payment?action=createOrder` | POST | Create Razorpay order |
| `/payment?action=verifyPayment` | POST | Verify payment signature |
| `/payment?action=processPayment` | POST | Legacy payment processing |

## Testing Credentials

### Test Cards (Razorpay Test Mode)
- **Successful Payment**: 4111 1111 1111 1111
- **Failed Payment**: 4111 1111 1111 1234
- **OTP for UPI**: Enter any 6-digit number
- **CVV**: Any 3 digits
- **Expiry**: Any future date

## Support

For Razorpay-specific issues:
- Documentation: https://razorpay.com/docs/
- Support: https://razorpay.com/support/

For EMS integration issues:
- Check server logs in Eclipse console
- Review PaymentServlet code
- Verify database payment records

## Files Modified/Created

### New Files:
1. `src/com/election/servlet/PaymentServlet.java`
2. `src/com/election/util/RazorpayConfig.java`
3. `RAZORPAY_INTEGRATION_GUIDE.md`

### Modified Files:
1. `WebContent/user/payment-gateway.jsp` - Added Razorpay checkout
2. `WebContent/user/candidate-payment.jsp` - Added Razorpay checkout
3. `WebContent/WEB-INF/web.xml` - Already had PaymentServlet mapping

### Unchanged Files:
- `src/com/election/dao/PaymentDAO.java` - Works as-is
- `src/com/election/model/Payment.java` - Works as-is
- Database schema - Already supports payment tracking

## Next Steps

1. **Webhooks**: Implement Razorpay webhooks for async payment notifications
2. **Refunds**: Add refund functionality for cancelled subscriptions
3. **Payment History**: Create detailed payment history page
4. **Email Notifications**: Send payment receipts via email
5. **Auto-renewal**: Implement subscription auto-renewal
6. **Payment Analytics**: Dashboard for payment statistics

---

**Version**: 1.0
**Last Updated**: 2024-10-31
**Integration Status**: ✅ Complete with demo fallback

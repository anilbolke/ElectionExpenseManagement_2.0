# Razorpay Integration Setup Guide

## ✅ Current Status
The Election Expense Management system already has **REAL Razorpay integration** implemented!

The system is currently running in **demo mode** because Razorpay credentials are not configured.

## 🔧 How It Works

### Architecture
1. **RazorpayConfig.java** - Stores API credentials and configuration
2. **PaymentServlet.java** - Handles payment processing with real Razorpay API
3. **Frontend Pages** - Use Razorpay Checkout modal for payments

### Payment Flow
```
User clicks Pay → Create Razorpay Order (via API) → 
Razorpay Checkout Modal → Payment → 
Verify Signature → Update Database → Success Page
```

## 📝 Setup Steps

### Step 1: Get Razorpay Credentials

1. Go to [https://razorpay.com](https://razorpay.com)
2. Sign up or log in to your account
3. Navigate to **Settings** → **API Keys**
4. Generate or copy your:
   - **Key ID** (starts with `rzp_test_` or `rzp_live_`)
   - **Key Secret** (keep this secure!)

### Step 2: Configure Credentials

**Option A: Using Environment Variables (Recommended)**

Set environment variables on your system:

**Windows:**
```cmd
setx RAZORPAY_KEY_ID "rzp_test_YOUR_ACTUAL_KEY_ID"
setx RAZORPAY_KEY_SECRET "YOUR_ACTUAL_KEY_SECRET"
```

**Linux/Mac:**
```bash
export RAZORPAY_KEY_ID="rzp_test_YOUR_ACTUAL_KEY_ID"
export RAZORPAY_KEY_SECRET="YOUR_ACTUAL_KEY_SECRET"
```

**Option B: Modify RazorpayConfig.java**

Edit: `src/com/election/util/RazorpayConfig.java`

Replace:
```java
private static final String KEY_ID = System.getenv("RAZORPAY_KEY_ID") != null ? 
                                     System.getenv("RAZORPAY_KEY_ID") : "rzp_test_YOUR_KEY_ID";

private static final String KEY_SECRET = System.getenv("RAZORPAY_KEY_SECRET") != null ? 
                                         System.getenv("RAZORPAY_KEY_SECRET") : "YOUR_KEY_SECRET";
```

With:
```java
private static final String KEY_ID = System.getenv("RAZORPAY_KEY_ID") != null ? 
                                     System.getenv("RAZORPAY_KEY_ID") : "rzp_test_1234567890ABCD";

private static final String KEY_SECRET = System.getenv("RAZORPAY_KEY_SECRET") != null ? 
                                         System.getenv("RAZORPAY_KEY_SECRET") : "YourActualSecretKey123";
```

⚠️ **Security Warning:** Never commit actual credentials to version control!

### Step 3: Restart Your Application

After setting credentials:
1. Stop Tomcat server
2. Clean and rebuild the project
3. Start Tomcat server

### Step 4: Test the Integration

1. Navigate to **Subscription** or **Candidate Payment** page
2. Click on **Pay Now** button
3. You should see the **real Razorpay checkout modal**
4. Use Razorpay test cards for testing:
   - Card: `4111 1111 1111 1111`
   - CVV: Any 3 digits
   - Expiry: Any future date

## 🎯 Features Implemented

### ✅ Subscription Payments
- Location: `WebContent/user/subscription.jsp`
- Creates Razorpay order via API
- Shows Razorpay checkout modal
- Verifies payment signature
- Updates subscription status

### ✅ Candidate Registration Payments
- Location: `WebContent/user/candidate-payment.jsp`
- Creates Razorpay order via API
- Shows Razorpay checkout modal
- Verifies payment signature
- Updates candidate payment status

### ✅ Payment Verification
- HMAC SHA256 signature verification
- Secure payment validation
- Prevents payment tampering
- Records all transactions

## 🔍 How to Check if Razorpay is Active

### In Browser Console:
1. Open payment page
2. Press F12 (Developer Tools)
3. Check Console logs:
   - `✅ Razorpay configured!` = Real Razorpay active
   - `⚠️ Razorpay not configured` = Demo mode

### In Application:
- If Razorpay checkout modal appears = Real integration working
- If form submits directly = Demo mode (fallback)

## 📊 Payment Records

All payments are recorded in the `payments` table:
- Transaction ID (Razorpay payment ID)
- Amount
- Payment status
- Payment method
- Timestamp

## 🐛 Troubleshooting

### Issue: "Razorpay not configured" message
**Solution:** Set environment variables or update RazorpayConfig.java

### Issue: Order creation fails
**Solution:** 
- Check API credentials are correct
- Verify internet connection
- Check Razorpay dashboard for API status

### Issue: Payment verification fails
**Solution:**
- Ensure Key Secret matches the one in Razorpay dashboard
- Check if signature verification is working
- Review server logs for errors

### Issue: Checkout modal doesn't appear
**Solution:**
- Check if Razorpay script is loaded: `https://checkout.razorpay.com/v1/checkout.js`
- Check browser console for JavaScript errors
- Verify Razorpay Key ID is correct

## 📞 Support

For Razorpay-specific issues:
- Documentation: https://razorpay.com/docs/
- Support: https://razorpay.com/support/

## 🔐 Security Best Practices

1. ✅ **Never** commit credentials to Git
2. ✅ Use environment variables in production
3. ✅ Use test credentials for development
4. ✅ Keep Key Secret secure
5. ✅ Enable webhook signature verification (optional)
6. ✅ Use HTTPS in production

## 🚀 Going Live

When ready for production:

1. Switch from Test to Live credentials:
   - Key ID: `rzp_live_...`
   - Key Secret: Live secret key

2. Complete Razorpay activation:
   - Submit KYC documents
   - Add bank account details
   - Complete verification

3. Update domain in Razorpay dashboard

4. Test thoroughly before going live!

## 💡 Additional Features

The implementation supports:
- ✅ Multiple payment types (subscription, candidate registration)
- ✅ INR currency
- ✅ Automatic amount conversion to paise
- ✅ Order tracking
- ✅ Payment status updates
- ✅ Success/Failure handling
- ✅ Fallback to demo mode if not configured

---

**Note:** The system is production-ready! Just add your Razorpay credentials to activate real payment processing.

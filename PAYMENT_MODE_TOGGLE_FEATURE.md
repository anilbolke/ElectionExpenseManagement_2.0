# 💳 Payment Mode Toggle Feature

## Overview
This feature allows administrators to toggle between two payment methods:
1. **Razorpay Online Gateway** - Integrated online payment with automatic verification
2. **QR Code Payment** - Manual QR code scan & pay with transaction ID submission

## 🎯 Key Features

### Backend-Controlled Toggle
- ✅ **No user-facing toggle** - Payment mode is controlled entirely from backend
- ✅ **Admin panel control** - Admins can switch modes via dedicated settings page
- ✅ **Database-driven** - Setting stored in `system_settings` table
- ✅ **Instant effect** - Changes apply immediately to all payment pages

### Two Payment Modes

#### 1. Razorpay Mode (Default)
- Integrated Razorpay payment gateway
- Multiple payment methods (UPI, Card, Net Banking, Wallet)
- Automatic payment verification
- Instant account activation
- Real-time payment tracking

#### 2. QR Code Mode
- Static QR code displayed (`WebContent/Document/QrCode.jpeg`)
- Users scan with any UPI app
- Manual transaction ID entry
- Admin verification required
- No gateway fees

## 📁 Files Modified

### 1. Payment Gateway Pages
- **`WebContent/user/payment-gateway.jsp`** - Subscription payment page
  - Checks `payment_mode` setting from database
  - Shows Razorpay OR QR code based on setting
  - Conditional script loading (Razorpay.js only when needed)

- **`WebContent/user/candidate-payment.jsp`** - Candidate registration payment
  - Same logic as payment-gateway.jsp
  - Supports QR code payment with transaction ID submission

### 2. Admin Panel
- **`WebContent/admin/payment-settings.jsp`** - NEW FILE
  - Admin interface to toggle payment mode
  - Visual comparison of both modes
  - Instant save with confirmation

### 3. Database
- **`database/add_payment_mode_setting.sql`** - NEW FILE
  - SQL script to add `payment_mode` setting
  - Default value: `razorpay`

## 🚀 Installation Steps

### Step 1: Run Database Script
```sql
-- Execute this SQL script
source database/add_payment_mode_setting.sql;

-- Or manually run:
INSERT INTO system_settings (setting_key, setting_value, description, updated_date) 
VALUES ('payment_mode', 'razorpay', 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE description = 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)';
```

### Step 2: Place QR Code Image
Ensure your QR code image is at:
```
WebContent/Document/QrCode.jpeg
```
**Current location confirmed:** ✅ File exists

### Step 3: Access Admin Panel
1. Login as admin
2. Navigate to: `/admin/payment-settings.jsp`
3. Select payment mode (Razorpay or QR Code)
4. Click "Save Payment Settings"

## 📋 How It Works

### Architecture Flow

```
User Visits Payment Page
         ↓
System reads 'payment_mode' from database
         ↓
    Is it 'qrcode'?
    ↙        ↘
  YES        NO
   ↓          ↓
Show QR    Show Razorpay
Code Form  Gateway
   ↓          ↓
Manual     Automatic
Verify     Verify
```

### Database Setting
```sql
-- Setting structure
setting_key: 'payment_mode'
setting_value: 'razorpay' OR 'qrcode'
description: 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)'
```

### Code Logic (JSP)
```java
// Get payment mode from database
SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
String paymentMode = settingsDAO.getSetting("payment_mode", "razorpay");
boolean useQRCode = "qrcode".equalsIgnoreCase(paymentMode);

// Conditional rendering
<% if (useQRCode) { %>
    <!-- Show QR Code -->
<% } else { %>
    <!-- Show Razorpay -->
<% } %>
```

## 🎨 User Experience

### QR Code Payment Flow
1. User sees amount to pay
2. QR code displayed prominently
3. Instructions in English & Marathi
4. User scans with any UPI app
5. Makes payment
6. Returns to form
7. Enters transaction ID
8. Submits for verification

### Razorpay Payment Flow
1. User sees amount to pay
2. Clicks "Pay" button
3. Razorpay modal opens
4. Completes payment
5. Automatic verification
6. Instant activation

## 🔧 Admin Operations

### Change to QR Code Mode
```sql
UPDATE system_settings 
SET setting_value = 'qrcode' 
WHERE setting_key = 'payment_mode';
```
**Or use admin panel:** `/admin/payment-settings.jsp`

### Change to Razorpay Mode
```sql
UPDATE system_settings 
SET setting_value = 'razorpay' 
WHERE setting_key = 'payment_mode';
```
**Or use admin panel:** `/admin/payment-settings.jsp`

## 📱 QR Code Payment Features

### Form Fields
- **Transaction ID** (Required) - UPI transaction reference number
- **Payment Screenshot** (Optional) - For faster verification

### Validation
- Transaction ID format validation
- Terms & conditions acceptance required
- Amount display for reference

### Admin Verification
When QR Code mode is active, admins need to:
1. Check submitted transaction IDs
2. Verify payment in UPI app/bank statement
3. Manually activate accounts

## ⚙️ Configuration

### System Settings Table
```sql
CREATE TABLE IF NOT EXISTS system_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    setting_value TEXT NOT NULL,
    description TEXT,
    updated_by INT,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Default Values
| Setting | Default | Options |
|---------|---------|---------|
| payment_mode | razorpay | razorpay, qrcode |
| candidate_registration_fee | 5000.00 | Numeric value |

## 🔐 Security Considerations

### QR Code Mode
- ✅ Static QR code - No dynamic generation
- ✅ Manual verification prevents fraud
- ✅ Transaction ID recorded for audit
- ⚠️ Requires admin vigilance

### Razorpay Mode
- ✅ Signature verification
- ✅ Webhook validation
- ✅ Encrypted transactions
- ✅ PCI DSS compliant

## 📊 Benefits Comparison

| Feature | Razorpay | QR Code |
|---------|----------|---------|
| Automation | ✅ Full | ❌ Manual |
| Payment Methods | ✅ Multiple | 🟡 UPI Only |
| Verification | ✅ Instant | ❌ Manual |
| Gateway Fees | ❌ Yes | ✅ None |
| Setup Complexity | 🟡 Medium | ✅ Easy |
| User Experience | ✅ Smooth | 🟡 Good |
| Admin Effort | ✅ Minimal | 🟡 Moderate |

## 🧪 Testing

### Test QR Code Mode
1. Run database script to add setting
2. Set payment_mode to 'qrcode'
3. Visit: `/user/payment-gateway.jsp?planName=Monthly&paymentMethod=UPI&amount=500`
4. Verify QR code is displayed
5. Check transaction ID form appears
6. Test form submission

### Test Razorpay Mode
1. Set payment_mode to 'razorpay'
2. Visit same payment page
3. Verify Razorpay form appears
4. Check QR code is NOT shown
5. Test Razorpay integration

### Test Admin Panel
1. Login as admin
2. Visit: `/admin/payment-settings.jsp`
3. Toggle between modes
4. Verify changes save
5. Check payment pages reflect change

## 🐛 Troubleshooting

### QR Code Not Showing
✅ **Check:** Is payment_mode set to 'qrcode'?
✅ **Check:** Does QrCode.jpeg exist in Document folder?
✅ **Check:** File permissions correct?

### Razorpay Not Loading
✅ **Check:** Is payment_mode set to 'razorpay'?
✅ **Check:** Are Razorpay credentials configured?
✅ **Check:** Is Razorpay.js loading?

### Admin Panel Not Accessible
✅ **Check:** Logged in as admin?
✅ **Check:** Correct URL: `/admin/payment-settings.jsp`
✅ **Check:** Admin navbar includes link?

## 📝 Notes

- **No restart required** - Changes apply immediately
- **All pages affected** - Both subscription and candidate payments
- **Backward compatible** - Default to Razorpay if setting missing
- **QR code path:** `/Document/QrCode.jpeg` (context-relative)

## 🔮 Future Enhancements

Potential improvements:
- [ ] Multiple QR codes (per amount)
- [ ] Dynamic QR code generation
- [ ] Auto-verification via payment gateway API
- [ ] Payment status dashboard
- [ ] Transaction history export
- [ ] Email notifications for QR payments

## 📞 Support

For issues or questions:
1. Check this documentation
2. Verify database setting
3. Check server logs
4. Test with browser console open
5. Contact system administrator

---

**Version:** 1.0  
**Last Updated:** November 2024  
**Status:** ✅ Production Ready

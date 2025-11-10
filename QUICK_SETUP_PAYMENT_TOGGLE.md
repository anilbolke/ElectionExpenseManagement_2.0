# 🚀 Quick Setup Guide - Payment Mode Toggle

## ✅ What Was Added

A backend-controlled payment mode toggle that allows admins to switch between:
- **Razorpay Online Gateway** (automatic payment)
- **QR Code Payment** (manual payment with your QR code)

## 📋 Setup Steps

### Step 1: Run Database Script (REQUIRED)

Execute this SQL in your MySQL database:

```sql
INSERT INTO system_settings (setting_key, setting_value, description, updated_date) 
VALUES ('payment_mode', 'razorpay', 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE 
    description = 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)',
    updated_date = CURRENT_TIMESTAMP;
```

**Or run the SQL file:**
```bash
mysql -u your_username -p your_database < database/add_payment_mode_setting.sql
```

### Step 2: Verify QR Code File

Your QR code is already present at:
```
✅ WebContent/Document/QrCode.jpeg (391 KB)
```

### Step 3: Access Admin Panel

1. **Start your Tomcat server**
2. **Login as admin**
3. **Navigate to:** `http://localhost:8080/YourApp/admin/payment-settings.jsp`
4. **Select payment mode:**
   - Choose "Razorpay" for automatic online payments
   - Choose "QR Code" for manual UPI payments
5. **Click "Save Payment Settings"**

## 🎯 How to Use

### To Enable QR Code Payments

**Option 1: Via Admin Panel (Recommended)**
1. Go to `/admin/payment-settings.jsp`
2. Select "QR Code Payment"
3. Click Save

**Option 2: Via SQL**
```sql
UPDATE system_settings 
SET setting_value = 'qrcode' 
WHERE setting_key = 'payment_mode';
```

### To Enable Razorpay Payments

**Option 1: Via Admin Panel (Recommended)**
1. Go to `/admin/payment-settings.jsp`
2. Select "Razorpay Online Gateway"
3. Click Save

**Option 2: Via SQL**
```sql
UPDATE system_settings 
SET setting_value = 'razorpay' 
WHERE setting_key = 'payment_mode';
```

## 🔍 What Happens When You Switch

### When QR Code Mode is Active:
- Payment pages show your QR code (`QrCode.jpeg`)
- Users scan and pay with any UPI app
- Users enter Transaction ID manually
- No Razorpay scripts load (faster page load)
- Admin must verify payments manually

### When Razorpay Mode is Active:
- Payment pages show Razorpay gateway
- Users pay via Razorpay checkout
- Automatic payment verification
- Instant account activation
- Razorpay scripts load

## 📍 Affected Pages

Both modes work on:
1. **Subscription Payment:** `/user/payment-gateway.jsp`
2. **Candidate Registration Payment:** `/user/candidate-payment.jsp`

## ✨ Key Features

- ✅ **No user-facing toggle** - Controlled only by admin
- ✅ **Instant switch** - No server restart needed
- ✅ **Database-driven** - Setting stored in database
- ✅ **Automatic detection** - Pages detect mode automatically
- ✅ **Bilingual support** - Instructions in English & Marathi

## 🧪 Testing

### Test QR Code Mode:
```bash
1. Set payment_mode to 'qrcode' (admin panel or SQL)
2. Visit: http://localhost:8080/YourApp/user/payment-gateway.jsp?planName=Monthly&paymentMethod=UPI&amount=500
3. You should see:
   - Your QR Code image displayed
   - Transaction ID input field
   - Payment instructions in English & Marathi
   - NO Razorpay button
```

### Test Razorpay Mode:
```bash
1. Set payment_mode to 'razorpay' (admin panel or SQL)
2. Visit same URL
3. You should see:
   - Razorpay payment form
   - Card/UPI/NetBanking options
   - "Pay with Razorpay" button
   - NO QR Code
```

## 📁 Files Created/Modified

### New Files:
- ✅ `admin/payment-settings.jsp` - Admin control panel
- ✅ `database/add_payment_mode_setting.sql` - Database setup
- ✅ `PAYMENT_MODE_TOGGLE_FEATURE.md` - Full documentation
- ✅ `QUICK_SETUP_PAYMENT_TOGGLE.md` - This file

### Modified Files:
- ✅ `user/payment-gateway.jsp` - Added QR code support
- ✅ `user/candidate-payment.jsp` - Added QR code support

### Existing Files Used:
- ✅ `WebContent/Document/QrCode.jpeg` - Your QR code (already exists)

## 🎨 Admin Panel Link

Add this to your admin navigation menu (`admin-navbar.jsp`):

```jsp
<li>
    <a href="<%=request.getContextPath()%>/admin/payment-settings.jsp">
        <i class="icon">💳</i> Payment Settings
    </a>
</li>
```

## ❓ FAQ

**Q: Does this affect existing payments?**  
A: No, only new payments after the mode is changed.

**Q: Can I switch modes anytime?**  
A: Yes, instantly without server restart.

**Q: Do I need to configure anything for QR mode?**  
A: No, just place your QR code at `WebContent/Document/QrCode.jpeg` (already done ✅)

**Q: What if the QR code image is missing?**  
A: Users will see a broken image. Make sure QrCode.jpeg exists.

**Q: Can I test both modes?**  
A: Yes, switch between them in admin panel anytime.

**Q: Does QR mode work for both subscription and candidate payments?**  
A: Yes, both pages support QR code mode.

## 🔧 Troubleshooting

### Issue: QR Code not showing
**Solution:** 
```bash
# Check if file exists
ls WebContent/Document/QrCode.jpeg

# Check file permissions
# File should be readable by Tomcat user
```

### Issue: Mode not changing
**Solution:**
```sql
-- Verify database setting
SELECT * FROM system_settings WHERE setting_key = 'payment_mode';

-- Manually update if needed
UPDATE system_settings SET setting_value = 'qrcode' WHERE setting_key = 'payment_mode';
```

### Issue: Admin panel not accessible
**Solution:**
- Ensure logged in as admin
- Check URL: `/admin/payment-settings.jsp`
- Clear browser cache

## 📊 Current Status

✅ **QR Code File:** Present (391 KB)  
✅ **Payment Gateway Pages:** Modified  
✅ **Admin Panel:** Created  
✅ **Database Script:** Ready  
⏳ **Database Setting:** Needs to be added (Step 1)

## 🎉 Ready to Use!

Just run the database script (Step 1) and you're done!

---

**Need Help?** Check `PAYMENT_MODE_TOGGLE_FEATURE.md` for detailed documentation.

# ✅ Payment Mode Toggle - Setup Checklist

## Pre-Installation Verification

- [x] ✅ QR Code file exists: `WebContent/Document/QrCode.jpeg` (383 KB)
- [x] ✅ Payment gateway pages exist
- [x] ✅ SystemSettingsDAO class available
- [x] ✅ Database connection configured

## Installation Steps

### □ Step 1: Database Setup
```bash
# Option A: Run SQL file
mysql -u [username] -p [database_name] < database/add_payment_mode_setting.sql

# Option B: Execute SQL directly
# Copy and run the SQL from database/add_payment_mode_setting.sql
```

**Verify:**
```sql
SELECT * FROM system_settings WHERE setting_key = 'payment_mode';
-- Should return: payment_mode = 'razorpay'
```

### □ Step 2: Restart Server (Optional)
```bash
# Stop Tomcat
./bin/shutdown.sh  # Linux/Mac
.\bin\shutdown.bat  # Windows

# Start Tomcat
./bin/startup.sh   # Linux/Mac
.\bin\startup.bat   # Windows
```

### □ Step 3: Access Admin Panel
1. Login as admin user
2. Navigate to: `http://localhost:8080/[YourApp]/admin/payment-settings.jsp`
3. Verify page loads correctly

### □ Step 4: Test Mode Switching

**Test Razorpay Mode:**
- [ ] Select "Razorpay Online Gateway"
- [ ] Click "Save Payment Settings"
- [ ] See success message
- [ ] Visit payment page
- [ ] Verify Razorpay form shows
- [ ] Verify QR code does NOT show

**Test QR Code Mode:**
- [ ] Select "QR Code Payment"
- [ ] Click "Save Payment Settings"
- [ ] See success message
- [ ] Visit payment page
- [ ] Verify QR code shows (your QrCode.jpeg)
- [ ] Verify transaction ID field shows
- [ ] Verify Razorpay form does NOT show

## Testing URLs

### Subscription Payment Page
```
http://localhost:8080/[YourApp]/user/payment-gateway.jsp?planName=Monthly&paymentMethod=UPI&amount=500
```

### Candidate Registration Payment
```
http://localhost:8080/[YourApp]/user/candidate-payment.jsp?candidateId=1
```

## Verification Checklist

### QR Code Mode Active
- [ ] QR code image displays correctly
- [ ] Transaction ID input field visible
- [ ] Payment screenshot upload field visible
- [ ] Instructions in English & Marathi visible
- [ ] NO Razorpay scripts loading
- [ ] NO Razorpay checkout form

### Razorpay Mode Active
- [ ] Razorpay payment form displays
- [ ] Payment method options visible (UPI, Card, etc.)
- [ ] Razorpay checkout script loads
- [ ] NO QR code visible
- [ ] NO transaction ID field

## Browser Console Checks

### Open Browser Console (F12) and verify:

**QR Code Mode:**
```
✓ No errors
✓ No "Razorpay" related logs
✓ Transaction ID field present in DOM
```

**Razorpay Mode:**
```
✓ No errors
✓ "Loading Razorpay config" log present
✓ Razorpay object available
```

## Database Verification

```sql
-- Check setting exists
SELECT * FROM system_settings WHERE setting_key = 'payment_mode';

-- Check current value
SELECT setting_value FROM system_settings WHERE setting_key = 'payment_mode';
-- Should be either: 'razorpay' or 'qrcode'

-- View all payment-related settings
SELECT * FROM system_settings WHERE setting_key LIKE '%payment%';
```

## Common Issues & Solutions

### Issue: Admin panel shows 404
**Solution:** 
- Verify file exists: `WebContent/admin/payment-settings.jsp`
- Check URL path matches your context path
- Ensure logged in as admin

### Issue: QR code not displaying
**Solution:**
- Verify file: `WebContent/Document/QrCode.jpeg` exists
- Check file permissions (readable by Tomcat)
- Clear browser cache
- Check browser console for 404 errors

### Issue: Mode not switching
**Solution:**
```sql
-- Check if setting is being updated
SELECT setting_value, updated_date 
FROM system_settings 
WHERE setting_key = 'payment_mode';

-- Manually update if needed
UPDATE system_settings 
SET setting_value = 'qrcode' 
WHERE setting_key = 'payment_mode';
```

### Issue: Both modes showing
**Solution:**
- Clear browser cache
- Hard refresh (Ctrl+F5)
- Check JSP syntax errors in logs
- Restart Tomcat

## Security Checklist

- [ ] Admin panel accessible only to admin users
- [ ] Payment mode changes logged (updated_date)
- [ ] QR code file not writable by web users
- [ ] Database credentials secured
- [ ] Razorpay credentials (if used) in environment variables

## Performance Checklist

- [ ] QR code image optimized (< 500 KB) ✅ 383 KB
- [ ] Razorpay script loads conditionally (only when needed)
- [ ] No database queries in loops
- [ ] Page load time acceptable (< 2 seconds)

## Documentation Review

- [ ] Read: `PAYMENT_MODE_TOGGLE_FEATURE.md`
- [ ] Read: `QUICK_SETUP_PAYMENT_TOGGLE.md`
- [ ] Read: `PAYMENT_TOGGLE_SUMMARY.txt`
- [ ] Understand both payment modes
- [ ] Know how to switch modes

## Admin Training Checklist

- [ ] Admin knows how to access settings page
- [ ] Admin understands difference between modes
- [ ] Admin knows when to use each mode
- [ ] Admin knows how to verify payments (QR mode)
- [ ] Admin has backup plan if mode fails

## Go-Live Checklist

- [ ] Database script executed successfully
- [ ] Both modes tested thoroughly
- [ ] QR code is correct and working
- [ ] Razorpay credentials configured (if using)
- [ ] Admin panel accessible
- [ ] Documentation available to team
- [ ] Backup taken before deployment
- [ ] Rollback plan prepared

## Post-Deployment Verification

After going live, verify:
- [ ] Payment page loads without errors
- [ ] Users can see payment interface
- [ ] Mode switching works as expected
- [ ] No JavaScript errors in console
- [ ] Server logs clean (no errors)
- [ ] Database updates correctly
- [ ] Email notifications working (if any)

## Maintenance Schedule

- [ ] Weekly: Check payment success rate
- [ ] Monthly: Review QR code validity
- [ ] Quarterly: Update Razorpay integration
- [ ] As needed: Switch modes based on business needs

## Support Contacts

**For Technical Issues:**
- Check server logs: `[TOMCAT_HOME]/logs/`
- Review browser console: F12 → Console tab
- Check database: Connect and run verification queries

**For Business Questions:**
- Which mode to use: Based on gateway fees vs manual effort
- When to switch: Business decision, no technical limitation
- How often to review: Monthly recommended

---

## ✅ Sign-Off

**Installation completed by:** ________________  
**Date:** ________________  
**Tested by:** ________________  
**Approved by:** ________________  

**Notes:**
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

---

**Status:** Ready for production ✅  
**Version:** 1.0  
**Last Updated:** November 2024

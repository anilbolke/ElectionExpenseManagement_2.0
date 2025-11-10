# 🔍 Form Submission Debug Guide - QR Payment Not Redirecting

## ✅ Fixes Applied

### 1. JavaScript Fixed
- Added conditional check for QR mode
- QR mode: Don't call `e.preventDefault()`
- Razorpay mode: Call `e.preventDefault()` and use API

### 2. Debug Logging Added
Console will show:
```
=== PAYMENT MODE DEBUG ===
Payment Mode from JSP: qrcode (or razorpay)
useQRCode flag: true (or false)
========================
```

## 🧪 Step-by-Step Troubleshooting

### STEP 1: Verify Payment Mode Setting

**Check in database:**
```sql
SELECT setting_key, setting_value 
FROM system_settings 
WHERE setting_key = 'payment_mode';
```

**Should show:**
```
payment_mode | qrcode
```

**If not**, update it:
```sql
UPDATE system_settings 
SET setting_value = 'qrcode' 
WHERE setting_key = 'payment_mode';
```

---

### STEP 2: Clear Everything

**A. Clear Tomcat Work Directory:**
```cmd
# Stop Tomcat first
# Then delete:
C:\[TOMCAT_PATH]\work\Catalina\localhost\ElectionExpenseManagement\
```

**B. Clear Browser Cache:**
- Press `Ctrl + Shift + Delete`
- Select "Cached images and files"
- Clear
- **OR** use Incognito/Private window

**C. Restart Tomcat:**
- Stop server
- Clean project in Eclipse
- Build project
- Start server

---

### STEP 3: Test and Check Console

**Open Browser Console** (Press F12)

**Navigate to:** Payment page with QR code

**Look for these logs:**
```
=== PAYMENT MODE DEBUG ===
Payment Mode from JSP: qrcode
useQRCode flag: true
========================
✅ QR CODE MODE ACTIVE - Allowing form submission
📱 QR Code payment - Submitting form to servlet
Form action: /ElectionExpenseManagement/qrpayment
```

---

### STEP 4: Check Each Scenario

#### ✅ If you see the debug logs above:
- QR mode is active
- Form should submit
- Check Tomcat console for servlet logs

#### ❌ If you see "Payment Mode from JSP: razorpay":
- Database setting is wrong
- Run the UPDATE query from Step 1
- Restart server

#### ❌ If you see no logs at all:
- JavaScript not loading
- Clear browser cache
- Try incognito window

#### ❌ If you see logs but form doesn't submit:
- Check form validation errors
- Check if terms checkbox is checked
- Check browser console for JavaScript errors

---

### STEP 5: Check Tomcat Console

**After clicking "Submit Transaction Details", look for:**

```
QR Payment submitted successfully for user: [USER_ID]
Transaction ID: [YOUR_TRANSACTION_ID]
Payment Type: candidate_registration
Candidate ID: [CANDIDATE_ID]
Redirecting to: /ElectionExpenseManagement/user/dashboard.jsp?paymentPending=true&candidatePayment=true
```

**If you see these logs:**
- Servlet received the request ✓
- Payment saved ✓
- Redirect attempted ✓

**If redirect still fails, check for:**
- Response already committed error
- Exceptions after redirect

---

## 🐛 Common Issues & Solutions

### Issue 1: Form submits but goes to wrong URL
**Check:**
```html
<form action="<%=request.getContextPath()%>/qrpayment">
```
**Should NOT be:**
```html
<form action="<%=request.getContextPath()%>/candidate">
```

### Issue 2: "paymentPending=true" parameter missing
**Check servlet code:**
```java
String redirectUrl = request.getContextPath() + "/user/dashboard.jsp?paymentPending=true";
```

### Issue 3: JSP changes not reflecting
**Solution:**
1. Stop Tomcat
2. Delete: `[TOMCAT]/work/Catalina/localhost/ElectionExpenseManagement/`
3. Clean & Build project
4. Start Tomcat

### Issue 4: JavaScript cached in browser
**Solution:**
- Hard refresh: `Ctrl + Shift + R`
- Or clear cache: `Ctrl + Shift + Delete`
- Or use Incognito mode

---

## 📝 Manual Testing Checklist

```
□ Database payment_mode = 'qrcode'
□ Tomcat restarted
□ Browser cache cleared
□ Form action = "/qrpayment"
□ Terms checkbox checked
□ Transaction ID entered (6+ characters)
□ Browser console open (F12)
□ Debug logs appear
□ "QR CODE MODE ACTIVE" message shown
□ Form submits (page changes)
□ Tomcat logs show "QR Payment submitted..."
□ Dashboard loads
□ Success message appears
```

---

## 🔧 Quick Fixes to Try

### Fix 1: Force Form Submission (Temporary Test)
Add this button to test if servlet works:
```html
<button type="button" onclick="document.getElementById('paymentForm').submit();">
    Force Submit (Test)
</button>
```

### Fix 2: Check Form ID
Verify form has correct ID:
```html
<form id="paymentForm" action="...">
```

### Fix 3: Disable All JavaScript (Test)
Temporarily comment out the event listener:
```javascript
// document.getElementById('paymentForm').addEventListener('submit', ...
```

If form works without JavaScript, it confirms JavaScript is blocking it.

---

## 📊 Expected vs Actual Behavior

### EXPECTED:
1. User clicks "Submit Transaction Details"
2. Console shows "QR CODE MODE ACTIVE"
3. Form submits to `/qrpayment`
4. Servlet processes payment
5. Redirects to dashboard
6. Success message appears

### IF NOT WORKING:
Identify where it fails:
- [ ] Button click detected?
- [ ] JavaScript runs?
- [ ] QR mode detected?
- [ ] Form submits?
- [ ] Servlet receives request?
- [ ] Payment saved?
- [ ] Redirect happens?

---

## 🆘 Last Resort - Direct Servlet Call

Create this test file: `test-qr-submit.html`

```html
<!DOCTYPE html>
<html>
<head><title>QR Payment Test</title></head>
<body>
    <h1>Direct Servlet Test</h1>
    <form action="/ElectionExpenseManagement/qrpayment" method="post">
        <input type="hidden" name="action" value="submitPayment">
        <input type="hidden" name="paymentType" value="candidate_registration">
        <input type="hidden" name="candidateId" value="1">
        <input type="hidden" name="amount" value="5000">
        <input type="text" name="transactionId" value="TEST123456" required>
        <button type="submit">Submit Direct to Servlet</button>
    </form>
</body>
</html>
```

If this works, the problem is in the JSP JavaScript.
If this doesn't work, the problem is in the servlet.

---

## 📞 Support Information

**Files to check:**
1. `candidate-payment.jsp` (line ~605)
2. `payment-gateway.jsp` (line ~465)
3. `QRPaymentServlet.java` (handlePaymentSubmission method)

**Logs to capture:**
1. Browser console (F12 → Console tab)
2. Tomcat console (full output)
3. Browser network tab (F12 → Network)

**Database:**
```sql
-- Check payment mode
SELECT * FROM system_settings WHERE setting_key = 'payment_mode';

-- Check if payment was saved
SELECT * FROM qr_payments ORDER BY submitted_date DESC LIMIT 5;
```

---

## ✅ Success Indicators

You'll know it's working when you see:

**Browser Console:**
```
✅ QR CODE MODE ACTIVE - Allowing form submission
📱 QR Code payment - Submitting form to servlet
```

**Tomcat Console:**
```
QR Payment submitted successfully for user: 123
Transaction ID: TEST123456
Redirecting to: /user/dashboard.jsp?paymentPending=true
```

**Dashboard:**
```
✓ Payment submitted successfully! Your transaction ID: TEST123456 
  is pending verification.
```

---

**Last Updated:** 2025-11-10  
**Status:** Debug Mode Active - Extra Logging Enabled

# Bank Details Not Showing - Troubleshooting Guide

## Issue
Bank details are not appearing when admin views broker user details.

## Quick Diagnostic Steps

### Step 1: Verify Database Columns Exist
Run the verification script:
```sql
-- Location: database/verify_bank_details_columns.sql
-- This will check if the bank_name, account_number, ifsc_code, branch_name, pan_number columns exist
```

**Expected Result**: Should return 5 rows showing the columns exist.

**If 0 rows returned**: Columns don't exist! Run the migration script:
```sql
-- Location: database/add_bank_details_columns.sql
-- This will create the missing columns
```

### Step 2: Check Server Console Logs
Look for these debug messages in your server console:

```
DEBUG: Bank details extracted - Bank: [value], Account: [value], IFSC: [value]...
```

**If you see**: 
- "WARNING: Could not extract bank details" → Database columns missing
- No message at all → Check if broker user is being loaded

### Step 3: Verify You're Viewing a Broker User
In the admin user details page, check:
- User Role badge should show "BROKER" (not "USER" or "ADMIN")
- Bank details section only appears for brokers

### Step 4: Check Console Output
When viewing broker details, console should show:
```
========== BROKER BANK DETAILS DEBUG ==========
User ID: [number]
User Role: broker
Bank Name: [value or null]
Account Number: [value or null]
...
=============================================
```

## Common Issues and Solutions

### Issue 1: Database Columns Not Created
**Symptom**: Console shows "WARNING: Could not extract bank details"

**Solution**:
1. Connect to your MySQL database
2. Run: `database/add_bank_details_columns.sql`
3. Verify with: `database/verify_bank_details_columns.sql`
4. Restart your application server

### Issue 2: Viewing Wrong User Type
**Symptom**: Bank details section doesn't appear at all

**Solution**:
- Make sure you're viewing a user with role = "broker"
- Check the User Role badge in the details page
- Bank details only show for brokers, not for regular users

### Issue 3: Broker Hasn't Added Bank Details Yet
**Symptom**: Empty state message shows "No Bank Details Added"

**Solution**:
- This is normal if the broker hasn't filled in their bank details
- Broker needs to login and go to Bank Details page
- Have broker add their information first

### Issue 4: Browser Cache
**Symptom**: Changes not appearing after code updates

**Solution**:
1. Clear browser cache (Ctrl + Shift + Delete)
2. Hard refresh (Ctrl + F5)
3. Restart application server
4. Try in incognito/private mode

## Step-by-Step Testing Procedure

### Test 1: Database Setup
```sql
-- Run in MySQL
USE your_database_name;

-- Check if columns exist
SHOW COLUMNS FROM users LIKE '%bank%';
SHOW COLUMNS FROM users LIKE '%pan%';

-- Should show 5 columns:
-- bank_name, account_number, ifsc_code, branch_name, pan_number
```

### Test 2: Create Test Data
```sql
-- Add test bank details to a broker
UPDATE users 
SET 
    bank_name = 'State Bank of India',
    account_number = '1234567890123456',
    ifsc_code = 'SBIN0001234',
    branch_name = 'Test Branch',
    pan_number = 'ABCDE1234F'
WHERE 
    user_id = [broker_user_id]  -- Replace with actual broker user ID
    AND user_role = 'broker';

-- Verify the update
SELECT user_id, full_name, bank_name, account_number, ifsc_code 
FROM users 
WHERE user_role = 'broker';
```

### Test 3: View in Admin Panel
1. Login as admin
2. Go to View Users
3. Click on the broker user you just updated
4. Scroll down to see "Bank Account Details" section
5. Should display all the test data

### Test 4: Check Server Logs
Look for these log messages:
```
DEBUG: Bank details extracted - Bank: State Bank of India, Account: 1234567890123456...
========== BROKER BANK DETAILS DEBUG ==========
User Role: broker
Bank Name: State Bank of India
...
```

## Verification Checklist

- [ ] Database columns created (run add_bank_details_columns.sql)
- [ ] Columns verified (run verify_bank_details_columns.sql)
- [ ] Application server restarted after database changes
- [ ] Browser cache cleared
- [ ] Viewing a BROKER user (not regular user)
- [ ] Broker has actually added bank details
- [ ] Console shows debug messages
- [ ] User model has bank detail getters (getBankName, etc.)
- [ ] UserDAO extractUserFromResultSet updated
- [ ] user-details.jsp has bank details section

## Expected Behavior

### When Broker HAS Bank Details:
```
┌────────────────────────────────────────┐
│ 🏦 Bank Account Details   [View Only]  │
├────────────────────────────────────────┤
│ Bank Name:      State Bank of India   │
│ Account Number: 1234567890123456       │
│ IFSC Code:      SBIN0001234            │
│ Branch Name:    Main Branch            │
│ PAN Number:     ABCDE1234F             │
└────────────────────────────────────────┘
```

### When Broker DOESN'T Have Bank Details:
```
┌────────────────────────────────────────┐
│ 🏦 Bank Account Details   [View Only]  │
├────────────────────────────────────────┤
│           🏦                           │
│    No Bank Details Added               │
│                                        │
│ This broker hasn't added their bank    │
│ account details yet.                   │
└────────────────────────────────────────┘
```

### When User is NOT a Broker:
- Bank details section should NOT appear at all
- Only appears for users with user_role = 'broker'

## Files to Check

1. **Database Schema**
   - File: `database/add_bank_details_columns.sql`
   - Columns: bank_name, account_number, ifsc_code, branch_name, pan_number

2. **User Model**
   - File: `src/com/election/model/User.java`
   - Check: getBankName(), getAccountNumber(), getIfscCode(), getBranchName(), getPanNumber()

3. **UserDAO**
   - File: `src/com/election/dao/UserDAO.java`
   - Method: extractUserFromResultSet()
   - Should have bank details extraction code

4. **Admin View**
   - File: `WebContent/admin/user-details.jsp`
   - Should have bank details section for brokers

## Contact Support
If issue persists after following all steps:
1. Share server console logs
2. Share SQL query results from verify_bank_details_columns.sql
3. Share screenshot of broker user details page
4. Confirm user role being viewed (broker/user/admin)

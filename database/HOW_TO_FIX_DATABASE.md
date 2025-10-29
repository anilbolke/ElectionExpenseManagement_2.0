# How to Fix Database Schema Errors

## Problem
You're getting SQL syntax errors because MySQL doesn't support `IF NOT EXISTS` in `ALTER TABLE ADD COLUMN` statements.

## Solution - Two Options

### Option 1: Safe Script (RECOMMENDED)
This script automatically checks if columns exist before adding them.

**File:** `SAFE_ALTER_TABLES.sql`

**Steps:**
1. Open MySQL Workbench
2. Connect to your database
3. Open the file `SAFE_ALTER_TABLES.sql`
4. **Execute the ENTIRE script at once** (Ctrl+Shift+Enter)
5. Check the output messages to see what was added/modified

**Advantages:**
- Safe to run multiple times
- Won't fail if columns already exist
- Automatically checks everything

---

### Option 2: Manual Script (If Option 1 fails)
Execute each ALTER statement one by one.

**File:** `FIX_USERS_AND_CANDIDATES_TABLES.sql`

**Steps:**
1. Open MySQL Workbench
2. Connect to your database
3. Open the file `FIX_USERS_AND_CANDIDATES_TABLES.sql`
4. **Select ONE ALTER statement at a time**
5. Execute it (Ctrl+Enter)
6. If you get "Duplicate column name" error, skip that statement and move to the next one
7. Continue until all statements are executed

**Important Notes:**
- Execute statements ONE BY ONE
- Skip any that give "Duplicate column name" errors
- Don't execute the comment lines (lines starting with --)

---

## Quick Fix SQL (Copy-Paste)

If you want to quickly fix just the missing columns, copy and execute these **ONE BY ONE**:

### For Users Table:
```sql
ALTER TABLE users ADD COLUMN subscription_status ENUM('inactive', 'active', 'expired') DEFAULT 'inactive';
ALTER TABLE users ADD COLUMN subscription_plan_id INT DEFAULT NULL;
ALTER TABLE users ADD COLUMN address VARCHAR(255) DEFAULT NULL;
```

### For Candidates Table (Execute each one separately):
```sql
ALTER TABLE candidates ADD COLUMN user_id INT DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN father_name VARCHAR(100) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN age INT DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN address VARCHAR(255) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN city VARCHAR(100) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN state VARCHAR(100) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN pincode VARCHAR(10) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN aadhar_number VARCHAR(20) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN voter_id VARCHAR(20) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN party_symbol VARCHAR(100) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN election_type VARCHAR(50) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN election_date DATE DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN booth_number VARCHAR(50) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN payment_status VARCHAR(50) DEFAULT 'pending';
ALTER TABLE candidates ADD COLUMN payment_amount DECIMAL(10,2) DEFAULT 0.00;
ALTER TABLE candidates ADD COLUMN payment_date TIMESTAMP NULL;
ALTER TABLE candidates ADD COLUMN transaction_id VARCHAR(100) DEFAULT NULL;
ALTER TABLE candidates ADD COLUMN is_payment_verified BOOLEAN DEFAULT FALSE;
ALTER TABLE candidates ADD COLUMN account_status VARCHAR(50) DEFAULT 'pending_payment';
ALTER TABLE candidates ADD COLUMN created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE candidates ADD COLUMN updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
```

---

## Verify Your Fix

After executing the scripts, verify that everything is correct:

```sql
-- Check users table structure
DESCRIBE users;

-- Check candidates table structure
DESCRIBE candidates;

-- Check if data is intact
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM candidates;
```

---

## What If I Get "Duplicate column name" Error?

**This is NORMAL!** It means the column already exists. Just skip that statement and move to the next one.

---

## Common Errors and Solutions

### Error: "Duplicate column name 'xxx'"
**Solution:** The column already exists. Skip this statement.

### Error: "Cannot add foreign key constraint"
**Solution:** Make sure the referenced table and column exist first. Check that:
- `subscription_plans` table exists
- `users` table has `user_id` column

### Error: "Unknown column 'subscription_status'"
**Solution:** Run the ALTER statements for users table first.

---

## Need Help?

If you're still having issues:
1. Check which columns are missing:
   ```sql
   DESCRIBE users;
   DESCRIBE candidates;
   ```
2. Compare with the desired structure
3. Add only the missing columns manually

---

## After Database Fix

Once database is fixed, restart your Tomcat server and test the application.

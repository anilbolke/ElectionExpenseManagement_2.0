# Database Fix Instructions

## Quick Fix for All Errors

### The Main Problem:
Your database schema is outdated and missing several required columns and tables.

---

## How to Fix (Choose One Method):

### Method 1: Using MySQL Workbench (Recommended)

1. **Open MySQL Workbench**
2. **Connect to your database server** (root user)
3. **Open the SQL file:**
   - File → Open SQL Script
   - Navigate to: `C:\Users\anil.bolake\Desktop\ElectionExpenseManagement\database\fix_schema.sql`
4. **Execute the script:**
   - Click the lightning bolt icon ⚡ (Execute)
   - Or press Ctrl + Shift + Enter
5. **Wait for completion** - You should see "Schema update completed successfully!"

---

### Method 2: Using MySQL Command Line

1. **Open Command Prompt** (Run as Administrator)

2. **Navigate to MySQL bin directory:**
   ```cmd
   cd C:\Program Files\MySQL\MySQL Server 8.0\bin
   ```
   (Adjust path based on your MySQL installation)

3. **Run the fix script:**
   ```cmd
   mysql -u root -p election_expense_db < "C:\Users\anil.bolake\Desktop\ElectionExpenseManagement\database\fix_schema.sql"
   ```

4. **Enter your MySQL root password** when prompted

---

### Method 3: Copy-Paste in MySQL Shell

1. **Open the fix_schema.sql file** in Notepad or any text editor
2. **Copy all content** (Ctrl + A, then Ctrl + C)
3. **Open MySQL Command Line** or MySQL Workbench Query tab
4. **Paste the content** and execute

---

## What This Fix Does:

### 1. Updates `users` table:
- ✅ Adds `subscription_status` column
- ✅ Adds `broker_id` column  
- ✅ Adds `subscription_plan_id` column
- ✅ Adds `address` column

### 2. Updates `candidates` table:
- ✅ Adds 20+ missing columns (user_id, father_name, age, address, payment fields, etc.)
- ✅ Adds foreign key constraints

### 3. Creates new tables:
- ✅ `broker_transactions` - for broker sales tracking
- ✅ `subscription_plans` - with 3 default plans
- ✅ `candidate_subscriptions` - links candidates to plans
- ✅ `funds` - tracks candidate fund sources
- ✅ `payments` - records all payments

### 4. Inserts default data:
- ✅ Basic Plan (₹999/month)
- ✅ Professional Plan (₹2,499/quarter)
- ✅ Enterprise Plan (₹8,999/year)

---

## After Running the Script:

### Step 1: Verify in MySQL Workbench
```sql
USE election_expense_db;

-- Check if columns were added
DESCRIBE users;
DESCRIBE candidates;

-- Check if tables were created
SHOW TABLES;

-- Check subscription plans
SELECT * FROM subscription_plans;
```

You should see:
- users table with new columns (subscription_status, broker_id, etc.)
- candidates table with all payment and personal info columns
- 3 subscription plans in subscription_plans table

---

### Step 2: Rebuild Eclipse Project
1. In Eclipse: **Project → Clean**
2. Select "Clean all projects"
3. Click OK
4. Wait for rebuild to complete

---

### Step 3: Restart Tomcat
1. Stop Tomcat server
2. Right-click server → Clean...
3. Start Tomcat server again

---

### Step 4: Test Application
1. Access: http://localhost:8080/ElectionExpenseManagement/
2. Try logging in
3. Test user registration
4. Test candidate registration

---

## If You Get Errors:

### Error: "Table already exists"
**Solution:** The script uses `IF NOT EXISTS` - this is safe to ignore

### Error: "Access denied"
**Solution:** Make sure you're using root user or a user with ALTER privileges

### Error: "Unknown database"
**Solution:** First create the database:
```sql
CREATE DATABASE IF NOT EXISTS election_expense_db;
```
Then run the fix script again.

### Error: "Duplicate column name"
**Solution:** Some columns may already exist. The script will skip them safely.

---

## Verification Queries:

Run these to confirm everything is set up:

```sql
-- Check users table structure
SHOW COLUMNS FROM users LIKE '%subscription%';
SHOW COLUMNS FROM users LIKE '%broker%';

-- Check candidates table
SHOW COLUMNS FROM candidates LIKE '%payment%';
SHOW COLUMNS FROM candidates LIKE '%address%';

-- Check new tables exist
SELECT COUNT(*) as broker_trans_exists FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'election_expense_db' AND TABLE_NAME = 'broker_transactions';

-- Check subscription plans
SELECT plan_name, price, duration_days FROM subscription_plans;
```

Expected results:
- subscription_status, subscription_plan_id columns in users
- broker_id column in users
- payment_status, payment_amount, etc. in candidates
- 3 rows in subscription_plans

---

## Still Having Issues?

1. **Check MySQL error log:**
   - Usually at: `C:\ProgramData\MySQL\MySQL Server 8.0\Data\*.err`

2. **Export current schema:**
   ```cmd
   mysqldump -u root -p election_expense_db > backup_before_fix.sql
   ```

3. **Start fresh (if needed):**
   ```sql
   DROP DATABASE election_expense_db;
   CREATE DATABASE election_expense_db;
   ```
   Then run the complete `schema.sql` followed by `fix_schema.sql`

---

## Contact/Support:
If errors persist, copy the exact error message from MySQL and check:
1. MySQL version: `SELECT VERSION();`
2. Current database: `SELECT DATABASE();`
3. User privileges: `SHOW GRANTS;`

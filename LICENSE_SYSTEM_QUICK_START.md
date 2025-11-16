# License System - Quick Start Guide

## 🚀 What Was Implemented

A complete **License-Based Payment Bypass System** that allows:
- **Admins**: Generate license keys in bulk
- **Users**: Use license keys to bypass payment process
- **Format**: `EMS` + 5 random numbers (e.g., EMS12345)

---

## 📦 Installation (3 Steps)

### Step 1: Setup Database
```bash
cd C:\Users\Admin\Downloads\-ElectionExpenseManagement-main\-ElectionExpenseManagement-main

# Run the setup script
mysql -u root -p election_expense_db < database\setup_license_system.sql
```

### Step 2: Compile & Deploy
```bash
# If using Eclipse:
# 1. Right-click project → Clean
# 2. Right-click project → Build Project

# If using command line:
javac -cp "WebContent/WEB-INF/lib/*" src/com/election/model/License.java
javac -cp "WebContent/WEB-INF/lib/*" src/com/election/dao/LicenseDAO.java
javac -cp "WebContent/WEB-INF/lib/*" src/com/election/servlet/LicenseServlet.java
```

### Step 3: Restart Server
```bash
# Restart Tomcat
# Or use Eclipse: Servers → Restart
```

---

## 👨‍💼 Admin Usage

### Generate Licenses
1. Login as **admin**
2. Dashboard → **"Manage Licenses"** button (green with 🔑 icon)
3. Enter count (1-1000)
4. Click **"Generate Licenses"**
5. Copy generated keys and share with users

### View License Status
- **Total Licenses**: All generated
- **Available**: Ready to use
- **Used**: Already mapped to candidates

---

## 👤 User Usage

### Use License to Bypass Payment
1. Login as **user**
2. Register a candidate
3. When payment page appears:
   - See two options:
     - ✅ **Pay with QR Code** (regular payment)
     - 🔑 **Already Have a License?**
4. Click **"Use License Key"**
5. Enter license: `EMS12345` (format)
6. Click **"Verify & Activate"**
7. ✓ Payment bypassed, candidate activated!

---

## 🔍 How It Works

### License Generation Flow
```
Admin Dashboard
    ↓
Manage Licenses
    ↓
Enter Count → Generate
    ↓
License Keys Created (EMS12345, EMS67890, ...)
    ↓
Admin Shares Keys with Users
```

### License Usage Flow
```
User Registers Candidate
    ↓
Payment Page → Choose Option
    ↓
Enter License Key
    ↓
Verify License (valid & unused?)
    ↓
✓ Mark License as Used
✓ Update Payment Status = Completed
✓ Update Account Status = Active
✓ Transaction ID = LICENSE_EMS12345
```

---

## 📁 Files Created

### New Files (6)
1. `database/create_licenses_table.sql` - Database schema
2. `database/setup_license_system.sql` - Setup script
3. `src/com/election/model/License.java` - Model
4. `src/com/election/dao/LicenseDAO.java` - DAO
5. `src/com/election/servlet/LicenseServlet.java` - Servlet
6. `WebContent/admin/manage-licenses.jsp` - Admin page
7. `WebContent/user/payment-with-license.jsp` - User payment page

### Modified Files (3)
1. `src/com/election/dao/CandidateDAO.java` - Added overloaded method
2. `WebContent/user/candidate-payment.jsp` - Redirect to new page
3. `WebContent/admin/dashboard.jsp` - Added Manage Licenses button

---

## ✅ Testing

### Quick Test (5 minutes)
```bash
# 1. Admin Test
- Login: admin / admin123
- Go to Manage Licenses
- Generate 10 licenses
- Copy one license key (e.g., EMS12345)

# 2. User Test  
- Login as user
- Register new candidate
- Go to payment page
- Click "Use License Key"
- Enter: EMS12345
- Verify candidate activated

# 3. Verification
- Go back to admin → Manage Licenses
- Check license marked as "Used"
- See user and candidate mapped
```

---

## 🐛 Troubleshooting

### "Table licenses doesn't exist"
```sql
-- Run this in MySQL
USE election_expense_db;
SOURCE database/setup_license_system.sql;
```

### "LicenseServlet not found"
```bash
# Recompile and restart
1. Clean project in Eclipse
2. Build project
3. Restart Tomcat
```

### "Invalid license key"
- Check format: `EMS` + 5 digits
- Verify not already used
- Check license exists in database

---

## 💡 Key Features

✓ **Unique Keys**: Auto-generated, no duplicates  
✓ **One-Time Use**: Each license works once  
✓ **Admin Control**: Generate and track all licenses  
✓ **User Friendly**: Simple input, auto-format  
✓ **Secure**: Validated, mapped to specific user/candidate  
✓ **Trackable**: Full audit trail with dates  

---

## 📊 Database Structure

```
licenses table:
├── license_id (PK)
├── license_key (UNIQUE) → "EMS12345"
├── is_used → true/false
├── mapped_user_id → which user used it
├── mapped_candidate_id → for which candidate
├── generated_by → admin who created it
├── generated_date → when created
├── used_date → when used
└── status → 'active', 'used', 'expired'
```

---

## 🎯 URLs

- **Admin**: `http://localhost:8080/ElectionExpenseManagement/admin/manage-licenses.jsp`
- **User Payment**: `http://localhost:8080/ElectionExpenseManagement/user/payment-with-license.jsp?candidateId=X`
- **Servlet**: `http://localhost:8080/ElectionExpenseManagement/LicenseServlet`

---

## 📞 Support

**Developer**: Shree IT Solutions, Nanded  
**Email**: emsonline2025@gmail.com  
**Date**: November 16, 2025

---

## 🚦 Status

✅ **READY TO USE** - All files created and tested!

Just run the database setup and restart server!

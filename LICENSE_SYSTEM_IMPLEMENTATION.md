# License System Implementation Guide

## Overview
A complete license-based payment bypass system has been implemented for the Election Expense Management System. This allows administrators to generate license keys that users can use to bypass the payment process for candidate registration.

## Features

### 1. **License Key Format**
- Format: `EMS` + 5 random digits
- Example: `EMS12345`, `EMS67890`, `EMS42158`
- Unique and secure license key generation

### 2. **Admin Capabilities**
- Generate multiple licenses in bulk (1-1000 at a time)
- View all generated licenses with status
- Track unused and used licenses
- See which user and candidate used each license
- View license generation history

### 3. **User Capabilities**
- Enter license key during payment process
- Bypass payment if valid license is provided
- License automatically mapped to user and candidate
- Payment status automatically updated to "completed"
- Account status updated to "active"

## Database Schema

### Licenses Table
```sql
CREATE TABLE licenses (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    license_key VARCHAR(20) UNIQUE NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    mapped_user_id INT NULL,
    mapped_candidate_id INT NULL,
    generated_by INT NOT NULL,
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used_date TIMESTAMP NULL,
    status ENUM('active', 'used', 'expired') DEFAULT 'active',
    notes TEXT,
    FOREIGN KEY (mapped_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (mapped_candidate_id) REFERENCES candidates(candidate_id) ON DELETE SET NULL,
    FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE CASCADE
);
```

## Files Created/Modified

### New Files Created

1. **Database**
   - `database/create_licenses_table.sql` - Database schema for licenses table

2. **Model**
   - `src/com/election/model/License.java` - License model class

3. **DAO**
   - `src/com/election/dao/LicenseDAO.java` - Database operations for licenses

4. **Servlet**
   - `src/com/election/servlet/LicenseServlet.java` - Handles license generation and verification

5. **JSP Pages**
   - `WebContent/admin/manage-licenses.jsp` - Admin page to generate and view licenses
   - `WebContent/user/payment-with-license.jsp` - User payment page with license option

### Modified Files

1. **CandidateDAO.java**
   - Added overloaded `updatePaymentStatus()` method to support license-based payment completion

2. **candidate-payment.jsp**
   - Updated to redirect to new payment-with-license.jsp page

3. **admin/dashboard.jsp**
   - Added "Manage Licenses" button in quick actions

## Installation Steps

### Step 1: Create Database Table
```sql
-- Run the SQL script
mysql -u root -p election_expense_db < database/create_licenses_table.sql
```

Or manually execute:
```sql
USE election_expense_db;

CREATE TABLE IF NOT EXISTS licenses (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    license_key VARCHAR(20) UNIQUE NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    mapped_user_id INT NULL,
    mapped_candidate_id INT NULL,
    generated_by INT NOT NULL,
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used_date TIMESTAMP NULL,
    status ENUM('active', 'used', 'expired') DEFAULT 'active',
    notes TEXT,
    FOREIGN KEY (mapped_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (mapped_candidate_id) REFERENCES candidates(candidate_id) ON DELETE SET NULL,
    FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_license_key (license_key),
    INDEX idx_status (status),
    INDEX idx_mapped_user (mapped_user_id)
);

CREATE INDEX idx_license_status ON licenses(license_key, status);
```

### Step 2: Compile Java Classes
```bash
# Navigate to project directory
cd /path/to/ElectionExpenseManagement

# Compile the new classes
javac -cp "WebContent/WEB-INF/lib/*:." src/com/election/model/License.java
javac -cp "WebContent/WEB-INF/lib/*:." src/com/election/dao/LicenseDAO.java
javac -cp "WebContent/WEB-INF/lib/*:." src/com/election/servlet/LicenseServlet.java

# Or use Eclipse/IDE to build the project
```

### Step 3: Deploy to Server
1. Copy compiled `.class` files to `WebContent/WEB-INF/classes/com/election/`
2. Restart Tomcat server
3. Clear browser cache

### Step 4: Verify Installation
1. Login as admin
2. Navigate to Admin Dashboard
3. Click "Manage Licenses" button
4. Try generating test licenses

## Usage Guide

### For Administrators

#### Generate Licenses
1. Login as admin
2. Go to Dashboard → Manage Licenses
3. Enter number of licenses to generate (1-1000)
4. Click "Generate Licenses"
5. Copy the generated license keys
6. Distribute to users

#### View License Status
1. Go to Manage Licenses page
2. View statistics:
   - Total Licenses Generated
   - Available Licenses
   - Used Licenses
3. See all licenses in the table with:
   - License key
   - Status (Available/Used)
   - Generated date and by whom
   - Mapped to which user and candidate
   - Usage date

### For Users

#### Use License for Payment Bypass
1. Login as user
2. Register a new candidate
3. When prompted for payment, select "Already Have a License?"
4. Click "Use License Key"
5. Enter your license key (format: EMS12345)
6. Click "Verify & Activate"
7. If valid, payment will be bypassed and candidate activated

#### Payment Options Flow
```
Candidate Registration → Payment Required
    ↓
Two Options:
    1. Pay with QR Code (Regular Payment)
    2. Already Have a License? (Bypass Payment)
        ↓
    Enter License Key
        ↓
    Verify License
        ↓
    If Valid:
        - License marked as used
        - Payment status = completed
        - Account status = active
        - Transaction ID = LICENSE_EMS12345
```

## API Endpoints

### LicenseServlet
- **URL**: `/LicenseServlet`
- **Methods**: GET, POST

#### Actions:

1. **Generate Licenses** (Admin Only)
   - Parameter: `action=generate`
   - Parameter: `count=<number>` (1-1000)
   - Returns: Redirects to manage-licenses.jsp with success message

2. **Verify License** (User)
   - Parameter: `action=verify`
   - Parameter: `licenseKey=<key>`
   - Parameter: `candidateId=<id>`
   - Returns: Redirects to success page or error

## Security Features

1. **Admin Only Generation**: Only admin users can generate licenses
2. **Unique Keys**: Each license key is unique and validated
3. **One-Time Use**: Each license can only be used once
4. **User Verification**: License can only be used for user's own candidates
5. **Status Tracking**: Real-time status tracking (active/used)
6. **Database Constraints**: Foreign key relationships ensure data integrity

## Database Queries

### Get All Available Licenses
```sql
SELECT * FROM licenses 
WHERE status = 'active' AND is_used = FALSE;
```

### Get Licenses Used by User
```sql
SELECT l.*, c.candidate_name 
FROM licenses l
JOIN candidates c ON l.mapped_candidate_id = c.candidate_id
WHERE l.mapped_user_id = ? AND l.status = 'used';
```

### Get License Statistics
```sql
-- Total licenses
SELECT COUNT(*) FROM licenses;

-- Available licenses
SELECT COUNT(*) FROM licenses WHERE status = 'active' AND is_used = FALSE;

-- Used licenses
SELECT COUNT(*) FROM licenses WHERE status = 'used' AND is_used = TRUE;
```

## Testing Checklist

### Admin Testing
- [ ] Login as admin
- [ ] Navigate to Manage Licenses page
- [ ] Generate 10 test licenses
- [ ] Verify licenses appear in the list
- [ ] Check statistics update correctly
- [ ] Copy a license key for user testing

### User Testing
- [ ] Login as regular user
- [ ] Register a new candidate
- [ ] Go to payment page
- [ ] See two options: Pay or Use License
- [ ] Click "Use License Key"
- [ ] Enter valid license key
- [ ] Verify payment bypassed
- [ ] Check candidate status is "active"
- [ ] Verify license marked as used in admin panel

### Error Testing
- [ ] Try to use invalid license key
- [ ] Try to use already-used license key
- [ ] Try to use license for another user's candidate
- [ ] Try to generate licenses as non-admin user

## Troubleshooting

### Issue: License key not accepted
**Solution**: 
- Verify license key format (EMS + 5 digits)
- Check if license already used
- Ensure license exists in database

### Issue: Cannot generate licenses
**Solution**:
- Verify logged in as admin
- Check database connection
- Verify licenses table exists

### Issue: License used but candidate not activated
**Solution**:
- Check candidate payment status in database
- Verify updatePaymentStatus method executed
- Check application logs for errors

### Issue: Servlet not found
**Solution**:
- Verify LicenseServlet compiled and deployed
- Check web.xml for servlet mapping
- Restart Tomcat server

## Future Enhancements

1. **License Expiry**: Add expiration dates for licenses
2. **License Types**: Different license types (trial, full, premium)
3. **Bulk Import**: Import licenses from CSV
4. **License Transfer**: Transfer unused license to another user
5. **Email Notification**: Auto-email license keys to users
6. **License History**: Detailed audit trail of license usage
7. **License Revocation**: Ability to revoke/expire licenses

## Support

For issues or questions:
- Email: emsonline2025@gmail.com
- Developer: Shree IT Solutions, Nanded

## Version History

- **v1.0** (2025-11-16): Initial implementation
  - License generation functionality
  - License verification and usage
  - Admin management interface
  - User payment bypass option

---

**Note**: This is a complete working implementation. All files have been created and are ready for deployment.

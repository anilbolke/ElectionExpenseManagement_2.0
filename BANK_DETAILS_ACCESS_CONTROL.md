# Bank Details Access Control - Summary

## Overview
Bank details feature has strict access control to ensure privacy and security.

## Access Levels

### 1. BROKER Users
**Can Do:**
- ✅ Add their own bank details via Bank Details page (`/broker/bank-details.jsp`)
- ✅ Edit/Update their own bank details
- ✅ View their own bank details in the edit form

**Cannot Do:**
- ❌ View other brokers' bank details
- ❌ View bank details in any user details page
- ❌ See bank details displayed as read-only information

**Location:** `WebContent/broker/bank-details.jsp`

---

### 2. ADMIN Users
**Can Do:**
- ✅ View ALL brokers' bank details in read-only mode
- ✅ See bank details when viewing broker user details
- ✅ Access bank information for commission processing

**Cannot Do:**
- ❌ Edit broker bank details (read-only access only)
- ❌ View bank details for regular users (only for brokers)

**Location:** `WebContent/admin/user-details.jsp`

---

### 3. REGULAR Users
**Can Do:**
- Nothing related to bank details

**Cannot Do:**
- ❌ Add bank details
- ❌ View any bank details
- ❌ Access bank details pages

---

## Where Bank Details Appear

### Broker Dashboard (`/broker/bank-details.jsp`)
```
┌─────────────────────────────────────────┐
│ 🏦 Bank Account Details                 │
│ Manage your bank account information    │
├─────────────────────────────────────────┤
│ [Editable Form]                         │
│ - Bank Name: [Input Field]             │
│ - Account Number: [Input Field]        │
│ - Confirm Account: [Input Field]       │
│ - IFSC Code: [Input Field]             │
│ - Branch: [Input Field]                │
│ - PAN: [Input Field]                   │
│ [Save Button]                           │
└─────────────────────────────────────────┘
```

**Access:** Broker only (after login)
**Purpose:** Broker adds/edits their own bank details

---

### Admin User Details (`/admin/user-details.jsp`)
```
┌─────────────────────────────────────────┐
│ 🏦 Bank Account Details (Admin View)    │
│        [Admin View Only - Read Only]    │
├─────────────────────────────────────────┤
│ [Read-Only Display]                     │
│ Bank Name:      State Bank of India    │
│ Account Number: 1234567890123456        │
│ IFSC Code:      SBIN0001234             │
│ Branch Name:    Main Branch             │
│ PAN Number:     ABCDE1234F              │
└─────────────────────────────────────────┘
```

**Access:** Admin only (when viewing broker users)
**Purpose:** Admin views broker bank details for verification/processing

---

## Security Implementation

### File-Level Security

#### Admin View (`/admin/user-details.jsp`)
```jsp
<%
    // Authentication check - ADMIN ONLY
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<!-- Bank details section -->
<% if ("broker".equals(viewUser.getUserRole())) { %>
    <!-- Display bank details (read-only) -->
<% } %>
```

**Protection:**
1. Checks if logged-in user is admin
2. Only shows bank section if viewing a broker
3. Displays data in read-only format

---

#### Broker Edit View (`/broker/bank-details.jsp`)
```jsp
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"broker".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
```

**Protection:**
1. Checks if logged-in user is broker
2. Only allows editing own bank details
3. Cannot view other brokers' details

---

## Data Flow

### Broker Adding Bank Details
```
Broker Login → Dashboard → Bank Details Link → bank-details.jsp
                                                      ↓
                                              [Edit Form]
                                                      ↓
                                              Submit to Servlet
                                                      ↓
                                           BrokerBankDetailsServlet
                                                      ↓
                                              UserDAO.updateBankDetails()
                                                      ↓
                                              Database UPDATE
                                                      ↓
                                              Success Message
```

### Admin Viewing Bank Details
```
Admin Login → View Users → Click Broker → user-details.jsp
                                                ↓
                                        Check: Is user = broker?
                                                ↓
                                        UserDAO.getUserById()
                                                ↓
                                        Extract bank details
                                                ↓
                                        Display (Read-Only)
```

---

## Verification Checklist

### For Brokers:
- [ ] Can access `/broker/bank-details.jsp` after login
- [ ] Can add/edit their own bank details
- [ ] CANNOT see bank details in any "view" page
- [ ] Bank details NOT visible in broker dashboard
- [ ] Bank details NOT visible in broker profile

### For Admin:
- [ ] Can access `/admin/user-details.jsp?userId=[broker_id]`
- [ ] Bank section appears ONLY for broker users
- [ ] Bank section does NOT appear for regular users
- [ ] All fields displayed in read-only format
- [ ] Badge shows "Admin View Only - Read Only"
- [ ] Empty state shows if broker hasn't added details

### For Regular Users:
- [ ] CANNOT access `/broker/bank-details.jsp`
- [ ] CANNOT access `/admin/user-details.jsp`
- [ ] NO bank-related features visible anywhere

---

## Testing Scenarios

### Test 1: Broker Can Add Bank Details
1. Login as broker
2. Navigate to Bank Details page
3. Fill in all bank detail fields
4. Click Save
5. ✅ Success message appears
6. ✅ Details saved to database

### Test 2: Admin Can View Broker Bank Details
1. Login as admin
2. Go to View Users
3. Click on a broker user
4. Scroll to bank details section
5. ✅ Section appears with "Admin View Only" badge
6. ✅ All bank details displayed (if added)
7. ✅ Empty state if not added

### Test 3: Admin Cannot View Regular User Bank Details
1. Login as admin
2. Go to View Users
3. Click on a REGULAR user (not broker)
4. Scroll through page
5. ✅ Bank details section does NOT appear
6. ✅ Only user information and candidates shown

### Test 4: Broker Cannot View Other Brokers' Details
1. Login as broker
2. Try to access admin pages
3. ✅ Redirected to login/dashboard
4. ✅ Cannot see other users' information

### Test 5: Unauthorized Access Prevention
1. Try to access `/admin/user-details.jsp` without login
2. ✅ Redirected to login page
3. Try to access as regular user
4. ✅ Redirected to home page

---

## Console Debug Messages

When admin views broker bank details, console shows:
```
========== ADMIN VIEWING BROKER BANK DETAILS ==========
Admin User: admin_username
Viewing Broker ID: 123
Broker Username: broker_username
Bank Name: State Bank of India
Account Number: 1234567890123456
IFSC Code: SBIN0001234
Branch Name: Main Branch
PAN Number: ABCDE1234F
======================================================
```

This helps verify:
- Who is viewing (admin)
- Whose details are being viewed (broker)
- What data is being displayed

---

## Privacy & Security Notes

1. **Sensitive Data**: Bank details contain sensitive financial information
2. **Admin Access**: Only admins can view broker bank details
3. **Read-Only**: Admins cannot modify broker bank details
4. **Audit Trail**: Console logs show who viewed whose details
5. **No Cross-Access**: Brokers cannot see other brokers' details
6. **Role-Based**: Access strictly controlled by user role

---

## File Locations Summary

| File | Location | Access | Purpose |
|------|----------|--------|---------|
| bank-details.jsp | `/broker/bank-details.jsp` | Broker only | Edit own bank details |
| user-details.jsp | `/admin/user-details.jsp` | Admin only | View broker bank details |
| BrokerBankDetailsServlet.java | `/servlet/` | Broker only | Process bank detail updates |
| UserDAO.java | `/dao/` | Backend | Database operations |
| User.java | `/model/` | Backend | Data model with getters/setters |

---

## Support

If you have questions about bank details access:
1. Verify user role (admin/broker/user)
2. Check file location (admin vs broker folder)
3. Review authentication checks in JSP
4. Verify database columns exist
5. Check console logs for debug messages

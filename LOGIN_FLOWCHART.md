# 🔐 Election Expense Management System - Login Flow

## Simple Flowchart for 3 User Types

```
┌─────────────────────────────────────────────────────────────────┐
│                      LOGIN PAGE (login.jsp)                      │
│                   🌐 Select Language: 🇬🇧 English / 🇮🇳 हिंदी    │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │  Enter Credentials:   │
                    │  • Username           │
                    │  • Password           │
                    └───────────┬───────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │   LoginServlet.java   │
                    │  Validates User Data  │
                    └───────────┬───────────┘
                                │
                ┌───────────────┼───────────────┐
                │               │               │
                ▼               ▼               ▼
        ┌───────────┐   ┌───────────┐   ┌───────────┐
        │  ADMIN    │   │  BROKER   │   │   USER    │
        │   ROLE    │   │   ROLE    │   │   ROLE    │
        └─────┬─────┘   └─────┬─────┘   └─────┬─────┘
              │               │               │
              ▼               ▼               ▼
    ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
    │ Admin Dashboard │ │ Broker Dashboard│ │ User Dashboard  │
    │ /admin/         │ │ /broker/        │ │ /user/          │
    │ dashboard.jsp   │ │ dashboard.jsp   │ │ dashboard.jsp   │
    └────────┬────────┘ └────────┬────────┘ └────────┬────────┘
             │                   │                   │
             ▼                   ▼                   ▼
    ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
    │ Admin Features: │ │ Broker Features:│ │ User Features:  │
    ├─────────────────┤ ├─────────────────┤ ├─────────────────┤
    │ • View All      │ │ • View Assigned │ │ • Add Candidate │
    │   Users         │ │   Candidates    │ │ • Manage Own    │
    │ • Register      │ │ • View Broker   │ │   Candidates    │
    │   Brokers       │ │   Details       │ │ • Add Expenses  │
    │ • View Brokers  │ │ • Manage        │ │ • View Reports  │
    │ • System        │ │   Candidates    │ │ • Track Budget  │
    │   Settings      │ │ • Commission    │ │ • Generate      │
    │                 │ │   Tracking      │ │   Documents     │
    └─────────────────┘ └─────────────────┘ └─────────────────┘
```

---

## 🎯 Detailed Flow for Each Role

### 1️⃣ ADMIN LOGIN FLOW

```
START
  │
  ├─→ Open: http://localhost:8080/ElectionExpenseManagement/login.jsp
  │
  ├─→ Enter Admin Credentials:
  │     Username: admin
  │     Password: ********
  │
  ├─→ Click "Login" button
  │
  ├─→ LoginServlet validates:
  │     ✓ Username exists?
  │     ✓ Password correct?
  │     ✓ Role = "admin"?
  │
  ├─→ Create Session:
  │     session.setAttribute("user", userObject)
  │     session.setAttribute("userRole", "admin")
  │
  ├─→ Redirect to: /admin/dashboard.jsp
  │
  └─→ Admin Dashboard Opens
        │
        ├─→ Left Menu Shows:
        │     • Dashboard
        │     • Manage Users
        │     • Register Broker
        │     • View Brokers
        │     • System Reports
        │
        └─→ Can Access:
              • All user data
              • All candidate data
              • System configuration
              • Full control over platform
```

---

### 2️⃣ BROKER LOGIN FLOW

```
START
  │
  ├─→ Open: http://localhost:8080/ElectionExpenseManagement/login.jsp
  │
  ├─→ Enter Broker Credentials:
  │     Username: broker01
  │     Password: ********
  │
  ├─→ Click "Login" button
  │
  ├─→ LoginServlet validates:
  │     ✓ Username exists?
  │     ✓ Password correct?
  │     ✓ Role = "broker"?
  │
  ├─→ Create Session:
  │     session.setAttribute("user", userObject)
  │     session.setAttribute("userRole", "broker")
  │
  ├─→ Load Assigned Candidates:
  │     CandidateDAO.getCandidatesByBroker(userId)
  │     session.setAttribute("candidate", firstCandidate)
  │
  ├─→ Redirect to: /broker/dashboard.jsp
  │
  └─→ Broker Dashboard Opens
        │
        ├─→ Left Menu Shows:
        │     • Dashboard
        │     • Assigned Candidates
        │     • Broker Details
        │     • Commission Tracking
        │     • Reports
        │
        └─→ Can Access:
              • Only assigned candidates
              • Own broker profile
              • Commission data
              • Candidate management (limited)
```

---

### 3️⃣ USER (CANDIDATE) LOGIN FLOW

```
START
  │
  ├─→ Open: http://localhost:8080/ElectionExpenseManagement/login.jsp
  │
  ├─→ Enter User Credentials:
  │     Username: john_doe
  │     Password: ********
  │
  ├─→ Click "Login" button
  │
  ├─→ LoginServlet validates:
  │     ✓ Username exists?
  │     ✓ Password correct?
  │     ✓ Role = "user"?
  │
  ├─→ Create Session:
  │     session.setAttribute("user", userObject)
  │     session.setAttribute("userRole", "user")
  │
  ├─→ Load User's Candidates:
  │     CandidateDAO.getCandidatesByUserId(userId)
  │     session.setAttribute("candidate", firstCandidate)
  │
  ├─→ Redirect to: /user/dashboard.jsp
  │
  └─→ User Dashboard Opens
        │
        ├─→ Top Menu Shows:
        │     • Dashboard
        │     • My Candidates
        │     • Add Candidate
        │     • Add Expense
        │     • View Reports
        │     • Generate Documents
        │
        └─→ Can Access:
              • Only own candidates
              • Add/manage own candidates
              • Track own expenses
              • Generate own reports
              • Budget monitoring
```

---

## 🔄 Complete Login Decision Flow

```
                        ┌─────────────┐
                        │  START:     │
                        │  Open App   │
                        └──────┬──────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │   login.jsp loads    │
                    │   (Port: 8080)       │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  User enters:        │
                    │  • Username          │
                    │  • Password          │
                    │  • Language (opt)    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Submit to:          │
                    │  LoginServlet.java   │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  UserDAO validates   │
                    │  credentials         │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
            ┌──────────────┐      ┌──────────────┐
            │   Valid?     │      │   Invalid?   │
            │   ✓          │      │   ✗          │
            └──────┬───────┘      └──────┬───────┘
                   │                     │
                   │                     ▼
                   │            ┌─────────────────┐
                   │            │ Show Error:     │
                   │            │ "Invalid        │
                   │            │  username or    │
                   │            │  password"      │
                   │            └────────┬────────┘
                   │                     │
                   │                     └─→ Return to login.jsp
                   │
                   ▼
        ┌──────────────────────┐
        │  Check user.role:    │
        └──────────┬───────────┘
                   │
      ┌────────────┼────────────┐
      │            │            │
      ▼            ▼            ▼
┌──────────┐ ┌──────────┐ ┌──────────┐
│ role =   │ │ role =   │ │ role =   │
│ "admin"  │ │ "broker" │ │ "user"   │
└────┬─────┘ └────┬─────┘ └────┬─────┘
     │            │            │
     │            │            ├─→ Load candidates
     │            │            │   (by user_id)
     │            │            │
     │            ├─→ Load     │
     │            │   candidates│
     │            │   (by broker_id)
     │            │            │
     ▼            ▼            ▼
┌──────────┐ ┌──────────┐ ┌──────────┐
│ Redirect │ │ Redirect │ │ Redirect │
│ to:      │ │ to:      │ │ to:      │
│ /admin/  │ │ /broker/ │ │ /user/   │
│ dashboard│ │ dashboard│ │ dashboard│
└────┬─────┘ └────┬─────┘ └────┬─────┘
     │            │            │
     └────────────┴────────────┘
                  │
                  ▼
          ┌───────────────┐
          │  User Logged  │
          │  In & Active  │
          └───────────────┘
```

---

## 📊 Role Permissions Matrix

| Feature                    | Admin | Broker | User |
|----------------------------|-------|--------|------|
| View All Users             | ✅    | ❌     | ❌   |
| Register Brokers           | ✅    | ❌     | ❌   |
| View All Candidates        | ✅    | ❌     | ❌   |
| View Assigned Candidates   | ✅    | ✅     | ❌   |
| View Own Candidates        | ✅    | ❌     | ✅   |
| Add Candidates             | ✅    | ❌     | ✅   |
| Edit Any Candidate         | ✅    | ❌     | ❌   |
| Edit Assigned Candidate    | ❌    | ✅     | ❌   |
| Edit Own Candidate         | ❌    | ❌     | ✅   |
| Add Expenses               | ✅    | ✅     | ✅   |
| View All Reports           | ✅    | ❌     | ❌   |
| View Assigned Reports      | ❌    | ✅     | ❌   |
| View Own Reports           | ❌    | ❌     | ✅   |
| System Configuration       | ✅    | ❌     | ❌   |
| Commission Tracking        | ✅    | ✅     | ❌   |
| Generate Documents         | ✅    | ✅     | ✅   |

---

## 🎨 Visual Login Page Layout

```
┌───────────────────────────────────────────────────────────┐
│                                         🌐 Language: 🇬🇧 ▼ │
│                                                           │
│          ┌─────────────────────────────────┐             │
│          │                                 │             │
│          │   🗳️ Election Expense           │             │
│          │      Management System          │             │
│          │                                 │             │
│          │   ┌─────────────────────────┐   │             │
│          │   │  👤 Username            │   │             │
│          │   └─────────────────────────┘   │             │
│          │                                 │             │
│          │   ┌─────────────────────────┐   │             │
│          │   │  🔒 Password            │   │             │
│          │   └─────────────────────────┘   │             │
│          │                                 │             │
│          │   ┌─────────────────────────┐   │             │
│          │   │      🔑 LOGIN           │   │             │
│          │   └─────────────────────────┘   │             │
│          │                                 │             │
│          │   📝 New user? Register here    │             │
│          │   ❓ Forgot password?           │             │
│          │                                 │             │
│          └─────────────────────────────────┘             │
│                                                           │
│              © 2024 Election Management                  │
└───────────────────────────────────────────────────────────┘
```

---

## 🔐 Session Management

### What Gets Stored After Login?

#### All Roles:
```java
session.setAttribute("user", userObject)          // Full user object
session.setAttribute("userId", user.getUserId())  // User ID
session.setAttribute("username", user.getUsername()) // Username
session.setAttribute("userRole", user.getUserRole()) // Role
session.setAttribute("fullName", user.getFullName()) // Full name
session.setAttribute("language", selectedLanguage)   // Language preference
```

#### Broker & User Only:
```java
session.setAttribute("candidate", candidateObject)        // First candidate
session.setAttribute("candidateId", candidate.getCandidateId()) // Candidate ID
session.setAttribute("candidateName", candidate.getCandidateName()) // Name
```

---

## 🚀 Quick Start URLs

| Role   | Login URL | Dashboard URL After Login |
|--------|-----------|---------------------------|
| Admin  | /login.jsp | /admin/dashboard.jsp |
| Broker | /login.jsp | /broker/dashboard.jsp |
| User   | /login.jsp | /user/dashboard.jsp |

**All roles use the same login page** but are redirected to different dashboards based on their role!

---

## 🛡️ Security Features

1. **Password Validation** - Checked against database hash
2. **Role-Based Access** - Each role has specific permissions
3. **Session Management** - Secure session creation
4. **Authentication Filter** - Prevents unauthorized access
5. **CSRF Protection** - Token-based form submission
6. **SQL Injection Prevention** - Prepared statements

---

## 📝 Error Handling

### Invalid Credentials:
```
❌ Error: "Invalid username or password"
→ Stay on login.jsp
→ Show error message
→ Clear password field
```

### Empty Fields:
```
❌ Error: "Please enter username and password"
→ Stay on login.jsp
→ Highlight empty fields
```

### Invalid Role:
```
❌ Error: "Invalid user role"
→ Stay on login.jsp
→ Contact administrator
```

---

## 🎯 Testing Credentials (Example)

### Admin Login:
```
Username: admin
Password: admin123
Expected: Redirect to /admin/dashboard.jsp
```

### Broker Login:
```
Username: broker01
Password: broker123
Expected: Redirect to /broker/dashboard.jsp
```

### User Login:
```
Username: john_doe
Password: user123
Expected: Redirect to /user/dashboard.jsp
```

---

## 📞 Support

**Login Issues?**
- Check username spelling
- Verify password is correct
- Ensure account is active
- Contact system administrator

**Role Questions?**
- Admin = Full system access
- Broker = Assigned candidates only
- User = Own candidates only

---

**Created**: November 3, 2025
**Status**: ✅ Documented
**Last Updated**: Today

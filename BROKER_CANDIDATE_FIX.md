# Broker Candidate Visibility Fix

## Problem
Brokers were unable to see users and candidates in their dashboard because:
1. The `broker_id` was not being properly set when candidates registered
2. Existing candidates didn't have the `broker_id` field populated

## Solution Applied

### 1. Code Fix - CandidateServlet.java
Updated the `createCandidateProfile` method to inherit `broker_id` from the user object instead of trying to get it from form parameters.

**Changed:**
```java
// OLD CODE - getting from form parameter (incorrect)
String brokerIdStr = request.getParameter("brokerId");
if (brokerIdStr != null && !brokerIdStr.isEmpty()) {
    candidate.setBrokerId(Integer.parseInt(brokerIdStr));
}

// NEW CODE - inheriting from user (correct)
candidate.setBrokerId(user.getBrokerId());
```

### 2. Database Update Required
Run the SQL script `UPDATE_CANDIDATE_BROKER_ID.sql` to update existing candidates.

## Steps to Complete the Fix

### Step 1: Compile the Code
Open Eclipse and:
1. Refresh the project (F5)
2. Clean and build the project (Project > Clean)
3. Or let Eclipse auto-compile

### Step 2: Update Database
Run this SQL query in your MySQL database:

```sql
UPDATE candidates c
INNER JOIN users u ON c.user_id = u.user_id
SET c.broker_id = u.broker_id
WHERE u.broker_id IS NOT NULL AND c.broker_id IS NULL;
```

### Step 3: Verify the Fix
1. Login as a broker
2. Navigate to "My Candidates" page
3. You should now see all candidates from users who registered with your referral code

## How It Works

### User Registration Flow:
1. User registers with a referral code
2. System validates referral code and gets broker_id
3. User record is saved with broker_id

### Candidate Registration Flow:
1. User creates a candidate profile
2. Candidate inherits broker_id from user
3. Broker can now see this candidate

### Broker Dashboard:
1. Shows users registered with broker's referral code
2. Shows all candidates from those users
3. Shows candidates directly registered with broker_id

## Verification Queries

Check if users have broker_id:
```sql
SELECT user_id, username, full_name, broker_id, user_role
FROM users
WHERE broker_id IS NOT NULL;
```

Check if candidates have broker_id:
```sql
SELECT c.candidate_id, c.candidate_name, c.broker_id, u.username
FROM candidates c
INNER JOIN users u ON c.user_id = u.user_id
WHERE c.broker_id IS NOT NULL;
```

Check broker's users and candidates:
```sql
-- Replace 'BROKER_USER_ID' with actual broker's user_id
SELECT 
    u.user_id,
    u.username,
    u.full_name AS user_name,
    c.candidate_id,
    c.candidate_name,
    c.broker_id
FROM users u
LEFT JOIN candidates c ON u.user_id = c.user_id
WHERE u.broker_id = BROKER_USER_ID
ORDER BY u.user_id, c.candidate_id;
```

## Testing

### Test 1: New User Registration
1. Get a broker's referral code
2. Register a new user with that referral code
3. Login as the new user
4. Create a candidate profile
5. Login as the broker
6. Verify the candidate appears in broker's dashboard

### Test 2: Existing Data
1. Run the UPDATE_CANDIDATE_BROKER_ID.sql script
2. Login as a broker
3. Verify existing candidates now appear

## Troubleshooting

### Problem: Broker still can't see candidates
**Solution:** 
- Check if broker_id is set in users table
- Check if broker_id is set in candidates table
- Run the verification queries above

### Problem: No users registered with referral code
**Solution:**
- Users must register using the broker's referral code
- Check users table: `SELECT * FROM users WHERE broker_id IS NOT NULL`

### Problem: Candidates created before fix
**Solution:**
- Run UPDATE_CANDIDATE_BROKER_ID.sql to backfill broker_id

## Files Modified
- `src/com/election/servlet/CandidateServlet.java` - Fixed createCandidateProfile method

## Files Created
- `UPDATE_CANDIDATE_BROKER_ID.sql` - Database update script
- `BROKER_CANDIDATE_FIX.md` - This documentation

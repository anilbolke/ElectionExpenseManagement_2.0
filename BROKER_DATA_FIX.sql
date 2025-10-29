-- Broker Data Verification and Fix Script
-- Run this to check and fix broker-user-candidate relationships

-- =====================================================
-- STEP 1: VERIFY BROKER ACCOUNTS
-- =====================================================
SELECT '=== BROKER ACCOUNTS ===' as Info;
SELECT user_id, username, full_name, email, user_role, referral_code, is_active
FROM users 
WHERE user_role = 'broker';

-- =====================================================
-- STEP 2: CHECK USERS ASSIGNED TO BROKERS
-- =====================================================
SELECT '=== USERS ASSIGNED TO BROKERS ===' as Info;
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    u.broker_id,
    b.username as broker_username,
    b.full_name as broker_name
FROM users u
LEFT JOIN users b ON u.broker_id = b.user_id
WHERE u.broker_id IS NOT NULL
ORDER BY u.broker_id;

-- =====================================================
-- STEP 3: CHECK CANDIDATES WITH BROKER RELATIONSHIPS
-- =====================================================
SELECT '=== CANDIDATES WITH BROKER RELATIONSHIPS ===' as Info;
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.user_id,
    c.broker_id as candidate_broker_id,
    u.username,
    u.broker_id as user_broker_id,
    b.full_name as broker_name
FROM candidates c
JOIN users u ON c.user_id = u.user_id
LEFT JOIN users b ON c.broker_id = b.user_id
ORDER BY c.broker_id;

-- =====================================================
-- STEP 4: FIND BROKEN RELATIONSHIPS
-- =====================================================
SELECT '=== CANDIDATES WITH MISSING OR INCORRECT BROKER_ID ===' as Info;
SELECT 
    c.candidate_id,
    c.candidate_name,
    c.user_id,
    c.broker_id as candidate_broker_id,
    u.broker_id as user_broker_id,
    CASE 
        WHEN c.broker_id IS NULL THEN 'NULL'
        WHEN c.broker_id = 0 THEN 'ZERO'
        WHEN c.broker_id != u.broker_id THEN 'MISMATCH'
        ELSE 'OK'
    END as status
FROM candidates c
JOIN users u ON c.user_id = u.user_id
WHERE c.broker_id IS NULL 
   OR c.broker_id = 0 
   OR c.broker_id != u.broker_id
   OR u.broker_id IS NOT NULL;

-- =====================================================
-- STEP 5: FIX BROKEN RELATIONSHIPS
-- =====================================================
-- This will update all candidates to have the correct broker_id
-- based on their user's broker_id

UPDATE candidates c
JOIN users u ON c.user_id = u.user_id
SET c.broker_id = u.broker_id
WHERE u.broker_id IS NOT NULL 
  AND (c.broker_id IS NULL OR c.broker_id = 0 OR c.broker_id != u.broker_id);

SELECT 'Fixed candidates with incorrect broker_id' as Info;

-- =====================================================
-- STEP 6: VERIFY FIX
-- =====================================================
SELECT '=== VERIFICATION AFTER FIX ===' as Info;
SELECT 
    b.user_id as broker_id,
    b.full_name as broker_name,
    COUNT(DISTINCT u.user_id) as total_users,
    COUNT(DISTINCT c.candidate_id) as total_candidates
FROM users b
LEFT JOIN users u ON b.user_id = u.broker_id
LEFT JOIN candidates c ON b.user_id = c.broker_id
WHERE b.user_role = 'broker'
GROUP BY b.user_id, b.full_name;

-- =====================================================
-- STEP 7: DETAILED BREAKDOWN BY BROKER
-- =====================================================
SELECT '=== DETAILED BREAKDOWN BY BROKER ===' as Info;
SELECT 
    b.user_id as broker_id,
    b.full_name as broker_name,
    b.referral_code,
    u.user_id,
    u.username,
    u.full_name as user_name,
    COUNT(c.candidate_id) as candidate_count
FROM users b
LEFT JOIN users u ON b.user_id = u.broker_id
LEFT JOIN candidates c ON u.user_id = c.user_id
WHERE b.user_role = 'broker'
GROUP BY b.user_id, b.full_name, b.referral_code, u.user_id, u.username, u.full_name
ORDER BY b.user_id, u.user_id;

-- =====================================================
-- OPTIONAL: CREATE TEST DATA FOR A BROKER
-- =====================================================
-- Uncomment and modify these if you need to create test data
-- Replace <BROKER_USER_ID> with actual broker's user_id

/*
-- Create test user for broker
INSERT INTO users (username, full_name, email, mobile, password, broker_id, user_role, subscription_status, is_active, created_date)
VALUES 
('testuser1', 'Test User One', 'testuser1@test.com', '9876543211', 'test123', <BROKER_USER_ID>, 'user', 'active', TRUE, NOW());

-- Get the newly created user's ID and use it below
SET @new_user_id = LAST_INSERT_ID();

-- Create test candidates for this user
INSERT INTO candidates (
    user_id, 
    candidate_name, 
    father_name,
    age,
    gender,
    mobile, 
    email, 
    address,
    city,
    state,
    pincode,
    aadhar_number,
    voter_id,
    constituency,
    election_type,
    broker_id, 
    account_status,
    payment_status,
    created_date
)
VALUES 
(
    @new_user_id, 
    'Test Candidate One', 
    'Father Name',
    35,
    'Male',
    '9876543211', 
    'testcandidate1@test.com', 
    '123 Test Street',
    'Test City',
    'Test State',
    '123456',
    '123456789012',
    'ABC1234567',
    'Test Constituency',
    'State Assembly',
    <BROKER_USER_ID>, 
    'pending_payment',
    'pending',
    NOW()
),
(
    @new_user_id, 
    'Test Candidate Two', 
    'Father Name',
    40,
    'Female',
    '9876543212', 
    'testcandidate2@test.com', 
    '456 Test Avenue',
    'Test City',
    'Test State',
    '123456',
    '123456789013',
    'ABC1234568',
    'Test Constituency',
    'Lok Sabha',
    <BROKER_USER_ID>, 
    'active',
    'completed',
    NOW()
);

SELECT 'Test data created successfully' as Info;
*/

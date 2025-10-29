-- Test Candidate Update - Manual Testing
-- This script helps diagnose the candidate update issue

USE election_expense_db;

-- Step 1: Check current table structure
SELECT 'Step 1: Checking table structure...' AS Test;
DESCRIBE candidates;

-- Step 2: Check if gender, mobile, email columns exist
SELECT 'Step 2: Verifying gender, mobile, email columns exist...' AS Test;
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'election_expense_db' 
    AND TABLE_NAME = 'candidates'
    AND COLUMN_NAME IN ('gender', 'mobile', 'email');

-- Step 3: View current data (replace 1 with your actual candidate_id)
SELECT 'Step 3: Current data for candidate...' AS Test;
SELECT 
    candidate_id,
    candidate_name,
    father_name,
    age,
    gender,
    mobile,
    email,
    address,
    city,
    state
FROM candidates
WHERE candidate_id = 1;  -- CHANGE THIS TO YOUR ACTUAL CANDIDATE ID

-- Step 4: Test manual update (replace values and ID)
SELECT 'Step 4: Testing manual update...' AS Test;
-- UNCOMMENT THE NEXT LINE AND REPLACE VALUES TO TEST:
-- UPDATE candidates SET gender = 'Male', mobile = '9999999999', email = 'test@test.com' WHERE candidate_id = 1;

-- Step 5: Verify the update worked
SELECT 'Step 5: Verify updated data...' AS Test;
SELECT 
    candidate_id,
    candidate_name,
    father_name,
    age,
    gender,
    mobile,
    email,
    address,
    city,
    state
FROM candidates
WHERE candidate_id = 1;  -- CHANGE THIS TO YOUR ACTUAL CANDIDATE ID

-- Step 6: Test the exact same query that Java code uses
SELECT 'Step 6: Testing exact Java UPDATE query...' AS Test;
-- UNCOMMENT AND REPLACE ALL ? WITH ACTUAL VALUES:
/*
UPDATE candidates 
SET candidate_name = 'Test Name', 
    father_name = 'Test Father', 
    age = 30, 
    gender = 'Male', 
    mobile = '9876543210', 
    email = 'newemail@test.com', 
    address = 'Test Address', 
    city = 'Test City', 
    state = 'Test State', 
    pincode = '123456', 
    aadhar_number = '123456789012', 
    voter_id = 'ABC1234567', 
    constituency = 'Test Constituency', 
    party_name = 'Test Party', 
    party_symbol = 'Test Symbol', 
    election_type = 'Lok Sabha (General / Parliamentary) elections', 
    election_date = '2025-12-31', 
    booth_number = '123' 
WHERE candidate_id = 1;  -- CHANGE THIS TO YOUR ACTUAL CANDIDATE ID
*/

-- Step 7: Check for triggers that might be preventing updates
SELECT 'Step 7: Checking for triggers on candidates table...' AS Test;
SELECT 
    TRIGGER_NAME,
    EVENT_MANIPULATION,
    ACTION_TIMING,
    ACTION_STATEMENT
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE EVENT_OBJECT_TABLE = 'candidates'
    AND EVENT_OBJECT_SCHEMA = 'election_expense_db';

-- Step 8: Check for any constraints
SELECT 'Step 8: Checking constraints...' AS Test;
SELECT 
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'election_expense_db'
    AND TABLE_NAME = 'candidates'
    AND COLUMN_NAME IN ('gender', 'mobile', 'email');

-- Step 9: Check database permissions
SELECT 'Step 9: Checking UPDATE permissions...' AS Test;
SHOW GRANTS;

-- Step 10: Instructions for manual testing
SELECT '========================================' AS Instructions
UNION ALL SELECT 'MANUAL TESTING INSTRUCTIONS:'
UNION ALL SELECT '1. Run Steps 1-3 to see current state'
UNION ALL SELECT '2. Uncomment Step 4 UPDATE and run it'
UNION ALL SELECT '3. Run Step 5 to verify if manual update works'
UNION ALL SELECT '4. If manual update works, issue is in Java code'
UNION ALL SELECT '5. If manual update fails, issue is in database'
UNION ALL SELECT '========================================';

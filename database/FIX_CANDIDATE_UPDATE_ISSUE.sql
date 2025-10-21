-- Fix Candidate Update Issue - Mobile, Email, and Gender not updating
-- This script diagnoses and fixes the issue with candidate update

USE election_expense_db;

-- =====================================================
-- STEP 1: Check current table structure
-- =====================================================
SELECT 'Current candidates table structure:' AS Info;
DESCRIBE candidates;

-- =====================================================
-- STEP 2: Check if gender, mobile, email columns exist
-- =====================================================
SELECT 'Checking for gender, mobile, email columns:' AS Info;
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'election_expense_db' 
    AND TABLE_NAME = 'candidates'
    AND COLUMN_NAME IN ('gender', 'mobile', 'email', 'contact_number');

-- =====================================================
-- STEP 3: Add missing columns (if needed)
-- =====================================================

-- Add gender column if it doesn't exist
-- If it exists, this will give an error - that's OK
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'election_expense_db' 
     AND TABLE_NAME = 'candidates' 
     AND COLUMN_NAME = 'gender') = 0,
    'ALTER TABLE candidates ADD COLUMN gender VARCHAR(10) DEFAULT NULL AFTER age',
    'SELECT "gender column already exists" AS Info'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add mobile column if it doesn't exist
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'election_expense_db' 
     AND TABLE_NAME = 'candidates' 
     AND COLUMN_NAME = 'mobile') = 0,
    'ALTER TABLE candidates ADD COLUMN mobile VARCHAR(15) DEFAULT NULL AFTER gender',
    'SELECT "mobile column already exists" AS Info'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Make sure email column is properly defined (modify if exists)
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = 'election_expense_db' 
     AND TABLE_NAME = 'candidates' 
     AND COLUMN_NAME = 'email') > 0,
    'ALTER TABLE candidates MODIFY COLUMN email VARCHAR(100) DEFAULT NULL',
    'ALTER TABLE candidates ADD COLUMN email VARCHAR(100) DEFAULT NULL AFTER mobile'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =====================================================
-- STEP 4: If contact_number exists but mobile doesn't, copy data
-- =====================================================
SET @has_contact = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
                    WHERE TABLE_SCHEMA = 'election_expense_db' 
                    AND TABLE_NAME = 'candidates' 
                    AND COLUMN_NAME = 'contact_number');

SET @has_mobile = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_SCHEMA = 'election_expense_db' 
                   AND TABLE_NAME = 'candidates' 
                   AND COLUMN_NAME = 'mobile');

-- If both exist, copy contact_number to mobile for existing records
SET @sql = IF(
    @has_contact > 0 AND @has_mobile > 0,
    'UPDATE candidates SET mobile = contact_number WHERE mobile IS NULL AND contact_number IS NOT NULL',
    'SELECT "No need to copy contact_number to mobile" AS Info'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =====================================================
-- STEP 5: Verify the fix
-- =====================================================
SELECT 'Updated table structure:' AS Info;
DESCRIBE candidates;

SELECT 'Sample data to verify columns:' AS Info;
SELECT 
    candidate_id,
    candidate_name,
    father_name,
    age,
    gender,
    mobile,
    email,
    address,
    city
FROM candidates
LIMIT 5;

-- =====================================================
-- STEP 6: Test update query (the same one used in Java code)
-- =====================================================
SELECT 'Testing if update query will work:' AS Info;

-- This simulates what the Java code does
-- Replace the SET values with test data for your actual candidate_id
-- UPDATE candidates 
-- SET candidate_name = ?, father_name = ?, age = ?, gender = ?, mobile = ?, email = ?, 
--     address = ?, city = ?, state = ?, pincode = ?, aadhar_number = ?, voter_id = ?, 
--     constituency = ?, party_name = ?, party_symbol = ?, election_type = ?, 
--     election_date = ?, booth_number = ? 
-- WHERE candidate_id = ?;

SELECT 'Fix completed! Please test the candidate update functionality.' AS Status;

-- Simple Fix for Candidate Update Issue
-- Run each statement ONE BY ONE if you get errors

USE election_expense_db;

-- Check current structure
DESCRIBE candidates;

-- Try to add gender column (skip if error says "Duplicate column name")
ALTER TABLE candidates ADD COLUMN gender VARCHAR(10) DEFAULT NULL AFTER age;

-- Try to add mobile column (skip if error says "Duplicate column name")
ALTER TABLE candidates ADD COLUMN mobile VARCHAR(15) DEFAULT NULL AFTER gender;

-- Ensure email is properly configured
-- If email already exists, this will modify it to ensure it can be updated
ALTER TABLE candidates MODIFY COLUMN email VARCHAR(100) DEFAULT NULL;

-- Verify the changes
DESCRIBE candidates;

-- Show sample data
SELECT candidate_id, candidate_name, gender, mobile, email FROM candidates LIMIT 3;

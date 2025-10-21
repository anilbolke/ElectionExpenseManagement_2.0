-- Add missing gender, mobile, and email columns to candidates table
-- Execute this script if mobile, email, or gender are not updating

USE election_expense_db;

-- Check if columns exist before adding them
-- If they don't exist, add them. If they exist, this will show an error which can be ignored.

-- Add gender column if it doesn't exist
ALTER TABLE candidates ADD COLUMN gender VARCHAR(10) DEFAULT NULL AFTER age;

-- Add mobile column if it doesn't exist
ALTER TABLE candidates ADD COLUMN mobile VARCHAR(15) DEFAULT NULL AFTER gender;

-- Ensure email column exists with proper definition
-- If email column already exists as 'email', this will error (which is fine)
-- If it's named 'contact_email' or something else, you may need to adjust

-- If the table has contact_number instead of mobile, you can rename it:
-- ALTER TABLE candidates CHANGE COLUMN contact_number mobile VARCHAR(15) DEFAULT NULL;

-- Verify the changes
DESCRIBE candidates;

-- Check existing data
SELECT candidate_id, candidate_name, gender, mobile, email 
FROM candidates 
LIMIT 5;

-- SQL Script to alter candidates table for election_type column
-- This script adds/modifies the election_type column to support comprehensive election types

USE election_expense_db;

-- Check if election_type column exists, if not add it
-- If it exists, modify it to support longer values
ALTER TABLE candidates 
MODIFY COLUMN election_type VARCHAR(150) DEFAULT NULL;

-- If column doesn't exist, use this (comment out the above and uncomment below if column doesn't exist)
-- ALTER TABLE candidates 
-- ADD COLUMN election_type VARCHAR(150) DEFAULT NULL AFTER constituency;

-- Optional: Update any existing records with old short values to new detailed values
UPDATE candidates 
SET election_type = 'Lok Sabha (General / Parliamentary) elections' 
WHERE election_type = 'Lok Sabha';

UPDATE candidates 
SET election_type = 'State Legislative Assembly (Vidhan Sabha) elections' 
WHERE election_type = 'Vidhan Sabha';

UPDATE candidates 
SET election_type = 'Municipal / Local body elections (Municipal Corporation, Municipality, Nagar Panchayat)' 
WHERE election_type = 'Municipal Corporation';

UPDATE candidates 
SET election_type = 'Panchayat elections (Gram Panchayat, Panchayat Samiti, Zilla Parishad)' 
WHERE election_type = 'Panchayat';

-- Show the updated table structure
DESCRIBE candidates;

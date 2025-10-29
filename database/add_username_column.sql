-- Add username column to users table
-- Run each statement separately

-- Step 1: Add username column (nullable first)
ALTER TABLE users 
ADD COLUMN username VARCHAR(50) UNIQUE AFTER user_id;

-- Step 2: Update existing users with default username (email prefix or user_id based)
UPDATE users 
SET username = CONCAT('user', user_id) 
WHERE username IS NULL;

-- Step 3: Make username NOT NULL
ALTER TABLE users 
MODIFY COLUMN username VARCHAR(50) NOT NULL UNIQUE;

-- Verify the changes
SELECT user_id, username, email, full_name FROM users LIMIT 10;

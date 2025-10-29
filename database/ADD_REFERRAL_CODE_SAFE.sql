-- Safe script to add referral_code column to users table
-- This script checks if column exists before adding it
-- Date: October 13, 2025

USE election_expense_db;

-- Check and add referral_code column if it doesn't exist
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = 'election_expense_db' 
  AND TABLE_NAME = 'users' 
  AND COLUMN_NAME = 'referral_code';

SET @query = IF(@col_exists = 0,
    'ALTER TABLE users ADD COLUMN referral_code VARCHAR(20) UNIQUE DEFAULT NULL AFTER broker_commission_rate',
    'SELECT "Column referral_code already exists" AS Message'
);

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Create index if it doesn't exist
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'election_expense_db'
  AND TABLE_NAME = 'users'
  AND INDEX_NAME = 'idx_users_referral_code';

SET @query2 = IF(@index_exists = 0,
    'CREATE INDEX idx_users_referral_code ON users(referral_code)',
    'SELECT "Index idx_users_referral_code already exists" AS Message'
);

PREPARE stmt2 FROM @query2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- Display success message
SELECT 'Migration completed successfully!' AS Status;

-- Show updated table structure
DESCRIBE users;

-- Add referral_code column to users table for brokers
-- Date: October 13, 2025

USE election_expense_db;

-- Add referral_code column (unique for brokers)
ALTER TABLE users 
ADD COLUMN referral_code VARCHAR(20) UNIQUE DEFAULT NULL
AFTER broker_commission_rate;

-- Create index for faster lookups
CREATE INDEX idx_users_referral_code ON users(referral_code);

-- Display success message
SELECT 'referral_code column added successfully to users table!' AS Status;

-- Show table structure
DESCRIBE users;

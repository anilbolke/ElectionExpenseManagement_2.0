-- Fix Users and Candidates Tables
-- Execute each ALTER statement ONE BY ONE separately

USE election_expense_db;

-- =====================================================
-- FIX USERS TABLE - Execute each statement separately
-- =====================================================

-- Add subscription_status column
ALTER TABLE users ADD COLUMN subscription_status ENUM('inactive', 'active', 'expired') DEFAULT 'inactive';

-- Add subscription_plan_id column
ALTER TABLE users ADD COLUMN subscription_plan_id INT DEFAULT NULL;

-- Add address column
ALTER TABLE users ADD COLUMN address VARCHAR(255) DEFAULT NULL;

-- Add foreign key for subscription_plan_id
ALTER TABLE users ADD CONSTRAINT fk_users_subscription_plan 
    FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(plan_id) ON DELETE SET NULL;

-- =====================================================
-- FIX CANDIDATES TABLE - Execute each statement separately
-- =====================================================

-- Add user_id column
ALTER TABLE candidates ADD COLUMN user_id INT DEFAULT NULL AFTER candidate_id;

-- Add father_name column
ALTER TABLE candidates ADD COLUMN father_name VARCHAR(100) DEFAULT NULL AFTER candidate_name;

-- Add age column
ALTER TABLE candidates ADD COLUMN age INT DEFAULT NULL AFTER father_name;

-- Add address column
ALTER TABLE candidates ADD COLUMN address VARCHAR(255) DEFAULT NULL AFTER age;

-- Add city column
ALTER TABLE candidates ADD COLUMN city VARCHAR(100) DEFAULT NULL AFTER address;

-- Add state column
ALTER TABLE candidates ADD COLUMN state VARCHAR(100) DEFAULT NULL AFTER city;

-- Add pincode column
ALTER TABLE candidates ADD COLUMN pincode VARCHAR(10) DEFAULT NULL AFTER state;

-- Add aadhar_number column
ALTER TABLE candidates ADD COLUMN aadhar_number VARCHAR(20) DEFAULT NULL AFTER pincode;

-- Add voter_id column
ALTER TABLE candidates ADD COLUMN voter_id VARCHAR(20) DEFAULT NULL AFTER aadhar_number;

-- Add party_symbol column
ALTER TABLE candidates ADD COLUMN party_symbol VARCHAR(100) DEFAULT NULL AFTER party_name;

-- Add election_type column
ALTER TABLE candidates ADD COLUMN election_type VARCHAR(50) DEFAULT NULL AFTER constituency;

-- Add election_date column
ALTER TABLE candidates ADD COLUMN election_date DATE DEFAULT NULL AFTER election_type;

-- Add booth_number column
ALTER TABLE candidates ADD COLUMN booth_number VARCHAR(50) DEFAULT NULL AFTER election_date;

-- Add payment_status column
ALTER TABLE candidates ADD COLUMN payment_status VARCHAR(50) DEFAULT 'pending' AFTER broker_id;

-- Add payment_amount column
ALTER TABLE candidates ADD COLUMN payment_amount DECIMAL(10,2) DEFAULT 0.00 AFTER payment_status;

-- Add payment_date column
ALTER TABLE candidates ADD COLUMN payment_date TIMESTAMP NULL AFTER payment_amount;

-- Add transaction_id column
ALTER TABLE candidates ADD COLUMN transaction_id VARCHAR(100) DEFAULT NULL AFTER payment_date;

-- Add is_payment_verified column
ALTER TABLE candidates ADD COLUMN is_payment_verified BOOLEAN DEFAULT FALSE AFTER transaction_id;

-- Add account_status column
ALTER TABLE candidates ADD COLUMN account_status VARCHAR(50) DEFAULT 'pending_payment' AFTER is_payment_verified;

-- Add created_date column
ALTER TABLE candidates ADD COLUMN created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER account_status;

-- Add updated_date column
ALTER TABLE candidates ADD COLUMN updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_date;

-- Modify contact_number column
ALTER TABLE candidates MODIFY COLUMN contact_number VARCHAR(15) DEFAULT NULL;

-- Modify email column
ALTER TABLE candidates MODIFY COLUMN email VARCHAR(100) DEFAULT NULL;

-- Add foreign key for user_id
ALTER TABLE candidates ADD CONSTRAINT fk_candidates_user 
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Verify users table structure
DESCRIBE users;

-- Verify candidates table structure
DESCRIBE candidates;

-- Check data
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as candidate_count FROM candidates;

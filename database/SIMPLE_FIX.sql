-- SIMPLE DATABASE FIX
-- Copy each statement below and execute ONE BY ONE in MySQL Workbench
-- If you get "Duplicate column" error, just skip that statement

USE election_expense_db;

-- ==================== USERS TABLE ====================
-- Execute each line separately:

ALTER TABLE users ADD COLUMN subscription_status ENUM('inactive', 'active', 'expired') DEFAULT 'inactive';

ALTER TABLE users ADD COLUMN subscription_plan_id INT DEFAULT NULL;

ALTER TABLE users ADD COLUMN address VARCHAR(255) DEFAULT NULL;

-- ==================== CANDIDATES TABLE ====================
-- Execute each line separately:

ALTER TABLE candidates ADD COLUMN user_id INT DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN father_name VARCHAR(100) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN age INT DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN address VARCHAR(255) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN city VARCHAR(100) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN state VARCHAR(100) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN pincode VARCHAR(10) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN aadhar_number VARCHAR(20) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN voter_id VARCHAR(20) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN party_symbol VARCHAR(100) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN election_type VARCHAR(50) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN election_date DATE DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN booth_number VARCHAR(50) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN payment_status VARCHAR(50) DEFAULT 'pending';

ALTER TABLE candidates ADD COLUMN payment_amount DECIMAL(10,2) DEFAULT 0.00;

ALTER TABLE candidates ADD COLUMN payment_date TIMESTAMP NULL;

ALTER TABLE candidates ADD COLUMN transaction_id VARCHAR(100) DEFAULT NULL;

ALTER TABLE candidates ADD COLUMN is_payment_verified BOOLEAN DEFAULT FALSE;

ALTER TABLE candidates ADD COLUMN account_status VARCHAR(50) DEFAULT 'pending_payment';

ALTER TABLE candidates ADD COLUMN created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE candidates ADD COLUMN updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- ==================== VERIFICATION ====================

DESCRIBE users;

DESCRIBE candidates;

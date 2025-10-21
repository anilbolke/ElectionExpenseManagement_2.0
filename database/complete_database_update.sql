-- Complete Database Update Script
-- This script adds subscription and broker transaction features
-- Run this script AFTER the main database_schema.sql

USE election_expense_db;

-- ============================================
-- PART 1: Add Subscription Fields to Users Table
-- ============================================

-- Check if columns exist before adding them
SET @col_exists = (SELECT COUNT(*) 
                   FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_SCHEMA = 'election_expense_db' 
                   AND TABLE_NAME = 'users' 
                   AND COLUMN_NAME = 'subscription_status');

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE users 
     ADD COLUMN subscription_status ENUM(''pending'', ''active'', ''expired'') DEFAULT ''pending'' AFTER status,
     ADD COLUMN subscription_start_date DATETIME NULL,
     ADD COLUMN subscription_end_date DATETIME NULL,
     ADD COLUMN payment_status ENUM(''unpaid'', ''paid'', ''pending'') DEFAULT ''unpaid''',
    'SELECT ''Subscription columns already exist'' AS Message');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================
-- PART 2: Create Subscription Plans Table
-- ============================================

CREATE TABLE IF NOT EXISTS subscription_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL UNIQUE,
    plan_description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    features TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Default Subscription Plans (ignore if already exist)
INSERT IGNORE INTO subscription_plans (plan_name, plan_description, price, duration_days, features) VALUES
('Basic', 'Monthly subscription for basic expense management', 500.00, 30, 'Add unlimited expenses, Upload receipts, View expense history, Generate reports'),
('Quarterly', 'Quarterly subscription with 10% discount', 1350.00, 90, 'All Basic features, Priority support, Advanced analytics'),
('Annual', 'Annual subscription with 20% discount', 4800.00, 365, 'All features, Premium support, Custom reports, API access');

-- ============================================
-- PART 3: Create User Subscriptions Table
-- ============================================

CREATE TABLE IF NOT EXISTS user_subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL DEFAULT 'Basic',
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    subscription_start_date DATETIME,
    subscription_end_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================
-- PART 4: Create Payment History Table
-- ============================================

CREATE TABLE IF NOT EXISTS payment_history (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    subscription_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES user_subscriptions(subscription_id) ON DELETE SET NULL
);

-- ============================================
-- PART 5: Create Broker Transactions Table
-- ============================================

CREATE TABLE IF NOT EXISTS broker_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    broker_id INT NOT NULL,
    candidate_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    commission_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    commission_percentage DECIMAL(5, 2) DEFAULT 10.00,
    payment_status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    payment_mode VARCHAR(50) DEFAULT 'cash',
    transaction_reference VARCHAR(100),
    remarks TEXT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (broker_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================
-- PART 6: Create Indexes for Performance
-- ============================================

-- Subscription indexes
CREATE INDEX IF NOT EXISTS idx_user_subscription ON users(user_id, subscription_status);
CREATE INDEX IF NOT EXISTS idx_subscription_dates ON user_subscriptions(subscription_start_date, subscription_end_date);
CREATE INDEX IF NOT EXISTS idx_payment_status ON payment_history(payment_status, payment_date);

-- Broker transaction indexes
CREATE INDEX IF NOT EXISTS idx_broker_transactions ON broker_transactions(broker_id, payment_status);
CREATE INDEX IF NOT EXISTS idx_candidate_transactions ON broker_transactions(candidate_id);
CREATE INDEX IF NOT EXISTS idx_transaction_date ON broker_transactions(transaction_date);

-- ============================================
-- PART 7: Update Existing Admin Users
-- ============================================

-- Give admin users active subscription by default
UPDATE users 
SET subscription_status = 'active', 
    subscription_start_date = NOW(), 
    subscription_end_date = DATE_ADD(NOW(), INTERVAL 365 DAY),
    payment_status = 'paid'
WHERE role = 'admin';

-- Give broker users active subscription by default
UPDATE users 
SET subscription_status = 'active', 
    subscription_start_date = NOW(), 
    subscription_end_date = DATE_ADD(NOW(), INTERVAL 365 DAY),
    payment_status = 'paid'
WHERE role = 'broker';

-- ============================================
-- PART 8: Verification
-- ============================================

-- Show created tables
SELECT 'Database update completed successfully!' AS Status;
SELECT '============================================' AS Divider;
SELECT 'Tables created/updated:' AS Info;
SHOW TABLES LIKE '%subscription%';
SHOW TABLES LIKE '%broker%';

SELECT '============================================' AS Divider;
SELECT 'Subscription Plans Available:' AS Info;
SELECT plan_name, price, duration_days FROM subscription_plans;

SELECT '============================================' AS Divider;
SELECT 'Users with Active Subscriptions:' AS Info;
SELECT user_id, username, full_name, role, subscription_status, subscription_end_date 
FROM users 
WHERE subscription_status = 'active';

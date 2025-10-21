-- Fix Schema for Election Expense Management
-- Adds missing columns and updates structure

USE election_expense_db;

-- Update users table to add missing columns
ALTER TABLE users 
    ADD COLUMN IF NOT EXISTS broker_id INT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS subscription_status ENUM('inactive', 'active', 'expired') DEFAULT 'inactive',
    ADD COLUMN IF NOT EXISTS subscription_plan_id INT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS address VARCHAR(255) DEFAULT NULL;

-- Ensure candidates table has all required columns
ALTER TABLE candidates 
    ADD COLUMN IF NOT EXISTS user_id INT DEFAULT NULL AFTER candidate_id,
    ADD COLUMN IF NOT EXISTS father_name VARCHAR(100) DEFAULT NULL AFTER candidate_name,
    ADD COLUMN IF NOT EXISTS age INT DEFAULT NULL AFTER father_name,
    ADD COLUMN IF NOT EXISTS address VARCHAR(255) DEFAULT NULL AFTER age,
    ADD COLUMN IF NOT EXISTS city VARCHAR(100) DEFAULT NULL AFTER address,
    ADD COLUMN IF NOT EXISTS state VARCHAR(100) DEFAULT NULL AFTER city,
    ADD COLUMN IF NOT EXISTS pincode VARCHAR(10) DEFAULT NULL AFTER state,
    ADD COLUMN IF NOT EXISTS aadhar_number VARCHAR(20) DEFAULT NULL AFTER pincode,
    ADD COLUMN IF NOT EXISTS voter_id VARCHAR(20) DEFAULT NULL AFTER aadhar_number,
    ADD COLUMN IF NOT EXISTS party_symbol VARCHAR(100) DEFAULT NULL AFTER party_name,
    ADD COLUMN IF NOT EXISTS election_type VARCHAR(50) DEFAULT NULL AFTER constituency,
    ADD COLUMN IF NOT EXISTS election_date DATE DEFAULT NULL AFTER election_type,
    ADD COLUMN IF NOT EXISTS booth_number VARCHAR(50) DEFAULT NULL AFTER election_date,
    ADD COLUMN IF NOT EXISTS payment_status VARCHAR(50) DEFAULT 'pending' AFTER broker_id,
    ADD COLUMN IF NOT EXISTS payment_amount DECIMAL(10,2) DEFAULT 0.00 AFTER payment_status,
    ADD COLUMN IF NOT EXISTS payment_date TIMESTAMP NULL AFTER payment_amount,
    ADD COLUMN IF NOT EXISTS transaction_id VARCHAR(100) DEFAULT NULL AFTER payment_date,
    ADD COLUMN IF NOT EXISTS is_payment_verified BOOLEAN DEFAULT FALSE AFTER transaction_id,
    ADD COLUMN IF NOT EXISTS account_status VARCHAR(50) DEFAULT 'pending_payment' AFTER is_payment_verified,
    ADD COLUMN IF NOT EXISTS created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER account_status,
    ADD COLUMN IF NOT EXISTS updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_date,
    MODIFY COLUMN contact_number VARCHAR(15) DEFAULT NULL,
    MODIFY COLUMN email VARCHAR(100) DEFAULT NULL;

-- Add foreign key for user_id in candidates if not exists
SET @fk_exists = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS 
                  WHERE CONSTRAINT_SCHEMA = 'election_expense_db' 
                  AND TABLE_NAME = 'candidates' 
                  AND CONSTRAINT_NAME = 'fk_candidate_user');

SET @query = IF(@fk_exists = 0, 
    'ALTER TABLE candidates ADD CONSTRAINT fk_candidate_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE',
    'SELECT "Foreign key already exists"');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Ensure broker_transactions table exists with all columns
CREATE TABLE IF NOT EXISTS broker_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    broker_id INT NOT NULL,
    candidate_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('pending', 'partial', 'completed') DEFAULT 'pending',
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_date TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (broker_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Ensure subscription_plans table exists
CREATE TABLE IF NOT EXISTS subscription_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(100) NOT NULL,
    plan_description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    plan_type VARCHAR(50),
    max_candidates INT DEFAULT 1,
    expense_tracking BOOLEAN DEFAULT TRUE,
    fund_management BOOLEAN DEFAULT TRUE,
    report_generation BOOLEAN DEFAULT FALSE,
    priority_support BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Ensure candidate_subscriptions table exists
CREATE TABLE IF NOT EXISTS candidate_subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP NULL,
    status VARCHAR(50) DEFAULT 'active',
    payment_id INT DEFAULT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id)
);

-- Ensure expenses table has candidate_id
ALTER TABLE expenses 
    ADD COLUMN IF NOT EXISTS candidate_id INT DEFAULT NULL AFTER user_id;

-- Add foreign key for candidate_id in expenses if not exists
SET @fk_expenses_exists = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS 
                           WHERE CONSTRAINT_SCHEMA = 'election_expense_db' 
                           AND TABLE_NAME = 'expenses' 
                           AND CONSTRAINT_NAME = 'fk_expense_candidate');

SET @query2 = IF(@fk_expenses_exists = 0, 
    'ALTER TABLE expenses ADD CONSTRAINT fk_expense_candidate FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE',
    'SELECT "Foreign key already exists"');

PREPARE stmt2 FROM @query2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- Create funds table if not exists
CREATE TABLE IF NOT EXISTS funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT NOT NULL,
    source_name VARCHAR(200) NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    receipt_number VARCHAR(100),
    received_date DATE NOT NULL,
    payment_mode VARCHAR(50),
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE
);

-- Create payments table if not exists
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'pending',
    transaction_id VARCHAR(100),
    payment_method VARCHAR(50),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert default subscription plans if not exists
INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, plan_type, max_candidates, expense_tracking, fund_management, report_generation, priority_support)
SELECT * FROM (SELECT 
    'Basic Plan' as plan_name,
    'Perfect for single candidate election campaigns' as plan_description,
    999.00 as price,
    30 as duration_days,
    'monthly' as plan_type,
    1 as max_candidates,
    TRUE as expense_tracking,
    TRUE as fund_management,
    FALSE as report_generation,
    FALSE as priority_support
) AS tmp
WHERE NOT EXISTS (
    SELECT plan_name FROM subscription_plans WHERE plan_name = 'Basic Plan'
) LIMIT 1;

INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, plan_type, max_candidates, expense_tracking, fund_management, report_generation, priority_support)
SELECT * FROM (SELECT 
    'Professional Plan' as plan_name,
    'Ideal for multiple candidates with advanced features' as plan_description,
    2499.00 as price,
    90 as duration_days,
    'quarterly' as plan_type,
    5 as max_candidates,
    TRUE as expense_tracking,
    TRUE as fund_management,
    TRUE as report_generation,
    TRUE as priority_support
) AS tmp
WHERE NOT EXISTS (
    SELECT plan_name FROM subscription_plans WHERE plan_name = 'Professional Plan'
) LIMIT 1;

INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, plan_type, max_candidates, expense_tracking, fund_management, report_generation, priority_support)
SELECT * FROM (SELECT 
    'Enterprise Plan' as plan_name,
    'Complete solution for large political parties' as plan_description,
    8999.00 as price,
    365 as duration_days,
    'yearly' as plan_type,
    999 as max_candidates,
    TRUE as expense_tracking,
    TRUE as fund_management,
    TRUE as report_generation,
    TRUE as priority_support
) AS tmp
WHERE NOT EXISTS (
    SELECT plan_name FROM subscription_plans WHERE plan_name = 'Enterprise Plan'
) LIMIT 1;

-- Update admin user if needed
UPDATE users SET role = 'admin', status = 'active' WHERE username = 'admin' AND email = 'admin@election.com';

SELECT 'Schema update completed successfully!' as message;

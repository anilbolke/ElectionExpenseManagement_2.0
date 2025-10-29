-- =====================================================
-- SIMPLE FIX USERS TABLE - Add Missing Columns
-- =====================================================
-- Copy and paste ONE statement at a time into MySQL Workbench
-- If column already exists, you'll get an error - just skip it

USE election_expense_db;

-- Add subscription_status column
ALTER TABLE users ADD COLUMN subscription_status ENUM('inactive', 'active', 'expired') DEFAULT 'inactive';

-- Add subscription_plan_id column  
ALTER TABLE users ADD COLUMN subscription_plan_id INT DEFAULT NULL;

-- Add address column
ALTER TABLE users ADD COLUMN address VARCHAR(500) DEFAULT NULL;

-- Add broker_id column (for users assigned to broker)
ALTER TABLE users ADD COLUMN broker_id INT DEFAULT NULL;

-- Add foreign key for subscription_plan_id (only if subscription_plans table exists)
-- ALTER TABLE users ADD CONSTRAINT fk_user_subscription_plan FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(plan_id) ON DELETE SET NULL;

-- Verify the changes
DESCRIBE users;

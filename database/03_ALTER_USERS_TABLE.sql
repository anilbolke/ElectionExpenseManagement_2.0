-- =====================================================
-- ALTER USERS TABLE - Add Missing Columns
-- =====================================================
-- Execute these statements ONE BY ONE

-- Step 1: Add subscription_status column
ALTER TABLE users 
ADD COLUMN subscription_status ENUM('inactive', 'active', 'expired') DEFAULT 'inactive';

-- Step 2: Add subscription_plan_id column  
ALTER TABLE users 
ADD COLUMN subscription_plan_id INT DEFAULT NULL;

-- Step 3: Add address column (if not exists)
ALTER TABLE users 
ADD COLUMN address VARCHAR(255) DEFAULT NULL;

-- Step 4: Add foreign key for subscription_plan_id
ALTER TABLE users 
ADD CONSTRAINT fk_user_subscription_plan 
FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(plan_id) 
ON DELETE SET NULL;

-- Verify the changes
DESCRIBE users;

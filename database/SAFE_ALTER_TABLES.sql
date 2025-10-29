-- SAFE ALTER TABLES SCRIPT
-- This script uses stored procedures to safely add columns only if they don't exist
-- Execute this entire script at once

USE election_expense_db;

-- Drop procedures if they exist
DROP PROCEDURE IF EXISTS AddColumnIfNotExists;
DROP PROCEDURE IF EXISTS ModifyColumnIfExists;

DELIMITER $$

-- Procedure to add column if it doesn't exist
CREATE PROCEDURE AddColumnIfNotExists(
    IN tableName VARCHAR(100),
    IN columnName VARCHAR(100),
    IN columnDefinition VARCHAR(255)
)
BEGIN
    DECLARE columnExists INT;
    
    SELECT COUNT(*) INTO columnExists
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = tableName
    AND COLUMN_NAME = columnName;
    
    IF columnExists = 0 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' ADD COLUMN ', columnName, ' ', columnDefinition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('Added column ', columnName, ' to ', tableName) AS message;
    ELSE
        SELECT CONCAT('Column ', columnName, ' already exists in ', tableName) AS message;
    END IF;
END$$

-- Procedure to modify column if it exists
CREATE PROCEDURE ModifyColumnIfExists(
    IN tableName VARCHAR(100),
    IN columnName VARCHAR(100),
    IN columnDefinition VARCHAR(255)
)
BEGIN
    DECLARE columnExists INT;
    
    SELECT COUNT(*) INTO columnExists
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = tableName
    AND COLUMN_NAME = columnName;
    
    IF columnExists > 0 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' MODIFY COLUMN ', columnName, ' ', columnDefinition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('Modified column ', columnName, ' in ', tableName) AS message;
    ELSE
        SELECT CONCAT('Column ', columnName, ' does not exist in ', tableName) AS message;
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- FIX USERS TABLE
-- =====================================================

CALL AddColumnIfNotExists('users', 'subscription_status', "ENUM('inactive', 'active', 'expired') DEFAULT 'inactive'");
CALL AddColumnIfNotExists('users', 'subscription_plan_id', 'INT DEFAULT NULL');
CALL AddColumnIfNotExists('users', 'address', 'VARCHAR(255) DEFAULT NULL');

-- =====================================================
-- FIX CANDIDATES TABLE
-- =====================================================

CALL AddColumnIfNotExists('candidates', 'user_id', 'INT DEFAULT NULL AFTER candidate_id');
CALL AddColumnIfNotExists('candidates', 'father_name', 'VARCHAR(100) DEFAULT NULL AFTER candidate_name');
CALL AddColumnIfNotExists('candidates', 'age', 'INT DEFAULT NULL AFTER father_name');
CALL AddColumnIfNotExists('candidates', 'address', 'VARCHAR(255) DEFAULT NULL AFTER age');
CALL AddColumnIfNotExists('candidates', 'city', 'VARCHAR(100) DEFAULT NULL AFTER address');
CALL AddColumnIfNotExists('candidates', 'state', 'VARCHAR(100) DEFAULT NULL AFTER city');
CALL AddColumnIfNotExists('candidates', 'pincode', 'VARCHAR(10) DEFAULT NULL AFTER state');
CALL AddColumnIfNotExists('candidates', 'aadhar_number', 'VARCHAR(20) DEFAULT NULL AFTER pincode');
CALL AddColumnIfNotExists('candidates', 'voter_id', 'VARCHAR(20) DEFAULT NULL AFTER aadhar_number');
CALL AddColumnIfNotExists('candidates', 'party_symbol', 'VARCHAR(100) DEFAULT NULL AFTER party_name');
CALL AddColumnIfNotExists('candidates', 'election_type', 'VARCHAR(50) DEFAULT NULL AFTER constituency');
CALL AddColumnIfNotExists('candidates', 'election_date', 'DATE DEFAULT NULL AFTER election_type');
CALL AddColumnIfNotExists('candidates', 'booth_number', 'VARCHAR(50) DEFAULT NULL AFTER election_date');
CALL AddColumnIfNotExists('candidates', 'payment_status', "VARCHAR(50) DEFAULT 'pending' AFTER broker_id");
CALL AddColumnIfNotExists('candidates', 'payment_amount', 'DECIMAL(10,2) DEFAULT 0.00 AFTER payment_status');
CALL AddColumnIfNotExists('candidates', 'payment_date', 'TIMESTAMP NULL AFTER payment_amount');
CALL AddColumnIfNotExists('candidates', 'transaction_id', 'VARCHAR(100) DEFAULT NULL AFTER payment_date');
CALL AddColumnIfNotExists('candidates', 'is_payment_verified', 'BOOLEAN DEFAULT FALSE AFTER transaction_id');
CALL AddColumnIfNotExists('candidates', 'account_status', "VARCHAR(50) DEFAULT 'pending_payment' AFTER is_payment_verified");
CALL AddColumnIfNotExists('candidates', 'created_date', 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER account_status');
CALL AddColumnIfNotExists('candidates', 'updated_date', 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_date');

-- Modify existing columns
CALL ModifyColumnIfExists('candidates', 'contact_number', 'VARCHAR(15) DEFAULT NULL');
CALL ModifyColumnIfExists('candidates', 'email', 'VARCHAR(100) DEFAULT NULL');

-- =====================================================
-- ADD FOREIGN KEYS (if not exist)
-- =====================================================

-- Add foreign key for users.subscription_plan_id
SET @fk_exists = 0;
SELECT COUNT(*) INTO @fk_exists
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'users'
AND CONSTRAINT_NAME = 'fk_users_subscription_plan';

SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE users ADD CONSTRAINT fk_users_subscription_plan FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(plan_id) ON DELETE SET NULL',
    'SELECT "Foreign key fk_users_subscription_plan already exists" AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add foreign key for candidates.user_id
SET @fk_exists = 0;
SELECT COUNT(*) INTO @fk_exists
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'candidates'
AND CONSTRAINT_NAME = 'fk_candidates_user';

SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE candidates ADD CONSTRAINT fk_candidates_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE',
    'SELECT "Foreign key fk_candidates_user already exists" AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =====================================================
-- CLEANUP
-- =====================================================

DROP PROCEDURE IF EXISTS AddColumnIfNotExists;
DROP PROCEDURE IF EXISTS ModifyColumnIfExists;

-- =====================================================
-- VERIFICATION
-- =====================================================

SELECT 'Users Table Structure:' AS '';
DESCRIBE users;

SELECT 'Candidates Table Structure:' AS '';
DESCRIBE candidates;

SELECT 'Data Counts:' AS '';
SELECT 
    (SELECT COUNT(*) FROM users) AS user_count,
    (SELECT COUNT(*) FROM candidates) AS candidate_count;

-- ===================================================================
-- Multi-Language Support - Database UTF-8 Configuration
-- ===================================================================
-- This script updates the database to support multi-language input
-- (Hindi, Marathi, and other Indian languages)
-- ===================================================================

USE election_expense_db;

-- Step 1: Update Database Character Set
-- ===================================================================
ALTER DATABASE election_expense_db 
CHARACTER SET = utf8mb4 
COLLATE = utf8mb4_unicode_ci;

-- Step 2: Update Users Table
-- ===================================================================
ALTER TABLE users 
CONVERT TO CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

ALTER TABLE users 
MODIFY username VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY email VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY full_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY address TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY city VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY state VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Step 3: Update Candidates Table
-- ===================================================================
ALTER TABLE candidates 
CONVERT TO CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

ALTER TABLE candidates 
MODIFY candidate_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY email VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY party_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY constituency VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY election_type VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY address TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Step 4: Update Expenses Table
-- ===================================================================
ALTER TABLE expenses 
CONVERT TO CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

ALTER TABLE expenses 
MODIFY description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY category VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY receipt_path VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Step 5: Update Brokers Table
-- ===================================================================
ALTER TABLE brokers 
CONVERT TO CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

ALTER TABLE brokers 
MODIFY broker_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY email VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY business_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY address TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Step 6: Update Payments Table (if exists)
-- ===================================================================
ALTER TABLE payments 
CONVERT TO CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

ALTER TABLE payments 
MODIFY payment_method VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY transaction_id VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
MODIFY payment_status VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Verify changes
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    CHARACTER_SET_NAME, 
    COLLATION_NAME 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_SCHEMA = 'election_expense_db'
    AND TABLE_NAME IN ('users', 'candidates', 'expenses', 'brokers', 'payments')
    AND CHARACTER_SET_NAME IS NOT NULL
ORDER BY 
    TABLE_NAME, COLUMN_NAME;

-- ===================================================================
-- Multi-Language Support Configuration Complete!
-- 
-- Now you can:
-- ✅ Enter Hindi text: राजेश कुमार
-- ✅ Enter Marathi text: राजेश कुमार
-- ✅ Enter any Indian language text
-- ✅ Search and filter in any language
-- ===================================================================

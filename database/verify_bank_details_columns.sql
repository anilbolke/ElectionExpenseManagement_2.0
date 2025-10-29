-- Verify if bank details columns exist in users table
-- Run this script to check database structure

-- Check if columns exist
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'users'
    AND COLUMN_NAME IN ('bank_name', 'account_number', 'ifsc_code', 'branch_name', 'pan_number')
ORDER BY 
    ORDINAL_POSITION;

-- If above query returns 0 rows, columns don't exist. Run add_bank_details_columns.sql first!

-- Check broker users
SELECT 
    user_id,
    username,
    full_name,
    user_role,
    bank_name,
    account_number,
    ifsc_code,
    branch_name,
    pan_number
FROM 
    users
WHERE 
    user_role = 'broker'
ORDER BY 
    user_id;

-- Count broker users with bank details
SELECT 
    COUNT(*) as total_brokers,
    SUM(CASE WHEN bank_name IS NOT NULL THEN 1 ELSE 0 END) as brokers_with_bank_details
FROM 
    users
WHERE 
    user_role = 'broker';

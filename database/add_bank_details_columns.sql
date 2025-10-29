-- Add bank details columns to users table for broker bank account information

ALTER TABLE users
ADD COLUMN bank_name VARCHAR(200) DEFAULT NULL AFTER referral_code,
ADD COLUMN account_number VARCHAR(20) DEFAULT NULL AFTER bank_name,
ADD COLUMN ifsc_code VARCHAR(11) DEFAULT NULL AFTER account_number,
ADD COLUMN branch_name VARCHAR(200) DEFAULT NULL AFTER ifsc_code,
ADD COLUMN pan_number VARCHAR(10) DEFAULT NULL AFTER branch_name;

-- Add indexes for better performance
CREATE INDEX idx_users_pan_number ON users(pan_number);
CREATE INDEX idx_users_ifsc_code ON users(ifsc_code);

-- Add comment to columns
ALTER TABLE users 
MODIFY COLUMN bank_name VARCHAR(200) COMMENT 'Broker bank name for commission payments',
MODIFY COLUMN account_number VARCHAR(20) COMMENT 'Broker bank account number',
MODIFY COLUMN ifsc_code VARCHAR(11) COMMENT 'Bank IFSC code',
MODIFY COLUMN branch_name VARCHAR(200) COMMENT 'Bank branch name',
MODIFY COLUMN pan_number VARCHAR(10) COMMENT 'Broker PAN number for tax purposes';

-- Display confirmation message
SELECT 'Bank details columns added successfully to users table' AS Status;

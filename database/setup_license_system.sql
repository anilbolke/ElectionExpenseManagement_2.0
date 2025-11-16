-- ========================================
-- LICENSE SYSTEM SETUP
-- Election Expense Management System
-- Author: Shree IT Solutions, Nanded
-- Date: 2025-11-16
-- ========================================

USE election_expense_db;

-- Drop existing table if exists (CAUTION: This will delete all existing licenses)
-- Comment out the next line if you want to preserve existing data
-- DROP TABLE IF EXISTS licenses;

-- Create licenses table
CREATE TABLE IF NOT EXISTS licenses (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    license_key VARCHAR(20) UNIQUE NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    mapped_user_id INT NULL,
    mapped_candidate_id INT NULL,
    generated_by INT NOT NULL,
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used_date TIMESTAMP NULL,
    status ENUM('active', 'used', 'expired') DEFAULT 'active',
    notes TEXT,
    FOREIGN KEY (mapped_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (mapped_candidate_id) REFERENCES candidates(candidate_id) ON DELETE SET NULL,
    FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_license_key (license_key),
    INDEX idx_status (status),
    INDEX idx_mapped_user (mapped_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create composite index for faster lookup
CREATE INDEX idx_license_status ON licenses(license_key, status);

-- Verify table creation
SELECT 
    'Licenses table created successfully!' as Status,
    COUNT(*) as 'Current License Count'
FROM licenses;

-- Display table structure
DESCRIBE licenses;

-- Optional: Insert test licenses (comment out if not needed)
-- INSERT INTO licenses (license_key, generated_by, status) 
-- VALUES 
--     ('EMS10001', 1, 'active'),
--     ('EMS10002', 1, 'active'),
--     ('EMS10003', 1, 'active'),
--     ('EMS10004', 1, 'active'),
--     ('EMS10005', 1, 'active');

-- Display success message
SELECT '✓ License System Setup Complete!' as Message;
SELECT 'You can now generate licenses from Admin Dashboard → Manage Licenses' as 'Next Steps';

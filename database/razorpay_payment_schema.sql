-- ================================================================
-- Razorpay Payment Integration - Database Schema Updates
-- ================================================================
-- This script adds Razorpay-specific columns to the payments table
-- Run this script before using Razorpay integration
-- ================================================================

-- Add Razorpay columns to payments table
ALTER TABLE payments 
ADD COLUMN razorpay_order_id VARCHAR(255) COMMENT 'Razorpay Order ID (starts with order_)',
ADD COLUMN razorpay_payment_id VARCHAR(255) COMMENT 'Razorpay Payment ID (starts with pay_)',
ADD COLUMN razorpay_signature VARCHAR(512) COMMENT 'Razorpay Payment Signature for verification';

-- Add indexes for faster lookups
CREATE INDEX idx_razorpay_order_id ON payments(razorpay_order_id);
CREATE INDEX idx_razorpay_payment_id ON payments(razorpay_payment_id);
CREATE INDEX idx_payment_status ON payments(payment_status);

-- Optional: Create payment_logs table for audit trail
CREATE TABLE IF NOT EXISTS payment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    user_id INT,
    action VARCHAR(100) COMMENT 'Action: created, verified, failed, refunded',
    razorpay_order_id VARCHAR(255),
    razorpay_payment_id VARCHAR(255),
    amount DECIMAL(10, 2),
    status VARCHAR(50),
    error_message TEXT,
    request_data TEXT COMMENT 'JSON data of request',
    response_data TEXT COMMENT 'JSON data of response',
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_payment_id (payment_id),
    INDEX idx_user_id (user_id),
    INDEX idx_razorpay_order_id (razorpay_order_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Payment transaction audit log';

-- Optional: Create refunds table
CREATE TABLE IF NOT EXISTS payment_refunds (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    razorpay_payment_id VARCHAR(255),
    razorpay_refund_id VARCHAR(255) COMMENT 'Razorpay Refund ID (starts with rfnd_)',
    refund_amount DECIMAL(10, 2) NOT NULL,
    refund_reason VARCHAR(255),
    refund_status VARCHAR(50) DEFAULT 'pending' COMMENT 'pending, processed, failed',
    refunded_by INT COMMENT 'User ID who initiated refund',
    refund_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_date TIMESTAMP NULL,
    remarks TEXT,
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE,
    INDEX idx_payment_id (payment_id),
    INDEX idx_razorpay_refund_id (razorpay_refund_id),
    INDEX idx_refund_status (refund_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Payment refunds tracking';

-- ================================================================
-- Sample queries for testing
-- ================================================================

-- Query to check successful payments
-- SELECT * FROM payments WHERE payment_status = 'success' AND razorpay_payment_id IS NOT NULL;

-- Query to check failed payments
-- SELECT * FROM payments WHERE payment_status = 'failed' ORDER BY payment_date DESC;

-- Query to get payment summary by status
-- SELECT payment_status, COUNT(*) as count, SUM(amount) as total_amount 
-- FROM payments 
-- GROUP BY payment_status;

-- Query to get recent payments
-- SELECT p.payment_id, p.transaction_id, p.razorpay_payment_id, p.amount, 
--        p.payment_status, p.payment_date, u.full_name, u.email
-- FROM payments p
-- JOIN users u ON p.candidate_id = u.user_id
-- ORDER BY p.payment_date DESC
-- LIMIT 20;

-- ================================================================
-- Rollback script (use with caution)
-- ================================================================

-- To remove Razorpay columns (only if needed):
-- ALTER TABLE payments 
-- DROP COLUMN razorpay_order_id,
-- DROP COLUMN razorpay_payment_id,
-- DROP COLUMN razorpay_signature;

-- To drop audit tables:
-- DROP TABLE IF EXISTS payment_refunds;
-- DROP TABLE IF EXISTS payment_logs;

-- ================================================================
-- End of script
-- ================================================================

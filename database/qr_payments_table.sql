-- QR Code Payments Table
-- Stores QR code payment submissions for manual verification

CREATE TABLE IF NOT EXISTS qr_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    candidate_id INT NULL,
    payment_type VARCHAR(50) NOT NULL, -- 'subscription' or 'candidate_registration'
    plan_name VARCHAR(100) NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    payment_method VARCHAR(50) DEFAULT 'QR Code',
    screenshot_path VARCHAR(255) NULL,
    payment_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'verified', 'rejected'
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_date TIMESTAMP NULL,
    verified_by INT NULL,
    admin_notes TEXT NULL,
    terms_accepted BOOLEAN DEFAULT FALSE,
    terms_version VARCHAR(20) NULL,
    terms_timestamp TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE SET NULL,
    FOREIGN KEY (verified_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_candidate_id (candidate_id),
    INDEX idx_payment_status (payment_status),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_submitted_date (submitted_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add comment to table
ALTER TABLE qr_payments COMMENT = 'Stores QR code payment submissions pending manual verification';

-- Sample query to check pending payments
-- SELECT qp.*, u.full_name, u.email 
-- FROM qr_payments qp 
-- JOIN users u ON qp.user_id = u.user_id 
-- WHERE qp.payment_status = 'pending' 
-- ORDER BY qp.submitted_date DESC;

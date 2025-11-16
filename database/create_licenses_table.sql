-- License Management System
-- Licenses to bypass payment process
-- Author: System Generated
-- Date: 2025-11-16

USE election_expense_db;

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

-- Add index for faster lookup
CREATE INDEX idx_license_status ON licenses(license_key, status);

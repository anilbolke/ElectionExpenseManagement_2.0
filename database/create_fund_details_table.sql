-- Create Fund Details Table
CREATE TABLE IF NOT EXISTS fund_details (
    fund_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id INT NOT NULL,
    user_id INT NOT NULL,
    fund_date DATE NOT NULL,
    fund_type VARCHAR(50) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    funder_name VARCHAR(100) NOT NULL,
    funder_mobile VARCHAR(15) NOT NULL,
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_candidate_id (candidate_id),
    INDEX idx_user_id (user_id),
    INDEX idx_fund_date (fund_date),
    INDEX idx_fund_type (fund_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add some sample fund types as reference
-- Fund Types:
-- 1. Cash in Hand
-- 2. Bank Balance
-- 3. Hand Loan
-- 4. Donation
-- 5. Other

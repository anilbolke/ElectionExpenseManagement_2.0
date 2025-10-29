-- Add Broker Transactions Table
-- Run this after add_subscription_tables.sql

USE election_expense_db;

-- Broker Transactions Table (for tracking broker commissions and sales)
CREATE TABLE IF NOT EXISTS broker_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    broker_id INT NOT NULL,
    candidate_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    commission_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    commission_percentage DECIMAL(5, 2) DEFAULT 10.00,
    payment_status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    payment_mode VARCHAR(50) DEFAULT 'cash',
    transaction_reference VARCHAR(100),
    remarks TEXT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (broker_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_broker_transactions ON broker_transactions(broker_id, payment_status);
CREATE INDEX idx_candidate_transactions ON broker_transactions(candidate_id);
CREATE INDEX idx_transaction_date ON broker_transactions(transaction_date);

-- Show the changes
SELECT 'Broker transactions table created successfully!' AS Status;
DESCRIBE broker_transactions;

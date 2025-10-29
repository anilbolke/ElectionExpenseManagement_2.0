-- Add Subscription/Payment Feature to Election Expense Management System
-- Run this after the main schema.sql

USE election_expense_db;

-- Add subscription fields to users table
ALTER TABLE users 
ADD COLUMN subscription_status ENUM('pending', 'active', 'expired') DEFAULT 'pending' AFTER status,
ADD COLUMN subscription_start_date DATETIME NULL,
ADD COLUMN subscription_end_date DATETIME NULL,
ADD COLUMN payment_status ENUM('unpaid', 'paid', 'pending') DEFAULT 'unpaid';

-- User Subscriptions/Payments Table
CREATE TABLE IF NOT EXISTS user_subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL DEFAULT 'Basic',
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    subscription_start_date DATETIME,
    subscription_end_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Subscription Plans Table
CREATE TABLE IF NOT EXISTS subscription_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL UNIQUE,
    plan_description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    features TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Default Subscription Plans
INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, features) VALUES
('Basic', 'Monthly subscription for basic expense management', 500.00, 30, 'Add unlimited expenses, Upload receipts, View expense history, Generate reports'),
('Quarterly', 'Quarterly subscription with 10% discount', 1350.00, 90, 'All Basic features, Priority support, Advanced analytics'),
('Annual', 'Annual subscription with 20% discount', 4800.00, 365, 'All features, Premium support, Custom reports, API access');

-- Payment History Table (for tracking all payment attempts)
CREATE TABLE IF NOT EXISTS payment_history (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    subscription_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES user_subscriptions(subscription_id) ON DELETE SET NULL
);

-- Update existing admin and test users to have active subscription
UPDATE users 
SET subscription_status = 'active', 
    subscription_start_date = NOW(), 
    subscription_end_date = DATE_ADD(NOW(), INTERVAL 365 DAY),
    payment_status = 'paid'
WHERE role = 'admin';

-- Create indexes for better performance
CREATE INDEX idx_user_subscription ON users(user_id, subscription_status);
CREATE INDEX idx_subscription_dates ON user_subscriptions(subscription_start_date, subscription_end_date);
CREATE INDEX idx_payment_status ON payment_history(payment_status, payment_date);

-- Show the changes
SELECT 'Subscription tables created successfully!' AS Status;
DESCRIBE users;

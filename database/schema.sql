-- Election Expense Management Database Schema
-- Author: System Generated
-- Date: 2025

CREATE DATABASE IF NOT EXISTS election_expense_db;
USE election_expense_db;

-- Users Table (Admin, User, Broker)
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    role ENUM('admin', 'user', 'broker') NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Candidates Table (for broker's tracking)
CREATE TABLE IF NOT EXISTS candidates (
    candidate_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_name VARCHAR(100) NOT NULL,
    party_name VARCHAR(100),
    constituency VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    broker_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (broker_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Products Table (items sold to candidates)
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    product_description TEXT,
    unit_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Broker Transactions (Products sold to candidates)
CREATE TABLE IF NOT EXISTS broker_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    broker_id INT NOT NULL,
    candidate_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('pending', 'partial', 'completed') DEFAULT 'pending',
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_date TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (broker_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Expenses Table (User's expense tracking)
CREATE TABLE IF NOT EXISTS expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    expense_category VARCHAR(50) NOT NULL,
    expense_description TEXT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expense_date DATE NOT NULL,
    receipt_file VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Expense Categories Table
CREATE TABLE IF NOT EXISTS expense_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Activity Logs Table
CREATE TABLE IF NOT EXISTS activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, email, full_name, role) 
VALUES ('admin', 'admin123', 'admin@election.com', 'System Administrator', 'admin');

-- Insert default expense categories
INSERT INTO expense_categories (category_name, description) VALUES
('Campaign Materials', 'Posters, banners, pamphlets'),
('Transportation', 'Vehicle expenses, fuel'),
('Venue Rental', 'Meeting halls, event spaces'),
('Advertising', 'Media and online ads'),
('Staff Salaries', 'Campaign team salaries'),
('Food & Beverages', 'Meeting refreshments'),
('Printing', 'Printing services'),
('Miscellaneous', 'Other expenses');

-- Insert sample products
INSERT INTO products (product_name, product_description, unit_price) VALUES
('Campaign Poster (A3)', 'High quality campaign poster', 50.00),
('Banner (10x5 ft)', 'Vinyl banner for outdoor use', 500.00),
('Pamphlet (100 units)', 'Information pamphlets', 200.00),
('T-Shirt', 'Campaign branded t-shirt', 150.00),
('Cap', 'Campaign branded cap', 100.00),
('Sticker (100 units)', 'Campaign stickers', 100.00);

-- Create Views for easy data access
CREATE OR REPLACE VIEW vw_user_expenses AS
SELECT 
    e.expense_id,
    e.user_id,
    u.full_name AS user_name,
    u.username,
    e.expense_category,
    e.expense_description,
    e.amount,
    e.expense_date,
    e.receipt_file,
    e.created_at
FROM expenses e
JOIN users u ON e.user_id = u.user_id;

CREATE OR REPLACE VIEW vw_broker_sales AS
SELECT 
    bt.transaction_id,
    u.full_name AS broker_name,
    c.candidate_name,
    c.party_name,
    p.product_name,
    bt.quantity,
    bt.total_amount,
    bt.payment_status,
    bt.paid_amount,
    bt.transaction_date,
    bt.payment_date
FROM broker_transactions bt
JOIN users u ON bt.broker_id = u.user_id
JOIN candidates c ON bt.candidate_id = c.candidate_id
JOIN products p ON bt.product_id = p.product_id;

-- Stored Procedure for generating expense reports
DELIMITER //
CREATE PROCEDURE sp_get_expense_report(
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_user_id INT
)
BEGIN
    SELECT 
        expense_category,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount,
        AVG(amount) AS average_amount
    FROM expenses
    WHERE expense_date BETWEEN p_start_date AND p_end_date
    AND (p_user_id IS NULL OR user_id = p_user_id)
    GROUP BY expense_category
    ORDER BY total_amount DESC;
END //
DELIMITER ;

-- Stored Procedure for broker payment summary
DELIMITER //
CREATE PROCEDURE sp_broker_payment_summary(IN p_broker_id INT)
BEGIN
    SELECT 
        c.candidate_name,
        COUNT(bt.transaction_id) AS total_transactions,
        SUM(bt.total_amount) AS total_amount,
        SUM(bt.paid_amount) AS paid_amount,
        SUM(bt.total_amount - bt.paid_amount) AS pending_amount,
        CASE 
            WHEN SUM(bt.total_amount - bt.paid_amount) = 0 THEN 'Fully Paid'
            WHEN SUM(bt.paid_amount) > 0 THEN 'Partial Payment'
            ELSE 'No Payment'
        END AS payment_status
    FROM broker_transactions bt
    JOIN candidates c ON bt.candidate_id = c.candidate_id
    WHERE bt.broker_id = p_broker_id
    GROUP BY c.candidate_name, c.candidate_id
    ORDER BY pending_amount DESC;
END //
DELIMITER ;

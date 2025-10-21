-- Enhanced Election Expense Management Database Schema
-- Updated with detailed candidate information and election program details
-- Date: 2025

USE election_expense_db;

-- Drop existing users table and recreate with enhanced fields
DROP TABLE IF EXISTS activity_logs;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS broker_transactions;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS user_subscriptions;
DROP TABLE IF EXISTS payment_history;
DROP TABLE IF EXISTS users;

-- Enhanced Users Table (Candidate/User with detailed information)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- Basic Authentication
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    
    -- Personal Information
    full_name VARCHAR(100) NOT NULL,
    father_husband_name VARCHAR(100),
    date_of_birth DATE,
    age INT,
    gender ENUM('Male', 'Female', 'Other'),
    
    -- Address Information
    address_line1 VARCHAR(200),
    address_line2 VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    
    -- Election Information (for candidates)
    constituency VARCHAR(100),
    assembly_number VARCHAR(50),
    party_name VARCHAR(100),
    party_symbol VARCHAR(100),
    election_type ENUM('Assembly', 'Lok Sabha', 'Municipal', 'Panchayat', 'Other'),
    election_year VARCHAR(10),
    
    -- Election Program Details
    election_slogan VARCHAR(255),
    manifesto_summary TEXT,
    key_promises TEXT, -- JSON format: ["Promise 1", "Promise 2"]
    target_areas TEXT, -- Areas/Villages to cover
    
    -- Campaign Details
    campaign_budget DECIMAL(12, 2),
    expense_limit DECIMAL(12, 2),
    campaign_manager_name VARCHAR(100),
    campaign_manager_contact VARCHAR(15),
    
    -- Social Media & Communication
    facebook_url VARCHAR(255),
    twitter_url VARCHAR(255),
    instagram_url VARCHAR(255),
    website_url VARCHAR(255),
    whatsapp_number VARCHAR(15),
    
    -- Documents
    photo_url VARCHAR(255),
    id_proof_type VARCHAR(50), -- Aadhar, PAN, Voter ID
    id_proof_number VARCHAR(50),
    id_proof_document VARCHAR(255),
    affidavit_document VARCHAR(255),
    
    -- User Role and Status
    role ENUM('admin', 'user', 'broker') NOT NULL DEFAULT 'user',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    account_type ENUM('candidate', 'supporter', 'broker') DEFAULT 'candidate',
    
    -- Subscription and Payment
    subscription_status ENUM('pending', 'active', 'expired') DEFAULT 'pending',
    subscription_start_date DATETIME NULL,
    subscription_end_date DATETIME NULL,
    payment_status ENUM('unpaid', 'paid', 'pending') DEFAULT 'unpaid',
    subscription_plan_id INT NULL,
    
    -- Broker Information (if role is broker)
    broker_firm_name VARCHAR(100),
    broker_gst_number VARCHAR(20),
    broker_commission_rate DECIMAL(5, 2),
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    
    -- Profile Completion
    profile_completed BOOLEAN DEFAULT FALSE,
    profile_completion_percentage INT DEFAULT 20,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_subscription (subscription_status),
    INDEX idx_constituency (constituency)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Subscription Plans Table
CREATE TABLE subscription_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL,
    plan_description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    features TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    discount_percentage DECIMAL(5, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- User Subscriptions Table
CREATE TABLE user_subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    status ENUM('active', 'expired', 'cancelled') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payment History Table
CREATE TABLE payment_history (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    subscription_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100) UNIQUE,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_gateway VARCHAR(50),
    payment_details TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES user_subscriptions(subscription_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Expenses Table (Candidate's expense tracking)
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    expense_category VARCHAR(50) NOT NULL,
    expense_subcategory VARCHAR(50),
    expense_description TEXT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expense_date DATE NOT NULL,
    payment_mode ENUM('Cash', 'Cheque', 'Online Transfer', 'UPI', 'Card') DEFAULT 'Cash',
    vendor_name VARCHAR(100),
    vendor_contact VARCHAR(15),
    bill_number VARCHAR(50),
    receipt_file VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE,
    verified_by INT NULL,
    verified_date DATETIME NULL,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_expense_date (expense_date),
    INDEX idx_category (expense_category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Expense Categories Table
CREATE TABLE expense_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    budget_limit DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Products Table (for broker sales)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50),
    product_description TEXT,
    unit_price DECIMAL(10, 2) NOT NULL,
    unit_type VARCHAR(20), -- piece, kg, meter, etc.
    stock_quantity INT DEFAULT 0,
    product_image VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Broker Sales/Transactions (Products sold to candidates by brokers)
CREATE TABLE broker_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    broker_id INT NOT NULL,
    candidate_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    final_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('pending', 'partial', 'completed') DEFAULT 'pending',
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    balance_amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_date DATETIME NULL,
    payment_due_date DATE NULL,
    delivery_status ENUM('pending', 'dispatched', 'delivered') DEFAULT 'pending',
    delivery_date DATETIME NULL,
    invoice_number VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (broker_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    INDEX idx_broker (broker_id),
    INDEX idx_candidate (candidate_id),
    INDEX idx_payment_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Activity Logs Table
CREATE TABLE activity_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_action (action_type),
    INDEX idx_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Notifications Table
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'warning', 'success', 'error') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    link_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_unread (user_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Default Admin User
INSERT INTO users (username, password, email, mobile, full_name, role, status, profile_completed, subscription_status, payment_status) 
VALUES ('admin', 'admin123', 'admin@election.com', '9999999999', 'System Administrator', 'admin', 'active', TRUE, 'active', 'paid');

-- Insert Subscription Plans
INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, features, display_order, discount_percentage) VALUES
('Basic Monthly', 'Perfect for local election candidates', 500.00, 30, 
'{"features": ["Add unlimited expenses", "Upload receipts", "Basic reports", "Email support"]}', 
1, 0.00),
('Quarterly Plan', 'Most popular for assembly elections', 1350.00, 90, 
'{"features": ["All Basic features", "Advanced analytics", "Priority support", "Export to PDF/Excel", "Expense limits tracking"]}', 
2, 10.00),
('Annual Plan', 'Best value for long-term campaigns', 4800.00, 365, 
'{"features": ["All features", "Premium support", "Custom reports", "API access", "Dedicated account manager", "Campaign insights"]}', 
3, 20.00);

-- Insert Default Expense Categories
INSERT INTO expense_categories (category_name, description, icon, budget_limit, display_order) VALUES
('Campaign Materials', 'Posters, banners, pamphlets, flex boards', 'fas fa-scroll', 50000.00, 1),
('Transportation', 'Vehicle expenses, fuel, driver charges', 'fas fa-car', 30000.00, 2),
('Venue Rental', 'Meeting halls, event spaces, stage setup', 'fas fa-building', 20000.00, 3),
('Advertising', 'Media ads, newspaper, TV, radio, online', 'fas fa-ad', 100000.00, 4),
('Staff Salaries', 'Campaign team, volunteers stipend', 'fas fa-users', 40000.00, 5),
('Food & Beverages', 'Meeting refreshments, volunteer meals', 'fas fa-utensils', 25000.00, 6),
('Printing', 'Printing services, photocopy', 'fas fa-print', 15000.00, 7),
('Sound System', 'PA system, DJ, music', 'fas fa-volume-up', 10000.00, 8),
('Photography', 'Photo/video coverage', 'fas fa-camera', 8000.00, 9),
('Miscellaneous', 'Other campaign expenses', 'fas fa-ellipsis-h', 20000.00, 10);

-- Insert Sample Products for Brokers
INSERT INTO products (product_name, product_category, product_description, unit_price, unit_type, stock_quantity) VALUES
('Campaign Poster A3', 'Printing', 'High quality glossy poster with candidate photo', 50.00, 'piece', 1000),
('Vinyl Banner 10x5 ft', 'Printing', 'Weather resistant outdoor banner', 500.00, 'piece', 100),
('Pamphlet Full Color', 'Printing', 'Information pamphlet with manifesto', 2.00, 'piece', 10000),
('Campaign T-Shirt', 'Merchandise', 'Cotton t-shirt with party logo', 150.00, 'piece', 500),
('Campaign Cap', 'Merchandise', 'Adjustable cap with embroidered logo', 100.00, 'piece', 300),
('Sticker Roll', 'Merchandise', 'Waterproof stickers (100 pcs)', 100.00, 'roll', 200),
('Flag Large', 'Campaign Materials', 'Party flag 4x6 ft', 200.00, 'piece', 150),
('Badge/Pin', 'Merchandise', 'Metal pin badge with photo', 25.00, 'piece', 2000),
('Hand Fan', 'Merchandise', 'Plastic hand fan with candidate photo', 15.00, 'piece', 5000),
('LED Torch', 'Merchandise', 'Branded LED torch', 80.00, 'piece', 300);

-- Create Views for Easy Data Access
CREATE OR REPLACE VIEW vw_active_candidates AS
SELECT 
    user_id, username, full_name, email, mobile,
    constituency, party_name, election_type,
    subscription_status, subscription_end_date, payment_status,
    created_at
FROM users
WHERE role = 'user' AND status = 'active' AND account_type = 'candidate';

CREATE OR REPLACE VIEW vw_user_expenses_summary AS
SELECT 
    u.user_id,
    u.full_name AS candidate_name,
    u.constituency,
    u.campaign_budget,
    u.expense_limit,
    COUNT(e.expense_id) AS total_expenses,
    SUM(e.amount) AS total_spent,
    (u.expense_limit - IFNULL(SUM(e.amount), 0)) AS balance_amount,
    ROUND((IFNULL(SUM(e.amount), 0) / u.expense_limit * 100), 2) AS budget_used_percentage
FROM users u
LEFT JOIN expenses e ON u.user_id = e.user_id
WHERE u.role = 'user' AND u.account_type = 'candidate'
GROUP BY u.user_id;

CREATE OR REPLACE VIEW vw_broker_sales_summary AS
SELECT 
    u.user_id AS broker_id,
    u.full_name AS broker_name,
    u.broker_firm_name,
    COUNT(DISTINCT bt.candidate_id) AS total_customers,
    COUNT(bt.transaction_id) AS total_transactions,
    SUM(bt.final_amount) AS total_sales,
    SUM(bt.paid_amount) AS total_received,
    SUM(bt.balance_amount) AS total_pending,
    ROUND((SUM(bt.paid_amount) / SUM(bt.final_amount) * 100), 2) AS collection_percentage
FROM users u
LEFT JOIN broker_transactions bt ON u.user_id = bt.broker_id
WHERE u.role = 'broker' AND u.status = 'active'
GROUP BY u.user_id;

-- Stored Procedures

-- Get Expense Report for a specific user/candidate
DELIMITER //
CREATE PROCEDURE sp_get_expense_report(
    IN p_user_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        e.expense_category,
        COUNT(e.expense_id) AS transaction_count,
        SUM(e.amount) AS total_amount,
        AVG(e.amount) AS average_amount,
        MIN(e.expense_date) AS first_expense_date,
        MAX(e.expense_date) AS last_expense_date
    FROM expenses e
    WHERE e.user_id = p_user_id
    AND e.expense_date BETWEEN p_start_date AND p_end_date
    GROUP BY e.expense_category
    ORDER BY total_amount DESC;
END //
DELIMITER ;

-- Get Broker Payment Summary
DELIMITER //
CREATE PROCEDURE sp_broker_payment_summary(IN p_broker_id INT)
BEGIN
    SELECT 
        c.user_id AS candidate_id,
        c.full_name AS candidate_name,
        c.mobile AS candidate_contact,
        c.constituency,
        COUNT(bt.transaction_id) AS total_transactions,
        SUM(bt.final_amount) AS total_amount,
        SUM(bt.paid_amount) AS paid_amount,
        SUM(bt.balance_amount) AS pending_amount,
        MAX(bt.transaction_date) AS last_transaction_date,
        CASE 
            WHEN SUM(bt.balance_amount) = 0 THEN 'Fully Paid'
            WHEN SUM(bt.paid_amount) > 0 THEN 'Partial Payment'
            ELSE 'No Payment'
        END AS overall_status
    FROM broker_transactions bt
    JOIN users c ON bt.candidate_id = c.user_id
    WHERE bt.broker_id = p_broker_id
    GROUP BY c.user_id, c.full_name, c.mobile, c.constituency
    ORDER BY pending_amount DESC;
END //
DELIMITER ;

-- Check Subscription Validity
DELIMITER //
CREATE PROCEDURE sp_check_subscription(IN p_user_id INT)
BEGIN
    DECLARE v_end_date DATETIME;
    DECLARE v_status VARCHAR(20);
    
    SELECT subscription_end_date, subscription_status 
    INTO v_end_date, v_status
    FROM users 
    WHERE user_id = p_user_id;
    
    IF v_end_date < NOW() AND v_status = 'active' THEN
        UPDATE users 
        SET subscription_status = 'expired' 
        WHERE user_id = p_user_id;
        
        INSERT INTO notifications (user_id, title, message, type)
        VALUES (p_user_id, 'Subscription Expired', 'Your subscription has expired. Please renew to continue.', 'warning');
    END IF;
    
    SELECT subscription_status FROM users WHERE user_id = p_user_id;
END //
DELIMITER ;

COMMIT;

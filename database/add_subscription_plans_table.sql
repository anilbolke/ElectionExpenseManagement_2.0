-- Subscription Plans Table
CREATE TABLE IF NOT EXISTS subscription_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(100) NOT NULL,
    plan_description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    plan_type VARCHAR(20) DEFAULT 'monthly', -- monthly, quarterly, yearly
    max_candidates INT DEFAULT 5,
    expense_tracking BOOLEAN DEFAULT TRUE,
    fund_management BOOLEAN DEFAULT TRUE,
    report_generation BOOLEAN DEFAULT FALSE,
    priority_support BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plan_active (is_active),
    INDEX idx_plan_type (plan_type)
);

-- Insert sample subscription plans
INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, plan_type, max_candidates, 
                                expense_tracking, fund_management, report_generation, priority_support, is_active) 
VALUES
('Basic Plan', 'Perfect for individual candidates with basic expense tracking', 999.00, 30, 'monthly', 1, 
 TRUE, TRUE, FALSE, FALSE, TRUE),
 
('Standard Plan', 'Ideal for candidates with multiple campaigns', 2499.00, 30, 'monthly', 5, 
 TRUE, TRUE, TRUE, FALSE, TRUE),
 
('Premium Plan', 'Complete solution with priority support', 4999.00, 30, 'monthly', 10, 
 TRUE, TRUE, TRUE, TRUE, TRUE),
 
('Quarterly Basic', 'Basic plan with 10% discount', 2697.00, 90, 'quarterly', 1, 
 TRUE, TRUE, FALSE, FALSE, TRUE),
 
('Quarterly Standard', 'Standard plan with 10% discount', 6747.00, 90, 'quarterly', 5, 
 TRUE, TRUE, TRUE, FALSE, TRUE),
 
('Quarterly Premium', 'Premium plan with 10% discount', 13497.00, 90, 'quarterly', 10, 
 TRUE, TRUE, TRUE, TRUE, TRUE),
 
('Yearly Basic', 'Basic plan with 20% savings', 9588.00, 365, 'yearly', 1, 
 TRUE, TRUE, FALSE, FALSE, TRUE),
 
('Yearly Standard', 'Standard plan with 20% savings', 23988.00, 365, 'yearly', 5, 
 TRUE, TRUE, TRUE, FALSE, TRUE),
 
('Yearly Premium', 'Premium plan with 20% savings', 47988.00, 365, 'yearly', 10, 
 TRUE, TRUE, TRUE, TRUE, TRUE);

-- Verify insertion
SELECT * FROM subscription_plans;

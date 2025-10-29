-- Create system_settings table to store configurable values
CREATE TABLE IF NOT EXISTS system_settings (
    setting_key VARCHAR(50) PRIMARY KEY,
    setting_value VARCHAR(255) NOT NULL,
    description TEXT,
    updated_by INT,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Insert default candidate registration fee
INSERT INTO system_settings (setting_key, setting_value, description) 
VALUES ('candidate_registration_fee', '5000.00', 'One-time candidate registration fee')
ON DUPLICATE KEY UPDATE setting_value = setting_value;

-- Verify
SELECT * FROM system_settings;

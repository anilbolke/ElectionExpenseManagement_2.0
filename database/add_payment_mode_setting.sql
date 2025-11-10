-- Add payment mode setting to system_settings table
-- This allows admin to toggle between Razorpay and QR Code payment methods

-- Insert or update payment_mode setting
INSERT INTO system_settings (setting_key, setting_value, description, updated_date) 
VALUES ('payment_mode', 'razorpay', 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE 
    description = 'Payment mode: razorpay (online gateway) or qrcode (manual QR payment)',
    updated_date = CURRENT_TIMESTAMP;

-- Verify the setting
SELECT * FROM system_settings WHERE setting_key = 'payment_mode';

-- To switch to QR Code mode, run:
-- UPDATE system_settings SET setting_value = 'qrcode' WHERE setting_key = 'payment_mode';

-- To switch back to Razorpay mode, run:
-- UPDATE system_settings SET setting_value = 'razorpay' WHERE setting_key = 'payment_mode';

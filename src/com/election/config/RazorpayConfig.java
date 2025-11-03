package com.election.config;

/**
 * Razorpay Configuration Class
 * Store your Razorpay API credentials here
 */
public class RazorpayConfig {
    
    // Replace these with your actual Razorpay credentials from Razorpay Dashboard
    // Get credentials from: https://dashboard.razorpay.com/app/keys
    
    // For Test Mode
    public static final String KEY_ID = "rzp_test_RZlIiUqLy86R7O";
    public static final String KEY_SECRET = "6elDjGLa3dtXePdqEJZBKavx";
    
    // For Live Mode (uncomment when going to production)
    // public static final String KEY_ID = "rzp_live_YOUR_KEY_ID";
    // public static final String KEY_SECRET = "YOUR_KEY_SECRET";
    
    // Currency
    public static final String CURRENCY = "INR";
    
    // Company Details (will appear on Razorpay checkout)
    public static final String COMPANY_NAME = "Election Expense Management";
    public static final String COMPANY_LOGO = ""; // URL to your company logo
    
    // Callback URLs
    public static final String SUCCESS_URL = "/user/payment-success.jsp";
    public static final String FAILURE_URL = "/user/payment-failure.jsp";
    
    // Webhook Secret (for payment verification)
    public static final String WEBHOOK_SECRET = "YOUR_WEBHOOK_SECRET";
    
    private RazorpayConfig() {
        // Private constructor to prevent instantiation
    }
}

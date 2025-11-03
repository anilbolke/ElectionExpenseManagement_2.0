package com.election.util;

public class RazorpayConfig {
    
    // Razorpay API credentials (should be stored in environment variables or secure config)
    private static final String KEY_ID = System.getenv("RAZORPAY_KEY_ID") != null ? 
                                         System.getenv("RAZORPAY_KEY_ID") : "rzp_test_YOUR_KEY_ID";
    
    private static final String KEY_SECRET = System.getenv("RAZORPAY_KEY_SECRET") != null ? 
                                             System.getenv("RAZORPAY_KEY_SECRET") : "YOUR_KEY_SECRET";
    
    // Currency
    public static final String CURRENCY = "INR";
    
    // Company details
    public static final String COMPANY_NAME = "Election Expense Management";
    public static final String COMPANY_LOGO = "https://via.placeholder.com/150?text=EMS";
    
    // Payment receipt prefix
    public static final String RECEIPT_PREFIX = "EMS_";
    
    public static String getKeyId() {
        return KEY_ID;
    }
    
    public static String getKeySecret() {
        return KEY_SECRET;
    }
    
    public static boolean isConfigured() {
        return !KEY_ID.equals("rzp_test_YOUR_KEY_ID") && !KEY_SECRET.equals("YOUR_KEY_SECRET");
    }
}

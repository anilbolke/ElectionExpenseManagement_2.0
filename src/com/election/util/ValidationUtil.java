package com.election.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    
    // Email validation
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return Pattern.matches(emailRegex, email);
    }

    // Mobile validation (Indian format)
    public static boolean isValidMobile(String mobile) {
        if (mobile == null || mobile.trim().isEmpty()) {
            return false;
        }
        String mobileRegex = "^[6-9]\\d{9}$";
        return Pattern.matches(mobileRegex, mobile);
    }

    // Aadhar validation
    public static boolean isValidAadhar(String aadhar) {
        if (aadhar == null || aadhar.trim().isEmpty()) {
            return false;
        }
        String aadharRegex = "^[0-9]{12}$";
        return Pattern.matches(aadharRegex, aadhar.replaceAll("\\s", ""));
    }

    // Pincode validation
    public static boolean isValidPincode(String pincode) {
        if (pincode == null || pincode.trim().isEmpty()) {
            return false;
        }
        String pincodeRegex = "^[1-9][0-9]{5}$";
        return Pattern.matches(pincodeRegex, pincode);
    }

    // Password strength validation
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        return true;
    }

    // Check if string is not empty
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    // Sanitize input to prevent SQL injection
    public static String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }
        return input.trim().replaceAll("[<>\"']", "");
    }
}

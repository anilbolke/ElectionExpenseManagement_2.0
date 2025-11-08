package com.election.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * SMS Utility Class for Election Expense Management System
 * 
 * Integrates with Shree IT SMS API to send notifications
 * Each SMS type uses a different DLT-approved template ID
 * 
 * Template IDs Configuration:
 * - Broker Registration: 1207176228666587519
 * - Forgot Password:     1207176228666587520
 * - Payment Success:     1207176228666587521
 * - Referral Mapping:    1207176228666587522
 * - General/Admin SMS:   1207176228666587519
 * 
 * Usage:
 * - SMSUtil.sendBrokerRegistrationSMS(mobile, name, code);
 * - SMSUtil.sendForgotPasswordSMS(mobile, username, password);
 * - SMSUtil.sendPaymentSuccessSMS(mobile, amount);
 * - SMSUtil.sendReferralMappedSMS(mobile, code, username);
 * - SMSUtil.sendSMS(mobile, message); // Uses general template
 * 
 * @author Shree IT Solutions
 * @version 2.0 - Template ID Support Added
 */
public class SMSUtil {
    
    // SMS API Configuration
    private static final String SMS_API_URL = "http://shreeitsms.in/REST/sendsms/";
    private static final String SMS_USER = "emsonline";
    private static final String SMS_PASSWORD = "8a65a0416eXX";
    private static final String SENDER_ID = "SRlTin";
    private static final String ENTITY_ID = "1201159170317412990";
    private static final String ACCOUNT_USAGE_TYPE_ID = "1";
    
    // Template IDs for different SMS types (DLT Approved)
    // Update these with your actual template IDs from SMS provider
    private static final String TEMPLATE_ID_BROKER_REGISTRATION = "1207176228666587519";
    private static final String TEMPLATE_ID_FORGOT_PASSWORD = "1207176228666587520";
    private static final String TEMPLATE_ID_PAYMENT_SUCCESS = "1207176228666587521";
    private static final String TEMPLATE_ID_REFERRAL_MAPPING = "1207176228666587522";
    private static final String TEMPLATE_ID_GENERAL = "1207176228666587519"; // Default template
    
    /**
     * Send single SMS with default template
     */
    public static boolean sendSMS(String mobile, String message) {
        return sendSMS(mobile, message, TEMPLATE_ID_GENERAL);
    }
    
    /**
     * Send single SMS with specific template ID
     */
    public static boolean sendSMS(String mobile, String message, String templateId) {
        List<SMSRequest> smsList = new ArrayList<>();
        smsList.add(new SMSRequest(mobile, message, templateId));
        return sendBulkSMS(smsList);
    }
    
    /**
     * Send bulk SMS
     */
    public static boolean sendBulkSMS(List<SMSRequest> smsRequests) {
        try {
            // Build JSON request
            JSONObject mainRequest = new JSONObject();
            mainRequest.put("user", SMS_USER);
            mainRequest.put("password", SMS_PASSWORD);
            
            JSONArray smsArray = new JSONArray();
            
            for (SMSRequest req : smsRequests) {
                JSONObject smsObj = new JSONObject();
                smsObj.put("sms", req.getMessage());
                smsObj.put("mobiles", formatMobile(req.getMobile()));
                smsObj.put("senderid", SENDER_ID);
                smsObj.put("clientsmsid", System.currentTimeMillis());
                smsObj.put("accountusagetypeid", ACCOUNT_USAGE_TYPE_ID);
                smsObj.put("entityid", ENTITY_ID);
                smsObj.put("tempid", req.getTemplateId() != null ? req.getTemplateId() : TEMPLATE_ID_GENERAL);
                smsArray.put(smsObj);
            }
            
            mainRequest.put("listsms", smsArray);
            
            // Send HTTP POST request
            URL url = new URL(SMS_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            
            // Write request
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = mainRequest.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            
            // Read response
            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();
            
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
            }
            
            // Log response for debugging
            System.out.println("SMS API Response Code: " + responseCode);
            System.out.println("SMS API Response: " + response.toString());
            
            // Parse response
            JSONObject jsonResponse = new JSONObject(response.toString());
            
            if (jsonResponse.has("smslist")) {
                JSONObject smslist = jsonResponse.getJSONObject("smslist");
                if (smslist.has("sms")) {
                    // Handle both single object and array responses
                    Object smsObj = smslist.get("sms");
                    
                    if (smsObj instanceof JSONArray) {
                        // Multiple SMS responses
                        JSONArray smsResponseArray = (JSONArray) smsObj;
                        for (int i = 0; i < smsResponseArray.length(); i++) {
                            JSONObject smsResponse = smsResponseArray.getJSONObject(i);
                            String status = smsResponse.optString("status", "");
                            if (!"success".equalsIgnoreCase(status)) {
                                System.err.println("SMS failed: " + smsResponse.toString());
                                return false;
                            }
                        }
                        return true;
                    } else if (smsObj instanceof JSONObject) {
                        // Single SMS response
                        JSONObject smsResponse = (JSONObject) smsObj;
                        String status = smsResponse.optString("status", "");
                        if (!"success".equalsIgnoreCase(status)) {
                            System.err.println("SMS failed: " + smsResponse.toString());
                            return false;
                        }
                        return true;
                    }
                }
            }
            
            return false;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Format mobile number with country code
     */
    private static String formatMobile(String mobile) {
        if (mobile == null || mobile.isEmpty()) {
            return mobile;
        }
        
        mobile = mobile.trim().replaceAll("[^0-9+]", "");
        
        if (mobile.startsWith("+91")) {
            return mobile;
        } else if (mobile.startsWith("91") && mobile.length() == 12) {
            return "+" + mobile;
        } else if (mobile.length() == 10) {
            return "+91" + mobile;
        }
        
        return mobile;
    }
    
    /**
     * Send Broker Registration SMS
     */
    public static boolean sendBrokerRegistrationSMS(String mobile, String brokerName, String referralCode) {
        String message = String.format(
            "Dear %s,\n" +
            "Your registration as a Broker for our Election Expense Mgmt Software is successful.\n" +
            "Your Code is: %s\n" +
            "Use this code for all sales to track commission accurately.\n" +
            "Start selling now!\n" +
            "EMSonline.in\n" +
            "Shree IT Solutions",
            brokerName, referralCode
        );
        
        return sendSMS(mobile, message, TEMPLATE_ID_BROKER_REGISTRATION);
    }
    
    /**
     * Send Forgot Password SMS
     */
    public static boolean sendForgotPasswordSMS(String mobile, String username, String password) {
        String message = String.format(
            "Dear User,\n" +
            "Your password for %s is %s\n" +
            "EMS Online\n" +
            "Shree IT Solutions",
            username, password
        );
        
        return sendSMS(mobile, message, TEMPLATE_ID_FORGOT_PASSWORD);
    }
    
    /**
     * Send Payment Success SMS
     */
    public static boolean sendPaymentSuccessSMS(String mobile, String amount) {
        String message = String.format(
            "Success!\n" +
            "Your payment of Rs.%s is successful. Subscription is confirmed.\n" +
            "Your service is now active!\n" +
            "Thank you for your purchase.\n" +
            "EMSOnline\n" +
            " Shree IT Solutions",
            amount
        );
        
        return sendSMS(mobile, message, TEMPLATE_ID_PAYMENT_SUCCESS);
    }
    
    /**
     * Send Referral Code Mapped SMS to Broker
     */
    public static boolean sendReferralMappedSMS(String brokerMobile, String referralCode, String username) {
        String message = String.format(
            "Congratulations!\n" +
            "Your referral code %s has been successfully applied to %s\n" +
            "Complete payment and start earning now!\n" +
            "EMSOnline\n" +
            "Shree IT Solutions",
            referralCode, username
        );
        
        return sendSMS(brokerMobile, message, TEMPLATE_ID_REFERRAL_MAPPING);
    }
    
    /**
     * SMS Request inner class
     */
    public static class SMSRequest {
        private String mobile;
        private String message;
        private String templateId;
        
        public SMSRequest(String mobile, String message) {
            this.mobile = mobile;
            this.message = message;
            this.templateId = TEMPLATE_ID_GENERAL;
        }
        
        public SMSRequest(String mobile, String message, String templateId) {
            this.mobile = mobile;
            this.message = message;
            this.templateId = templateId;
        }
        
        public String getMobile() {
            return mobile;
        }
        
        public String getMessage() {
            return message;
        }
        
        public String getTemplateId() {
            return templateId;
        }
    }
}

package com.election.debug;

import org.json.JSONObject;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.UUID;

/**
 * Small standalone utility to print the Razorpay order JSON payload that the servlet sends.
 * Run from the project root or inside Eclipse. Example args:
 *   100.00 Basic card 123 user@example.com
 */
public class RazorpayPayloadPrinter {
    public static void main(String[] args) {
        String amountStr = args.length > 0 ? args[0] : "100.00";
        String planName = args.length > 1 ? args[1] : "Basic";
        String paymentMethod = args.length > 2 ? args[2] : "card";
        String userId = args.length > 3 ? args[3] : "123";
        String userEmail = args.length > 4 ? args[4] : "user@example.com";

        try {
            BigDecimal amountBD = new BigDecimal(amountStr.trim()).setScale(2, RoundingMode.HALF_UP);
            if (amountBD.compareTo(new BigDecimal("1.00")) < 0) {
                System.err.println("Amount must be at least 1.00 INR");
                return;
            }
            int amountInPaise = amountBD.multiply(new BigDecimal(100)).intValue();

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise);
            orderRequest.put("currency", "INR");
            String receipt = "rcpt_" + UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
            orderRequest.put("receipt", receipt);
            orderRequest.put("payment_capture", 1);

            JSONObject notes = new JSONObject();
            notes.put("user_id", String.valueOf(userId));
            notes.put("user_email", userEmail != null ? userEmail : "");
            notes.put("plan_name", planName != null ? planName : "");
            notes.put("payment_method", paymentMethod != null ? paymentMethod : "");
            orderRequest.put("notes", notes);

            System.out.println(orderRequest.toString(2));
        } catch (Exception e) {
            System.err.println("Failed to build payload: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

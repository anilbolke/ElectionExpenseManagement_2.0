package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.dao.PaymentDAO;
import com.election.dao.SubscriptionDAO;
import com.election.model.Candidate;
import com.election.model.Payment;
import com.election.model.User;
import com.election.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.UUID;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * PaymentServlet handles Razorpay payment integration
 * Supports both subscription payments and candidate registration payments
 */
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private PaymentDAO paymentDAO;
    private SubscriptionDAO subscriptionDAO;
    private CandidateDAO candidateDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        paymentDAO = new PaymentDAO();
        subscriptionDAO = new SubscriptionDAO();
        candidateDAO = new CandidateDAO();
    }
    
    /**
     * Simple JSON builder to avoid external dependencies
     */
    private String buildJSON(String... keyValuePairs) {
        StringBuilder json = new StringBuilder("{");
        for (int i = 0; i < keyValuePairs.length; i += 2) {
            if (i > 0) json.append(",");
            json.append("\"").append(keyValuePairs[i]).append("\":");
            String value = keyValuePairs[i + 1];
            // Check if value is a number or boolean
            if (value.matches("-?\\d+(\\.\\d+)?") || value.equals("true") || value.equals("false")) {
                json.append(value);
            } else {
                json.append("\"").append(value).append("\"");
            }
        }
        json.append("}");
        return json.toString();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("config".equals(action)) {
            // Return Razorpay configuration
            sendRazorpayConfig(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("user/dashboard.jsp?error=Invalid action");
            return;
        }
        
        switch (action) {
            case "createOrder":
                createRazorpayOrder(request, response);
                break;
            case "verifyPayment":
                verifyPayment(request, response);
                break;
            case "processPayment":
                processPayment(request, response);
                break;
            default:
                response.sendRedirect("user/dashboard.jsp?error=Invalid action");
        }
    }
    
    /**
     * Send Razorpay configuration to frontend
     */
    private void sendRazorpayConfig(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String config = buildJSON(
            "keyId", RazorpayConfig.getKeyId(),
            "currency", RazorpayConfig.CURRENCY,
            "companyName", RazorpayConfig.COMPANY_NAME,
            "companyLogo", RazorpayConfig.COMPANY_LOGO,
            "configured", String.valueOf(RazorpayConfig.isConfigured())
        );
        
        response.getWriter().write(config);
    }
    
    /**
     * Create Razorpay order using actual Razorpay API
     */
    private void createRazorpayOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"User not authenticated\"}");
            return;
        }
        
        try {
            String amountStr = request.getParameter("amount");
            String paymentType = request.getParameter("paymentType"); // "subscription" or "candidate"
            String entityId = request.getParameter("entityId"); // plan name or candidate ID
            
            if (amountStr == null || paymentType == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(buildJSON("error", "Missing required parameters"));
                return;
            }
            
            double amount = Double.parseDouble(amountStr);
            int amountInPaise = (int) (amount * 100); // Convert to paise for Razorpay
            String receipt = RazorpayConfig.RECEIPT_PREFIX + System.currentTimeMillis();
            
            String orderId;
            
            // Create actual Razorpay order if configured
            if (RazorpayConfig.isConfigured()) {
                orderId = createRazorpayOrderViaAPI(amountInPaise, receipt);
                if (orderId == null) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write(buildJSON("error", "Failed to create Razorpay order"));
                    return;
                }
            } else {
                // Demo mode - create mock order
                orderId = "order_demo_" + System.currentTimeMillis();
            }
            
            // Store order details in session for verification
            session.setAttribute("pending_order_id", orderId);
            session.setAttribute("pending_amount", amount);
            session.setAttribute("pending_payment_type", paymentType);
            session.setAttribute("pending_entity_id", entityId);
            
            // Return order details
            response.setContentType("application/json");
            String orderResponse = buildJSON(
                "id", orderId,
                "amount", String.valueOf(amountInPaise),
                "currency", RazorpayConfig.CURRENCY,
                "receipt", receipt
            );
            
            response.getWriter().write(orderResponse);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(buildJSON("error", "Failed to create order: " + e.getMessage()));
        }
    }
    
    /**
     * Create order using Razorpay REST API
     */
    private String createRazorpayOrderViaAPI(int amountInPaise, String receipt) {
        try {
            URL url = new URL("https://api.razorpay.com/v1/orders");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            
            // Basic authentication
            String auth = RazorpayConfig.getKeyId() + ":" + RazorpayConfig.getKeySecret();
            String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            
            conn.setDoOutput(true);
            
            // Create JSON request body
            String jsonBody = buildJSON(
                "amount", String.valueOf(amountInPaise),
                "currency", RazorpayConfig.CURRENCY,
                "receipt", receipt
            );
            
            // Send request
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // Read response
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder responseStr = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseStr.append(responseLine.trim());
                    }
                    
                    // Parse order ID from response (simple JSON parsing)
                    String response = responseStr.toString();
                    int idIndex = response.indexOf("\"id\":\"");
                    if (idIndex != -1) {
                        int startIndex = idIndex + 6;
                        int endIndex = response.indexOf("\"", startIndex);
                        return response.substring(startIndex, endIndex);
                    }
                }
            } else {
                System.err.println("Razorpay API Error: " + responseCode);
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                    StringBuilder errorStr = new StringBuilder();
                    String errorLine;
                    while ((errorLine = br.readLine()) != null) {
                        errorStr.append(errorLine.trim());
                    }
                    System.err.println("Error details: " + errorStr.toString());
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Verify Razorpay payment signature
     */
    private void verifyPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(buildJSON("success", "false", "error", "User not authenticated"));
            return;
        }
        
        try {
            String razorpayOrderId = request.getParameter("razorpay_order_id");
            String razorpayPaymentId = request.getParameter("razorpay_payment_id");
            String razorpaySignature = request.getParameter("razorpay_signature");
            
            if (razorpayOrderId == null || razorpayPaymentId == null || razorpaySignature == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(buildJSON("success", "false", "error", "Missing payment parameters"));
                return;
            }
            
            // Verify signature
            boolean isValid = false;
            if (RazorpayConfig.isConfigured()) {
                isValid = verifyRazorpaySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature);
            } else {
                // Demo mode - assume valid
                isValid = razorpayOrderId.startsWith("order_demo_");
            }
            
            if (isValid) {
                // Retrieve pending order details
                String pendingOrderId = (String) session.getAttribute("pending_order_id");
                Double amount = (Double) session.getAttribute("pending_amount");
                String paymentType = (String) session.getAttribute("pending_payment_type");
                String entityId = (String) session.getAttribute("pending_entity_id");
                
                if (pendingOrderId == null || !pendingOrderId.equals(razorpayOrderId)) {
                    response.getWriter().write(buildJSON("success", "false", "error", "Order mismatch"));
                    return;
                }
                
                // Process payment based on type
                boolean success = false;
                if ("subscription".equals(paymentType)) {
                    success = processSubscriptionPayment(user, entityId, amount, razorpayPaymentId);
                } else if ("candidate".equals(paymentType)) {
                    success = processCandidatePayment(user, Integer.parseInt(entityId), amount, razorpayPaymentId);
                }
                
                // Clear pending order from session
                session.removeAttribute("pending_order_id");
                session.removeAttribute("pending_amount");
                session.removeAttribute("pending_payment_type");
                session.removeAttribute("pending_entity_id");
                
                // Store transaction details
                session.setAttribute("transactionId", razorpayPaymentId);
                session.setAttribute("paymentAmount", amount);
                
                response.setContentType("application/json");
                String result;
                if (success) {
                    String redirectUrl;
                    if ("subscription".equals(paymentType)) {
                        redirectUrl = request.getContextPath() + "/user/payment-success.jsp";
                    } else {
                        redirectUrl = request.getContextPath() + "/user/payment-success-candidate.jsp";
                    }
                    result = buildJSON(
                        "success", "true",
                        "paymentId", razorpayPaymentId,
                        "redirectUrl", redirectUrl
                    );
                } else {
                    result = buildJSON(
                        "success", "false",
                        "paymentId", razorpayPaymentId,
                        "error", "Failed to process payment"
                    );
                }
                
                response.getWriter().write(result);
                
            } else {
                response.getWriter().write(buildJSON("success", "false", "error", "Payment verification failed"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(buildJSON("success", "false", "error", e.getMessage()));
        }
    }
    
    /**
     * Verify Razorpay payment signature using HMAC SHA256
     */
    private boolean verifyRazorpaySignature(String orderId, String paymentId, String signature) {
        try {
            String payload = orderId + "|" + paymentId;
            String secret = RazorpayConfig.getKeySecret();
            
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKeySpec);
            
            byte[] hash = mac.doFinal(payload.getBytes(StandardCharsets.UTF_8));
            
            // Convert to hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            String generatedSignature = hexString.toString();
            return generatedSignature.equals(signature);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Legacy payment processing - DISABLED
     * This was a demo fallback that bypassed real payment processing
     * All payments must go through Razorpay createOrder -> verifyPayment flow
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String candidateIdStr = request.getParameter("candidateId");
        String planName = request.getParameter("planName");
        
        // Reject direct payment processing - force Razorpay integration
        String errorMsg = "Payment gateway not configured. Please set up Razorpay credentials: " +
                         "RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET environment variables. " +
                         "Contact administrator for assistance.";
        
        try {
            if (candidateIdStr != null) {
                response.sendRedirect("user/candidate-payment.jsp?candidateId=" + candidateIdStr + 
                    "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
            } else if (planName != null) {
                response.sendRedirect("user/subscription.jsp?error=" + 
                    java.net.URLEncoder.encode(errorMsg, "UTF-8"));
            } else {
                response.sendRedirect("user/dashboard.jsp?error=" + 
                    java.net.URLEncoder.encode(errorMsg, "UTF-8"));
            }
        } catch (Exception e) {
            response.sendRedirect("user/dashboard.jsp?error=Payment configuration error");
        }
    }
    
    /**
     * Process subscription payment
     */
    private boolean processSubscriptionPayment(User user, String planName, double amount, String transactionId) {
        try {
            // Update user subscription
            boolean subscriptionUpdated = subscriptionDAO.updateUserSubscription(
                user.getUserId(), 
                planName, 
                "active"
            );
            
            if (subscriptionUpdated) {
                // Record payment
                Payment payment = new Payment();
                payment.setCandidateId(0); // Not related to candidate
                payment.setBrokerId(user.getBrokerId() != null ? user.getBrokerId() : 0);
                payment.setPaymentType("subscription");
                payment.setAmount(BigDecimal.valueOf(amount));
                payment.setPaymentMethod("Razorpay");
                payment.setTransactionId(transactionId);
                payment.setPaymentStatus("success");
                payment.setRemarks("Subscription: " + planName);
                
                return paymentDAO.addPayment(payment);
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Process candidate registration payment
     */
    private boolean processCandidatePayment(User user, int candidateId, double amount, String transactionId) {
        try {
            Candidate candidate = candidateDAO.getCandidateById(candidateId);
            
            if (candidate == null || candidate.getUserId() != user.getUserId()) {
                return false;
            }
            
            // Update candidate payment status
            boolean paymentUpdated = candidateDAO.updatePaymentStatus(candidateId, "completed", transactionId);
            boolean verifyUpdated = candidateDAO.verifyPayment(candidateId, true);
            
            if (paymentUpdated && verifyUpdated) {
                // Record payment
                Payment payment = new Payment();
                payment.setCandidateId(candidateId);
                payment.setBrokerId(user.getBrokerId() != null ? user.getBrokerId() : 0);
                payment.setPaymentType("candidate_registration");
                payment.setAmount(BigDecimal.valueOf(amount));
                payment.setPaymentMethod("Razorpay");
                payment.setTransactionId(transactionId);
                payment.setPaymentStatus("success");
                payment.setRemarks("Candidate Registration: " + candidate.getCandidateName());
                
                return paymentDAO.addPayment(payment);
            }
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

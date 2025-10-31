package com.election.servlet;

import com.election.config.RazorpayConfig;
import com.election.dao.PaymentDAO;
import com.election.model.Candidate;
import com.election.model.Payment;
import com.election.model.User;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.UUID;

public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;
    private RazorpayClient razorpayClient;

    @Override
    public void init() throws ServletException {
        super.init();
        paymentDAO = new PaymentDAO();
        
        try {
            // Initialize Razorpay Client
            razorpayClient = new RazorpayClient(RazorpayConfig.KEY_ID, RazorpayConfig.KEY_SECRET);
        } catch (RazorpayException e) {
            throw new ServletException("Failed to initialize Razorpay client", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "createOrder";
        }
        
        switch (action) {
            case "config":
                sendConfigResponse(response);
                break;
            case "createOrder":
                createRazorpayOrder(request, response, user);
                break;
            case "verifyPayment":
                verifyRazorpayPayment(request, response, user);
                break;
            case "processPayment":
                // Legacy support - redirect to create order
                createRazorpayOrder(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/user/subscription.jsp");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("config".equals(action)) {
            sendConfigResponse(response);
            return;
        }
        
        doPost(request, response);
    }

    /**
     * Create Razorpay Order
     */
    private void createRazorpayOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Get payment details from request
            String planName = request.getParameter("planName");
            String paymentMethod = request.getParameter("paymentMethod");
            String amountStr = request.getParameter("amount");
            
            if (planName == null || amountStr == null || amountStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user/subscription.jsp?error=invalid_params");
                return;
            }
            
            // Parse amount using BigDecimal to avoid floating errors and convert to paise
            BigDecimal amountBD;
            try {
                amountBD = new BigDecimal(amountStr.trim()).setScale(2, RoundingMode.HALF_UP);
            } catch (NumberFormatException nfe) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JSONObject errorJson = new JSONObject();
                errorJson.put("success", false);
                errorJson.put("error", "Invalid amount format");
                response.getWriter().write(errorJson.toString());
                return;
            }

            if (amountBD.compareTo(BigDecimal.ZERO) <= 0) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JSONObject errorJson = new JSONObject();
                errorJson.put("success", false);
                errorJson.put("error", "Amount must be greater than zero");
                response.getWriter().write(errorJson.toString());
                return;
            }
            
            // Enforce a sensible minimum (Razorpay minimum is typically ₹1 => 100 paise)
            BigDecimal minimumAmount = new BigDecimal("1.00");
            if (amountBD.compareTo(minimumAmount) < 0) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JSONObject errorJson = new JSONObject();
                errorJson.put("success", false);
                errorJson.put("error", "Amount must be at least " + minimumAmount.toPlainString() + " INR");
                response.getWriter().write(errorJson.toString());
                return;
            }
            
            int amountInPaise = amountBD.multiply(new BigDecimal(100)).intValue();
            double amountInRupees = amountBD.doubleValue();
            
            // Create Razorpay Order
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise); // amount in paise
            orderRequest.put("currency", RazorpayConfig.CURRENCY);
            // Use a shorter unique receipt to avoid any length issues
            String receipt = "rcpt_" + UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
            orderRequest.put("receipt", receipt);
            // Ensure payment capture is enabled (1)
            orderRequest.put("payment_capture", 1);
            
            // Add notes for reference
            // Notes: ensure values are strings to avoid unexpected JSON types
            JSONObject notes = new JSONObject();
            notes.put("user_id", String.valueOf(user.getUserId()));
            notes.put("user_email", user.getEmail() != null ? user.getEmail() : "");
            notes.put("plan_name", planName != null ? planName : "");
            notes.put("payment_method", paymentMethod != null ? paymentMethod : "");
            orderRequest.put("notes", notes);
            
            // Create order using Razorpay API
            // Debug: log the outgoing request payload to help diagnose 400 Bad Request
            System.out.println("[DEBUG] Razorpay Order Request: " + orderRequest.toString());
            Order order = razorpayClient.orders.create(orderRequest);
            
            String orderId = order.get("id");
            String orderStatus = order.get("status");
            
            // Store order details in session for verification later (store paise as Integer)
            HttpSession session = request.getSession();
            session.setAttribute("razorpay_order_id", orderId);
            session.setAttribute("razorpay_amount", amountInPaise);
            session.setAttribute("plan_name", planName);
            session.setAttribute("payment_method", paymentMethod);
            
            // Send order details to frontend as JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            JSONObject responseJson = new JSONObject();
            responseJson.put("success", true);
            responseJson.put("order_id", orderId);
            responseJson.put("amount", amountInPaise);
            responseJson.put("currency", RazorpayConfig.CURRENCY);
            responseJson.put("key_id", RazorpayConfig.KEY_ID);
            responseJson.put("name", RazorpayConfig.COMPANY_NAME);
            responseJson.put("description", planName + " Plan Subscription");
            responseJson.put("prefill_name", user.getFullName());
            responseJson.put("prefill_email", user.getEmail());
            // User model exposes mobile instead of phone
            responseJson.put("prefill_contact", user.getMobile() != null ? user.getMobile() : "");
            
            response.getWriter().write(responseJson.toString());
            
        } catch (RazorpayException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            JSONObject errorJson = new JSONObject();
            // include the message returned by Razorpay to help debug 400 errors
            errorJson.put("success", false);
            // Include full exception string (message + class) to aid debugging in logs/frontend
            errorJson.put("error", "Failed to create Razorpay order: " + e.toString());
            // Try to extract JSON body from exception message if Razorpay SDK included it
            String exMsg = e.getMessage();
            if (exMsg != null) {
                int firstJson = exMsg.indexOf('{');
                int lastJson = exMsg.lastIndexOf('}');
                if (firstJson >= 0 && lastJson > firstJson) {
                    String jsonPart = exMsg.substring(firstJson, lastJson + 1);
                    try {
                        JSONObject razorpayError = new JSONObject(jsonPart);
                        errorJson.put("razorpay_error", razorpayError);
                    } catch (Exception parseEx) {
                        // Not JSON - include raw message
                        errorJson.put("razorpay_exception_message", exMsg);
                    }
                } else {
                    errorJson.put("razorpay_exception_message", exMsg);
                }
            }
             response.getWriter().write(errorJson.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            JSONObject errorJson = new JSONObject();
            errorJson.put("success", false);
            errorJson.put("error", "An error occurred: " + e.getMessage());
            response.getWriter().write(errorJson.toString());
        }
    }

    /**
     * Verify Razorpay Payment Signature
     */
    private void verifyRazorpayPayment(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            // Get payment details from request
            String razorpayOrderId = request.getParameter("razorpay_order_id");
            String razorpayPaymentId = request.getParameter("razorpay_payment_id");
            String razorpaySignature = request.getParameter("razorpay_signature");
            String candidateIdParam = request.getParameter("candidateId");
            
            // Get stored session data
            HttpSession session = request.getSession();
            String sessionOrderId = (String) session.getAttribute("razorpay_order_id");
            Integer amountPaise = (Integer) session.getAttribute("razorpay_amount");
            String planName = (String) session.getAttribute("plan_name");
            String paymentMethod = (String) session.getAttribute("payment_method");
            
            // Validate order ID
            if (razorpayOrderId == null || !razorpayOrderId.equals(sessionOrderId)) {
                throw new Exception("Order ID mismatch");
            }
            
            // Verify payment signature
            JSONObject options = new JSONObject();
            options.put("razorpay_order_id", razorpayOrderId);
            options.put("razorpay_payment_id", razorpayPaymentId);
            options.put("razorpay_signature", razorpaySignature);
            
            boolean isValidSignature = Utils.verifyPaymentSignature(options, RazorpayConfig.KEY_SECRET);
            
            if (isValidSignature) {
                // Validate candidate ID
                if (candidateIdParam == null || candidateIdParam.isEmpty()) {
                    throw new Exception("Candidate ID is missing");
                }
                
                int candidateId = Integer.parseInt(candidateIdParam);
                
                // Verify candidate exists and belongs to this user
                com.election.dao.CandidateDAO candidateDAO = new com.election.dao.CandidateDAO();
                com.election.model.Candidate candidate = candidateDAO.getCandidateById(candidateId);
                
                if (candidate == null) {
                    throw new Exception("Candidate not found");
                }
                
                if (candidate.getUserId() != user.getUserId()) {
                    throw new Exception("Unauthorized: Candidate does not belong to this user");
                }
                
                // Payment signature is valid - Save to database
                Payment payment = new Payment();
                payment.setCandidateId(candidateId); // Use actual candidate ID
                payment.setBrokerId(user.getUserId()); // user_id (reusing broker_id field in Payment model)
                payment.setPaymentType(planName + " Plan");
                // Convert paise back to rupees for storing amount
                BigDecimal paidAmount = new BigDecimal(amountPaise).divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
                payment.setAmount(new BigDecimal(paidAmount.toPlainString()));
                payment.setPaymentMethod(paymentMethod);
                payment.setTransactionId(razorpayPaymentId);
                payment.setRazorpayOrderId(razorpayOrderId);
                payment.setRazorpayPaymentId(razorpayPaymentId);
                payment.setRazorpaySignature(razorpaySignature);
                payment.setPaymentStatus("success");
                payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
                payment.setRemarks("Payment for " + planName + ". Order: " + razorpayOrderId);
                
                boolean saved = paymentDAO.addPayment(payment);
                
                if (saved) {
                    // Update candidate payment status
                    // Update payment-related fields
                    candidate.setPaymentVerified(true);
                    candidate.setAccountStatus("active");
                    candidate.setPaymentStatus("completed");
                    candidate.setTransactionId(razorpayPaymentId);
                    candidate.setPaymentDate(new Timestamp(System.currentTimeMillis()));
                    candidate.setPaymentMethod(paymentMethod);
                    candidate.setPaymentReference(razorpayOrderId);
                    candidate.setPaymentAmount(paidAmount);
                    
                    // Update candidate in database
                    boolean updated = candidateDAO.updatePaymentStatus(candidateId, "completed", razorpayPaymentId);
                    if (updated) {
                        System.out.println("✅ Candidate activated successfully: " + candidateId);
                        System.out.println("   - Payment Status: completed");
                        System.out.println("   - Account Status: active");
                        System.out.println("   - Transaction ID: " + razorpayPaymentId);
                        
                        // Update candidate in session if it's the selected one
                        Candidate sessionCandidate = (Candidate) session.getAttribute("candidate");
                        if (sessionCandidate != null && sessionCandidate.getCandidateId() == candidateId) {
                            session.setAttribute("candidate", candidate);
                        }
                        
                        // Clear payment session data only (keep user logged in)
                        session.removeAttribute("razorpay_order_id");
                        session.removeAttribute("razorpay_amount");
                        session.removeAttribute("plan_name");
                        session.removeAttribute("payment_method");
                        
                        // Send success response
                        response.setContentType("application/json");
                        JSONObject successJson = new JSONObject();
                        successJson.put("success", true);
                        successJson.put("message", "Payment successful and candidate activated");
                        successJson.put("redirect_url", request.getContextPath() + "/user/dashboard.jsp?success=Payment successful! Your candidate has been activated.");
                        response.getWriter().write(successJson.toString());
                    } else {
                        System.err.println("⚠️ Failed to update candidate payment status");
                        throw new Exception("Failed to update candidate status");
                    }
                } else {
                    throw new Exception("Failed to save payment to database");
                }
            } else {
                // Invalid signature
                throw new Exception("Invalid payment signature");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // Try to log failed payment attempt only if candidateId is valid
            String candidateIdParam = request.getParameter("candidateId");
            if (candidateIdParam != null && !candidateIdParam.isEmpty()) {
                try {
                    int candidateId = Integer.parseInt(candidateIdParam);
                    
                    // Verify candidate exists before logging
                    com.election.dao.CandidateDAO candidateDAO = new com.election.dao.CandidateDAO();
                    com.election.model.Candidate candidate = candidateDAO.getCandidateById(candidateId);
                    
                    if (candidate != null) {
                        String failedTransactionId = "FAILED_" + UUID.randomUUID().toString();
                        Payment failedPayment = new Payment();
                        failedPayment.setCandidateId(candidateId);
                        failedPayment.setBrokerId(user.getUserId());
                        failedPayment.setPaymentType("Failed Payment");
                        failedPayment.setAmount(new BigDecimal(0));
                        failedPayment.setPaymentMethod("Razorpay");
                        failedPayment.setTransactionId(failedTransactionId);
                        failedPayment.setPaymentStatus("failed");
                        failedPayment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
                        failedPayment.setRemarks("Payment verification failed: " + e.getMessage());
                        paymentDAO.addPayment(failedPayment);
                    }
                } catch (NumberFormatException nfe) {
                    System.err.println("Invalid candidate ID format: " + candidateIdParam);
                }
            }
            
            // Send error response
            response.setContentType("application/json");
            JSONObject errorJson = new JSONObject();
            errorJson.put("success", false);
            errorJson.put("error", "Payment verification failed: " + e.getMessage());
            errorJson.put("redirect_url", request.getContextPath() + RazorpayConfig.FAILURE_URL);
            response.getWriter().write(errorJson.toString());
        }
    }
    
    /**
     * Send configuration status as JSON
     */
    private void sendConfigResponse(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JSONObject config = new JSONObject();
        
        // Debug: Log what we're reading
        System.out.println("=== Razorpay Config Debug ===");
        System.out.println("KEY_ID: " + RazorpayConfig.KEY_ID);
        System.out.println("KEY_ID is null: " + (RazorpayConfig.KEY_ID == null));
        System.out.println("KEY_ID is empty: " + (RazorpayConfig.KEY_ID != null && RazorpayConfig.KEY_ID.isEmpty()));
        System.out.println("KEY_ID starts with rzp_: " + (RazorpayConfig.KEY_ID != null && RazorpayConfig.KEY_ID.startsWith("rzp_")));
        System.out.println("KEY_SECRET length: " + (RazorpayConfig.KEY_SECRET != null ? RazorpayConfig.KEY_SECRET.length() : 0));
        
        // Check if Razorpay keys are configured (not empty and start with rzp_)
        boolean isConfigured = RazorpayConfig.KEY_ID != null && 
                               !RazorpayConfig.KEY_ID.isEmpty() &&
                               RazorpayConfig.KEY_ID.startsWith("rzp_") &&
                               RazorpayConfig.KEY_SECRET != null &&
                               !RazorpayConfig.KEY_SECRET.isEmpty() &&
                               RazorpayConfig.KEY_SECRET.length() > 10;
        
        System.out.println("isConfigured: " + isConfigured);
        System.out.println("===========================");
        
        config.put("configured", isConfigured);
        config.put("key_id", RazorpayConfig.KEY_ID != null ? RazorpayConfig.KEY_ID : "null");
        config.put("key_secret_length", RazorpayConfig.KEY_SECRET != null ? RazorpayConfig.KEY_SECRET.length() : 0);
        config.put("currency", RazorpayConfig.CURRENCY);
        config.put("company_name", RazorpayConfig.COMPANY_NAME);
        
        // Add detailed debug info
        config.put("debug_key_id_null", RazorpayConfig.KEY_ID == null);
        config.put("debug_key_id_empty", RazorpayConfig.KEY_ID != null && RazorpayConfig.KEY_ID.isEmpty());
        config.put("debug_key_id_starts_rzp", RazorpayConfig.KEY_ID != null && RazorpayConfig.KEY_ID.startsWith("rzp_"));
        
        response.getWriter().write(config.toString());
    }
}

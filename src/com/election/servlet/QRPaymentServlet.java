package com.election.servlet;

import com.election.dao.QRPaymentDAO;
import com.election.dao.CandidateDAO;
import com.election.model.QRPayment;
import com.election.model.User;
import com.election.model.Candidate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/qrpayment")
public class QRPaymentServlet extends HttpServlet {
    
    private QRPaymentDAO qrPaymentDAO;
    private CandidateDAO candidateDAO;
    
    @Override
    public void init() throws ServletException {
        qrPaymentDAO = new QRPaymentDAO();
        candidateDAO = new CandidateDAO();
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
        
        if ("submitPayment".equals(action)) {
            handlePaymentSubmission(request, response, user);
        } else if ("verifyPayment".equals(action) && "admin".equals(user.getRole())) {
            handlePaymentVerification(request, response, user);
        } else if ("rejectPayment".equals(action) && "admin".equals(user.getRole())) {
            handlePaymentRejection(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
        }
    }
    
    /**
     * Handle QR payment submission from user
     */
    private void handlePaymentSubmission(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get form parameters
            String transactionId = request.getParameter("transactionId");
            String paymentType = request.getParameter("paymentType");
            String planName = request.getParameter("planName");
            String amountStr = request.getParameter("amount");
            String candidateIdStr = request.getParameter("candidateId");
            String termsVersion = request.getParameter("termsVersion");
            String termsTimestamp = request.getParameter("acceptedTimestamp");
            
            // Validate required fields
            if (transactionId == null || transactionId.trim().isEmpty()) {
                session.setAttribute("error", "Transaction ID is required");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            if (amountStr == null || amountStr.trim().isEmpty()) {
                session.setAttribute("error", "Amount is required");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            // Validate transaction ID format (basic validation)
            transactionId = transactionId.trim().toUpperCase();
            if (transactionId.length() < 6 || transactionId.length() > 50) {
                session.setAttribute("error", "Invalid transaction ID format. Must be between 6-50 characters.");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            // Check if transaction ID already exists
            if (qrPaymentDAO.transactionIdExists(transactionId)) {
                session.setAttribute("error", "This transaction ID has already been submitted. Please check your transaction history.");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
            double amount = Double.parseDouble(amountStr);
            
            // Create QRPayment object
            QRPayment payment = new QRPayment();
            payment.setUserId(user.getUserId());
            payment.setPaymentType(paymentType != null ? paymentType : "subscription");
            payment.setPlanName(planName);
            payment.setAmount(amount);
            payment.setTransactionId(transactionId);
            payment.setPaymentMethod("QR Code");
            payment.setTermsAccepted(true);
            payment.setTermsVersion(termsVersion);
            
            if (termsTimestamp != null && !termsTimestamp.isEmpty()) {
                payment.setTermsTimestamp(Timestamp.valueOf(termsTimestamp.replace("T", " ").replace("Z", "")));
            }
            
            // Handle candidate payment
            if (candidateIdStr != null && !candidateIdStr.trim().isEmpty()) {
                payment.setCandidateId(Integer.parseInt(candidateIdStr));
            }
            
            // Submit payment
            boolean success = qrPaymentDAO.submitPayment(payment);
            
            if (success) {
                System.out.println("QR Payment submitted successfully for user: " + user.getUserId());
                System.out.println("Transaction ID: " + transactionId);
                System.out.println("Payment Type: " + payment.getPaymentType());
                System.out.println("Candidate ID: " + payment.getCandidateId());
                
                session.setAttribute("paymentPending", true);
                session.setAttribute("message", "✓ Payment submitted successfully! Your transaction ID: " + transactionId + 
                    " is pending verification. You will be notified once the payment is verified by admin.");
                
                // Always redirect to dashboard for better UX
                String redirectUrl = request.getContextPath() + "/user/dashboard.jsp?paymentPending=true";
                
                if (payment.getCandidateId() != null) {
                    redirectUrl += "&candidatePayment=true";
                }
                
                System.out.println("Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
                return; // Important: prevent further processing
            } else {
                System.err.println("Failed to submit QR payment for user: " + user.getUserId());
                session.setAttribute("error", "Failed to submit payment. Please try again.");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }
            
        } catch (NumberFormatException e) {
            System.err.println("NumberFormatException in payment submission: " + e.getMessage());
            session.setAttribute("error", "Invalid amount format");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        } catch (Exception e) {
            System.err.println("Error in payment submission: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while processing your payment. Please try again.");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }
    }
    
    /**
     * Handle payment verification by admin
     */
    private void handlePaymentVerification(HttpServletRequest request, HttpServletResponse response, User admin) 
            throws ServletException, IOException {
        
        try {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            String notes = request.getParameter("notes");
            
            QRPayment payment = qrPaymentDAO.getPaymentById(paymentId);
            
            if (payment == null) {
                request.getSession().setAttribute("error", "Payment not found");
                response.sendRedirect(request.getContextPath() + "/admin/verify-qr-payments.jsp");
                return;
            }
            
            boolean success = qrPaymentDAO.verifyPayment(paymentId, admin.getUserId(), notes);
            
            if (success) {
                System.out.println("QR Payment #" + paymentId + " marked as verified in database");
                
                // Activate candidate if this was a candidate registration payment
                if (payment.getCandidateId() != null) {
                    System.out.println("Activating candidate ID: " + payment.getCandidateId());
                    
                    // Update payment status to 'completed'
                    boolean paymentStatusUpdated = candidateDAO.updatePaymentStatus(
                        payment.getCandidateId(), 
                        "completed", 
                        payment.getTransactionId()
                    );
                    
                    // Also verify payment (sets is_payment_verified = true and account_status = 'active')
                    boolean candidateActivated = candidateDAO.verifyPayment(payment.getCandidateId(), true);
                    
                    if (paymentStatusUpdated && candidateActivated) {
                        System.out.println("SUCCESS: Candidate " + payment.getCandidateId() + " activated with payment status 'completed'");
                        request.getSession().setAttribute("message", "Payment verified successfully! Candidate account has been activated.");
                    } else {
                        System.err.println("WARNING: QR payment verified but candidate activation may have failed");
                        request.getSession().setAttribute("message", "Payment verified but there may be an issue with candidate activation. Please check manually.");
                    }
                } else {
                    // Subscription payment
                    request.getSession().setAttribute("message", "Payment verified successfully!");
                }
            } else {
                request.getSession().setAttribute("error", "Failed to verify payment");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/verify-qr-payments.jsp");
            
        } catch (Exception e) {
            System.err.println("Error verifying payment: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred while verifying payment");
            response.sendRedirect(request.getContextPath() + "/admin/verify-qr-payments.jsp");
        }
    }
    
    /**
     * Handle payment rejection by admin
     */
    private void handlePaymentRejection(HttpServletRequest request, HttpServletResponse response, User admin) 
            throws ServletException, IOException {
        
        try {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            String notes = request.getParameter("notes");
            
            if (notes == null || notes.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Rejection reason is required");
                response.sendRedirect(request.getContextPath() + "/admin/verify-qr-payments.jsp");
                return;
            }
            
            boolean success = qrPaymentDAO.rejectPayment(paymentId, admin.getUserId(), notes);
            
            if (success) {
                request.getSession().setAttribute("message", "Payment rejected successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to reject payment");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/verify-qr-payments.jsp");
            
        } catch (Exception e) {
            System.err.println("Error rejecting payment: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred while rejecting payment");
            response.sendRedirect(request.getContextPath() + "/admin/verify-qr-payments.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
    }
}

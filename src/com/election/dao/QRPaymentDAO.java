package com.election.dao;

import com.election.model.QRPayment;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for QR Code payment operations
 */
public class QRPaymentDAO {
    
    /**
     * Submit a new QR payment for verification
     */
    public boolean submitPayment(QRPayment payment) {
        String sql = "INSERT INTO qr_payments (user_id, candidate_id, payment_type, plan_name, " +
                    "amount, transaction_id, payment_method, screenshot_path, " +
                    "terms_accepted, terms_version, terms_timestamp) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, payment.getUserId());
            if (payment.getCandidateId() != null) {
                pstmt.setInt(2, payment.getCandidateId());
            } else {
                pstmt.setNull(2, Types.INTEGER);
            }
            pstmt.setString(3, payment.getPaymentType());
            pstmt.setString(4, payment.getPlanName());
            pstmt.setDouble(5, payment.getAmount());
            pstmt.setString(6, payment.getTransactionId());
            pstmt.setString(7, payment.getPaymentMethod());
            pstmt.setString(8, payment.getScreenshotPath());
            pstmt.setBoolean(9, payment.isTermsAccepted());
            pstmt.setString(10, payment.getTermsVersion());
            pstmt.setTimestamp(11, payment.getTermsTimestamp());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    payment.setPaymentId(rs.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error submitting QR payment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get payment by ID
     */
    public QRPayment getPaymentById(int paymentId) {
        String sql = "SELECT qp.*, u.full_name, u.email, c.candidate_name, v.full_name as verified_by_name " +
                    "FROM qr_payments qp " +
                    "JOIN users u ON qp.user_id = u.user_id " +
                    "LEFT JOIN candidates c ON qp.candidate_id = c.candidate_id " +
                    "LEFT JOIN users v ON qp.verified_by = v.user_id " +
                    "WHERE qp.payment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, paymentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting payment by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all payments by user ID
     */
    public List<QRPayment> getPaymentsByUserId(int userId) {
        String sql = "SELECT qp.*, u.full_name, u.email, c.candidate_name, v.full_name as verified_by_name " +
                    "FROM qr_payments qp " +
                    "JOIN users u ON qp.user_id = u.user_id " +
                    "LEFT JOIN candidates c ON qp.candidate_id = c.candidate_id " +
                    "LEFT JOIN users v ON qp.verified_by = v.user_id " +
                    "WHERE qp.user_id = ? " +
                    "ORDER BY qp.submitted_date DESC";
        
        List<QRPayment> payments = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting payments by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        return payments;
    }
    
    /**
     * Get all pending payments for admin verification
     */
    public List<QRPayment> getPendingPayments() {
        String sql = "SELECT qp.*, u.full_name, u.email, c.candidate_name, v.full_name as verified_by_name " +
                    "FROM qr_payments qp " +
                    "JOIN users u ON qp.user_id = u.user_id " +
                    "LEFT JOIN candidates c ON qp.candidate_id = c.candidate_id " +
                    "LEFT JOIN users v ON qp.verified_by = v.user_id " +
                    "WHERE qp.payment_status = 'pending' " +
                    "ORDER BY qp.submitted_date ASC";
        
        List<QRPayment> payments = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting pending payments: " + e.getMessage());
            e.printStackTrace();
        }
        return payments;
    }
    
    /**
     * Get all payments with optional status filter
     */
    public List<QRPayment> getAllPayments(String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT qp.*, u.full_name, u.email, c.candidate_name, v.full_name as verified_by_name " +
            "FROM qr_payments qp " +
            "JOIN users u ON qp.user_id = u.user_id " +
            "LEFT JOIN candidates c ON qp.candidate_id = c.candidate_id " +
            "LEFT JOIN users v ON qp.verified_by = v.user_id");
        
        if (status != null && !status.isEmpty()) {
            sql.append(" WHERE qp.payment_status = ?");
        }
        
        sql.append(" ORDER BY qp.submitted_date DESC");
        
        List<QRPayment> payments = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            if (status != null && !status.isEmpty()) {
                pstmt.setString(1, status);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all payments: " + e.getMessage());
            e.printStackTrace();
        }
        return payments;
    }
    
    /**
     * Verify (approve) a payment
     */
    public boolean verifyPayment(int paymentId, int adminId, String notes) {
        String sql = "UPDATE qr_payments SET payment_status = 'verified', " +
                    "verified_date = CURRENT_TIMESTAMP, verified_by = ?, admin_notes = ? " +
                    "WHERE payment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            pstmt.setString(2, notes);
            pstmt.setInt(3, paymentId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error verifying payment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Reject a payment
     */
    public boolean rejectPayment(int paymentId, int adminId, String notes) {
        String sql = "UPDATE qr_payments SET payment_status = 'rejected', " +
                    "verified_date = CURRENT_TIMESTAMP, verified_by = ?, admin_notes = ? " +
                    "WHERE payment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            pstmt.setString(2, notes);
            pstmt.setInt(3, paymentId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error rejecting payment: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if transaction ID already exists
     */
    public boolean transactionIdExists(String transactionId) {
        String sql = "SELECT COUNT(*) FROM qr_payments WHERE transaction_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, transactionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking transaction ID: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get payment count by status
     */
    public int getPaymentCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM qr_payments WHERE payment_status = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting payment count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Extract QRPayment object from ResultSet
     */
    private QRPayment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        QRPayment payment = new QRPayment();
        
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setUserId(rs.getInt("user_id"));
        
        int candidateId = rs.getInt("candidate_id");
        if (!rs.wasNull()) {
            payment.setCandidateId(candidateId);
        }
        
        payment.setPaymentType(rs.getString("payment_type"));
        payment.setPlanName(rs.getString("plan_name"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setScreenshotPath(rs.getString("screenshot_path"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setSubmittedDate(rs.getTimestamp("submitted_date"));
        payment.setVerifiedDate(rs.getTimestamp("verified_date"));
        
        int verifiedBy = rs.getInt("verified_by");
        if (!rs.wasNull()) {
            payment.setVerifiedBy(verifiedBy);
        }
        
        payment.setAdminNotes(rs.getString("admin_notes"));
        payment.setTermsAccepted(rs.getBoolean("terms_accepted"));
        payment.setTermsVersion(rs.getString("terms_version"));
        payment.setTermsTimestamp(rs.getTimestamp("terms_timestamp"));
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        payment.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Display fields
        payment.setUserFullName(rs.getString("full_name"));
        payment.setUserEmail(rs.getString("email"));
        payment.setCandidateName(rs.getString("candidate_name"));
        payment.setVerifiedByName(rs.getString("verified_by_name"));
        
        return payment;
    }
}

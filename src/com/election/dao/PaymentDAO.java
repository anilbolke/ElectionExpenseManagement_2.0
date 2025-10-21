package com.election.dao;

import com.election.model.Payment;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    
    // Add new payment
    public boolean addPayment(Payment payment) {
        String query = "INSERT INTO payments (candidate_id, broker_id, payment_type, amount, payment_method, " +
                      "transaction_id, payment_status, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, payment.getCandidateId());
            pstmt.setInt(2, payment.getBrokerId());
            pstmt.setString(3, payment.getPaymentType());
            pstmt.setBigDecimal(4, payment.getAmount());
            pstmt.setString(5, payment.getPaymentMethod());
            pstmt.setString(6, payment.getTransactionId());
            pstmt.setString(7, payment.getPaymentStatus());
            pstmt.setString(8, payment.getRemarks());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get payment by transaction ID
    public Payment getPaymentByTransactionId(String transactionId) {
        String query = "SELECT * FROM payments WHERE transaction_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, transactionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get payments by candidate
    public List<Payment> getPaymentsByCandidate(int candidateId) {
        List<Payment> payments = new ArrayList<>();
        String query = "SELECT * FROM payments WHERE candidate_id = ? ORDER BY payment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    // Get payments by broker
    public List<Payment> getPaymentsByBroker(int brokerId) {
        List<Payment> payments = new ArrayList<>();
        String query = "SELECT * FROM payments WHERE broker_id = ? ORDER BY payment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, brokerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    // Get payments by status
    public List<Payment> getPaymentsByStatus(String status) {
        List<Payment> payments = new ArrayList<>();
        String query = "SELECT * FROM payments WHERE payment_status = ? ORDER BY payment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    // Update payment status
    public boolean updatePaymentStatus(int paymentId, String status) {
        String query = "UPDATE payments SET payment_status = ? WHERE payment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, paymentId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Verify payment
    public boolean verifyPayment(int paymentId, int verifiedBy) {
        String query = "UPDATE payments SET payment_status = 'success', verified_by = ?, " +
                      "verification_date = CURRENT_TIMESTAMP WHERE payment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, verifiedBy);
            pstmt.setInt(2, paymentId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all payments (for admin)
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String query = "SELECT * FROM payments ORDER BY payment_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    // Extract payment from ResultSet
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setCandidateId(rs.getInt("candidate_id"));
        payment.setBrokerId(rs.getInt("broker_id"));
        payment.setPaymentType(rs.getString("payment_type"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setVerifiedBy(rs.getInt("verified_by"));
        payment.setVerificationDate(rs.getTimestamp("verification_date"));
        payment.setRemarks(rs.getString("remarks"));
        return payment;
    }
}

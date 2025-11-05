package com.election.dao;

import com.election.model.TermsAcceptance;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Terms and Conditions Acceptance operations
 * Handles all database interactions for terms acceptance tracking
 */
public class TermsAcceptanceDAO {
    
    /**
     * Record terms and conditions acceptance
     * @param acceptance TermsAcceptance object with user details
     * @return true if successful, false otherwise
     */
    public boolean recordAcceptance(TermsAcceptance acceptance) {
        String query = "INSERT INTO terms_acceptance (user_id, candidate_id, accepted_on, " +
                       "ip_address, user_agent, terms_version) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, acceptance.getUserId());
            
            if (acceptance.getCandidateId() != null) {
                pstmt.setInt(2, acceptance.getCandidateId());
            } else {
                pstmt.setNull(2, Types.INTEGER);
            }
            
            pstmt.setTimestamp(3, acceptance.getAcceptedOn());
            pstmt.setString(4, acceptance.getIpAddress());
            pstmt.setString(5, acceptance.getUserAgent());
            pstmt.setString(6, acceptance.getTermsVersion());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    acceptance.setAcceptanceId(rs.getInt(1));
                }
                
                // Update users table
                updateUserTermsStatus(acceptance.getUserId(), conn);
                
                // Update candidates table if candidate_id is present
                if (acceptance.getCandidateId() != null) {
                    updateCandidateTermsStatus(acceptance.getCandidateId(), conn);
                }
                
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error recording terms acceptance: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update terms_accepted status in users table
     */
    private void updateUserTermsStatus(int userId, Connection conn) {
        String query = "UPDATE users SET terms_accepted = TRUE, " +
                       "terms_accepted_date = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating user terms status: " + e.getMessage());
        }
    }
    
    /**
     * Update terms_accepted status in candidates table
     */
    private void updateCandidateTermsStatus(int candidateId, Connection conn) {
        String query = "UPDATE candidates SET terms_accepted = TRUE, " +
                       "terms_accepted_date = CURRENT_TIMESTAMP WHERE candidate_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, candidateId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating candidate terms status: " + e.getMessage());
        }
    }
    
    /**
     * Check if user has accepted terms
     * @param userId User ID
     * @return true if accepted, false otherwise
     */
    public boolean hasAcceptedTerms(int userId) {
        String query = "SELECT COUNT(*) FROM terms_acceptance WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking terms acceptance: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Get all terms acceptances for a user
     * @param userId User ID
     * @return List of TermsAcceptance objects
     */
    public List<TermsAcceptance> getUserAcceptances(int userId) {
        List<TermsAcceptance> acceptances = new ArrayList<>();
        String query = "SELECT * FROM terms_acceptance WHERE user_id = ? ORDER BY accepted_on DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                TermsAcceptance acceptance = new TermsAcceptance();
                acceptance.setAcceptanceId(rs.getInt("acceptance_id"));
                acceptance.setUserId(rs.getInt("user_id"));
                acceptance.setCandidateId(rs.getObject("candidate_id") != null ? rs.getInt("candidate_id") : null);
                acceptance.setAcceptedOn(rs.getTimestamp("accepted_on"));
                acceptance.setIpAddress(rs.getString("ip_address"));
                acceptance.setUserAgent(rs.getString("user_agent"));
                acceptance.setTermsVersion(rs.getString("terms_version"));
                
                acceptances.add(acceptance);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user acceptances: " + e.getMessage());
        }
        
        return acceptances;
    }
    
    /**
     * Get latest terms acceptance for a user
     * @param userId User ID
     * @return TermsAcceptance object or null if not found
     */
    public TermsAcceptance getLatestAcceptance(int userId) {
        String query = "SELECT * FROM terms_acceptance WHERE user_id = ? ORDER BY accepted_on DESC LIMIT 1";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                TermsAcceptance acceptance = new TermsAcceptance();
                acceptance.setAcceptanceId(rs.getInt("acceptance_id"));
                acceptance.setUserId(rs.getInt("user_id"));
                acceptance.setCandidateId(rs.getObject("candidate_id") != null ? rs.getInt("candidate_id") : null);
                acceptance.setAcceptedOn(rs.getTimestamp("accepted_on"));
                acceptance.setIpAddress(rs.getString("ip_address"));
                acceptance.setUserAgent(rs.getString("user_agent"));
                acceptance.setTermsVersion(rs.getString("terms_version"));
                
                return acceptance;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting latest acceptance: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get total number of users who have accepted terms
     * @return count of users
     */
    public int getTotalAcceptances() {
        String query = "SELECT COUNT(DISTINCT user_id) FROM terms_acceptance";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total acceptances: " + e.getMessage());
        }
        
        return 0;
    }
}

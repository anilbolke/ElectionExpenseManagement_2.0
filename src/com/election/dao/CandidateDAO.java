package com.election.dao;

import com.election.model.Candidate;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDAO {
    
    // Create candidate profile
    public int createCandidate(Candidate candidate) {
        String query = "INSERT INTO candidates (user_id, candidate_name, father_name, age, gender, mobile, email, address, city, state, pincode, " +
                      "aadhar_number, voter_id, constituency, nomination_id, party_name, party_symbol, election_type, election_date, " +
                      "booth_number, broker_id, account_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, candidate.getUserId());
            pstmt.setString(2, candidate.getCandidateName());
            pstmt.setString(3, candidate.getFatherName());
            pstmt.setInt(4, candidate.getAge());
            pstmt.setString(5, candidate.getGender());
            pstmt.setString(6, candidate.getMobile());
            pstmt.setString(7, candidate.getEmail());
            pstmt.setString(8, candidate.getAddress());
            pstmt.setString(9, candidate.getCity());
            pstmt.setString(10, candidate.getState());
            pstmt.setString(11, candidate.getPincode());
            pstmt.setString(12, candidate.getAadharNumber());
            pstmt.setString(13, candidate.getVoterId());
            pstmt.setString(14, candidate.getConstituency());
            pstmt.setString(15, candidate.getNominationId());
            pstmt.setString(16, candidate.getPartyName());
            pstmt.setString(17, candidate.getPartySymbol());
            pstmt.setString(18, candidate.getElectionType());
            pstmt.setDate(19, candidate.getElectionDate());
            pstmt.setString(20, candidate.getBoothNumber());
            pstmt.setInt(21, candidate.getBrokerId());
            pstmt.setString(22, "pending_payment");
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    // Get candidate by user ID (returns first candidate)
    public Candidate getCandidateByUserId(int userId) {
        String query = "SELECT * FROM candidates WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractCandidateFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all candidates by user ID (plural - for users with multiple candidates)
    public List<Candidate> getCandidatesByUserId(int userId) {
        List<Candidate> candidates = new ArrayList<>();
        String query = "SELECT * FROM candidates WHERE user_id = ? ORDER BY created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                candidates.add(extractCandidateFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidates;
    }
    
    // Get candidate by ID
    public Candidate getCandidateById(int candidateId) {
        String query = "SELECT * FROM candidates WHERE candidate_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractCandidateFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update candidate details
    public boolean updateCandidate(Candidate candidate) {
        String query = "UPDATE candidates SET candidate_name = ?, father_name = ?, age = ?, gender = ?, mobile = ?, email = ?, address = ?, city = ?, " +
                      "state = ?, pincode = ?, aadhar_number = ?, voter_id = ?, constituency = ?, nomination_id = ?, party_name = ?, " +
                      "party_symbol = ?, election_type = ?, election_date = ?, booth_number = ? WHERE candidate_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            // Debug logging
            System.out.println("========== CANDIDATE UPDATE DEBUG ==========");
            System.out.println("Candidate ID: " + candidate.getCandidateId());
            System.out.println("Gender: " + candidate.getGender());
            System.out.println("Mobile: " + candidate.getMobile());
            System.out.println("Email: " + candidate.getEmail());
            System.out.println("==========================================");
            
            pstmt.setString(1, candidate.getCandidateName());
            pstmt.setString(2, candidate.getFatherName());
            pstmt.setInt(3, candidate.getAge());
            pstmt.setString(4, candidate.getGender());
            pstmt.setString(5, candidate.getMobile());
            pstmt.setString(6, candidate.getEmail());
            pstmt.setString(7, candidate.getAddress());
            pstmt.setString(8, candidate.getCity());
            pstmt.setString(9, candidate.getState());
            pstmt.setString(10, candidate.getPincode());
            pstmt.setString(11, candidate.getAadharNumber());
            pstmt.setString(12, candidate.getVoterId());
            pstmt.setString(13, candidate.getConstituency());
            pstmt.setString(14, candidate.getNominationId());
            pstmt.setString(15, candidate.getPartyName());
            pstmt.setString(16, candidate.getPartySymbol());
            pstmt.setString(17, candidate.getElectionType());
            pstmt.setDate(18, candidate.getElectionDate());
            pstmt.setString(19, candidate.getBoothNumber());
            pstmt.setInt(20, candidate.getCandidateId());
            
            int result = pstmt.executeUpdate();
            System.out.println("Update result: " + result + " row(s) affected");
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR updating candidate: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Update payment status
    public boolean updatePaymentStatus(int candidateId, String status, String transactionId) {
        String query = "UPDATE candidates SET payment_status = ?, transaction_id = ?, payment_date = CURRENT_TIMESTAMP, " +
                      "account_status = ? WHERE candidate_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, transactionId);
            pstmt.setString(3, status.equals("completed") ? "active" : "pending_payment");
            pstmt.setInt(4, candidateId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Verify payment
    public boolean verifyPayment(int candidateId, boolean verified) {
        String query = "UPDATE candidates SET is_payment_verified = ?, account_status = ? WHERE candidate_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setBoolean(1, verified);
            pstmt.setString(2, verified ? "active" : "pending_payment");
            pstmt.setInt(3, candidateId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all candidates
    public List<Candidate> getAllCandidates() {
        List<Candidate> candidates = new ArrayList<>();
        String query = "SELECT * FROM candidates ORDER BY created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                candidates.add(extractCandidateFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidates;
    }
    
    // Get candidates by broker
    public List<Candidate> getCandidatesByBroker(int brokerId) {
        List<Candidate> candidates = new ArrayList<>();
        String query = "SELECT * FROM candidates WHERE broker_id = ? ORDER BY created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            System.out.println("========== GET CANDIDATES BY BROKER ==========");
            System.out.println("Broker ID: " + brokerId);
            
            pstmt.setInt(1, brokerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                candidates.add(extractCandidateFromResultSet(rs));
            }
            
            System.out.println("Found " + candidates.size() + " candidates for broker " + brokerId);
            System.out.println("==============================================");
            
        } catch (SQLException e) {
            System.err.println("ERROR getting candidates by broker: " + e.getMessage());
            e.printStackTrace();
        }
        return candidates;
    }
    
    // Get candidates by payment status
    public List<Candidate> getCandidatesByPaymentStatus(String status) {
        List<Candidate> candidates = new ArrayList<>();
        String query = "SELECT * FROM candidates WHERE payment_status = ? ORDER BY created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                candidates.add(extractCandidateFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidates;
    }
    
    // Get candidate count by broker
    public int getCandidateCountByBroker(int brokerId) {
        String query = "SELECT COUNT(*) FROM candidates WHERE broker_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, brokerId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Extract candidate from ResultSet
    private Candidate extractCandidateFromResultSet(ResultSet rs) throws SQLException {
        Candidate candidate = new Candidate();
        candidate.setCandidateId(rs.getInt("candidate_id"));
        candidate.setUserId(rs.getInt("user_id"));
        candidate.setCandidateName(rs.getString("candidate_name"));
        candidate.setFatherName(rs.getString("father_name"));
        candidate.setAge(rs.getInt("age"));
        candidate.setGender(rs.getString("gender"));
        candidate.setMobile(rs.getString("mobile"));
        candidate.setEmail(rs.getString("email"));
        candidate.setAddress(rs.getString("address"));
        candidate.setCity(rs.getString("city"));
        candidate.setState(rs.getString("state"));
        candidate.setPincode(rs.getString("pincode"));
        candidate.setAadharNumber(rs.getString("aadhar_number"));
        candidate.setVoterId(rs.getString("voter_id"));
        candidate.setConstituency(rs.getString("constituency"));
        candidate.setNominationId(rs.getString("nomination_id"));
        candidate.setPartyName(rs.getString("party_name"));
        candidate.setPartySymbol(rs.getString("party_symbol"));
        candidate.setElectionType(rs.getString("election_type"));
        candidate.setElectionDate(rs.getDate("election_date"));
        candidate.setBoothNumber(rs.getString("booth_number"));
        candidate.setBrokerId(rs.getInt("broker_id"));
        candidate.setPaymentStatus(rs.getString("payment_status"));
        candidate.setPaymentAmount(rs.getBigDecimal("payment_amount"));
        candidate.setPaymentDate(rs.getTimestamp("payment_date"));
        candidate.setTransactionId(rs.getString("transaction_id"));
        candidate.setPaymentVerified(rs.getBoolean("is_payment_verified"));
        candidate.setAccountStatus(rs.getString("account_status"));
        candidate.setCreatedDate(rs.getTimestamp("created_date"));
        candidate.setUpdatedDate(rs.getTimestamp("updated_date"));
        return candidate;
    }
}

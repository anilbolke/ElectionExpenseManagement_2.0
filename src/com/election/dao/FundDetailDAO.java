package com.election.dao;

import com.election.model.FundDetail;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FundDetailDAO {
    
    // Add fund detail
    public boolean addFundDetail(FundDetail fund) {
        String query = "INSERT INTO fund_details (candidate_id, user_id, fund_date, fund_type, amount, " +
                      "funder_name, funder_mobile, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, fund.getCandidateId());
            pstmt.setInt(2, fund.getUserId());
            pstmt.setDate(3, fund.getFundDate());
            pstmt.setString(4, fund.getFundType());
            pstmt.setBigDecimal(5, fund.getAmount());
            pstmt.setString(6, fund.getFunderName());
            pstmt.setString(7, fund.getFunderMobile());
            pstmt.setString(8, fund.getDescription());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get fund detail by ID
    public FundDetail getFundDetailById(int fundId) {
        String query = "SELECT f.*, c.candidate_name FROM fund_details f " +
                      "LEFT JOIN candidates c ON f.candidate_id = c.candidate_id " +
                      "WHERE f.fund_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, fundId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractFundDetailFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all fund details by candidate
    public List<FundDetail> getFundDetailsByCandidate(int candidateId) {
        List<FundDetail> funds = new ArrayList<>();
        String query = "SELECT f.*, c.candidate_name FROM fund_details f " +
                      "LEFT JOIN candidates c ON f.candidate_id = c.candidate_id " +
                      "WHERE f.candidate_id = ? ORDER BY f.fund_date DESC, f.created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                funds.add(extractFundDetailFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return funds;
    }
    
    // Get all fund details by user
    public List<FundDetail> getFundDetailsByUser(int userId) {
        List<FundDetail> funds = new ArrayList<>();
        String query = "SELECT f.*, c.candidate_name FROM fund_details f " +
                      "LEFT JOIN candidates c ON f.candidate_id = c.candidate_id " +
                      "WHERE f.user_id = ? ORDER BY f.fund_date DESC, f.created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                funds.add(extractFundDetailFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return funds;
    }
    
    // Update fund detail
    public boolean updateFundDetail(FundDetail fund) {
        String query = "UPDATE fund_details SET fund_date = ?, fund_type = ?, amount = ?, " +
                      "funder_name = ?, funder_mobile = ?, description = ? WHERE fund_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDate(1, fund.getFundDate());
            pstmt.setString(2, fund.getFundType());
            pstmt.setBigDecimal(3, fund.getAmount());
            pstmt.setString(4, fund.getFunderName());
            pstmt.setString(5, fund.getFunderMobile());
            pstmt.setString(6, fund.getDescription());
            pstmt.setInt(7, fund.getFundId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete fund detail
    public boolean deleteFundDetail(int fundId) {
        String query = "DELETE FROM fund_details WHERE fund_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, fundId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get total funds by candidate
    public double getTotalFundsByCandidate(int candidateId) {
        String query = "SELECT COALESCE(SUM(amount), 0) as total FROM fund_details WHERE candidate_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Get total funds by type for a candidate
    public double getTotalFundsByType(int candidateId, String fundType) {
        String query = "SELECT COALESCE(SUM(amount), 0) as total FROM fund_details " +
                      "WHERE candidate_id = ? AND fund_type = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            pstmt.setString(2, fundType);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Extract fund detail from ResultSet
    private FundDetail extractFundDetailFromResultSet(ResultSet rs) throws SQLException {
        FundDetail fund = new FundDetail();
        fund.setFundId(rs.getInt("fund_id"));
        fund.setCandidateId(rs.getInt("candidate_id"));
        fund.setUserId(rs.getInt("user_id"));
        fund.setFundDate(rs.getDate("fund_date"));
        fund.setFundType(rs.getString("fund_type"));
        fund.setAmount(rs.getBigDecimal("amount"));
        fund.setFunderName(rs.getString("funder_name"));
        fund.setFunderMobile(rs.getString("funder_mobile"));
        fund.setDescription(rs.getString("description"));
        fund.setCreatedDate(rs.getTimestamp("created_date"));
        fund.setUpdatedDate(rs.getTimestamp("updated_date"));
        fund.setCandidateName(rs.getString("candidate_name"));
        return fund;
    }
}

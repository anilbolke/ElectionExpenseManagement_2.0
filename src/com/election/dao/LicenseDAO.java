package com.election.dao;

import com.election.model.License;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * License DAO - Database operations for License Management
 * 
 * @author System Generated
 * @date 2025-11-16
 */
public class LicenseDAO {
    
    /**
     * Generate unique license key starting with EMS + 5 random numbers
     */
    public String generateLicenseKey() {
        Random random = new Random();
        String licenseKey;
        int attempts = 0;
        int maxAttempts = 100;
        
        do {
            int randomNumber = 10000 + random.nextInt(90000); // 5-digit number (10000-99999)
            licenseKey = "EMS" + randomNumber;
            attempts++;
            
            if (attempts >= maxAttempts) {
                throw new RuntimeException("Failed to generate unique license key after " + maxAttempts + " attempts");
            }
        } while (licenseKeyExists(licenseKey));
        
        return licenseKey;
    }
    
    /**
     * Check if license key already exists
     */
    private boolean licenseKeyExists(String licenseKey) {
        String query = "SELECT COUNT(*) FROM licenses WHERE license_key = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, licenseKey);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Generate multiple licenses
     */
    public List<String> generateLicenses(int count, int generatedBy) {
        List<String> generatedKeys = new ArrayList<>();
        String query = "INSERT INTO licenses (license_key, generated_by, status) VALUES (?, ?, 'active')";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            for (int i = 0; i < count; i++) {
                String licenseKey = generateLicenseKey();
                
                pstmt.setString(1, licenseKey);
                pstmt.setInt(2, generatedBy);
                pstmt.executeUpdate();
                
                generatedKeys.add(licenseKey);
                System.out.println("✓ Generated license: " + licenseKey);
            }
            
            System.out.println("✓ Successfully generated " + count + " licenses");
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return generatedKeys;
    }
    
    /**
     * Verify if license is valid and unused
     */
    public License verifyLicense(String licenseKey) {
        String query = "SELECT * FROM licenses WHERE license_key = ? AND status = 'active' AND is_used = FALSE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, licenseKey.trim().toUpperCase());
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractLicenseFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Use license and map to user and candidate
     */
    public boolean useLicense(String licenseKey, int userId, int candidateId) {
        String query = "UPDATE licenses SET is_used = TRUE, mapped_user_id = ?, mapped_candidate_id = ?, " +
                      "used_date = CURRENT_TIMESTAMP, status = 'used' WHERE license_key = ? AND status = 'active' AND is_used = FALSE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, candidateId);
            pstmt.setString(3, licenseKey.trim().toUpperCase());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("✓ License " + licenseKey + " successfully mapped to user " + userId + " and candidate " + candidateId);
                return true;
            } else {
                System.out.println("✗ Failed to use license " + licenseKey + " - may already be used or invalid");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get all licenses
     */
    public List<License> getAllLicenses() {
        List<License> licenses = new ArrayList<>();
        String query = "SELECT l.*, u1.full_name as generated_by_name, " +
                      "u2.full_name as mapped_user_name, c.candidate_name as mapped_candidate_name " +
                      "FROM licenses l " +
                      "LEFT JOIN users u1 ON l.generated_by = u1.user_id " +
                      "LEFT JOIN users u2 ON l.mapped_user_id = u2.user_id " +
                      "LEFT JOIN candidates c ON l.mapped_candidate_id = c.candidate_id " +
                      "ORDER BY l.generated_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                License license = extractLicenseFromResultSet(rs);
                license.setGeneratedByName(rs.getString("generated_by_name"));
                license.setMappedUserName(rs.getString("mapped_user_name"));
                license.setMappedCandidateName(rs.getString("mapped_candidate_name"));
                licenses.add(license);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return licenses;
    }
    
    /**
     * Get all unused licenses
     */
    public List<License> getUnusedLicenses() {
        List<License> licenses = new ArrayList<>();
        String query = "SELECT l.*, u1.full_name as generated_by_name " +
                      "FROM licenses l " +
                      "LEFT JOIN users u1 ON l.generated_by = u1.user_id " +
                      "WHERE l.status = 'active' AND l.is_used = FALSE " +
                      "ORDER BY l.generated_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                License license = extractLicenseFromResultSet(rs);
                license.setGeneratedByName(rs.getString("generated_by_name"));
                licenses.add(license);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return licenses;
    }
    
    /**
     * Get unused licenses count
     */
    public int getUnusedLicensesCount() {
        String query = "SELECT COUNT(*) FROM licenses WHERE status = 'active' AND is_used = FALSE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get used licenses count
     */
    public int getUsedLicensesCount() {
        String query = "SELECT COUNT(*) FROM licenses WHERE status = 'used' AND is_used = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get license by ID
     */
    public License getLicenseById(int licenseId) {
        String query = "SELECT * FROM licenses WHERE license_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, licenseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractLicenseFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Check if candidate has used license
     */
    public boolean isCandidateLicensed(int candidateId) {
        String query = "SELECT COUNT(*) FROM licenses WHERE mapped_candidate_id = ? AND status = 'used' AND is_used = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Extract License from ResultSet
     */
    private License extractLicenseFromResultSet(ResultSet rs) throws SQLException {
        License license = new License();
        license.setLicenseId(rs.getInt("license_id"));
        license.setLicenseKey(rs.getString("license_key"));
        license.setUsed(rs.getBoolean("is_used"));
        
        int mappedUserId = rs.getInt("mapped_user_id");
        if (!rs.wasNull()) {
            license.setMappedUserId(mappedUserId);
        }
        
        int mappedCandidateId = rs.getInt("mapped_candidate_id");
        if (!rs.wasNull()) {
            license.setMappedCandidateId(mappedCandidateId);
        }
        
        license.setGeneratedBy(rs.getInt("generated_by"));
        license.setGeneratedDate(rs.getTimestamp("generated_date"));
        license.setUsedDate(rs.getTimestamp("used_date"));
        license.setStatus(rs.getString("status"));
        license.setNotes(rs.getString("notes"));
        
        return license;
    }
}

package com.election.dao;

import com.election.util.DatabaseConnection;
import java.sql.*;

public class SystemSettingsDAO {
    
    /**
     * Get a setting value by key
     * @param key Setting key
     * @param defaultValue Default value if setting not found
     * @return Setting value or default
     */
    public String getSetting(String key, String defaultValue) {
        String query = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, key);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("setting_value");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting setting: " + key);
            e.printStackTrace();
        }
        return defaultValue;
    }
    
    /**
     * Get a setting value as double
     * @param key Setting key
     * @param defaultValue Default value if setting not found
     * @return Setting value as double or default
     */
    public double getSettingAsDouble(String key, double defaultValue) {
        String value = getSetting(key, String.valueOf(defaultValue));
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            System.err.println("Error parsing setting as double: " + key + " = " + value);
            return defaultValue;
        }
    }
    
    /**
     * Update or insert a setting
     * @param key Setting key
     * @param value Setting value
     * @param description Description of the setting
     * @param updatedBy User ID who updated
     * @return true if successful
     */
    public boolean updateSetting(String key, String value, String description, Integer updatedBy) {
        String query = "INSERT INTO system_settings (setting_key, setting_value, description, updated_by) " +
                      "VALUES (?, ?, ?, ?) " +
                      "ON DUPLICATE KEY UPDATE setting_value = ?, description = ?, updated_by = ?, updated_date = CURRENT_TIMESTAMP";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, key);
            pstmt.setString(2, value);
            pstmt.setString(3, description);
            if (updatedBy != null) {
                pstmt.setInt(4, updatedBy);
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }
            pstmt.setString(5, value);
            pstmt.setString(6, description);
            if (updatedBy != null) {
                pstmt.setInt(7, updatedBy);
            } else {
                pstmt.setNull(7, Types.INTEGER);
            }
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating setting: " + key);
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update or insert a setting (without tracking updater)
     * @param key Setting key
     * @param value Setting value
     * @return true if successful
     */
    public boolean updateSetting(String key, String value) {
        return updateSetting(key, value, null, null);
    }
    
    /**
     * Delete a setting
     * @param key Setting key
     * @return true if successful
     */
    public boolean deleteSetting(String key) {
        String query = "DELETE FROM system_settings WHERE setting_key = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, key);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting setting: " + key);
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if a setting exists
     * @param key Setting key
     * @return true if exists
     */
    public boolean settingExists(String key) {
        String query = "SELECT COUNT(*) as count FROM system_settings WHERE setting_key = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, key);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking setting existence: " + key);
            e.printStackTrace();
        }
        return false;
    }
}

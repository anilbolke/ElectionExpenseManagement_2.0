package com.election.dao;

import com.election.model.User;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    // Register new user
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, full_name, email, mobile, password, broker_id, user_role, subscription_status, created_date) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getFullName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getMobile());
            pstmt.setString(5, user.getPassword());
            
            // Set broker_id - null for brokers, specific ID for users assigned to brokers
            if (user.getBrokerId() != null) {
                pstmt.setInt(6, user.getBrokerId());
            } else {
                pstmt.setNull(6, Types.INTEGER);
            }
            
            pstmt.setString(7, user.getRole());
            pstmt.setString(8, "active");
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Login validation
    public User validateUser(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = extractUserFromResultSet(rs);
                updateLastLogin(user.getUserId());
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get user by ID
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get user by username
    public User getUserByUsername(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Check if username exists
    public boolean isUsernameExists(String username) {
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if email exists
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if mobile exists
    public boolean isMobileExists(String mobile) {
        String query = "SELECT COUNT(*) FROM users WHERE mobile = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, mobile);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if referral code exists
    public boolean isReferralCodeExists(String referralCode) {
        String query = "SELECT COUNT(*) FROM users WHERE referral_code = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, referralCode);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get broker by referral code
    public User getBrokerByReferralCode(String referralCode) {
        String query = "SELECT user_id, username, full_name, email, mobile, user_role, referral_code " +
                      "FROM users WHERE referral_code = ? AND user_role = 'broker' AND is_active = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, referralCode);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User broker = new User();
                broker.setUserId(rs.getInt("user_id"));
                broker.setUsername(rs.getString("username"));
                broker.setFullName(rs.getString("full_name"));
                broker.setEmail(rs.getString("email"));
                broker.setMobile(rs.getString("mobile"));
                broker.setUserRole(rs.getString("user_role"));
                broker.setReferralCode(rs.getString("referral_code"));
                return broker;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Register broker with referral code
    public boolean registerBroker(User user) {
        String query = "INSERT INTO users (username, full_name, email, mobile, password, broker_id, user_role, referral_code, subscription_status, created_date) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getFullName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getMobile());
            pstmt.setString(5, user.getPassword());
            
            // Set broker_id - null for brokers
            if (user.getBrokerId() != null) {
                pstmt.setInt(6, user.getBrokerId());
            } else {
                pstmt.setNull(6, Types.INTEGER);
            }
            
            pstmt.setString(7, user.getRole());
            pstmt.setString(8, user.getReferralCode());
            pstmt.setString(9, "active");
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all brokers
    public List<User> getAllBrokers() {
        List<User> brokers = new ArrayList<>();
        String query = "SELECT * FROM users WHERE user_role = 'broker' AND is_active = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                brokers.add(extractUserFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brokers;
    }
    
    // Get all users by role
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE user_role = ? AND is_active = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, role);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Get users by broker ID (for broker dashboard)
    public List<User> getUsersByBrokerId(int brokerId) {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE broker_id = ? AND user_role = 'user' AND is_active = TRUE ORDER BY created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            System.out.println("========== GET USERS BY BROKER ==========");
            System.out.println("Broker ID: " + brokerId);
            
            pstmt.setInt(1, brokerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
            
            System.out.println("Found " + users.size() + " users for broker " + brokerId);
            System.out.println("=========================================");
            
        } catch (SQLException e) {
            System.err.println("ERROR getting users by broker: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    // Update last login
    private void updateLastLogin(int userId) {
        String query = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Extract user from ResultSet
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setMobile(rs.getString("mobile"));
        user.setUserRole(rs.getString("user_role"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedDate(rs.getTimestamp("created_date"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        
        // Handle broker-related fields
        int brokerId = rs.getInt("broker_id");
        if (!rs.wasNull()) {
            user.setBrokerId(brokerId);
        }
        
        // Handle referral code for brokers
        try {
            String referralCode = rs.getString("referral_code");
            if (referralCode != null && !referralCode.trim().isEmpty()) {
                user.setReferralCode(referralCode);
            }
        } catch (SQLException e) {
            // referral_code field might not be present in all queries
        }
        
        // Additional fields that might be present
        try {
            user.setCity(rs.getString("city"));
            user.setState(rs.getString("state"));
            user.setAddress(rs.getString("address"));
        } catch (SQLException e) {
            // These fields might not be present in all queries
        }
        
        return user;
    }
    
    // Update user subscription status
    public boolean updateUserSubscription(int userId, String subscriptionStatus, 
                                          Timestamp startDate, Timestamp endDate, String paymentStatus) {
        String query = "UPDATE users SET subscription_status = ?, subscription_start_date = ?, " +
                      "subscription_end_date = ?, payment_status = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, subscriptionStatus);
            pstmt.setTimestamp(2, startDate);
            pstmt.setTimestamp(3, endDate);
            pstmt.setString(4, paymentStatus);
            pstmt.setInt(5, userId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update user profile
    public boolean updateUser(User user) {
        String query = "UPDATE users SET email = ?, full_name = ?, mobile = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getFullName());
            pstmt.setString(3, user.getMobile());
            pstmt.setInt(4, user.getUserId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY created_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Update user status (activate/deactivate)
    public boolean updateUserStatus(int userId, boolean isActive) {
        String query = "UPDATE users SET is_active = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setBoolean(1, isActive);
            pstmt.setInt(2, userId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Change password
    public boolean changePassword(int userId, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete user
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get user count by role
    public int getUserCountByRole(String role) {
        String query = "SELECT COUNT(*) FROM users WHERE user_role = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, role);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get total user count
    public int getTotalUserCount() {
        String query = "SELECT COUNT(*) FROM users";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

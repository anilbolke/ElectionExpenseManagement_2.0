package com.election.dao;

import com.election.model.SubscriptionPlan;
import com.election.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubscriptionDAO {
    
    // Get all active subscription plans
    public List<SubscriptionPlan> getAllPlans() {
        List<SubscriptionPlan> plans = new ArrayList<>();
        String query = "SELECT * FROM subscription_plans WHERE is_active = TRUE ORDER BY price ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                plans.add(extractPlanFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plans;
    }
    
    // Get subscription plan by ID
    public SubscriptionPlan getPlanById(int planId) {
        String query = "SELECT * FROM subscription_plans WHERE plan_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, planId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractPlanFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Create subscription plan
    public int createPlan(SubscriptionPlan plan) {
        String query = "INSERT INTO subscription_plans (plan_name, plan_description, price, duration_days, " +
                      "plan_type, max_candidates, expense_tracking, fund_management, report_generation, " +
                      "priority_support, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, plan.getPlanName());
            pstmt.setString(2, plan.getPlanDescription());
            pstmt.setBigDecimal(3, plan.getPrice());
            pstmt.setInt(4, plan.getDurationDays());
            pstmt.setString(5, plan.getPlanType());
            pstmt.setInt(6, plan.getMaxCandidates());
            pstmt.setBoolean(7, plan.isExpenseTracking());
            pstmt.setBoolean(8, plan.isFundManagement());
            pstmt.setBoolean(9, plan.isReportGeneration());
            pstmt.setBoolean(10, plan.isPrioritySupport());
            pstmt.setBoolean(11, plan.isActive());
            
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
    
    // Update subscription plan
    public boolean updatePlan(SubscriptionPlan plan) {
        String query = "UPDATE subscription_plans SET plan_name = ?, plan_description = ?, price = ?, " +
                      "duration_days = ?, plan_type = ?, max_candidates = ?, expense_tracking = ?, " +
                      "fund_management = ?, report_generation = ?, priority_support = ?, is_active = ? " +
                      "WHERE plan_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, plan.getPlanName());
            pstmt.setString(2, plan.getPlanDescription());
            pstmt.setBigDecimal(3, plan.getPrice());
            pstmt.setInt(4, plan.getDurationDays());
            pstmt.setString(5, plan.getPlanType());
            pstmt.setInt(6, plan.getMaxCandidates());
            pstmt.setBoolean(7, plan.isExpenseTracking());
            pstmt.setBoolean(8, plan.isFundManagement());
            pstmt.setBoolean(9, plan.isReportGeneration());
            pstmt.setBoolean(10, plan.isPrioritySupport());
            pstmt.setBoolean(11, plan.isActive());
            pstmt.setInt(12, plan.getPlanId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Subscribe user to a plan
    public boolean subscribeUser(int userId, int planId) {
        String query = "UPDATE users SET subscription_plan_id = ?, subscription_status = 'pending', " +
                      "updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, planId);
            pstmt.setInt(2, userId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Activate user subscription after payment
    public boolean activateSubscription(int userId, int planId) {
        SubscriptionPlan plan = getPlanById(planId);
        if (plan == null) return false;
        
        String query = "UPDATE users SET subscription_status = 'active', " +
                      "subscription_start_date = CURRENT_TIMESTAMP, " +
                      "subscription_end_date = DATE_ADD(CURRENT_TIMESTAMP, INTERVAL ? DAY), " +
                      "updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, plan.getDurationDays());
            pstmt.setInt(2, userId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if user's subscription is active
    public boolean isSubscriptionActive(int userId) {
        String query = "SELECT subscription_status FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("subscription_status");
               
                if ("active".equals(status) ) {
                    return true;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update plan price only (for admin)
    public boolean updatePlanPrice(int planId, java.math.BigDecimal newPrice) {
        String query = "UPDATE subscription_plans SET price = ?, updated_date = CURRENT_TIMESTAMP WHERE plan_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setBigDecimal(1, newPrice);
            pstmt.setInt(2, planId);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Extract subscription plan from ResultSet
    private SubscriptionPlan extractPlanFromResultSet(ResultSet rs) throws SQLException {
        SubscriptionPlan plan = new SubscriptionPlan();
        plan.setPlanId(rs.getInt("plan_id"));
        plan.setPlanName(rs.getString("plan_name"));
        plan.setPlanDescription(rs.getString("plan_description"));
        plan.setPrice(rs.getBigDecimal("price"));
        plan.setDurationDays(rs.getInt("duration_days"));
        plan.setPlanType(rs.getString("plan_type"));
        plan.setMaxCandidates(rs.getInt("max_candidates"));
        plan.setExpenseTracking(rs.getBoolean("expense_tracking"));
        plan.setFundManagement(rs.getBoolean("fund_management"));
        plan.setReportGeneration(rs.getBoolean("report_generation"));
        plan.setPrioritySupport(rs.getBoolean("priority_support"));
        plan.setActive(rs.getBoolean("is_active"));
        plan.setCreatedDate(rs.getTimestamp("created_date"));
        plan.setUpdatedDate(rs.getTimestamp("updated_date"));
        return plan;
    }
}

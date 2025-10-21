package com.election.dao;

import com.election.model.Expense;
import com.election.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ExpenseDAO {
    
    // Add new expense
    public boolean addExpense(Expense expense) {
        String query = "INSERT INTO expenses (candidate_id, expense_category, expense_description, expense_amount, " +
                      "expense_date, payment_mode, receipt_number, vendor_name, remarks, created_by) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, expense.getCandidateId());
            pstmt.setString(2, expense.getExpenseCategory());
            pstmt.setString(3, expense.getExpenseDescription());
            pstmt.setBigDecimal(4, expense.getExpenseAmount());
            pstmt.setDate(5, expense.getExpenseDate());
            pstmt.setString(6, expense.getPaymentMode());
            pstmt.setString(7, expense.getReceiptNumber());
            pstmt.setString(8, expense.getVendorName());
            pstmt.setString(9, expense.getRemarks());
            pstmt.setInt(10, expense.getCreatedBy());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get expenses by candidate
    public List<Expense> getExpensesByCandidate(int candidateId) {
        List<Expense> expenses = new ArrayList<>();
        String query = "SELECT * FROM expenses WHERE candidate_id = ? ORDER BY expense_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                expenses.add(extractExpenseFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return expenses;
    }
    
    // Get expense by ID
    public Expense getExpenseById(int expenseId) {
        String query = "SELECT * FROM expenses WHERE expense_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, expenseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractExpenseFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get total expenses for candidate
    public BigDecimal getTotalExpensesByCandidate(int candidateId) {
        String query = "SELECT COALESCE(SUM(expense_amount), 0) as total FROM expenses WHERE candidate_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    // Get expenses by date range
    public List<Expense> getExpensesByDateRange(int candidateId, Date startDate, Date endDate) {
        List<Expense> expenses = new ArrayList<>();
        String query = "SELECT * FROM expenses WHERE candidate_id = ? AND expense_date BETWEEN ? AND ? ORDER BY expense_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            pstmt.setDate(2, startDate);
            pstmt.setDate(3, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                expenses.add(extractExpenseFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return expenses;
    }
    
    // Get expenses by category
    public Map<String, BigDecimal> getExpensesByCategory(int candidateId) {
        Map<String, BigDecimal> categoryExpenses = new HashMap<>();
        String query = "SELECT expense_category, SUM(expense_amount) as total FROM expenses " +
                      "WHERE candidate_id = ? GROUP BY expense_category";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, candidateId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                categoryExpenses.put(rs.getString("expense_category"), rs.getBigDecimal("total"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categoryExpenses;
    }
    
    // Update expense
    public boolean updateExpense(Expense expense) {
        String query = "UPDATE expenses SET expense_category = ?, expense_description = ?, expense_amount = ?, " +
                      "expense_date = ?, payment_mode = ?, receipt_number = ?, vendor_name = ?, remarks = ? " +
                      "WHERE expense_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, expense.getExpenseCategory());
            pstmt.setString(2, expense.getExpenseDescription());
            pstmt.setBigDecimal(3, expense.getExpenseAmount());
            pstmt.setDate(4, expense.getExpenseDate());
            pstmt.setString(5, expense.getPaymentMode());
            pstmt.setString(6, expense.getReceiptNumber());
            pstmt.setString(7, expense.getVendorName());
            pstmt.setString(8, expense.getRemarks());
            pstmt.setInt(9, expense.getExpenseId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete expense
    public boolean deleteExpense(int expenseId) {
        String query = "DELETE FROM expenses WHERE expense_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, expenseId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all expenses (for admin)
    public List<Expense> getAllExpenses() {
        List<Expense> expenses = new ArrayList<>();
        String query = "SELECT * FROM expenses ORDER BY expense_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                expenses.add(extractExpenseFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return expenses;
    }
    
    // Get expenses by user (for user dashboard)
    public List<Expense> getExpensesByUser(int userId) {
        List<Expense> expenses = new ArrayList<>();
        String query = "SELECT e.* FROM expenses e " +
                      "JOIN candidates c ON e.candidate_id = c.candidate_id " +
                      "WHERE c.user_id = ? ORDER BY e.expense_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                expenses.add(extractExpenseFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return expenses;
    }
    
    // Extract expense from ResultSet
    private Expense extractExpenseFromResultSet(ResultSet rs) throws SQLException {
        Expense expense = new Expense();
        expense.setExpenseId(rs.getInt("expense_id"));
        expense.setCandidateId(rs.getInt("candidate_id"));
        expense.setExpenseCategory(rs.getString("expense_category"));
        expense.setExpenseDescription(rs.getString("expense_description"));
        expense.setExpenseAmount(rs.getBigDecimal("expense_amount"));
        expense.setExpenseDate(rs.getDate("expense_date"));
        expense.setPaymentMode(rs.getString("payment_mode"));
        expense.setReceiptNumber(rs.getString("receipt_number"));
        expense.setVendorName(rs.getString("vendor_name"));
        expense.setRemarks(rs.getString("remarks"));
        expense.setCreatedBy(rs.getInt("created_by"));
        expense.setCreatedDate(rs.getTimestamp("created_date"));
        return expense;
    }
}

package com.election.servlet;

import com.election.dao.ExpenseDAO;
import com.election.model.Expense;
import com.election.model.User;
import com.election.model.Candidate;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

public class ExpenseServlet extends HttpServlet {
    
    private ExpenseDAO expenseDAO;
    
    @Override
    public void init() throws ServletException {
        expenseDAO = new ExpenseDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addExpense(request, response);
        } else if ("update".equals(action)) {
            updateExpense(request, response);
        } else if ("delete".equals(action)) {
            deleteExpense(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            // Forward to edit page - the JSP will handle loading the expense
            request.getRequestDispatcher("/user/edit-expense.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/expenses.jsp");
        }
    }
    
    private void addExpense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Get user and candidate from session
        User user = (User) session.getAttribute("user");
        Candidate candidate = (Candidate) session.getAttribute("candidate");
        
        // Check if user and candidate exist
        if (user == null || candidate == null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=Please select a candidate first");
            return;
        }
        
        // Get candidate ID and user ID from objects
        Integer candidateId = candidate.getCandidateId();
        Integer userId = user.getUserId();
        
        if (candidateId == null || userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=Invalid session data");
            return;
        }
        
        // Get form parameters
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String amountStr = request.getParameter("amount");
        String dateStr = request.getParameter("date");
        String paymentMode = request.getParameter("paymentMode");
        String receiptNumber = request.getParameter("receiptNumber");
        String vendorName = request.getParameter("vendorName");
        String remarks = request.getParameter("remarks");
        
        try {
            BigDecimal amount = new BigDecimal(amountStr);
            Date expenseDate = Date.valueOf(dateStr);
            
            Expense expense = new Expense();
            expense.setCandidateId(candidateId);
            expense.setExpenseCategory(category);
            expense.setExpenseDescription(description);
            expense.setExpenseAmount(amount);
            expense.setExpenseDate(expenseDate);
            expense.setPaymentMode(paymentMode);
            expense.setReceiptNumber(receiptNumber);
            expense.setVendorName(vendorName);
            expense.setRemarks(remarks);
            expense.setCreatedBy(userId);
            
            if (expenseDAO.addExpense(expense)) {
                response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?success=Expense added successfully! ₹" + String.format("%.2f", amount) + " for " + category);
            } else {
                response.sendRedirect(request.getContextPath() + "/user/add-expense.jsp?error=Failed to add expense");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/add-expense.jsp?error=Invalid data: " + e.getMessage());
        }
    }
    
    private void updateExpense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Candidate candidate = (Candidate) session.getAttribute("candidate");
        
        if (candidate == null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=Please select a candidate first");
            return;
        }
        
        Integer candidateId = candidate.getCandidateId();
        
        try {
            int expenseId = Integer.parseInt(request.getParameter("expenseId"));
            
            Expense expense = expenseDAO.getExpenseById(expenseId);
            if (expense != null && expense.getCandidateId() == candidateId) {
                expense.setExpenseCategory(request.getParameter("category"));
                expense.setExpenseDescription(request.getParameter("description"));
                expense.setExpenseAmount(new BigDecimal(request.getParameter("amount")));
                expense.setExpenseDate(Date.valueOf(request.getParameter("date")));
                expense.setPaymentMode(request.getParameter("paymentMode"));
                expense.setReceiptNumber(request.getParameter("receiptNumber"));
                expense.setVendorName(request.getParameter("vendorName"));
                expense.setRemarks(request.getParameter("remarks"));
                
                if (expenseDAO.updateExpense(expense)) {
                    response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?success=Expense updated successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?error=Failed to update expense");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?error=Invalid expense or unauthorized access");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?error=Invalid data: " + e.getMessage());
        }
    }
    
    private void deleteExpense(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Candidate candidate = (Candidate) session.getAttribute("candidate");
        
        if (candidate == null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=Please select a candidate first");
            return;
        }
        
        Integer candidateId = candidate.getCandidateId();
        
        try {
            int expenseId = Integer.parseInt(request.getParameter("expenseId"));
            
            Expense expense = expenseDAO.getExpenseById(expenseId);
            if (expense != null && expense.getCandidateId() == candidateId) {
                if (expenseDAO.deleteExpense(expenseId)) {
                    response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?success=Expense deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?error=Failed to delete expense");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?error=Invalid expense or unauthorized access");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/expenses.jsp?error=Invalid expense ID");
        }
    }
}

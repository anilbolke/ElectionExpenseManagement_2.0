package com.election.servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.election.dao.CandidateDAO;
import com.election.dao.ExpenseDAO;
import com.election.model.Candidate;
import com.election.model.Expense;
import com.election.model.User;
import com.election.util.PDFGeneratorProforma1;

/**
 * Servlet to generate Proforma-1 for specific date
 * Shows expenses incurred on a particular date
 */
public class GenerateProforma1Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Authentication check
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String candidateIdParam = request.getParameter("candidateId");
        String expenseDateParam = request.getParameter("expenseDate");
        
        if (candidateIdParam == null || candidateIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid candidate ID");
            return;
        }
        
        if (expenseDateParam == null || expenseDateParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/select-date-proforma1.jsp?candidateId=" + candidateIdParam + "&error=Date is required");
            return;
        }

        try {
            int candidateId = Integer.parseInt(candidateIdParam);
            
            // Parse the date
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = inputFormat.parse(expenseDateParam);
            Date expenseDate = new Date(utilDate.getTime());
            
            // Get candidate information
            CandidateDAO candidateDAO = new CandidateDAO();
            Candidate candidate = candidateDAO.getCandidateById(candidateId);

            if (candidate == null) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Candidate not found");
                return;
            }

            // Verify ownership
            if (candidate.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Unauthorized access");
                return;
            }

            // Get expenses for this candidate on the specified date
            ExpenseDAO expenseDAO = new ExpenseDAO();
            List<Expense> expenses = expenseDAO.getExpensesByDate(candidateId, expenseDate);
            
            // Debug logging
            System.out.println("DEBUG Proforma1: Candidate ID: " + candidateId);
            System.out.println("DEBUG Proforma1: Selected Date: " + expenseDateParam);
            System.out.println("DEBUG Proforma1: Expenses retrieved: " + (expenses != null ? expenses.size() : "null"));

            // Get real path to WebContent directory
            String contextPath = getServletContext().getRealPath("/");
            
            // Generate Proforma-1 HTML
            byte[] htmlData = PDFGeneratorProforma1.generateProforma1(candidate, expenses, expenseDate, contextPath);

            // Set response headers for HTML display
            response.setContentType("text/html; charset=UTF-8");
            response.setHeader("Content-Disposition", "inline; filename=Proforma1_" + 
                candidate.getCandidateName().replaceAll(" ", "_") + "_" + expenseDateParam + ".html");

            // Write HTML to response
            OutputStream out = response.getOutputStream();
            out.write(htmlData);
            out.flush();
            out.close();

        } catch (NumberFormatException e) {
            System.err.println("Invalid candidate ID format: " + candidateIdParam);
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid candidate ID");
        } catch (ParseException e) {
            System.err.println("Invalid date format: " + expenseDateParam);
            response.sendRedirect(request.getContextPath() + "/user/select-date-proforma1.jsp?candidateId=" + candidateIdParam + "&error=Invalid date format");
        } catch (Exception e) {
            System.err.println("Error generating Proforma-1: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Error generating report");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

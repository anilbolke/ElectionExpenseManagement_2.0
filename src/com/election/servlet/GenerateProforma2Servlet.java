package com.election.servlet;

import java.io.IOException;
import java.io.OutputStream;
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
import com.election.util.PDFGeneratorProforma2;

/**
 * Servlet to generate Proforma-2 (नमुना-२) from HTML template
 * Uses WebContent/Document/proforma2.html as template
 */
public class GenerateProforma2Servlet extends HttpServlet {
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
        
        if (candidateIdParam == null || candidateIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid candidate ID");
            return;
        }

        try {
            int candidateId = Integer.parseInt(candidateIdParam);
            
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

            // Get all expenses for this candidate
            ExpenseDAO expenseDAO = new ExpenseDAO();
            List<Expense> expenses = expenseDAO.getExpensesByCandidate(candidateId);
            
            // Debug logging
            System.out.println("DEBUG: Candidate ID: " + candidateId);
            System.out.println("DEBUG: Expenses retrieved: " + (expenses != null ? expenses.size() : "null"));
            if (expenses != null && !expenses.isEmpty()) {
                System.out.println("DEBUG: First expense category: " + expenses.get(0).getExpenseCategory());
            }

            // Get real path to WebContent directory
            String contextPath = getServletContext().getRealPath("/");
            
            // Generate Proforma-2 HTML from template
            byte[] htmlData = PDFGeneratorProforma2.generateProforma2(candidate, expenses, contextPath);

            // Set response headers for HTML display
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "inline; filename=proforma2_" + candidate.getCandidateName().replaceAll("\\s+", "_") + ".html");
            
            // Write HTML data to response
            OutputStream out = response.getOutputStream();
            out.write(htmlData);
            out.flush();
            out.close();

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid candidate ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Error generating Proforma-2: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

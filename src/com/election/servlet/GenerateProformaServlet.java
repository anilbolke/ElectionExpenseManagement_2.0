package com.election.servlet;

import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.election.dao.CandidateDAO;
import com.election.model.Candidate;
import com.election.model.User;
import com.election.util.PDFGeneratorSimple;

public class GenerateProformaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

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
            CandidateDAO candidateDAO = new CandidateDAO();
            Candidate candidate = candidateDAO.getCandidateById(candidateId);

            if (candidate == null) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Candidate not found");
                return;
            }

            // Verify that the candidate belongs to the logged-in user
            if (candidate.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Unauthorized access");
                return;
            }

            // Generate PDF (HTML format) - Simple clean format
            byte[] pdfData = PDFGeneratorSimple.generateSimpleProforma(candidate);

            // Set response headers for HTML display (user can print to PDF)
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            // Write HTML data to response
            OutputStream out = response.getOutputStream();
            out.write(pdfData);
            out.flush();
            out.close();

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid candidate ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Error generating PDF: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

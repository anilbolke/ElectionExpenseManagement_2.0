package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.model.Candidate;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/select-candidate")
public class SelectCandidateServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        // Clear candidate selection
        if ("clear".equals(action)) {
            session.removeAttribute("candidate");
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
            return;
        }
        
        // Select a candidate
        String candidateIdParam = request.getParameter("candidateId");
        if (candidateIdParam != null) {
            try {
                int candidateId = Integer.parseInt(candidateIdParam);
                CandidateDAO candidateDAO = new CandidateDAO();
                Candidate candidate = candidateDAO.getCandidateById(candidateId);
                
                // Verify the candidate belongs to the logged-in user
                if (candidate != null && candidate.getUserId() == user.getUserId()) {
                    // Check if payment is verified
                    if (candidate.isPaymentVerified() && "active".equals(candidate.getAccountStatus())) {
                        session.setAttribute("candidate", candidate);
                        response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?success=Candidate selected successfully");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/user/candidate-payment.jsp?candidateId=" + candidateId);
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=Invalid candidate");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?error=Invalid candidate ID");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

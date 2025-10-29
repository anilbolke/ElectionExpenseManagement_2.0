package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.dao.CandidateDAO;
import com.election.model.User;
import com.election.model.Candidate;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private CandidateDAO candidateDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        candidateDAO = new CandidateDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedLanguage = request.getParameter("selectedLanguage"); // Capture language from login page
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter username and password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Validate user
        User user = userDAO.validateUser(username.trim(), password);
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userRole", user.getUserRole());
            session.setAttribute("fullName", user.getFullName());
            
            // Preserve language preference from login page
            if (selectedLanguage != null && !selectedLanguage.trim().isEmpty()) {
                session.setAttribute("language", selectedLanguage);
                System.out.println("DEBUG: Language preference set to: " + selectedLanguage);
            }
            
            // Get candidate information for user and broker roles
            String role = user.getUserRole();
            
            if ("user".equals(role)) {
                try {
                    // Get candidates associated with this user (user_id)
                    List<Candidate> candidates = candidateDAO.getCandidatesByUserId(user.getUserId());
                    
                    if (candidates != null && !candidates.isEmpty()) {
                        // Store first candidate as default selected candidate
                        Candidate defaultCandidate = candidates.get(0);
                        session.setAttribute("candidate", defaultCandidate);
                        session.setAttribute("candidateId", defaultCandidate.getCandidateId());
                        session.setAttribute("candidateName", defaultCandidate.getCandidateName());
                        
                        System.out.println("DEBUG: Loaded candidate for user " + user.getUserId() + 
                                         ": " + defaultCandidate.getCandidateName() + 
                                         " (ID: " + defaultCandidate.getCandidateId() + ")");
                    } else {
                        System.out.println("DEBUG: No candidates found for user " + user.getUserId());
                    }
                } catch (Exception e) {
                    System.err.println("Error loading candidate information: " + e.getMessage());
                    e.printStackTrace();
                }
            } else if ("broker".equals(role)) {
                try {
                    // Get candidates assigned to this broker (broker_id)
                    List<Candidate> candidates = candidateDAO.getCandidatesByBroker(user.getUserId());
                    
                    if (candidates != null && !candidates.isEmpty()) {
                        // Store first candidate as default selected candidate
                        Candidate defaultCandidate = candidates.get(0);
                        session.setAttribute("candidate", defaultCandidate);
                        session.setAttribute("candidateId", defaultCandidate.getCandidateId());
                        session.setAttribute("candidateName", defaultCandidate.getCandidateName());
                        
                        System.out.println("DEBUG: Loaded candidate for broker " + user.getUserId() + 
                                         ": " + defaultCandidate.getCandidateName() + 
                                         " (ID: " + defaultCandidate.getCandidateId() + ")");
                    } else {
                        System.out.println("DEBUG: No candidates assigned to broker " + user.getUserId());
                    }
                } catch (Exception e) {
                    System.err.println("Error loading broker candidate information: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            // Redirect based on role
            if ("admin".equals(role)) {
                response.sendRedirect("admin/dashboard.jsp");
            } else if ("broker".equals(role)) {
                response.sendRedirect("broker/dashboard.jsp");
            } else if ("user".equals(role)) {
                response.sendRedirect("user/dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid user role");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}

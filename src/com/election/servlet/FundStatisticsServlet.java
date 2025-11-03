package com.election.servlet;

import com.election.model.Candidate;
import com.election.model.FundStatistics;
import com.election.model.User;
import com.election.util.FundMonitor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import org.json.JSONObject;

/**
 * Servlet to get fund statistics for selected candidate
 */
@WebServlet("/getFundStatistics")
public class FundStatisticsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Check authentication
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not authenticated\"}");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
        
        // Check if candidate is selected
        if (selectedCandidate == null) {
            response.getWriter().write("{\"error\": \"No candidate selected\"}");
            return;
        }
        
        // Get fund statistics
        FundMonitor monitor = new FundMonitor();
        FundStatistics stats = monitor.getFundStatistics(
            selectedCandidate.getCandidateId(), 
            selectedCandidate.getCandidateName()
        );
        
        // Convert to JSON and send response
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("candidateId", stats.getCandidateId());
        jsonResponse.put("candidateName", stats.getCandidateName());
        jsonResponse.put("totalFunds", stats.getTotalFunds());
        jsonResponse.put("totalExpenses", stats.getTotalExpenses());
        jsonResponse.put("remainingFunds", stats.getRemainingFunds());
        jsonResponse.put("usagePercentage", stats.getUsagePercentage());
        jsonResponse.put("alertLevel", stats.getAlertLevel());
        jsonResponse.put("alertMessage", stats.getAlertMessage());
        jsonResponse.put("hasAlert", stats.hasAlert());
        
        response.getWriter().write(jsonResponse.toString());
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

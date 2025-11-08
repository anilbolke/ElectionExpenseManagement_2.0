package com.election.servlet;

import com.election.dao.UserDAO;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/check-username")
public class CheckUsernameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        
        JSONObject jsonResponse = new JSONObject();
        
        try {
            if (username == null || username.trim().isEmpty()) {
                jsonResponse.put("available", false);
                jsonResponse.put("message", "Username cannot be empty");
            } else {
                username = username.trim().toLowerCase();
                
                // Validate username format
                if (!username.matches("^[a-z0-9_]{4,30}$")) {
                    jsonResponse.put("available", false);
                    jsonResponse.put("message", "Invalid username format");
                } else {
                    // Check if username exists in database
                    boolean exists = userDAO.isUsernameExists(username);
                    jsonResponse.put("available", !exists);
                    
                    if (exists) {
                        jsonResponse.put("message", "Username already taken");
                    } else {
                        jsonResponse.put("message", "Username is available");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("available", false);
            jsonResponse.put("message", "Error checking username availability");
        }
        
        PrintWriter out = response.getWriter();
        out.print(jsonResponse.toString());
        out.flush();
    }
}

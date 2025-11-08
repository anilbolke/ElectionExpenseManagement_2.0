package com.election.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.election.model.User;
import com.election.util.SMSUtil;
import org.json.JSONObject;

@WebServlet("/SendSMSServlet")
public class SendSMSServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Check if admin is logged in
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                JSONObject json = new JSONObject();
                json.put("success", false);
                json.put("message", "Unauthorized access");
                out.print(json.toString());
                return;
            }
            
            User user = (User) session.getAttribute("user");
            if (!"admin".equals(user.getUserRole())) {
                JSONObject json = new JSONObject();
                json.put("success", false);
                json.put("message", "Only admin can send SMS");
                out.print(json.toString());
                return;
            }
            
            // Get parameters
            String mobile = request.getParameter("mobile");
            String message = request.getParameter("message");
            
            // Validate input
            if (mobile == null || mobile.trim().isEmpty()) {
                JSONObject json = new JSONObject();
                json.put("success", false);
                json.put("message", "Mobile number is required");
                out.print(json.toString());
                return;
            }
            
            if (message == null || message.trim().isEmpty()) {
                JSONObject json = new JSONObject();
                json.put("success", false);
                json.put("message", "Message content is required");
                out.print(json.toString());
                return;
            }
            
            // Send SMS
            boolean sent = SMSUtil.sendSMS(mobile, message);
            
            JSONObject json = new JSONObject();
            if (sent) {
                json.put("success", true);
                json.put("message", "SMS sent successfully");
            } else {
                json.put("success", false);
                json.put("message", "Failed to send SMS. Please try again.");
            }
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject json = new JSONObject();
            json.put("success", false);
            json.put("message", "Error: " + e.getMessage());
            out.print(json.toString());
        } finally {
            out.flush();
        }
    }
}

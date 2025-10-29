<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.dao.SystemSettingsDAO" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get parameter
    String feeStr = request.getParameter("fee");
    
    // Debug logging
    System.out.println("=== UPDATE CANDIDATE FEE DEBUG ===");
    System.out.println("Fee received: " + feeStr);
    
    try {
        if (feeStr != null && !feeStr.trim().isEmpty()) {
            double fee = Double.parseDouble(feeStr.trim());
            
            System.out.println("Parsed Fee: " + fee);
            
            // Validate fee
            if (fee < 0) {
                System.out.println("ERROR: Fee is negative");
                response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Fee cannot be negative", "UTF-8"));
                return;
            }
            
            // Save to database using SystemSettingsDAO
            SystemSettingsDAO settingsDAO = new SystemSettingsDAO();
            String feeValue = String.format("%.2f", fee);
            boolean updated = settingsDAO.updateSetting(
                "candidate_registration_fee", 
                feeValue,
                "One-time candidate registration fee",
                user.getUserId()
            );
            
            System.out.println("Update result: " + updated);
            
            if (updated) {
                String successMsg = "Candidate registration fee updated successfully to ₹" + feeValue;
                System.out.println("SUCCESS: " + successMsg);
                response.sendRedirect("manage-payments.jsp?success=" + java.net.URLEncoder.encode(successMsg, "UTF-8"));
            } else {
                System.out.println("ERROR: Update failed");
                response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Failed to update fee. Please try again.", "UTF-8"));
            }
            
        } else {
            System.out.println("ERROR: Missing fee parameter");
            response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Missing fee parameter", "UTF-8"));
        }
    } catch (NumberFormatException e) {
        System.out.println("ERROR: NumberFormatException - " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Invalid fee format: " + e.getMessage(), "UTF-8"));
    } catch (Exception e) {
        System.out.println("ERROR: Exception - " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
    }
    System.out.println("=== END DEBUG ===");
%>

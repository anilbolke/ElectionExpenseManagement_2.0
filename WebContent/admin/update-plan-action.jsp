<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.model.User, com.election.dao.SubscriptionDAO, java.math.BigDecimal" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get parameters
    String planIdStr = request.getParameter("planId");
    String priceStr = request.getParameter("price");
    
    // Debug logging
    System.out.println("=== UPDATE PLAN ACTION DEBUG ===");
    System.out.println("Plan ID received: " + planIdStr);
    System.out.println("Price received: " + priceStr);
    
    try {
        if (planIdStr != null && priceStr != null && !planIdStr.trim().isEmpty() && !priceStr.trim().isEmpty()) {
            int planId = Integer.parseInt(planIdStr.trim());
            BigDecimal price = new BigDecimal(priceStr.trim());
            
            System.out.println("Parsed Plan ID: " + planId);
            System.out.println("Parsed Price: " + price);
            
            // Validate price
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                System.out.println("ERROR: Price is negative");
                response.sendRedirect("manage-payments.jsp?error=Price cannot be negative");
                return;
            }
            
            // Update the plan price
            System.out.println("Creating SubscriptionDAO...");
            SubscriptionDAO subscriptionDAO = new SubscriptionDAO();
            
            System.out.println("Calling updatePlanPrice...");
            boolean updated = subscriptionDAO.updatePlanPrice(planId, price);
            System.out.println("Update result: " + updated);
            
            if (updated) {
                String successMsg = "Subscription plan price updated successfully! New price: ₹" + price;
                System.out.println("SUCCESS: " + successMsg);
                response.sendRedirect("manage-payments.jsp?success=" + java.net.URLEncoder.encode(successMsg, "UTF-8"));
            } else {
                System.out.println("ERROR: Update returned false");
                response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Failed to update plan price. Please try again.", "UTF-8"));
            }
        } else {
            System.out.println("ERROR: Missing parameters");
            System.out.println("planIdStr is null: " + (planIdStr == null));
            System.out.println("priceStr is null: " + (priceStr == null));
            response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Missing required parameters", "UTF-8"));
        }
    } catch (NumberFormatException e) {
        System.out.println("ERROR: NumberFormatException - " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("Invalid number format: " + e.getMessage(), "UTF-8"));
    } catch (Exception e) {
        System.out.println("ERROR: Exception - " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("manage-payments.jsp?error=" + java.net.URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
    }
    System.out.println("=== END DEBUG ===");
%>

package com.election.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import com.election.model.User;
import com.election.dao.SubscriptionDAO;

public class SubscriptionFilter implements Filter {
    
    private SubscriptionDAO subscriptionDAO;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        subscriptionDAO = new SubscriptionDAO();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Get the requested URI
        String requestURI = httpRequest.getRequestURI();
        
        // Allow access to subscription pages and logout
        if (requestURI.contains("/subscription") || 
            requestURI.contains("/logout") ||
            requestURI.contains("/payment")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Admin and Broker users don't need subscription
        if ("admin".equals(user.getUserRole()) || "broker".equals(user.getUserRole())) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user's subscription is active (for regular users)
        if ("user".equals(user.getUserRole())) {
            boolean isActive = subscriptionDAO.isSubscriptionActive(user.getUserId());
            
            if (!isActive) {
                // Redirect to subscription page if subscription is not active
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/user/subscription.jsp");
                return;
            }
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        subscriptionDAO = null;
    }
}

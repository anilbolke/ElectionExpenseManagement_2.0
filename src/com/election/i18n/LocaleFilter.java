package com.election.i18n;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Filter to set up locale for each request
 */
public class LocaleFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        // Ensure locale is initialized
        LocaleManager.getLocale(httpRequest);
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

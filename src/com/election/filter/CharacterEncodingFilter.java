package com.election.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Filter to ensure UTF-8 encoding for all requests and responses
 * This enables multi-language input support
 */
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    private boolean forceEncoding = true;
    
    @Override
    public void init(FilterConfig config) throws ServletException {
        String encodingParam = config.getInitParameter("encoding");
        if (encodingParam != null) {
            encoding = encodingParam;
        }
        
        String forceParam = config.getInitParameter("forceEncoding");
        if (forceParam != null) {
            forceEncoding = Boolean.parseBoolean(forceParam);
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Set request encoding
        if (forceEncoding || request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(encoding);
        }
        
        // Set response encoding
        response.setCharacterEncoding(encoding);
        httpResponse.setContentType("text/html; charset=" + encoding);
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

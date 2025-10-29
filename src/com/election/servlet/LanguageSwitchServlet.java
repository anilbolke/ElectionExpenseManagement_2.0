package com.election.servlet;

import com.election.i18n.LocaleManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet to handle language switching
 */
@WebServlet("/switchLanguage")
public class LanguageSwitchServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String language = request.getParameter("lang");
        String redirectUrl = request.getParameter("redirect");
        
        if (language != null && !language.isEmpty()) {
            LocaleManager.setLocale(request, language);
        }
        
        // Redirect back to previous page or dashboard
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            String referer = request.getHeader("Referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

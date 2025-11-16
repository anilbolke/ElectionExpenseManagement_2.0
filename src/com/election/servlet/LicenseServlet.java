package com.election.servlet;

import com.election.dao.CandidateDAO;
import com.election.dao.LicenseDAO;
import com.election.model.Candidate;
import com.election.model.License;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * LicenseServlet - Handle license generation and verification
 * 
 * Actions:
 * - generate: Admin generates multiple licenses
 * - verify: User verifies and uses license for payment bypass
 * 
 * @author System Generated
 * @date 2025-11-16
 */
@WebServlet("/LicenseServlet")
public class LicenseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        switch (action) {
            case "generate":
                handleGenerateLicenses(request, response, user);
                break;
                
            case "verify":
                handleVerifyLicense(request, response, user);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    /**
     * Generate licenses (Admin only)
     */
    private void handleGenerateLicenses(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        
        // Check if user is admin
        if (!"admin".equals(user.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized+access");
            return;
        }
        
        try {
            String countStr = request.getParameter("count");
            
            if (countStr == null || countStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-licenses.jsp?error=Please+specify+license+count");
                return;
            }
            
            int count = Integer.parseInt(countStr);
            
            if (count < 1 || count > 1000) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-licenses.jsp?error=Count+must+be+between+1+and+1000");
                return;
            }
            
            LicenseDAO licenseDAO = new LicenseDAO();
            List<String> generatedKeys = licenseDAO.generateLicenses(count, user.getUserId());
            
            if (generatedKeys != null && !generatedKeys.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("generatedLicenses", generatedKeys);
                response.sendRedirect(request.getContextPath() + "/admin/manage-licenses.jsp?success=Generated+" + count + "+licenses");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-licenses.jsp?error=Failed+to+generate+licenses");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-licenses.jsp?error=Invalid+count+format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manage-licenses.jsp?error=Error+generating+licenses");
        }
    }
    
    /**
     * Verify and use license (User)
     */
    private void handleVerifyLicense(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        
        try {
            String licenseKey = request.getParameter("licenseKey");
            String candidateIdStr = request.getParameter("candidateId");
            
            if (licenseKey == null || licenseKey.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user/payment-with-license.jsp?candidateId=" + 
                                    candidateIdStr + "&error=Please+enter+license+key");
                return;
            }
            
            if (candidateIdStr == null || candidateIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid+candidate");
                return;
            }
            
            int candidateId = Integer.parseInt(candidateIdStr);
            
            // Verify candidate belongs to user
            CandidateDAO candidateDAO = new CandidateDAO();
            Candidate candidate = candidateDAO.getCandidateById(candidateId);
            
            if (candidate == null || candidate.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Candidate+not+found");
                return;
            }
            
            // Verify license
            LicenseDAO licenseDAO = new LicenseDAO();
            License license = licenseDAO.verifyLicense(licenseKey.trim().toUpperCase());
            
            if (license == null) {
                response.sendRedirect(request.getContextPath() + "/user/payment-with-license.jsp?candidateId=" + 
                                    candidateId + "&error=Invalid+or+already+used+license");
                return;
            }
            
            // Use license and mark payment as complete
            boolean licenseUsed = licenseDAO.useLicense(licenseKey.trim().toUpperCase(), user.getUserId(), candidateId);
            
            if (licenseUsed) {
                // Update candidate payment status
                boolean updated = candidateDAO.updatePaymentStatus(
                    candidateId,
                    "completed",
                    "LICENSE_" + licenseKey.trim().toUpperCase(),
                    true,
                    "active"
                );
                
                if (updated) {
                    System.out.println("✓ Payment completed using license: " + licenseKey);
                    // Redirect to user dashboard with success message
                    response.sendRedirect(request.getContextPath() + 
                        "/user/dashboard.jsp?success=Payment+bypassed+successfully+using+license+" + 
                        licenseKey.trim().toUpperCase() + ".+Candidate+activated!");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/payment-with-license.jsp?candidateId=" + 
                                        candidateId + "&error=Failed+to+update+payment+status");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/user/payment-with-license.jsp?candidateId=" + 
                                    candidateId + "&error=Failed+to+use+license");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Invalid+candidate+ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/manage-candidates.jsp?error=Error+processing+license");
        }
    }
}

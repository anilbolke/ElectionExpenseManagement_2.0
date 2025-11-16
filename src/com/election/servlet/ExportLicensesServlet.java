package com.election.servlet;

import com.election.dao.LicenseDAO;
import com.election.model.License;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * ExportLicensesServlet - Export unused licenses to Excel/CSV
 * 
 * @author System Generated
 * @date 2025-11-16
 */
@WebServlet("/ExportLicensesServlet")
public class ExportLicensesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get format parameter (csv or excel)
        String format = request.getParameter("format");
        if (format == null || format.isEmpty()) {
            format = "csv"; // Default to CSV
        }
        
        try {
            LicenseDAO licenseDAO = new LicenseDAO();
            List<License> unusedLicenses = licenseDAO.getUnusedLicenses();
            
            if (format.equalsIgnoreCase("excel") || format.equalsIgnoreCase("xls")) {
                exportToExcel(response, unusedLicenses);
            } else {
                exportToCSV(response, unusedLicenses);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin/manage-licenses.jsp?error=Failed+to+export+licenses");
        }
    }
    
    /**
     * Export licenses to CSV format (only license keys)
     */
    private void exportToCSV(HttpServletResponse response, List<License> licenses) 
            throws IOException {
        
        // Set response headers
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"unused_licenses_" + System.currentTimeMillis() + ".csv\"");
        
        PrintWriter writer = response.getWriter();
        
        // Write CSV header
        writer.println("License Key");
        
        // Write data rows (only license keys)
        for (License license : licenses) {
            writer.println(license.getLicenseKey());
        }
        
        writer.flush();
        writer.close();
        
        System.out.println("✓ Exported " + licenses.size() + " license keys to CSV");
    }
    
    /**
     * Export licenses to Excel format (only license keys)
     */
    private void exportToExcel(HttpServletResponse response, List<License> licenses) 
            throws IOException {
        
        // Set response headers for Excel
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"unused_licenses_" + System.currentTimeMillis() + ".xls\"");
        
        PrintWriter writer = response.getWriter();
        
        // Write HTML table (Excel can open HTML tables)
        writer.println("<?xml version=\"1.0\"?>");
        writer.println("<?mso-application progid=\"Excel.Sheet\"?>");
        writer.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        writer.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        writer.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        writer.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        writer.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        writer.println("<Worksheet ss:Name=\"Unused Licenses\">");
        writer.println("<Table>");
        
        // Header row
        writer.println("<Row>");
        writer.println("<Cell><Data ss:Type=\"String\">License Key</Data></Cell>");
        writer.println("</Row>");
        
        // Data rows (only license keys)
        for (License license : licenses) {
            writer.println("<Row>");
            writer.printf("<Cell><Data ss:Type=\"String\">%s</Data></Cell>%n", 
                escapeXml(license.getLicenseKey()));
            writer.println("</Row>");
        }
        
        writer.println("</Table>");
        writer.println("</Worksheet>");
        writer.println("</Workbook>");
        
        writer.flush();
        writer.close();
        
        System.out.println("✓ Exported " + licenses.size() + " license keys to Excel");
    }
    
    /**
     * Escape XML special characters
     */
    private String escapeXml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&apos;");
    }
}

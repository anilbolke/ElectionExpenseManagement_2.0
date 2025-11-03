package com.election.util;

import com.election.model.Candidate;
import com.election.model.Expense;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Generates Proforma-2 PDF from template with dynamic data
 * Template: WebContent/Document/proforma2.html
 */
public class PDFGeneratorProforma2 {
    
    private static final String TEMPLATE_PATH = "Document/proforma2.html";
    
    /**
     * Generate Proforma-2 HTML with dynamic data from template
     * @param candidate Candidate information
     * @param expenses List of expenses
     * @param contextPath Application context path
     * @return byte array of generated HTML
     */
    public static byte[] generateProforma2(Candidate candidate, List<Expense> expenses, String contextPath) throws IOException {
        String template = loadTemplate(contextPath);
        String html = replaceTemplatePlaceholders(template, candidate, expenses);
        return html.getBytes("UTF-8");
    }
    
    /**
     * Load HTML template from file
     */
    private static String loadTemplate(String contextPath) throws IOException {
        String fullPath;
        
        if (contextPath != null && !contextPath.isEmpty()) {
            // Running in servlet context - contextPath is the real path to WebContent
            // Ensure proper path separator
            if (!contextPath.endsWith("/") && !contextPath.endsWith("\\")) {
                contextPath += System.getProperty("file.separator");
            }
            fullPath = contextPath + TEMPLATE_PATH.replace("/", System.getProperty("file.separator"));
        } else {
            // Fallback to relative path
            fullPath = TEMPLATE_PATH;
        }
        
        System.out.println("Attempting to load template from: " + fullPath);
        
        try {
            String content = new String(Files.readAllBytes(Paths.get(fullPath)), "UTF-8");
            System.out.println("Template loaded successfully. Size: " + content.length() + " bytes");
            return content;
        } catch (Exception e) {
            // Log error and return default template
            System.err.println("ERROR: Template not found at: " + fullPath);
            System.err.println("Context path was: " + contextPath);
            System.err.println("Template path constant: " + TEMPLATE_PATH);
            e.printStackTrace();
            return getDefaultTemplate();
        }
    }
    
    /**
     * Replace all {{placeholders}} with actual data
     */
    private static String replaceTemplatePlaceholders(String template, Candidate candidate, List<Expense> expenses) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String today = dateFormat.format(new Date());
        
        // Basic candidate information
        template = template.replace("{{candidate_name}}", escapeHtml(candidate.getCandidateName()));
        template = template.replace("{{party_name}}", escapeHtml(candidate.getPartyName() != null ? candidate.getPartyName() : "अपक्ष / Independent"));
        template = template.replace("{{district_name}}", escapeHtml(candidate.getCity()));
        template = template.replace("{{local_body_name}}", escapeHtml(candidate.getConstituency()));
        template = template.replace("{{ward_number}}", escapeHtml(candidate.getBoothNumber() != null ? candidate.getBoothNumber() : ""));
        template = template.replace("{{seat_number}}", escapeHtml(candidate.getNominationId() != null ? candidate.getNominationId() : ""));
        
        // Election details
        template = template.replace("{{public_post_election}}", escapeHtml(candidate.getElectionType()));
        template = template.replace("{{election_date}}", candidate.getElectionDate() != null ? dateFormat.format(candidate.getElectionDate()) : "");
        template = template.replace("{{report_date}}", today);
        
        // QR Code - Generate URL to candidate profile
        String qrCodeUrl = generateQRCodeDataUrl(candidate);
        template = template.replace("{{qr_code_src}}", qrCodeUrl);
        
        // Generate expense rows
        StringBuilder expenseRowsHtml = new StringBuilder();
        double totalCandidate = 0;
        double totalParty = 0;
        double totalOthers = 0;
        
        // Debug logging
        System.out.println("DEBUG PDFGenerator: Processing " + (expenses != null ? expenses.size() : "null") + " expenses");
        
        if (expenses != null && !expenses.isEmpty()) {
            int serialNo = 1;
            System.out.println("DEBUG PDFGenerator: Generating expense rows...");
            for (Expense expense : expenses) {
                expenseRowsHtml.append("<tr>\n");
                expenseRowsHtml.append("  <td>").append(serialNo++).append("</td>").append("                           <!-- Serial -->\n");
                expenseRowsHtml.append("  <td>").append(escapeHtml(expense.getExpenseCategory())).append("</td>").append("              <!-- Category -->\n");
                expenseRowsHtml.append("  <td>").append(escapeHtml(expense.getExpenseDescription())).append("</td>").append("                 <!-- Description -->\n");
                expenseRowsHtml.append("  <td>").append(expense.getExpenseAmount() != null ? "₹" + String.format("%.2f", expense.getExpenseAmount().doubleValue()) : "-").append("</td>").append("                    <!-- Amount -->\n");
                expenseRowsHtml.append("  <td>").append(expense.getExpenseDate() != null ? dateFormat.format(expense.getExpenseDate()) : "").append("</td>").append("                  <!-- Date -->\n");
                expenseRowsHtml.append("  <td>").append(escapeHtml(expense.getReceiptNumber() != null ? expense.getReceiptNumber() : "-")).append("</td>").append("                     <!-- Receipt -->\n");
                
                // Determine expense type and populate columns
                String expenseType = expense.getPaymentMode() != null ? expense.getPaymentMode() : "self";
                double amount = expense.getExpenseAmount() != null ? expense.getExpenseAmount().doubleValue() : 0;
                
                // Column 7: Person Name - based on payment mode
                String personName = "";
                if ("party".equalsIgnoreCase(expenseType)) {
                    personName = candidate.getPartyName() != null ? candidate.getPartyName() : "पक्ष / Party";
                    expenseRowsHtml.append("  <td>").append(escapeHtml(personName)).append("</td>").append("                 <!-- Person (party) -->\n");
                    expenseRowsHtml.append("  <td>-</td>").append("                           <!-- Self expense -->\n");
                    expenseRowsHtml.append("  <td>₹").append(String.format("%.2f", amount)).append("</td>").append("                    <!-- Party expense -->\n");
                    expenseRowsHtml.append("  <td>-</td>").append("                           <!-- Others expense -->\n");
                    totalParty += amount;
                } else if ("others".equalsIgnoreCase(expenseType)) {
                    // Use vendorName if available, otherwise "इतर / Others"
                    personName = (expense.getVendorName() != null && !expense.getVendorName().trim().isEmpty()) 
                                  ? expense.getVendorName() 
                                  : "इतर / Others";
                    expenseRowsHtml.append("  <td>").append(escapeHtml(personName)).append("</td>").append("                 <!-- Person (others) -->\n");
                    expenseRowsHtml.append("  <td>-</td>").append("                           <!-- Self expense -->\n");
                    expenseRowsHtml.append("  <td>-</td>").append("                           <!-- Party expense -->\n");
                    expenseRowsHtml.append("  <td>₹").append(String.format("%.2f", amount)).append("</td>").append("                    <!-- Others expense -->\n");
                    totalOthers += amount;
                } else {
                    // Self - use candidate name
                    personName = candidate.getCandidateName();
                    expenseRowsHtml.append("  <td>").append(escapeHtml(personName)).append("</td>").append("                 <!-- Person (candidate) -->\n");
                    expenseRowsHtml.append("  <td>₹").append(String.format("%.2f", amount)).append("</td>").append("                    <!-- Self expense -->\n");
                    expenseRowsHtml.append("  <td>-</td>").append("                           <!-- Party expense -->\n");
                    expenseRowsHtml.append("  <td>-</td>").append("                           <!-- Others expense -->\n");
                    totalCandidate += amount;
                }
                
                expenseRowsHtml.append("</tr>\n");
            }
        } else {
            // No expenses - add empty row with message
            expenseRowsHtml.append("<tr>\n");
            expenseRowsHtml.append("  <td colspan='10' style='text-align:center; padding:20px; color:#999;'>कोणताही खर्च नोंदवला नाही / No expenses recorded</td>\n");
            expenseRowsHtml.append("</tr>\n");
        }
        
        // Replace expense rows loop (using Pattern.DOTALL to match across newlines)
        System.out.println("DEBUG PDFGenerator: Replacing template loop with " + expenseRowsHtml.length() + " chars of HTML");
        template = template.replaceAll("(?s)\\{\\{#each expense_rows\\}\\}.*?\\{\\{/each\\}\\}", 
                                        java.util.regex.Matcher.quoteReplacement(expenseRowsHtml.toString()));
        
        // Calculate and replace total
        double grandTotal = totalCandidate + totalParty + totalOthers;
        template = template.replace("{{total_expense}}", "₹" + String.format("%.2f", grandTotal));
        
        return template;
    }
    
    /**
     * Generate QR code as data URL
     * For now returns a placeholder, can be enhanced with actual QR generation
     */
    private static String generateQRCodeDataUrl(Candidate candidate) {
        // Simple placeholder - can integrate with QR library like ZXing
        // Returns a 1x1 transparent PNG as base64
        return "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";
    }
    
    /**
     * Get default template if file not found
     */
    private static String getDefaultTemplate() {
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html><head><meta charset='UTF-8'>");
        html.append("<title>Template Error</title>");
        html.append("<style>body{font-family:Arial,sans-serif;padding:40px;background:#f5f5f5;}");
        html.append(".error-box{background:white;padding:30px;border-radius:8px;box-shadow:0 2px 4px rgba(0,0,0,0.1);max-width:800px;margin:0 auto;}");
        html.append("h1{color:#d32f2f;margin-bottom:20px;}");
        html.append(".info{background:#e3f2fd;padding:15px;margin:15px 0;border-radius:4px;}");
        html.append("pre{background:#f5f5f5;padding:10px;overflow-x:auto;border-radius:4px;}</style>");
        html.append("</head><body>");
        html.append("<div class='error-box'>");
        html.append("<h1>⚠️ Template File Not Found</h1>");
        html.append("<p>The proforma2.html template could not be loaded.</p>");
        html.append("<div class='info'>");
        html.append("<strong>Expected Location:</strong><br>");
        html.append("<pre>WebContent/Document/proforma2.html</pre>");
        html.append("</div>");
        html.append("<div class='info'>");
        html.append("<strong>Troubleshooting Steps:</strong><br>");
        html.append("1. Verify the file exists in WebContent/Document/<br>");
        html.append("2. Check file permissions (read access)<br>");
        html.append("3. Restart the server<br>");
        html.append("4. Check server logs for the actual path being used<br>");
        html.append("</div>");
        html.append("<p style='margin-top:20px;color:#666;font-size:14px;'>Check server console output for detailed path information.</p>");
        html.append("</div>");
        html.append("</body></html>");
        return html.toString();
    }
    
    /**
     * Escape HTML special characters
     */
    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}

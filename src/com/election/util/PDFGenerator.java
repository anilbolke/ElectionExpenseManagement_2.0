package com.election.util;

import com.election.model.Candidate;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGenerator {
    
    private static final String HEADER_COLOR = "#2c3e50";
    private static final String ACCENT_COLOR = "#3498db";
    
    /**
     * Generates a PDF document for candidate proforma/scan document
     * This creates an HTML-based PDF that can be printed or saved
     * @param candidate The candidate object containing all details
     * @return byte array containing the PDF data
     */
    public static byte[] generateCandidateProforma(Candidate candidate) throws IOException {
        StringBuilder html = new StringBuilder();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
        
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>Candidate Proforma - ").append(escapeHtml(candidate.getCandidateName())).append("</title>");
        html.append("<style>");
        html.append("body { font-family: 'Arial', sans-serif; margin: 20px; color: #333; }");
        html.append(".header { background: ").append(HEADER_COLOR).append("; color: white; padding: 20px; text-align: center; margin-bottom: 20px; }");
        html.append(".header h1 { margin: 0; font-size: 24px; }");
        html.append(".header p { margin: 5px 0; font-size: 12px; }");
        html.append(".section { margin-bottom: 25px; border: 2px solid ").append(ACCENT_COLOR).append("; border-radius: 8px; padding: 15px; }");
        html.append(".section-title { background: ").append(ACCENT_COLOR).append("; color: white; padding: 8px 15px; margin: -15px -15px 15px -15px; font-size: 16px; font-weight: bold; border-radius: 5px 5px 0 0; }");
        html.append(".field-row { display: table; width: 100%; margin-bottom: 10px; }");
        html.append(".field-label { display: table-cell; width: 35%; font-weight: bold; color: #555; padding: 5px; }");
        html.append(".field-value { display: table-cell; width: 65%; padding: 5px; border-bottom: 1px dotted #ccc; }");
        html.append(".photo-box { float: right; width: 150px; height: 180px; border: 2px solid ").append(ACCENT_COLOR).append("; margin-left: 20px; text-align: center; padding: 10px; background: #f9f9f9; }");
        html.append(".photo-placeholder { width: 100%; height: 140px; background: #e0e0e0; display: flex; align-items: center; justify-content: center; color: #888; font-size: 12px; }");
        html.append(".footer { margin-top: 30px; padding-top: 15px; border-top: 2px solid #ccc; text-align: center; font-size: 11px; color: #666; }");
        html.append(".signature-box { margin-top: 30px; display: inline-block; width: 200px; border-top: 2px solid #333; text-align: center; padding-top: 5px; }");
        html.append(".watermark { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-45deg); font-size: 120px; color: rgba(0,0,0,0.05); z-index: -1; font-weight: bold; }");
        html.append(".print-btn { position: fixed; top: 20px; right: 20px; background: #667eea; color: white; padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600; box-shadow: 0 4px 8px rgba(0,0,0,0.2); z-index: 1000; }");
        html.append(".print-btn:hover { background: #5568d3; transform: translateY(-2px); box-shadow: 0 6px 12px rgba(0,0,0,0.3); }");
        html.append("@media print { body { margin: 0; } .no-print { display: none; } }");
        html.append("</style>");
        html.append("<script>");
        html.append("function printDocument() { window.print(); }");
        html.append("</script>");
        html.append("</head>");
        html.append("<body>");
        
        // Add print button
        html.append("<button onclick='printDocument()' class='print-btn no-print'>🖨️ Print to PDF</button>");
        
        // Watermark
        html.append("<div class='watermark'>ELECTION PROFORMA</div>");
        
        // Header
        html.append("<div class='header'>");
        html.append("<h1>ELECTION EXPENSE MANAGEMENT SYSTEM</h1>");
        html.append("<p>Candidate Registration Proforma & Official Document</p>");
        html.append("<p>Document Generated: ").append(timeFormat.format(new Date())).append("</p>");
        html.append("</div>");
        
        // Personal Information Section
        html.append("<div class='section'>");
        html.append("<div class='section-title'>PERSONAL INFORMATION</div>");
        
        // Photo placeholder
        html.append("<div class='photo-box'>");
        html.append("<div class='photo-placeholder'>CANDIDATE<br>PHOTOGRAPH</div>");
        html.append("<small>Affix recent<br>passport size photo</small>");
        html.append("</div>");
        
        addField(html, "Candidate ID", String.valueOf(candidate.getCandidateId()));
        addField(html, "Full Name", candidate.getCandidateName());
        addField(html, "Father's Name", candidate.getFatherName());
        addField(html, "Age", String.valueOf(candidate.getAge()) + " years");
        addField(html, "Gender", candidate.getGender());
        addField(html, "Mobile Number", candidate.getMobile());
        addField(html, "Email Address", candidate.getEmail());
        html.append("<div style='clear:both;'></div>");
        html.append("</div>");
        
        // Address Information Section
        html.append("<div class='section'>");
        html.append("<div class='section-title'>ADDRESS DETAILS</div>");
        addField(html, "Residential Address", candidate.getAddress());
        addField(html, "City", candidate.getCity());
        addField(html, "State", candidate.getState());
        addField(html, "Pin Code", candidate.getPincode());
        html.append("</div>");
        
        // Identity Documents Section
        html.append("<div class='section'>");
        html.append("<div class='section-title'>IDENTITY DOCUMENTS</div>");
        addField(html, "Aadhar Number", maskAadhar(candidate.getAadharNumber()));
        addField(html, "Voter ID", candidate.getVoterId());
        html.append("</div>");
        
        // Election Details Section
        html.append("<div class='section'>");
        html.append("<div class='section-title'>ELECTION PROGRAM DETAILS</div>");
        addField(html, "Constituency", candidate.getConstituency());
        addField(html, "Nomination ID", candidate.getNominationId());
        addField(html, "Party Name", candidate.getPartyName());
        addField(html, "Party Symbol", candidate.getPartySymbol());
        addField(html, "Election Type", candidate.getElectionType());
        if (candidate.getElectionDate() != null) {
            addField(html, "Election Date", dateFormat.format(candidate.getElectionDate()));
        }
        addField(html, "Booth Number", candidate.getBoothNumber());
        if (candidate.getExpenseLimit() != null) {
            addField(html, "Expense Limit", "₹ " + candidate.getExpenseLimit().toString());
        }
        html.append("</div>");
        
        // Payment & Account Status Section
        html.append("<div class='section'>");
        html.append("<div class='section-title'>PAYMENT & ACCOUNT STATUS</div>");
        addField(html, "Account Status", formatStatus(candidate.getAccountStatus()));
        addField(html, "Payment Status", formatStatus(candidate.getPaymentStatus()));
        if (candidate.getPaymentAmount() != null) {
            addField(html, "Payment Amount", "₹ " + candidate.getPaymentAmount().toString());
        }
        if (candidate.getPaymentDate() != null) {
            addField(html, "Payment Date", timeFormat.format(candidate.getPaymentDate()));
        }
        if (candidate.getTransactionId() != null && !candidate.getTransactionId().isEmpty()) {
            addField(html, "Transaction ID", candidate.getTransactionId());
        }
        addField(html, "Payment Verified", candidate.isPaymentVerified() ? "Yes ✓" : "Pending");
        html.append("</div>");
        
        // Declaration and Signature Section
        html.append("<div class='section'>");
        html.append("<div class='section-title'>DECLARATION</div>");
        html.append("<p style='line-height: 1.6; text-align: justify;'>");
        html.append("I, <strong>").append(escapeHtml(candidate.getCandidateName())).append("</strong>, ");
        html.append("hereby declare that the information provided above is true and correct to the best of my knowledge. ");
        html.append("I understand that any false information may lead to cancellation of my candidature and legal action. ");
        html.append("I agree to abide by the election rules and regulations set forth by the Election Commission.");
        html.append("</p>");
        
        html.append("<div style='margin-top: 40px; display: flex; justify-content: space-between;'>");
        html.append("<div class='signature-box'>Candidate's Signature</div>");
        html.append("<div style='text-align: center;'><strong>Date: ").append(dateFormat.format(new Date())).append("</strong></div>");
        html.append("<div class='signature-box'>Authorized Officer's Signature</div>");
        html.append("</div>");
        html.append("</div>");
        
        // Footer
        html.append("<div class='footer'>");
        html.append("<p><strong>This is a computer generated document. No signature required.</strong></p>");
        html.append("<p>For any queries, please contact the Election Office | Email: election@gov.in | Phone: 1800-XXX-XXXX</p>");
        html.append("<p style='font-size: 10px; margin-top: 10px;'>Document ID: CAND-").append(candidate.getCandidateId()).append("-").append(System.currentTimeMillis()).append("</p>");
        html.append("</div>");
        
        html.append("</body>");
        html.append("</html>");
        
        return html.toString().getBytes("UTF-8");
    }
    
    private static void addField(StringBuilder html, String label, String value) {
        html.append("<div class='field-row'>");
        html.append("<div class='field-label'>").append(escapeHtml(label)).append(":</div>");
        html.append("<div class='field-value'>").append(escapeHtml(value != null ? value : "N/A")).append("</div>");
        html.append("</div>");
    }
    
    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
    
    private static String maskAadhar(String aadhar) {
        if (aadhar == null || aadhar.length() < 4) return "N/A";
        return "XXXX-XXXX-" + aadhar.substring(aadhar.length() - 4);
    }
    
    private static String formatStatus(String status) {
        if (status == null) return "N/A";
        return status.replace("_", " ").toUpperCase();
    }
}

package com.election.util;

import com.election.model.Candidate;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGeneratorSimple {
    
    /**
     * Generates simple proforma matching proforma1.png format
     * Clean, minimal design with underlines
     */
    public static byte[] generateSimpleProforma(Candidate candidate) throws IOException {
        StringBuilder html = new StringBuilder();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>उमेदवार प्रपत्र / Candidate Proforma</title>");
        html.append("<link href='https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;600;700&display=swap' rel='stylesheet'>");
        html.append("<style>");
        
        // Clean, simple styling
        html.append("* { margin: 0; padding: 0; box-sizing: border-box; }");
        html.append("@page { size: A4; margin: 15mm; }");
        html.append("body { font-family: 'Noto Sans Devanagari', Arial, sans-serif; font-size: 12pt; line-height: 1.6; padding: 20px; background: white; color: #000; }");
        
        // Print button
        html.append(".print-btn { position: fixed; top: 10px; right: 10px; background: #2563eb; color: white; padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; box-shadow: 0 2px 8px rgba(0,0,0,0.2); z-index: 1000; }");
        html.append(".print-btn:hover { background: #1d4ed8; }");
        html.append("@media print { .no-print { display: none !important; } }");
        
        // Container
        html.append(".container { max-width: 180mm; margin: 0 auto; }");
        
        // Header - simple, centered
        html.append(".header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #000; padding-bottom: 15px; }");
        html.append(".header h1 { font-size: 18pt; font-weight: 700; margin-bottom: 8px; }");
        html.append(".header p { font-size: 11pt; margin: 4px 0; }");
        
        // Form title
        html.append(".form-title { text-align: center; font-size: 14pt; font-weight: 700; margin: 20px 0; text-decoration: underline; }");
        
        // Field row - simple with underline
        html.append(".field-row { display: flex; margin-bottom: 18px; align-items: baseline; }");
        html.append(".field-label { min-width: 200px; font-weight: 600; font-size: 11pt; }");
        html.append(".field-value { flex: 1; border-bottom: 1px solid #000; padding: 2px 10px; min-height: 24px; }");
        
        // Two column fields
        html.append(".two-cols { display: flex; gap: 30px; }");
        html.append(".col { flex: 1; }");
        
        // Section header - simple, underlined
        html.append(".section-header { font-size: 13pt; font-weight: 700; margin: 25px 0 15px 0; border-bottom: 2px solid #000; padding-bottom: 5px; }");
        
        // Photo box - top right
        html.append(".photo-box { float: right; width: 100px; height: 130px; border: 2px solid #000; margin: 0 0 20px 20px; text-align: center; padding: 5px; background: #fafafa; }");
        html.append(".photo-placeholder { width: 100%; height: 100px; background: #e5e5e5; border: 1px dashed #666; display: flex; align-items: center; justify-content: center; font-size: 9pt; color: #666; }");
        
        // Declaration box
        html.append(".declaration { margin-top: 30px; padding: 15px; border: 1px solid #000; font-size: 10pt; text-align: justify; line-height: 1.5; }");
        html.append(".declaration-title { font-weight: 700; text-align: center; margin-bottom: 10px; font-size: 12pt; }");
        
        // Signature section
        html.append(".signatures { margin-top: 40px; display: flex; justify-content: space-between; }");
        html.append(".sign-block { width: 45%; }");
        html.append(".sign-line { border-top: 1px solid #000; margin-top: 60px; padding-top: 5px; text-align: center; font-size: 10pt; font-weight: 600; }");
        
        // Footer
        html.append(".footer { margin-top: 30px; padding-top: 10px; border-top: 1px solid #000; text-align: center; font-size: 9pt; color: #555; }");
        
        html.append("</style>");
        html.append("<script>function printDoc(){window.print();}</script>");
        html.append("</head>");
        html.append("<body>");
        
        // Print button
        html.append("<button onclick='printDoc()' class='print-btn no-print'>🖨️ Print / प्रिंट</button>");
        
        html.append("<div class='container'>");
        
        // HEADER
        html.append("<div class='header'>");
        html.append("<h1>भारत निर्वाचन आयोग</h1>");
        html.append("<h1>Election Commission of India</h1>");
        html.append("<p>उमेदवार माहिती प्रपत्र | Candidate Information Form</p>");
        html.append("</div>");
        
        // Form number
        html.append("<div style='text-align: right; font-weight: 700; margin-bottom: 10px;'>फॉर्म क्र. २ / Form No. 2</div>");
        
        // Photo box
        html.append("<div class='photo-box'>");
        html.append("<div class='photo-placeholder'>फोटो<br>Photo</div>");
        html.append("<small style='font-size:8pt;'>पासपोर्ट<br>आकार</small>");
        html.append("</div>");
        
        // SECTION 1: PERSONAL INFORMATION
        html.append("<div class='section-header'>१. वैयक्तिक माहिती / Personal Information</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>उमेदवाराचे नाव / Name:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getCandidateName())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>वडिलांचे नाव / Father's Name:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getFatherName())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='two-cols'>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>वय / Age:</span>");
        html.append("<span class='field-value'>").append(candidate.getAge()).append(" वर्षे</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>लिंग / Gender:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getGender())).append("</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>मोबाईल / Mobile:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getMobile())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>ई-मेल / Email:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getEmail())).append("</span>");
        html.append("</div>");
        
        // Clear float
        html.append("<div style='clear:both;'></div>");
        
        // SECTION 2: ADDRESS
        html.append("<div class='section-header'>२. पत्ता / Address</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>पत्ता / Address:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getAddress())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='two-cols'>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>शहर / City:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getCity())).append("</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>राज्य / State:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getState())).append("</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>पिन कोड / Pin Code:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getPincode())).append("</span>");
        html.append("</div>");
        
        // SECTION 3: IDENTITY
        html.append("<div class='section-header'>३. ओळखपत्र / Identity Documents</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>आधार क्रमांक / Aadhaar Number:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(maskAadhar(candidate.getAadharNumber()))).append("</span>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>मतदार ओळखपत्र / Voter ID:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getVoterId())).append("</span>");
        html.append("</div>");
        
        // SECTION 4: ELECTION DETAILS
        html.append("<div class='section-header'>४. निवडणूक तपशील / Election Details</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>मतदारसंघ / Constituency:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getConstituency())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>नामांकन क्रमांक / Nomination ID:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getNominationId())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='two-cols'>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>पक्ष / Party:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getPartyName())).append("</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>चिन्ह / Symbol:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getPartySymbol())).append("</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("</div>");
        
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>निवडणूक प्रकार / Election Type:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getElectionType())).append("</span>");
        html.append("</div>");
        
        if (candidate.getElectionDate() != null) {
            html.append("<div class='field-row'>");
            html.append("<span class='field-label'>तारीख / Date:</span>");
            html.append("<span class='field-value'>").append(dateFormat.format(candidate.getElectionDate())).append("</span>");
            html.append("</div>");
        }
        
        html.append("<div class='two-cols'>");
        html.append("<div class='col'>");
        html.append("<div class='field-row'>");
        html.append("<span class='field-label'>बूथ / Booth:</span>");
        html.append("<span class='field-value'>").append(escapeHtml(candidate.getBoothNumber())).append("</span>");
        html.append("</div>");
        html.append("</div>");
        html.append("<div class='col'>");
        if (candidate.getExpenseLimit() != null) {
            html.append("<div class='field-row'>");
            html.append("<span class='field-label'>मर्यादा / Limit:</span>");
            html.append("<span class='field-value'>₹ ").append(candidate.getExpenseLimit().toString()).append("</span>");
            html.append("</div>");
        }
        html.append("</div>");
        html.append("</div>");
        
        // DECLARATION
        html.append("<div class='declaration'>");
        html.append("<div class='declaration-title'>घोषणा / Declaration</div>");
        html.append("<p>");
        html.append("मी, <strong>").append(escapeHtml(candidate.getCandidateName())).append("</strong>, ");
        html.append("याद्वारे घोषित करतो/करते की वरील माहिती सत्य आहे.");
        html.append("</p>");
        html.append("<p style='margin-top:8px;'>");
        html.append("I, <strong>").append(escapeHtml(candidate.getCandidateName())).append("</strong>, ");
        html.append("hereby declare that the above information is true and correct.");
        html.append("</p>");
        html.append("</div>");
        
        // SIGNATURES
        html.append("<div class='signatures'>");
        html.append("<div class='sign-block'>");
        html.append("<div>दिनांक / Date: ").append(dateFormat.format(new Date())).append("</div>");
        html.append("<div class='sign-line'>उमेदवाराची सही<br>Candidate's Signature</div>");
        html.append("</div>");
        html.append("<div class='sign-block'>");
        html.append("<div>दिनांक / Date: ___________</div>");
        html.append("<div class='sign-line'>अधिकाऱ्याची सही<br>Officer's Signature</div>");
        html.append("</div>");
        html.append("</div>");
        
        // FOOTER
        html.append("<div class='footer'>");
        html.append("<p>संगणक निर्मित दस्तऐवज / Computer Generated Document</p>");
        html.append("<p>दस्तऐवज ID: CAND-").append(candidate.getCandidateId()).append("-").append(System.currentTimeMillis()).append("</p>");
        html.append("</div>");
        
        html.append("</div>"); // container
        html.append("</body>");
        html.append("</html>");
        
        return html.toString().getBytes("UTF-8");
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
        if (aadhar == null || aadhar.length() < 4) return "";
        return "XXXX-XXXX-" + aadhar.substring(aadhar.length() - 4);
    }
}

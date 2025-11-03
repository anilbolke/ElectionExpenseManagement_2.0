package com.election.util;

import com.election.model.Candidate;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGeneratorMarathi {
    
    /**
     * Generates Form 2 (Proforma) in Marathi language based on official format
     * @param candidate The candidate object containing all details
     * @return byte array containing the HTML data
     */
    public static byte[] generateCandidateProformaMarathi(Candidate candidate) throws IOException {
        StringBuilder html = new StringBuilder();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        html.append("<title>फॉर्म २ - उमेदवार माहिती</title>");
        html.append("<link href='https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;600;700&display=swap' rel='stylesheet'>");
        html.append("<style>");
        
        // Print-optimized styles matching government form format
        html.append("* { margin: 0; padding: 0; box-sizing: border-box; }");
        html.append("body { font-family: 'Noto Sans Devanagari', Arial, sans-serif; font-size: 11pt; line-height: 1.4; color: #000; background: #fff; padding: 0; }");
        html.append("@page { size: A4; margin: 15mm; }");
        
        // Container
        html.append(".container { max-width: 210mm; margin: 0 auto; padding: 10mm; background: white; }");
        
        // Header - Government Format
        html.append(".header { text-align: center; border: 2px solid #000; padding: 10px; margin-bottom: 15px; }");
        html.append(".header h1 { font-size: 16pt; font-weight: 700; margin-bottom: 5px; }");
        html.append(".header h2 { font-size: 14pt; font-weight: 600; margin-bottom: 3px; }");
        html.append(".header p { font-size: 10pt; margin: 2px 0; }");
        
        // Form Number
        html.append(".form-number { text-align: right; font-size: 12pt; font-weight: 700; margin-bottom: 10px; }");
        
        // Title
        html.append(".form-title { text-align: center; font-size: 13pt; font-weight: 700; margin: 15px 0; text-decoration: underline; }");
        
        // Table styles
        html.append("table { width: 100%; border-collapse: collapse; margin-bottom: 15px; }");
        html.append("table, th, td { border: 1px solid #000; }");
        html.append("th, td { padding: 8px; text-align: left; vertical-align: top; }");
        html.append("th { background-color: #f0f0f0; font-weight: 700; font-size: 10pt; }");
        html.append("td { font-size: 10pt; }");
        html.append(".label { font-weight: 600; width: 40%; }");
        html.append(".value { width: 60%; }");
        
        // Photo box
        html.append(".photo-box { width: 120px; height: 140px; border: 2px solid #000; float: right; margin: 0 0 10px 10px; text-align: center; padding: 5px; background: #f9f9f9; }");
        html.append(".photo-placeholder { width: 100%; height: 100px; background: #e0e0e0; display: flex; align-items: center; justify-content: center; font-size: 9pt; }");
        
        // Section headers
        html.append(".section-header { background: #d0d0d0; font-weight: 700; font-size: 11pt; padding: 8px; margin-top: 15px; text-align: center; border: 2px solid #000; }");
        
        // Declaration
        html.append(".declaration { border: 2px solid #000; padding: 12px; margin-top: 15px; font-size: 10pt; text-align: justify; }");
        
        // Signature section
        html.append(".signature-section { margin-top: 25px; display: flex; justify-content: space-between; }");
        html.append(".sign-box { width: 45%; text-align: center; }");
        html.append(".sign-line { border-top: 1px solid #000; margin-top: 50px; padding-top: 5px; }");
        
        // Print button
        html.append(".print-btn { position: fixed; top: 20px; right: 20px; background: #0066cc; color: white; padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 600; box-shadow: 0 4px 8px rgba(0,0,0,0.3); z-index: 1000; font-family: 'Noto Sans Devanagari', Arial; }");
        html.append(".print-btn:hover { background: #0052a3; }");
        html.append("@media print { .no-print { display: none; } body { padding: 0; } .container { padding: 0; } }");
        
        html.append("</style>");
        html.append("<script>");
        html.append("function printDocument() { window.print(); }");
        html.append("</script>");
        html.append("</head>");
        html.append("<body>");
        
        // Print button
        html.append("<button onclick='printDocument()' class='print-btn no-print'>🖨️ प्रिंट करा / Print to PDF</button>");
        
        html.append("<div class='container'>");
        
        // Header
        html.append("<div class='header'>");
        html.append("<h1>भारत निर्वाचन आयोग</h1>");
        html.append("<h1>Election Commission of India</h1>");
        html.append("<h2>उमेदवार नोंदणी प्रपत्र</h2>");
        html.append("<h2>Candidate Registration Proforma</h2>");
        html.append("<p>लोकप्रतिनिधित्व अधिनियम, १९५१ / Representation of the People Act, 1951</p>");
        html.append("</div>");
        
        // Form number
        html.append("<div class='form-number'>फॉर्म क्र. २ / Form No. 2</div>");
        
        // Title
        html.append("<div class='form-title'>उमेदवार व खर्च निवेदन / Candidate and Expenditure Statement</div>");
        
        // Photo box
        html.append("<div class='photo-box'>");
        html.append("<div class='photo-placeholder'>उमेदवाराचा<br>फोटो<br>Candidate<br>Photo</div>");
        html.append("<small>अलीकडील<br>पासपोर्ट<br>आकाराचा फोटो</small>");
        html.append("</div>");
        
        // Part 1: Personal Information
        html.append("<div class='section-header'>भाग १: वैयक्तिक माहिती / Part 1: Personal Information</div>");
        html.append("<table>");
        html.append("<tr><td class='label'>उमेदवार ओळख क्रमांक / Candidate ID</td><td class='value'>").append(escapeHtml(String.valueOf(candidate.getCandidateId()))).append("</td></tr>");
        html.append("<tr><td class='label'>उमेदवाराचे पूर्ण नाव / Full Name of Candidate</td><td class='value'>").append(escapeHtml(candidate.getCandidateName())).append("</td></tr>");
        html.append("<tr><td class='label'>वडिलांचे नाव / Father's Name</td><td class='value'>").append(escapeHtml(candidate.getFatherName())).append("</td></tr>");
        html.append("<tr><td class='label'>वय / Age</td><td class='value'>").append(candidate.getAge()).append(" वर्षे / years</td></tr>");
        html.append("<tr><td class='label'>लिंग / Gender</td><td class='value'>").append(escapeHtml(candidate.getGender())).append("</td></tr>");
        html.append("<tr><td class='label'>मोबाईल क्रमांक / Mobile Number</td><td class='value'>").append(escapeHtml(candidate.getMobile())).append("</td></tr>");
        html.append("<tr><td class='label'>ई-मेल / Email</td><td class='value'>").append(escapeHtml(candidate.getEmail())).append("</td></tr>");
        html.append("</table>");
        
        // Part 2: Address
        html.append("<div class='section-header'>भाग २: राहत्या पत्ता / Part 2: Residential Address</div>");
        html.append("<table>");
        html.append("<tr><td class='label'>पत्ता / Address</td><td class='value'>").append(escapeHtml(candidate.getAddress())).append("</td></tr>");
        html.append("<tr><td class='label'>शहर / City</td><td class='value'>").append(escapeHtml(candidate.getCity())).append("</td></tr>");
        html.append("<tr><td class='label'>राज्य / State</td><td class='value'>").append(escapeHtml(candidate.getState())).append("</td></tr>");
        html.append("<tr><td class='label'>पिन कोड / Pin Code</td><td class='value'>").append(escapeHtml(candidate.getPincode())).append("</td></tr>");
        html.append("</table>");
        
        // Part 3: Identity Documents
        html.append("<div class='section-header'>भाग ३: ओळखपत्र तपशील / Part 3: Identity Documents</div>");
        html.append("<table>");
        html.append("<tr><td class='label'>आधार क्रमांक / Aadhaar Number</td><td class='value'>").append(escapeHtml(maskAadhar(candidate.getAadharNumber()))).append("</td></tr>");
        html.append("<tr><td class='label'>मतदार ओळखपत्र क्रमांक / Voter ID Number</td><td class='value'>").append(escapeHtml(candidate.getVoterId())).append("</td></tr>");
        html.append("</table>");
        
        // Part 4: Election Details
        html.append("<div class='section-header'>भाग ४: निवडणूक माहिती / Part 4: Election Details</div>");
        html.append("<table>");
        html.append("<tr><td class='label'>मतदारसंघ / Constituency</td><td class='value'>").append(escapeHtml(candidate.getConstituency())).append("</td></tr>");
        html.append("<tr><td class='label'>नामांकन क्रमांक / Nomination ID</td><td class='value'>").append(escapeHtml(candidate.getNominationId())).append("</td></tr>");
        html.append("<tr><td class='label'>पक्षाचे नाव / Party Name</td><td class='value'>").append(escapeHtml(candidate.getPartyName())).append("</td></tr>");
        html.append("<tr><td class='label'>पक्ष चिन्ह / Party Symbol</td><td class='value'>").append(escapeHtml(candidate.getPartySymbol())).append("</td></tr>");
        html.append("<tr><td class='label'>निवडणुकीचा प्रकार / Election Type</td><td class='value'>").append(escapeHtml(candidate.getElectionType())).append("</td></tr>");
        if (candidate.getElectionDate() != null) {
            html.append("<tr><td class='label'>निवडणूक तारीख / Election Date</td><td class='value'>").append(dateFormat.format(candidate.getElectionDate())).append("</td></tr>");
        }
        html.append("<tr><td class='label'>मतदान केंद्र क्रमांक / Polling Booth Number</td><td class='value'>").append(escapeHtml(candidate.getBoothNumber())).append("</td></tr>");
        if (candidate.getExpenseLimit() != null) {
            html.append("<tr><td class='label'>खर्च मर्यादा / Expense Limit</td><td class='value'>₹ ").append(candidate.getExpenseLimit().toString()).append("</td></tr>");
        }
        html.append("</table>");
        
        // Part 5: Payment Status
        html.append("<div class='section-header'>भाग ५: देयक स्थिती / Part 5: Payment Status</div>");
        html.append("<table>");
        html.append("<tr><td class='label'>खाते स्थिती / Account Status</td><td class='value'>").append(formatStatus(candidate.getAccountStatus())).append("</td></tr>");
        html.append("<tr><td class='label'>पेमेंट स्थिती / Payment Status</td><td class='value'>").append(formatStatus(candidate.getPaymentStatus())).append("</td></tr>");
        if (candidate.getPaymentAmount() != null) {
            html.append("<tr><td class='label'>पेमेंट रक्कम / Payment Amount</td><td class='value'>₹ ").append(candidate.getPaymentAmount().toString()).append("</td></tr>");
        }
        if (candidate.getTransactionId() != null && !candidate.getTransactionId().isEmpty()) {
            html.append("<tr><td class='label'>व्यवहार क्रमांक / Transaction ID</td><td class='value'>").append(escapeHtml(candidate.getTransactionId())).append("</td></tr>");
        }
        html.append("<tr><td class='label'>पेमेंट पडताळणी / Payment Verified</td><td class='value'>").append(candidate.isPaymentVerified() ? "होय ✓ / Yes ✓" : "प्रलंबित / Pending").append("</td></tr>");
        html.append("</table>");
        
        // Declaration
        html.append("<div class='declaration'>");
        html.append("<p style='font-weight:700; text-align:center; margin-bottom:10px;'>घोषणापत्र / DECLARATION</p>");
        html.append("<p style='text-align:justify;'>");
        html.append("मी, <strong>").append(escapeHtml(candidate.getCandidateName())).append("</strong>, ");
        html.append("याद्वारे घोषित करतो/करते की वर दिलेली माहिती माझ्या माहितीनुसार सत्य आणि बरोबर आहे. ");
        html.append("मला माहित आहे की खोटी माहिती दिल्यास माझी उमेदवारी रद्द होऊ शकते आणि कायदेशीर कारवाई होऊ शकते. ");
        html.append("मी निवडणूक आयोगाने निश्चित केलेले सर्व नियम आणि कायदे पाळण्यास सहमत आहे.");
        html.append("</p>");
        html.append("<p style='margin-top:10px; text-align:justify;'>");
        html.append("I, <strong>").append(escapeHtml(candidate.getCandidateName())).append("</strong>, ");
        html.append("hereby declare that the information provided above is true and correct to the best of my knowledge. ");
        html.append("I understand that any false information may lead to cancellation of my candidature and legal action. ");
        html.append("I agree to abide by all the rules and regulations set forth by the Election Commission.");
        html.append("</p>");
        html.append("</div>");
        
        // Signature Section
        html.append("<div class='signature-section'>");
        html.append("<div class='sign-box'>");
        html.append("<div class='sign-line'>उमेदवाराची सही<br>Candidate's Signature</div>");
        html.append("<p style='margin-top:8px; font-size:9pt;'>दिनांक / Date: ").append(dateFormat.format(new Date())).append("</p>");
        html.append("</div>");
        html.append("<div class='sign-box'>");
        html.append("<div class='sign-line'>अधिकृत अधिकाऱ्याची सही<br>Authorized Officer's Signature</div>");
        html.append("<p style='margin-top:8px; font-size:9pt;'>दिनांक / Date: _______________</p>");
        html.append("</div>");
        html.append("</div>");
        
        // Footer
        html.append("<div style='margin-top:25px; text-align:center; font-size:9pt; border-top:1px solid #000; padding-top:10px;'>");
        html.append("<p><strong>हे संगणक-निर्मित दस्तऐवज आहे. सहीची आवश्यकता नाही.</strong></p>");
        html.append("<p><strong>This is a computer-generated document. No signature required.</strong></p>");
        html.append("<p style='margin-top:5px;'>दस्तऐवज क्रमांक / Document ID: CAND-").append(candidate.getCandidateId()).append("-").append(System.currentTimeMillis()).append("</p>");
        html.append("<p style='margin-top:5px;'>निर्मिती तारीख / Generated Date: ").append(dateFormat.format(new Date())).append("</p>");
        html.append("</div>");
        
        html.append("</div>"); // container
        html.append("</body>");
        html.append("</html>");
        
        return html.toString().getBytes("UTF-8");
    }
    
    private static String escapeHtml(String text) {
        if (text == null) return "N/A";
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

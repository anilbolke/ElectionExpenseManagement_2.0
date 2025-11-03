package com.election.util;

import com.election.model.Candidate;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGeneratorForm2 {
    
    /**
     * Generates exact Form 2 format as per Election Commission standards
     * Bilingual Marathi-English with government document styling
     */
    public static byte[] generateForm2Proforma(Candidate candidate) throws IOException {
        StringBuilder html = new StringBuilder();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>फॉर्म २ / Form 2</title>");
        html.append("<link href='https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;600;700&display=swap' rel='stylesheet'>");
        html.append("<style>");
        
        // Exact government form styling
        html.append("* { margin: 0; padding: 0; box-sizing: border-box; }");
        html.append("@page { size: A4; margin: 10mm; }");
        html.append("body { font-family: 'Noto Sans Devanagari', Arial, sans-serif; font-size: 10pt; line-height: 1.3; background: white; padding: 5mm; }");
        
        // Print button
        html.append(".print-btn { position: fixed; top: 10px; right: 10px; background: #0066cc; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600; z-index: 1000; box-shadow: 0 2px 5px rgba(0,0,0,0.3); }");
        html.append(".print-btn:hover { background: #0052a3; }");
        html.append("@media print { .no-print { display: none !important; } }");
        
        // Container
        html.append(".container { width: 100%; max-width: 190mm; margin: 0 auto; border: 3px solid #000; padding: 5mm; }");
        
        // Header with emblem
        html.append(".header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 8px; margin-bottom: 8px; }");
        html.append(".emblem { font-size: 24pt; margin-bottom: 5px; }");
        html.append(".header h1 { font-size: 14pt; font-weight: 700; margin: 3px 0; line-height: 1.2; }");
        html.append(".header h2 { font-size: 12pt; font-weight: 600; margin: 2px 0; }");
        html.append(".header p { font-size: 9pt; margin: 2px 0; }");
        
        // Form number
        html.append(".form-no { text-align: right; font-size: 11pt; font-weight: 700; margin: 5px 0; }");
        
        // Title section
        html.append(".title-section { text-align: center; margin: 10px 0; padding: 5px; border: 2px solid #000; background: #f5f5f5; }");
        html.append(".title-section h3 { font-size: 11pt; font-weight: 700; margin: 2px 0; }");
        
        // Photo box
        html.append(".photo-section { float: right; width: 110px; border: 2px solid #000; margin: 0 0 5px 10px; padding: 5px; text-align: center; background: #fafafa; }");
        html.append(".photo-box { width: 100px; height: 120px; border: 1px dashed #666; background: #e8e8e8; display: flex; align-items: center; justify-content: center; font-size: 8pt; color: #666; margin-bottom: 3px; }");
        
        // Table styles - exact government format
        html.append("table { width: 100%; border-collapse: collapse; margin: 8px 0; }");
        html.append("table, th, td { border: 1px solid #000; }");
        html.append("th { background: #d9d9d9; font-weight: 700; font-size: 9pt; padding: 4px; text-align: center; }");
        html.append("td { font-size: 9pt; padding: 4px; vertical-align: top; }");
        html.append(".label-col { width: 45%; font-weight: 600; background: #f0f0f0; }");
        html.append(".value-col { width: 55%; min-height: 20px; }");
        html.append(".section-head { background: #c0c0c0; font-weight: 700; text-align: center; font-size: 10pt; padding: 5px; }");
        
        // Two column layout
        html.append(".two-col { display: table; width: 100%; }");
        html.append(".col-50 { display: table-cell; width: 50%; padding: 0 2px; }");
        
        // Declaration box
        html.append(".declaration { border: 2px solid #000; padding: 8px; margin-top: 10px; font-size: 9pt; text-align: justify; line-height: 1.4; }");
        html.append(".declaration-title { font-weight: 700; text-align: center; margin-bottom: 5px; font-size: 10pt; }");
        
        // Signature section
        html.append(".sign-row { display: flex; justify-content: space-between; margin-top: 15px; padding-top: 10px; }");
        html.append(".sign-box { width: 48%; text-align: center; }");
        html.append(".sign-line { border-top: 1px solid #000; margin-top: 40px; padding-top: 3px; font-size: 8pt; }");
        
        // Footer
        html.append(".footer { margin-top: 10px; padding-top: 5px; border-top: 1px solid #000; text-align: center; font-size: 7pt; }");
        
        html.append("</style>");
        html.append("<script>function printDoc(){window.print();}</script>");
        html.append("</head>");
        html.append("<body>");
        
        // Print button
        html.append("<button onclick='printDoc()' class='print-btn no-print'>🖨️ प्रिंट / Print</button>");
        
        html.append("<div class='container'>");
        
        // HEADER
        html.append("<div class='header'>");
        html.append("<div class='emblem'>☸</div>");
        html.append("<h1>भारत निर्वाचन आयोग</h1>");
        html.append("<h1>ELECTION COMMISSION OF INDIA</h1>");
        html.append("<h2>निवडणूक खर्चाचे विवरणपत्र</h2>");
        html.append("<h2>ELECTION EXPENDITURE STATEMENT</h2>");
        html.append("<p>(लोकप्रतिनिधित्व अधिनियम, १९५१ च्या कलम ७७ अन्वये)</p>");
        html.append("<p>(Under Section 77 of Representation of the People Act, 1951)</p>");
        html.append("</div>");
        
        // Form number
        html.append("<div class='form-no'>फॉर्म क्र. २ / FORM NO. 2</div>");
        
        // Title
        html.append("<div class='title-section'>");
        html.append("<h3>उमेदवाराची माहिती व नामांकन तपशील</h3>");
        html.append("<h3>CANDIDATE INFORMATION & NOMINATION DETAILS</h3>");
        html.append("</div>");
        
        // Photo box
        html.append("<div class='photo-section'>");
        html.append("<div class='photo-box'>उमेदवाराचा<br>फोटो येथे<br>लावा<br><br>Affix<br>Recent<br>Passport<br>Size Photo</div>");
        html.append("<small style='font-size:7pt;'>पासपोर्ट आकार<br>रंगीत फोटो</small>");
        html.append("</div>");
        
        // PART 1: PERSONAL DETAILS
        html.append("<table>");
        html.append("<tr><th colspan='2' class='section-head'>भाग १ : वैयक्तिक माहिती | PART 1 : PERSONAL DETAILS</th></tr>");
        html.append("<tr><td class='label-col'>१. उमेदवाराचे संपूर्ण नाव<br>1. Full Name of Candidate</td><td class='value-col'>").append(escapeHtml(candidate.getCandidateName())).append("</td></tr>");
        html.append("<tr><td class='label-col'>२. वडिलांचे/आईचे नाव<br>2. Father's/Mother's Name</td><td class='value-col'>").append(escapeHtml(candidate.getFatherName())).append("</td></tr>");
        html.append("<tr><td class='label-col'>३. जन्मतारीख व वय<br>3. Date of Birth & Age</td><td class='value-col'>").append(candidate.getAge()).append(" वर्षे / years</td></tr>");
        html.append("<tr><td class='label-col'>४. लिंग<br>4. Gender</td><td class='value-col'>").append(escapeHtml(candidate.getGender())).append("</td></tr>");
        html.append("<tr><td class='label-col'>५. मोबाईल क्रमांक<br>5. Mobile Number</td><td class='value-col'>").append(escapeHtml(candidate.getMobile())).append("</td></tr>");
        html.append("<tr><td class='label-col'>६. ई-मेल पत्ता<br>6. Email Address</td><td class='value-col'>").append(escapeHtml(candidate.getEmail())).append("</td></tr>");
        html.append("</table>");
        
        // Clear float
        html.append("<div style='clear:both;'></div>");
        
        // PART 2: ADDRESS
        html.append("<table>");
        html.append("<tr><th colspan='2' class='section-head'>भाग २ : पत्ता तपशील | PART 2 : ADDRESS DETAILS</th></tr>");
        html.append("<tr><td class='label-col'>७. सध्याचा पत्ता<br>7. Residential Address</td><td class='value-col'>").append(escapeHtml(candidate.getAddress())).append("</td></tr>");
        html.append("<tr><td class='label-col'>८. शहर / गाव<br>8. City / Village</td><td class='value-col'>").append(escapeHtml(candidate.getCity())).append("</td></tr>");
        html.append("<tr><td class='label-col'>९. राज्य<br>9. State</td><td class='value-col'>").append(escapeHtml(candidate.getState())).append("</td></tr>");
        html.append("<tr><td class='label-col'>१०. पिन कोड<br>10. Pin Code</td><td class='value-col'>").append(escapeHtml(candidate.getPincode())).append("</td></tr>");
        html.append("</table>");
        
        // PART 3: IDENTITY
        html.append("<table>");
        html.append("<tr><th colspan='2' class='section-head'>भाग ३ : ओळख दस्तऐवज | PART 3 : IDENTITY DOCUMENTS</th></tr>");
        html.append("<tr><td class='label-col'>११. आधार कार्ड क्रमांक<br>11. Aadhaar Card Number</td><td class='value-col'>").append(escapeHtml(maskAadhar(candidate.getAadharNumber()))).append("</td></tr>");
        html.append("<tr><td class='label-col'>१२. मतदार ओळखपत्र क्रमांक<br>12. Voter ID Card Number</td><td class='value-col'>").append(escapeHtml(candidate.getVoterId())).append("</td></tr>");
        html.append("</table>");
        
        // PART 4: ELECTION DETAILS
        html.append("<table>");
        html.append("<tr><th colspan='2' class='section-head'>भाग ४ : निवडणूक तपशील | PART 4 : ELECTION DETAILS</th></tr>");
        html.append("<tr><td class='label-col'>१३. मतदारसंघाचे नाव<br>13. Name of Constituency</td><td class='value-col'>").append(escapeHtml(candidate.getConstituency())).append("</td></tr>");
        html.append("<tr><td class='label-col'>१४. नामांकन क्रमांक<br>14. Nomination Number</td><td class='value-col'>").append(escapeHtml(candidate.getNominationId())).append("</td></tr>");
        html.append("<tr><td class='label-col'>१५. पक्षाचे नाव<br>15. Name of Party</td><td class='value-col'>").append(escapeHtml(candidate.getPartyName())).append("</td></tr>");
        html.append("<tr><td class='label-col'>१६. पक्षाचे चिन्ह<br>16. Party Symbol</td><td class='value-col'>").append(escapeHtml(candidate.getPartySymbol())).append("</td></tr>");
        html.append("<tr><td class='label-col'>१७. निवडणुकीचा प्रकार<br>17. Type of Election</td><td class='value-col'>").append(escapeHtml(candidate.getElectionType())).append("</td></tr>");
        if (candidate.getElectionDate() != null) {
            html.append("<tr><td class='label-col'>१८. निवडणूक तारीख<br>18. Date of Election</td><td class='value-col'>").append(dateFormat.format(candidate.getElectionDate())).append("</td></tr>");
        }
        html.append("<tr><td class='label-col'>१९. मतदान केंद्र क्रमांक<br>19. Polling Booth Number</td><td class='value-col'>").append(escapeHtml(candidate.getBoothNumber())).append("</td></tr>");
        if (candidate.getExpenseLimit() != null) {
            html.append("<tr><td class='label-col'>२०. खर्चाची मर्यादा<br>20. Expenditure Limit</td><td class='value-col'>₹ ").append(candidate.getExpenseLimit().toString()).append("</td></tr>");
        }
        html.append("</table>");
        
        // PART 5: ACCOUNT STATUS
        html.append("<table>");
        html.append("<tr><th colspan='2' class='section-head'>भाग ५ : खाते व देयक स्थिती | PART 5 : ACCOUNT & PAYMENT STATUS</th></tr>");
        html.append("<tr><td class='label-col'>२१. खाते स्थिती<br>21. Account Status</td><td class='value-col'>").append(formatStatus(candidate.getAccountStatus())).append("</td></tr>");
        html.append("<tr><td class='label-col'>२२. देयक स्थिती<br>22. Payment Status</td><td class='value-col'>").append(formatStatus(candidate.getPaymentStatus())).append("</td></tr>");
        if (candidate.getPaymentAmount() != null) {
            html.append("<tr><td class='label-col'>२३. देयक रक्कम<br>23. Payment Amount</td><td class='value-col'>₹ ").append(candidate.getPaymentAmount().toString()).append("</td></tr>");
        }
        if (candidate.getTransactionId() != null && !candidate.getTransactionId().isEmpty()) {
            html.append("<tr><td class='label-col'>२४. व्यवहार क्रमांक<br>24. Transaction ID</td><td class='value-col'>").append(escapeHtml(candidate.getTransactionId())).append("</td></tr>");
        }
        html.append("<tr><td class='label-col'>२५. देयक पडताळणी<br>25. Payment Verification</td><td class='value-col'>").append(candidate.isPaymentVerified() ? "होय ✓ / Yes ✓" : "प्रलंबित / Pending").append("</td></tr>");
        html.append("</table>");
        
        // DECLARATION
        html.append("<div class='declaration'>");
        html.append("<div class='declaration-title'>घोषणापत्र | DECLARATION</div>");
        html.append("<p style='margin:5px 0;'>");
        html.append("मी, <b>").append(escapeHtml(candidate.getCandidateName())).append("</b>, ");
        html.append("याद्वारे घोषित करतो/करते की वर नमूद केलेली सर्व माहिती माझ्या माहितीनुसार व समजुतीनुसार सत्य व बरोबर आहे. ");
        html.append("मला माहित आहे की खोटी माहिती दिल्यास माझी उमेदवारी रद्द होऊ शकते आणि कायदेशीर कारवाई होऊ शकते.");
        html.append("</p>");
        html.append("<p style='margin:5px 0;'>");
        html.append("I, <b>").append(escapeHtml(candidate.getCandidateName())).append("</b>, ");
        html.append("hereby declare that all the information furnished above is true and correct to the best of my knowledge and belief. ");
        html.append("I am aware that furnishing false information may lead to cancellation of my candidature and legal action.");
        html.append("</p>");
        html.append("</div>");
        
        // SIGNATURES
        html.append("<div class='sign-row'>");
        html.append("<div class='sign-box'>");
        html.append("<div class='sign-line'>");
        html.append("<b>उमेदवाराची सही</b><br><b>Candidate's Signature</b>");
        html.append("</div>");
        html.append("<p style='margin-top:5px; font-size:8pt;'>दिनांक/Date: ").append(dateFormat.format(new Date())).append("</p>");
        html.append("</div>");
        html.append("<div class='sign-box'>");
        html.append("<div class='sign-line'>");
        html.append("<b>अधिकृत अधिकाऱ्याची सही</b><br><b>Authorized Officer's Signature</b>");
        html.append("</div>");
        html.append("<p style='margin-top:5px; font-size:8pt;'>दिनांक/Date: _____________</p>");
        html.append("</div>");
        html.append("</div>");
        
        // FOOTER
        html.append("<div class='footer'>");
        html.append("<p><b>हे संगणक निर्मित दस्तऐवज आहे | This is a computer generated document</b></p>");
        html.append("<p>दस्तऐवज क्रमांक / Document ID: FORM2-").append(candidate.getCandidateId()).append("-").append(System.currentTimeMillis()).append("</p>");
        html.append("<p>निर्मिती तारीख / Generated on: ").append(dateFormat.format(new Date())).append("</p>");
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

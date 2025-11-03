package com.election.util;

import com.election.model.Candidate;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Generates Form-2: Total Election Expense Report with official Marathi header
 * नमुना-२: उमेदवार - एकूण निवडणूक खर्च
 */
public class PDFGeneratorExpenseReport {
    
    public static byte[] generateExpenseReport(Candidate candidate) throws IOException {
        StringBuilder html = new StringBuilder();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>नमुना-२ | Form-2 Election Expense Report</title>");
        html.append("<link href='https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;600;700&display=swap' rel='stylesheet'>");
        html.append("<style>");
        
        // Page setup
        html.append("* { margin: 0; padding: 0; box-sizing: border-box; }");
        html.append("@page { size: A4; margin: 10mm; }");
        html.append("body { font-family: 'Noto Sans Devanagari', Arial, sans-serif; font-size: 11pt; line-height: 1.5; background: white; padding: 5mm; }");
        
        // Print button
        html.append(".print-btn { position: fixed; top: 10px; right: 10px; background: #0066cc; color: white; padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; z-index: 1000; box-shadow: 0 4px 8px rgba(0,0,0,0.2); font-size: 14px; }");
        html.append(".print-btn:hover { background: #0052a3; transform: translateY(-2px); box-shadow: 0 6px 12px rgba(0,0,0,0.3); }");
        html.append("@media print { .no-print { display: none !important; } }");
        
        // Container
        html.append(".container { width: 100%; max-width: 190mm; margin: 0 auto; border: 3px double #000; padding: 8mm; background: white; }");
        
        // Header section with Marathi title
        html.append(".header { text-align: center; border-bottom: 3px double #000; padding-bottom: 12px; margin-bottom: 15px; }");
        html.append(".form-number { font-size: 16pt; font-weight: 700; color: #d32f2f; margin-bottom: 8px; letter-spacing: 2px; }");
        html.append(".main-title { font-size: 14pt; font-weight: 700; margin: 8px 0; line-height: 1.4; color: #1a237e; }");
        html.append(".subtitle { font-size: 10pt; margin: 5px 0; line-height: 1.4; color: #424242; }");
        html.append(".instruction { font-size: 9pt; margin: 8px 0; padding: 6px; background: #fff9c4; border-left: 4px solid #fbc02d; line-height: 1.5; }");
        
        // Candidate info section
        html.append(".info-section { margin: 15px 0; padding: 10px; border: 2px solid #000; background: #f5f5f5; }");
        html.append(".info-title { font-size: 12pt; font-weight: 700; margin-bottom: 10px; text-align: center; background: #e0e0e0; padding: 8px; border-radius: 4px; }");
        html.append(".info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 10px; }");
        html.append(".info-item { display: flex; padding: 6px; background: white; border: 1px solid #ddd; border-radius: 3px; }");
        html.append(".info-label { font-weight: 600; min-width: 140px; color: #424242; }");
        html.append(".info-value { color: #000; }");
        
        // Expense sections
        html.append(".expense-section { margin: 20px 0; border: 2px solid #000; }");
        html.append(".section-header { background: #1e88e5; color: white; padding: 10px; font-size: 12pt; font-weight: 700; text-align: center; }");
        html.append(".section-content { padding: 15px; background: white; }");
        html.append(".expense-row { display: grid; grid-template-columns: 2fr 1fr; gap: 10px; margin-bottom: 12px; padding: 10px; border: 1px solid #bdbdbd; border-radius: 4px; background: #fafafa; }");
        html.append(".expense-label { font-weight: 600; color: #424242; }");
        html.append(".expense-amount { text-align: right; font-size: 12pt; font-weight: 700; color: #2e7d32; }");
        html.append(".total-row { background: #e8f5e9; border: 2px solid #4caf50; font-size: 13pt; }");
        
        // Declaration
        html.append(".declaration { border: 2px solid #000; padding: 12px; margin-top: 20px; background: #f5f5f5; }");
        html.append(".declaration-title { font-weight: 700; text-align: center; margin-bottom: 10px; font-size: 12pt; text-decoration: underline; }");
        html.append(".declaration-text { text-align: justify; line-height: 1.6; margin: 8px 0; }");
        
        // Signature section
        html.append(".signature-section { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 30px; }");
        html.append(".signature-box { text-align: center; padding: 15px; border: 1px solid #000; background: #fafafa; }");
        html.append(".signature-line { border-top: 2px solid #000; margin-top: 50px; padding-top: 8px; font-weight: 600; }");
        html.append(".signature-date { margin-top: 10px; font-size: 9pt; }");
        
        // Footer
        html.append(".footer { margin-top: 20px; padding-top: 10px; border-top: 2px solid #000; text-align: center; font-size: 8pt; color: #666; }");
        
        html.append("</style>");
        html.append("<script>function printDoc(){window.print();}</script>");
        html.append("</head>");
        html.append("<body>");
        
        // Print button
        html.append("<button onclick='printDoc()' class='print-btn no-print'>🖨️ Print PDF</button>");
        
        html.append("<div class='container'>");
        
        // HEADER - Your specific Marathi format
        html.append("<div class='header'>");
        html.append("<div class='form-number'>नमुना-२</div>");
        html.append("<div class='main-title'>उमेदवार - एकूण निवडणूक खर्च</div>");
        html.append("<div class='subtitle'>");
        html.append("निवडणूक लढविणाऱ्या उमेदवारांनी निकाल लागल्यापासून ३० दिवसाच्या आत एकूण निवडणूक खर्च सादर करावा.");
        html.append("</div>");
        html.append("<div class='instruction'>");
        html.append("यामध्ये स्वतः केलेला खर्च, पक्षाने केलेला खर्च व इतर व्यक्ती / संस्था यांनी केलेला एकूण निवडणूक खर्च");
        html.append("</div>");
        html.append("</div>");
        
        // CANDIDATE INFORMATION
        html.append("<div class='info-section'>");
        html.append("<div class='info-title'>उमेदवाराची माहिती | Candidate Information</div>");
        html.append("<div class='info-grid'>");
        
        html.append("<div class='info-item'>");
        html.append("<span class='info-label'>नाव | Name:</span>");
        html.append("<span class='info-value'>").append(escapeHtml(candidate.getCandidateName())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='info-item'>");
        html.append("<span class='info-label'>मतदारसंघ | Constituency:</span>");
        html.append("<span class='info-value'>").append(escapeHtml(candidate.getConstituency())).append("</span>");
        html.append("</div>");
        
        html.append("<div class='info-item'>");
        html.append("<span class='info-label'>पक्ष | Party:</span>");
        html.append("<span class='info-value'>").append(escapeHtml(candidate.getPartyName() != null ? candidate.getPartyName() : "अपक्ष / Independent")).append("</span>");
        html.append("</div>");
        
        html.append("<div class='info-item'>");
        html.append("<span class='info-label'>निवडणूक प्रकार | Election Type:</span>");
        html.append("<span class='info-value'>").append(escapeHtml(candidate.getElectionType())).append("</span>");
        html.append("</div>");
        
        if (candidate.getElectionDate() != null) {
            html.append("<div class='info-item'>");
            html.append("<span class='info-label'>निवडणूक तारीख | Date:</span>");
            html.append("<span class='info-value'>").append(dateFormat.format(candidate.getElectionDate())).append("</span>");
            html.append("</div>");
        }
        
        html.append("<div class='info-item'>");
        html.append("<span class='info-label'>मोबाईल | Mobile:</span>");
        html.append("<span class='info-value'>").append(escapeHtml(candidate.getMobile())).append("</span>");
        html.append("</div>");
        
        html.append("</div>");
        html.append("</div>");
        
        // SECTION 1: स्वतः केलेला खर्च (Self Expense)
        html.append("<div class='expense-section'>");
        html.append("<div class='section-header'>भाग १ : स्वतः केलेला खर्च | Part 1: Expenses by Candidate</div>");
        html.append("<div class='section-content'>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>प्रचार साहित्य व पोस्टर | Campaign Material & Posters</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>सभा व मेळावे | Meetings & Rallies</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>वाहने व प्रवास | Vehicles & Travel</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>इलेक्ट्रॉनिक मीडिया व जाहिराती | Electronic Media & Advertisements</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>इतर खर्च | Other Expenses</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row total-row'>");
        html.append("<div class='expense-label'>भाग १ एकूण | Part 1 Total</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("</div>");
        html.append("</div>");
        
        // SECTION 2: पक्षाने केलेला खर्च (Party Expense)
        html.append("<div class='expense-section'>");
        html.append("<div class='section-header'>भाग २ : पक्षाने केलेला खर्च | Part 2: Expenses by Political Party</div>");
        html.append("<div class='section-content'>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>प्रचार साहित्य | Campaign Material</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>सभा व कार्यक्रम | Meetings & Events</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>मीडिया व जाहिराती | Media & Advertisements</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>इतर खर्च | Other Expenses</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row total-row'>");
        html.append("<div class='expense-label'>भाग २ एकूण | Part 2 Total</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("</div>");
        html.append("</div>");
        
        // SECTION 3: इतर व्यक्ती/संस्थांचा खर्च (Others Expense)
        html.append("<div class='expense-section'>");
        html.append("<div class='section-header'>भाग ३ : इतर व्यक्ती / संस्था यांनी केलेला खर्च | Part 3: Expenses by Others</div>");
        html.append("<div class='section-content'>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>समर्थकांचा खर्च | Expenses by Supporters</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>संस्थांचा खर्च | Expenses by Organizations</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row'>");
        html.append("<div class='expense-label'>इतर | Others</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("<div class='expense-row total-row'>");
        html.append("<div class='expense-label'>भाग ३ एकूण | Part 3 Total</div>");
        html.append("<div class='expense-amount'>₹ __________</div>");
        html.append("</div>");
        
        html.append("</div>");
        html.append("</div>");
        
        // GRAND TOTAL
        html.append("<div class='expense-section'>");
        html.append("<div class='section-header' style='background: #d32f2f; font-size: 14pt;'>एकूण निवडणूक खर्च | Total Election Expenditure</div>");
        html.append("<div class='section-content'>");
        
        html.append("<div class='expense-row total-row' style='background: #ffebee; border: 3px solid #d32f2f; font-size: 14pt;'>");
        html.append("<div class='expense-label'>एकूण खर्च (भाग १ + भाग २ + भाग ३) | Grand Total (Part 1 + Part 2 + Part 3)</div>");
        html.append("<div class='expense-amount' style='color: #d32f2f;'>₹ __________</div>");
        html.append("</div>");
        
        if (candidate.getExpenseLimit() != null) {
            html.append("<div class='expense-row' style='background: #e3f2fd;'>");
            html.append("<div class='expense-label'>खर्चाची कायदेशीर मर्यादा | Legal Expenditure Limit</div>");
            html.append("<div class='expense-amount' style='color: #1565c0;'>₹ ").append(candidate.getExpenseLimit().toString()).append("</div>");
            html.append("</div>");
        }
        
        html.append("</div>");
        html.append("</div>");
        
        // DECLARATION
        html.append("<div class='declaration'>");
        html.append("<div class='declaration-title'>घोषणापत्र | DECLARATION</div>");
        html.append("<div class='declaration-text'>");
        html.append("मी, <b>").append(escapeHtml(candidate.getCandidateName())).append("</b>, ");
        html.append("याद्वारे घोषित करतो/करते की वर नमूद केलेला एकूण निवडणूक खर्च माझ्या माहितीनुसार व समजुतीनुसार सत्य व बरोबर आहे. ");
        html.append("हा खर्च निवडणूक आयोगाच्या नियमांनुसार व कायदेशीर मर्यादेत आहे. ");
        html.append("मला माहित आहे की खोटी माहिती दिल्यास कायदेशीर कारवाई होऊ शकते.");
        html.append("</div>");
        html.append("<div class='declaration-text'>");
        html.append("I, <b>").append(escapeHtml(candidate.getCandidateName())).append("</b>, ");
        html.append("hereby declare that the total election expenditure mentioned above is true and correct to the best of my knowledge and belief. ");
        html.append("This expenditure is in accordance with Election Commission rules and within the legal limits. ");
        html.append("I am aware that furnishing false information may lead to legal action.");
        html.append("</div>");
        html.append("</div>");
        
        // SIGNATURES
        html.append("<div class='signature-section'>");
        html.append("<div class='signature-box'>");
        html.append("<div>ठिकाण | Place: ______________</div>");
        html.append("<div class='signature-line'>उमेदवाराची सही<br>Candidate's Signature</div>");
        html.append("<div class='signature-date'>दिनांक | Date: ").append(dateFormat.format(new Date())).append("</div>");
        html.append("</div>");
        html.append("<div class='signature-box'>");
        html.append("<div>कार्यालय शिक्का | Office Seal:</div>");
        html.append("<div class='signature-line'>निवडणूक अधिकारी<br>Returning Officer</div>");
        html.append("<div class='signature-date'>प्राप्त केल्याची तारीख | Date Received: _______</div>");
        html.append("</div>");
        html.append("</div>");
        
        // FOOTER
        html.append("<div class='footer'>");
        html.append("या अहवालासोबत खर्चाचे पुरावे (बिले, पावत्या) जोडणे आवश्यक आहे<br>");
        html.append("Supporting documents (bills, receipts) must be attached with this report<br>");
        html.append("═══════════════════════════════════════════════════════════════<br>");
        html.append("Generated on: ").append(dateFormat.format(new Date()));
        html.append(" | Election Expense Management System");
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
}

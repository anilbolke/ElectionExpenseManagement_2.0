<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms and Conditions - Election Expense Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f5f7fa;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 0.95rem;
            opacity: 0.9;
        }
        
        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .policy-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .section {
            margin-bottom: 30px;
        }
        
        .section h2 {
            color: #667eea;
            font-size: 1.5rem;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .section h3 {
            color: #4a5568;
            font-size: 1.2rem;
            margin: 20px 0 10px 0;
        }
        
        .section p {
            margin-bottom: 15px;
            text-align: justify;
        }
        
        .section ul, .section ol {
            margin-left: 25px;
            margin-bottom: 15px;
        }
        
        .section li {
            margin-bottom: 8px;
        }
        
        .highlight {
            background: #f7fafc;
            padding: 15px;
            border-left: 4px solid #667eea;
            margin: 20px 0;
            border-radius: 4px;
        }
        
        .back-link {
            display: inline-block;
            margin: 20px 0;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        
        .back-link:hover {
            transform: translateY(-2px);
        }
        
        .footer {
            text-align: center;
            padding: 20px;
            color: #718096;
            font-size: 0.9rem;
        }
        
        /* Mobile Responsive */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.5rem;
            }
            
            .policy-card {
                padding: 25px 20px;
            }
            
            .section h2 {
                font-size: 1.3rem;
            }
            
            .section h3 {
                font-size: 1.1rem;
            }
        }
        
        @media (max-width: 480px) {
            .header {
                padding: 20px 15px;
            }
            
            .policy-card {
                padding: 20px 15px;
            }
            
            .container {
                padding: 0 15px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Terms and Conditions</h1>
        <p>Last Updated: November 8, 2025</p>
    </div>
    
    <div class="container">
        <a href="<%= request.getContextPath() %>/login.jsp" class="back-link">← Back to Home</a>
        
        <div class="policy-card">
            <div class="section">
                <h2>1. Acceptance of Terms</h2>
                <p>
                    By accessing and using the Election Expense Management System ("the System"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.
                </p>
                <div class="highlight">
                    <strong>Important:</strong> These terms constitute a legally binding agreement between you and EMS Online (emsonline.in).
                </div>
            </div>
            
            <div class="section">
                <h2>2. Service Description</h2>
                <p>
                    The Election Expense Management System is an online platform designed to help political candidates manage and track their election-related expenses, generate reports, and maintain compliance with election commission regulations.
                </p>
                <h3>2.1 Features Include:</h3>
                <ul>
                    <li>Expense tracking and categorization</li>
                    <li>Daily activity logs (Proforma-1)</li>
                    <li>Fund management and reporting</li>
                    <li>Multi-user access (Candidate, Admin, Broker)</li>
                    <li>Secure payment processing through Razorpay</li>
                    <li>Data export and reporting capabilities</li>
                </ul>
            </div>
            
            <div class="section">
                <h2>3. User Registration and Account</h2>
                <h3>3.1 Eligibility</h3>
                <p>
                    You must be at least 18 years old and legally capable of entering into binding contracts to use this System. By registering, you confirm that you meet these requirements.
                </p>
                
                <h3>3.2 Account Security</h3>
                <ul>
                    <li>You are responsible for maintaining the confidentiality of your account credentials</li>
                    <li>You must notify us immediately of any unauthorized use of your account</li>
                    <li>You are responsible for all activities that occur under your account</li>
                    <li>We reserve the right to terminate accounts that violate these terms</li>
                </ul>
                
                <h3>3.3 Accurate Information</h3>
                <p>
                    You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.
                </p>
            </div>
            
            <div class="section">
                <h2>4. Payment Terms</h2>
                <h3>4.1 Subscription Fees</h3>
                <p>
                    Access to certain features of the System requires payment of subscription fees. All fees are stated in Indian Rupees (INR) and are subject to applicable taxes.
                </p>
                
                <h3>4.2 Payment Processing</h3>
                <p>
                    All payments are processed securely through Razorpay, our authorized payment gateway partner. We do not store your complete card details on our servers.
                </p>
                <ul>
                    <li>Accepted payment methods: Credit Card, Debit Card, UPI, Net Banking</li>
                    <li>Payments are subject to Razorpay's terms and conditions</li>
                    <li>You authorize us to charge the payment method you provide</li>
                </ul>
                
                <h3>4.3 Billing Cycle</h3>
                <p>
                    Subscription fees are charged on a one-time or recurring basis as per the plan selected. You will be notified before any renewal charges.
                </p>
                
                <h3>4.4 Refunds</h3>
                <p>
                    Refund policies are detailed in our separate Refund and Cancellation Policy. Generally, subscription fees are non-refundable except as required by law or as specified in the refund policy.
                </p>
            </div>
            
            <div class="section">
                <h2>5. User Responsibilities</h2>
                <h3>5.1 Prohibited Activities</h3>
                <p>You agree NOT to:</p>
                <ul>
                    <li>Use the System for any illegal purpose or in violation of any election laws</li>
                    <li>Submit false, misleading, or fraudulent information</li>
                    <li>Attempt to gain unauthorized access to any part of the System</li>
                    <li>Interfere with or disrupt the System or servers</li>
                    <li>Use automated scripts or bots to access the System</li>
                    <li>Copy, modify, or distribute any content without permission</li>
                    <li>Reverse engineer or attempt to extract source code</li>
                </ul>
                
                <h3>5.2 Data Accuracy</h3>
                <p>
                    You are solely responsible for the accuracy and legality of all data you enter into the System. You must maintain accurate records of all election expenses and activities.
                </p>
                
                <h3>5.3 Compliance</h3>
                <p>
                    You agree to comply with all applicable election laws, rules, and regulations, including those related to expense reporting and disclosure requirements.
                </p>
            </div>
            
            <div class="section">
                <h2>6. Intellectual Property Rights</h2>
                <h3>6.1 Our Rights</h3>
                <p>
                    All content, features, and functionality of the System, including but not limited to text, graphics, logos, icons, images, software, and design, are the exclusive property of EMS Online or its licensors and are protected by copyright, trademark, and other intellectual property laws.
                </p>
                
                <h3>6.2 Your Rights</h3>
                <p>
                    You retain all rights to the data and information you upload to the System. By using the System, you grant us a limited license to use, store, and process your data solely for the purpose of providing the service.
                </p>
                
                <h3>6.3 Restrictions</h3>
                <p>
                    You may not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any of the material on our System without prior written consent.
                </p>
            </div>
            
            <div class="section">
                <h2>7. Data Protection and Privacy</h2>
                <p>
                    Your privacy is important to us. Our collection, use, and disclosure of your personal information is governed by our Privacy Policy, which is incorporated into these Terms by reference. Please review our Privacy Policy to understand our practices.
                </p>
                <div class="highlight">
                    <strong>Key Points:</strong>
                    <ul>
                        <li>We collect and process data necessary to provide the service</li>
                        <li>We implement security measures to protect your data</li>
                        <li>We comply with applicable data protection laws</li>
                        <li>We do not sell your personal information to third parties</li>
                    </ul>
                </div>
            </div>
            
            <div class="section">
                <h2>8. Service Availability and Modifications</h2>
                <h3>8.1 Availability</h3>
                <p>
                    While we strive to provide uninterrupted service, we do not guarantee that the System will be available at all times or error-free. We may experience downtime for maintenance, upgrades, or due to circumstances beyond our control.
                </p>
                
                <h3>8.2 Modifications</h3>
                <p>
                    We reserve the right to:
                </p>
                <ul>
                    <li>Modify or discontinue any aspect of the System at any time</li>
                    <li>Update these Terms and Conditions with notice to users</li>
                    <li>Change pricing with advance notification</li>
                    <li>Add or remove features as we deem necessary</li>
                </ul>
            </div>
            
            <div class="section">
                <h2>9. Limitation of Liability</h2>
                <p>
                    To the fullest extent permitted by applicable law:
                </p>
                <ul>
                    <li>We shall not be liable for any indirect, incidental, special, consequential, or punitive damages</li>
                    <li>Our total liability shall not exceed the amount you paid for the service in the past 12 months</li>
                    <li>We are not responsible for any election-related compliance issues arising from your use of data</li>
                    <li>We do not guarantee that the System will meet your specific requirements</li>
                </ul>
                <div class="highlight">
                    <strong>Important:</strong> The System is provided on an "AS IS" and "AS AVAILABLE" basis without warranties of any kind, either express or implied.
                </div>
            </div>
            
            <div class="section">
                <h2>10. Indemnification</h2>
                <p>
                    You agree to indemnify, defend, and hold harmless EMS Online, its officers, directors, employees, and agents from and against any and all claims, damages, obligations, losses, liabilities, costs, or debt, and expenses arising from:
                </p>
                <ul>
                    <li>Your use of the System</li>
                    <li>Your violation of these Terms</li>
                    <li>Your violation of any third-party rights</li>
                    <li>Any content you submit or transmit through the System</li>
                    <li>Your violation of any election laws or regulations</li>
                </ul>
            </div>
            
            <div class="section">
                <h2>11. Termination</h2>
                <h3>11.1 By You</h3>
                <p>
                    You may terminate your account at any time by contacting our support team. Upon termination, your right to use the System will immediately cease.
                </p>
                
                <h3>11.2 By Us</h3>
                <p>
                    We may terminate or suspend your account immediately, without prior notice or liability, for any reason, including but not limited to:
                </p>
                <ul>
                    <li>Breach of these Terms</li>
                    <li>Non-payment of fees</li>
                    <li>Fraudulent activity</li>
                    <li>Violation of applicable laws</li>
                </ul>
                
                <h3>11.3 Effect of Termination</h3>
                <p>
                    Upon termination:
                </p>
                <ul>
                    <li>Your access to the System will be revoked</li>
                    <li>You may request a copy of your data (subject to applicable laws)</li>
                    <li>We may delete your data after a reasonable retention period</li>
                    <li>Fees paid are non-refundable unless otherwise specified</li>
                </ul>
            </div>
            
            <div class="section">
                <h2>12. Dispute Resolution</h2>
                <h3>12.1 Governing Law</h3>
                <p>
                    These Terms shall be governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.
                </p>
                
                <h3>12.2 Jurisdiction</h3>
                <p>
                    Any disputes arising out of or related to these Terms or the System shall be subject to the exclusive jurisdiction of the courts located in [Your City], India.
                </p>
                
                <h3>12.3 Dispute Resolution Process</h3>
                <ol>
                    <li>Initial communication to resolve issues amicably</li>
                    <li>Mediation if direct communication fails</li>
                    <li>Arbitration or court proceedings as a last resort</li>
                </ol>
            </div>
            
            <div class="section">
                <h2>13. Razorpay-Specific Terms</h2>
                <h3>13.1 Payment Gateway</h3>
                <p>
                    We use Razorpay as our payment gateway provider. By making a payment through our System, you also agree to Razorpay's Terms and Conditions available at <a href="https://razorpay.com/terms/" target="_blank">https://razorpay.com/terms/</a>
                </p>
                
                <h3>13.2 PCI DSS Compliance</h3>
                <p>
                    All payment transactions are secured and encrypted. We comply with PCI DSS standards through our partnership with Razorpay.
                </p>
                
                <h3>13.3 Payment Information</h3>
                <ul>
                    <li>We do not store complete credit/debit card information</li>
                    <li>Payment details are securely handled by Razorpay</li>
                    <li>Transaction data is encrypted using SSL/TLS protocols</li>
                </ul>
            </div>
            
            <div class="section">
                <h2>14. Contact Information</h2>
                <p>
                    For questions about these Terms and Conditions, please contact us:
                </p>
                <ul>
                    <li><strong>Website:</strong> <a href="https://emsonline.in" target="_blank">emsonline.in</a></li>
                    <li><strong>Email:</strong> support@emsonline.in</li>
                    <li><strong>Support Hours:</strong> Monday - Friday, 9:00 AM - 6:00 PM IST</li>
                </ul>
            </div>
            
            <div class="section">
                <h2>15. Miscellaneous</h2>
                <h3>15.1 Severability</h3>
                <p>
                    If any provision of these Terms is found to be invalid or unenforceable, the remaining provisions will continue in full force and effect.
                </p>
                
                <h3>15.2 Waiver</h3>
                <p>
                    Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.
                </p>
                
                <h3>15.3 Entire Agreement</h3>
                <p>
                    These Terms, together with our Privacy Policy and Refund Policy, constitute the entire agreement between you and EMS Online regarding the use of the System.
                </p>
                
                <h3>15.4 Assignment</h3>
                <p>
                    You may not assign or transfer these Terms without our prior written consent. We may assign our rights and obligations without restriction.
                </p>
                
                <h3>15.5 Updates to Terms</h3>
                <p>
                    We reserve the right to update these Terms at any time. We will notify you of any material changes by posting the new Terms on this page and updating the "Last Updated" date. Your continued use of the System after such modifications constitutes your acceptance of the updated Terms.
                </p>
            </div>
            
            <div class="section">
                <h2>16. Acknowledgment</h2>
                <p>
                    BY USING THE ELECTION EXPENSE MANAGEMENT SYSTEM, YOU ACKNOWLEDGE THAT YOU HAVE READ, UNDERSTOOD, AND AGREE TO BE BOUND BY THESE TERMS AND CONDITIONS.
                </p>
            </div>
        </div>
        
        <a href="<%= request.getContextPath() %>/login.jsp" class="back-link">← Back to Home</a>
    </div>
    
    <div class="footer">
        <p>&copy; 2025 EMS Online. All rights reserved. | Powered by <a href="https://emsonline.in" target="_blank" style="color: #667eea;">emsonline.in</a></p>
    </div>
</body>
</html>

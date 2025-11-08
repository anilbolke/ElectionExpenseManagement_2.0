<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Election Expense Management System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
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
        
        .header h1 { font-size: 2rem; margin-bottom: 10px; }
        .header p { font-size: 0.95rem; opacity: 0.9; }
        
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .contact-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }
        
        .contact-card h2 {
            color: #667eea;
            font-size: 1.5rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .contact-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        
        .contact-icon {
            font-size: 24px;
            margin-right: 15px;
            min-width: 30px;
        }
        
        .contact-details h3 {
            color: #4a5568;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }
        
        .contact-details p {
            color: #718096;
            line-height: 1.6;
        }
        
        .contact-details a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .contact-details a:hover {
            text-decoration: underline;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #4a5568;
            font-weight: 600;
        }
        
        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
            width: 100%;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
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
        
        .back-link:hover { transform: translateY(-2px); }
        
        .map-container {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: center;
        }
        
        .map-container h2 {
            color: #667eea;
            margin-bottom: 15px;
        }
        
        .footer {
            text-align: center;
            padding: 20px;
            color: #718096;
            font-size: 0.9rem;
        }
        
        .business-hours {
            background: #f7fafc;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .business-hours h4 {
            color: #4a5568;
            margin-bottom: 10px;
        }
        
        .business-hours p {
            color: #718096;
            margin: 5px 0;
        }
        
        @media (max-width: 968px) {
            .contact-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .header h1 { font-size: 1.5rem; }
            .contact-card { padding: 20px; }
        }
        
        @media (max-width: 480px) {
            .header { padding: 20px 15px; }
            .contact-card { padding: 20px 15px; }
            .container { padding: 0 15px; }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Contact Us</h1>
        <p>We're here to help! Reach out to us for any questions or support.</p>
    </div>
    
    <div class="container">
        <a href="<%= request.getContextPath() %>/login.jsp" class="back-link">← Back to Home</a>
        
        <div class="contact-grid">
            <!-- Contact Information -->
            <div class="contact-card">
                <h2>Get in Touch</h2>
                
                <div class="contact-item">
                    <div class="contact-icon">📧</div>
                    <div class="contact-details">
                        <h3>Email Support</h3>
                        <p>For general inquiries:</p>
                        <a href="mailto:support@emsonline.in">support@emsonline.in</a>
                        <p style="margin-top: 10px;">For technical issues:</p>
                        <a href="mailto:tech@emsonline.in">tech@emsonline.in</a>
                        <p style="margin-top: 10px;">For refunds:</p>
                        <a href="mailto:refunds@emsonline.in">refunds@emsonline.in</a>
                    </div>
                </div>
                
                <div class="contact-item">
                    <div class="contact-icon">📞</div>
                    <div class="contact-details">
                        <h3>Phone</h3>
                        <p>Customer Support:</p>
                        <a href="tel:+919422887070">+91 123-456-7890</a>
                        <p style="margin-top: 5px; font-size: 0.9rem; color: #718096;">
                            Monday - Friday: 9:00 AM - 6:00 PM IST<br>
                            Saturday: 10:00 AM - 4:00 PM IST<br>
                            Sunday: Closed
                        </p>
                    </div>
                </div>
                
                <div class="contact-item">
                    <div class="contact-icon">🌐</div>
                    <div class="contact-details">
                        <h3>Website</h3>
                        <p>Visit our website:</p>
                        <a href="https://emsonline.in" target="_blank">emsonline.in</a>
                    </div>
                </div>
                
                <div class="contact-item">
                    <div class="contact-icon">📍</div>
                    <div class="contact-details">
                        <h3>Office Address</h3>
                        <p>
                            EMS Online<br>
                            First floor, near Market Committee Office, near Vajan Kata, new mondha, Hyder Bagh, Dashmesh Nagar, Harsh Nagar, Nanded, Nanded-Waghala, <br>
                            Nanded, Maharashtra -  431602]<br>
                            India
                        </p>
                    </div>
                </div>
                
                <div class="business-hours">
                    <h4>Business Hours</h4>
                    <p><strong>Monday - Friday:</strong> 9:00 AM - 6:00 PM</p>
                    <p><strong>Saturday:</strong> 10:00 AM - 4:00 PM</p>
                    <p><strong>Sunday:</strong> Closed</p>
                    <p style="margin-top: 10px; font-size: 0.9rem;">
                        <strong>Note:</strong> For urgent issues outside business hours, please email us and we'll respond on the next business day.
                    </p>
                </div>
            </div>
            
            <!-- Contact Form -->
            <div class="contact-card">
                <h2>Send Us a Message</h2>
                <form id="contactForm" action="<%= request.getContextPath() %>/contact-form-handler" method="post">
                    <div class="form-group">
                        <label for="name">Full Name *</label>
                        <input type="text" id="name" name="name" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email Address *</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control">
                    </div>
                    
                    <div class="form-group">
                        <label for="subject">Subject *</label>
                        <select id="subject" name="subject" class="form-control" required>
                            <option value="">-- Select Subject --</option>
                            <option value="general">General Inquiry</option>
                            <option value="technical">Technical Support</option>
                            <option value="billing">Billing & Payments</option>
                            <option value="refund">Refund Request</option>
                            <option value="feature">Feature Request</option>
                            <option value="bug">Report a Bug</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="message">Message *</label>
                        <textarea id="message" name="message" class="form-control" required></textarea>
                    </div>
                    
                    <button type="submit" class="btn-submit">Send Message</button>
                    
                    <p style="margin-top: 15px; font-size: 0.9rem; color: #718096; text-align: center;">
                        We typically respond within 24 hours during business days.
                    </p>
                </form>
            </div>
        </div>
        
        <!-- Map Section (Optional) -->
        <div class="map-container">
            <h2>Visit Our Office</h2>
            <p style="color: #718096; margin-bottom: 15px;">
                [You can add Google Maps embed code here]
            </p>
            <!-- Uncomment and add your Google Maps embed code:
            <iframe 
                src="YOUR_GOOGLE_MAPS_EMBED_URL" 
                width="100%" 
                height="400" 
                style="border:0; border-radius: 8px;" 
                allowfullscreen="" 
                loading="lazy">
            </iframe>
            -->
        </div>
        
        <!-- FAQ Link Section -->
        <div class="contact-card">
            <h2>Quick Links</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 20px;">
                <a href="<%= request.getContextPath() %>/terms-and-conditions.jsp" style="display: block; padding: 15px; background: #f7fafc; border-radius: 8px; text-decoration: none; color: #667eea; font-weight: 600; text-align: center; transition: background 0.2s;">
                    📄 Terms & Conditions
                </a>
                <a href="<%= request.getContextPath() %>/privacy-policy.jsp" style="display: block; padding: 15px; background: #f7fafc; border-radius: 8px; text-decoration: none; color: #667eea; font-weight: 600; text-align: center; transition: background 0.2s;">
                    🔒 Privacy Policy
                </a>
                <a href="<%= request.getContextPath() %>/refund-policy.jsp" style="display: block; padding: 15px; background: #f7fafc; border-radius: 8px; text-decoration: none; color: #667eea; font-weight: 600; text-align: center; transition: background 0.2s;">
                    💳 Refund Policy
                </a>
                <a href="<%= request.getContextPath() %>/shipping-policy.jsp" style="display: block; padding: 15px; background: #f7fafc; border-radius: 8px; text-decoration: none; color: #667eea; font-weight: 600; text-align: center; transition: background 0.2s;">
                    🚚 Shipping Policy
                </a>
            </div>
        </div>
        
        <a href="<%= request.getContextPath() %>/login.jsp" class="back-link">← Back to Home</a>
    </div>
    
    <div class="footer">
        <p>&copy; 2025 EMS Online. All rights reserved. | Powered by <a href="https://emsonline.in" target="_blank" style="color: #667eea;">emsonline.in</a></p>
    </div>
    
    <script>
        // Form submission handler
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic form validation
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value.trim();
            
            if (!name || !email || !subject || !message) {
                alert('Please fill in all required fields.');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return;
            }
            
            // Submit form
            alert('Thank you for contacting us! We will get back to you within 24 hours.');
            this.reset();
            
            // Uncomment to actually submit:
            // this.submit();
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="mr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>निवडणूक खर्च व्यवस्थापन प्रणाली | Election Expense Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 20px 60px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff" fill-opacity="0.1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.5;
        }
        
        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .hero-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        h1 {
            font-size: 48px;
            font-weight: 800;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .subtitle {
            font-size: 24px;
            margin-bottom: 30px;
            opacity: 0.95;
        }
        
        .description {
            font-size: 18px;
            max-width: 800px;
            margin: 0 auto 40px;
            line-height: 1.6;
            opacity: 0.9;
        }
        
        .cta-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 40px;
        }
        
        .btn {
            padding: 16px 40px;
            border-radius: 50px;
            font-size: 18px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .btn-primary {
            background: white;
            color: #667eea;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        
        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid white;
        }
        
        .btn-secondary:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-3px);
        }
        
        /* Features Section */
        .features-section {
            background: white;
            padding: 80px 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .section-title {
            text-align: center;
            font-size: 36px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 50px;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        
        .feature-card {
            background: #f7fafc;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        
        .feature-icon {
            font-size: 48px;
            color: #667eea;
            margin-bottom: 20px;
        }
        
        .feature-title {
            font-size: 22px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 15px;
        }
        
        .feature-description {
            font-size: 16px;
            color: #4a5568;
            line-height: 1.6;
        }
        
        /* FAQ Section */
        .faq-section {
            background: #f7fafc;
            padding: 80px 20px;
        }
        
        .faq-container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        .faq-item {
            background: white;
            border-radius: 10px;
            margin-bottom: 20px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .faq-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .faq-question {
            padding: 25px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            font-size: 18px;
            color: #2d3748;
            background: white;
            transition: background 0.3s ease;
        }
        
        .faq-question:hover {
            background: #f7fafc;
        }
        
        .faq-question.active {
            background: #667eea;
            color: white;
        }
        
        .faq-icon {
            font-size: 20px;
            transition: transform 0.3s ease;
        }
        
        .faq-question.active .faq-icon {
            transform: rotate(180deg);
        }
        
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s ease, padding 0.4s ease;
            padding: 0 25px;
        }
        
        .faq-answer.active {
            max-height: 2000px;
            padding: 0 25px 25px;
        }
        
        .faq-answer-content {
            font-size: 16px;
            line-height: 1.8;
            color: #4a5568;
        }
        
        .faq-answer-content ul {
            margin: 15px 0;
            padding-left: 25px;
        }
        
        .faq-answer-content li {
            margin-bottom: 10px;
        }
        
        .faq-answer-content strong {
            color: #2d3748;
        }
        
        /* Footer */
        footer {
            background: #2d3748;
            color: #e2e8f0;
            padding: 40px 20px 20px;
            text-align: center;
        }
        
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .footer-links {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .footer-links a {
            color: #e2e8f0;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .footer-links a:hover {
            color: #667eea;
        }
        
        .copyright {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 14px;
            opacity: 0.8;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            h1 {
                font-size: 32px;
            }
            
            .subtitle {
                font-size: 18px;
            }
            
            .description {
                font-size: 16px;
            }
            
            .section-title {
                font-size: 28px;
            }
            
            .features-grid {
                grid-template-columns: 1fr;
            }
            
            .btn {
                padding: 14px 30px;
                font-size: 16px;
            }
            
            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
        
        /* Scroll Animation */
        .fade-in {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }
        
        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-content">
            <div class="hero-icon">
                <i class="fas fa-vote-yea"></i>
            </div>
            <h1>निवडणूक खर्च व्यवस्थापन प्रणाली</h1>
            <p class="subtitle">Election Expense Management System</p>
            <p class="description">
                उमेदवारांसाठी निवडणुकीदरम्यान होणाऱ्या खर्चाचे दैनंदिन, योग्य आणि कायद्यानुसार व्यवस्थापन करण्यासाठी 
                आणि निवडणूक आयोगाकडे सादर करायचे असलेले खर्चाचे अहवाल सुलभपणे तयार करण्यासाठी सॉफ्टवेअर
            </p>
            <div class="cta-buttons">
                <a href="<%=request.getContextPath()%>/login.jsp" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt"></i>
                    लॉगिन करा / Login
                </a>
                <a href="#features" class="btn btn-secondary">
                    <i class="fas fa-info-circle"></i>
                    अधिक माहिती / Learn More
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features-section">
        <div class="container">
            <h2 class="section-title fade-in">मुख्य वैशिष्ट्ये | Key Features</h2>
            <div class="features-grid">
                <div class="feature-card fade-in">
                    <div class="feature-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <h3 class="feature-title">दैनंदिन खर्च नोंद</h3>
                    <p class="feature-description">
                        प्रत्येक दिवसाचा खर्च तपशीलवार नोंदवा. सर्व प्रकारचे खर्च व्यवस्थित ठेवा.
                    </p>
                </div>
                
                <div class="feature-card fade-in">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3 class="feature-title">खर्च मर्यादा मागोवा</h3>
                    <p class="feature-description">
                        निवडणूक आयोगाने ठरवलेल्या खर्च मर्यादेचा रिअल-टाइम मागोवा घ्या.
                    </p>
                </div>
                
                <div class="feature-card fade-in">
                    <div class="feature-icon">
                        <i class="fas fa-file-pdf"></i>
                    </div>
                    <h3 class="feature-title">अहवाल तयार करा</h3>
                    <p class="feature-description">
                        ECI च्या विहित नमुन्यांनुसार प्रोफॉर्मा-२ आणि इतर अहवाल तयार करा.
                    </p>
                </div>
                
                <div class="feature-card fade-in">
                    <div class="feature-icon">
                        <i class="fas fa-receipt"></i>
                    </div>
                    <h3 class="feature-title">बिल व्यवस्थापन</h3>
                    <p class="feature-description">
                        प्रत्येक खर्चासाठी बिल/व्हाउचर नंबर नोंदवा आणि रेकॉर्ड ठेवा.
                    </p>
                </div>
                
                <div class="feature-card fade-in">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="feature-title">उमेदवार व्यवस्थापन</h3>
                    <p class="feature-description">
                        एकाधिक उमेदवारांचे खर्च स्वतंत्रपणे व्यवस्थापित करा.
                    </p>
                </div>
                
                <div class="feature-card fade-in">
                    <div class="feature-icon">
                        <i class="fas fa-language"></i>
                    </div>
                    <h3 class="feature-title">द्विभाषिक समर्थन</h3>
                    <p class="feature-description">
                        मराठी आणि इंग्रजी दोन्ही भाषांमध्ये उपलब्ध.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="faq-section">
        <div class="faq-container">
            <h2 class="section-title fade-in">वारंवार विचारले जाणारे प्रश्न | Frequently Asked Questions</h2>
            
            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>हे सॉफ्टवेअर कशासाठी उपयुक्त आहे?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        उमेदवारांना निवडणुकीदरम्यान होणाऱ्या खर्चाचे दैनंदिन, योग्य आणि कायद्यानुसार व्यवस्थापन करण्यासाठी, 
                        तसेच निवडणूक आयोगाकडे (Election Commission of India - ECI) सादर करायचे असलेले खर्चाचे अहवाल 
                        (Statements of Election Expenditure) सुलभपणे तयार करण्यासाठी हे सॉफ्टवेअर उपयुक्त आहे.
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>हे सॉफ्टवेअर कोण वापरू शकते?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        निवडणुकीत उभे असलेले उमेदवार, त्यांचे निवडणूक एजंट आणि खर्चाचे दैनंदिन हिशेब ठेवणारे कर्मचारी 
                        (Accountants) हे सॉफ्टवेअर वापरू शकतात.
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>खर्चाची नोंद किती दिवसांत करणे आवश्यक आहे?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        खर्चाची नोंद दैनंदिन आधारावर (Day-to-day basis) त्याच दिवशी किंवा दुसऱ्या दिवसाच्या सकाळपर्यंत 
                        करणे अत्यंत महत्त्वाचे आहे, जेणेकरून कोणतीही एंट्री राहू नये.
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>कोणते खर्च नोंदवणे आवश्यक आहेत?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        निवडणुकीशी संबंधित उमेदवाराने किंवा त्याच्या निवडणूक एजंटने केलेला किंवा त्यांच्या परवानगीने इतर 
                        कोणत्याही व्यक्ती/संस्थेने केलेला प्रत्येक खर्च नोंदवणे आवश्यक आहे. उदाहरणार्थ:
                        <ul>
                            <li><strong>प्रचार साहित्य:</strong> पोस्टर्स, बॅनर, हँडबिल</li>
                            <li><strong>जाहिराती:</strong> वृत्तपत्र, टीव्ही, सोशल मीडिया</li>
                            <li><strong>सार्वजनिक सभा:</strong> मैदान भाडे, ध्वनी व्यवस्था</li>
                            <li><strong>वाहतूक:</strong> वाहन भाडे, इंधन खर्च</li>
                            <li><strong>कार्यालयीन खर्च:</strong> भाडे, कर्मचारी पगार</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>निवडणूक आयोगाकडे खर्च कधी सादर करायचा?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        उमेदवारांना निवडणुकीचा निकाल जाहीर झाल्याच्या तारखेपासून <strong>३० दिवसांच्या आत</strong> खर्चाचे 
                        अंतिम स्टेटमेंट (Final Statement of Election Expenditure) जिल्हा निवडणूक अधिकारी (DEO) किंवा 
                        निवडणूक निर्णय अधिकारी (RO) यांच्याकडे सादर करणे बंधनकारक आहे.
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>खर्च सादर न केल्यास काय होते?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        <strong>अत्यंत गंभीर परिणाम:</strong>
                        <ul>
                            <li><strong>अपात्रता:</strong> निवडणूक आयोग उमेदवाराला अपात्र घोषित करते</li>
                            <li><strong>कालावधी:</strong> तीन वर्षांसाठी अपात्रता</li>
                            <li><strong>परिणाम:</strong> पुढील तीन वर्षांसाठी कोणतीही निवडणूक लढविण्यासाठी अपात्र</li>
                        </ul>
                        <strong>महत्त्वाचे:</strong> अगदी विजयी उमेदवाराचा निकाल देखील रद्द होऊ शकतो!
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>कागदपत्रे (Vouchers/Bills) कशी ठेवायची?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        प्रत्येक खर्चाच्या नोंदीसाठी मूळ बिल/व्हाउचर (Original Bill/Voucher) यांची झेरॉक्स कॉपी दैनंदिन 
                        खर्च स्टेटमेंट सोबत जोडून निवडणूक कार्यालयास सादर करावे आणि ही सर्व मूळ कागदपत्रे सुरक्षितपणे 
                        जतन करून ठेवणे बंधनकारक आहे.
                    </div>
                </div>
            </div>

            <div class="faq-item fade-in">
                <div class="faq-question">
                    <span>₹१०,००० पेक्षा जास्त खर्चासाठी काय नियम आहे?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        <strong>महत्त्वाची टीप:</strong> कोणताही खर्च ₹१०,००० पेक्षा जास्त असल्यास, तो चेक किंवा 
                        बँक ट्रान्सफरने करणे <strong>अनिवार्य</strong> आहे. रोख रकमेने ₹१०,००० पेक्षा जास्त खर्च 
                        करता येत नाही.
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/login.jsp">
                    <i class="fas fa-sign-in-alt"></i> लॉगिन करा
                </a>
                <a href="#features">
                    <i class="fas fa-star"></i> वैशिष्ट्ये
                </a>
                <a href="#faq">
                    <i class="fas fa-question-circle"></i> FAQ
                </a>
            </div>
            <div class="copyright">
                <p>&copy; 2025 निवडणूक खर्च व्यवस्थापन प्रणाली | Election Expense Management System</p>
                <p>सर्व हक्क राखीव | All Rights Reserved</p>
            </div>
        </div>
    </footer>

    <script>
        // FAQ Accordion
        document.querySelectorAll('.faq-question').forEach(question => {
            question.addEventListener('click', function() {
                const isActive = this.classList.contains('active');
                
                // Close all FAQs
                document.querySelectorAll('.faq-question').forEach(q => {
                    q.classList.remove('active');
                });
                document.querySelectorAll('.faq-answer').forEach(a => {
                    a.classList.remove('active');
                });
                
                // Open clicked FAQ if it wasn't already open
                if (!isActive) {
                    this.classList.add('active');
                    this.nextElementSibling.classList.add('active');
                }
            });
        });

        // Scroll Animation
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        }, observerOptions);

        document.querySelectorAll('.fade-in').forEach(el => {
            observer.observe(el);
        });

        // Smooth Scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>

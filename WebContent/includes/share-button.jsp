<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get the current domain URL
    String scheme = request.getScheme();
    String serverName = request.getServerName();
    int serverPort = request.getServerPort();
    String contextPath = request.getContextPath();
    
    String domainURL = scheme + "://" + serverName;
    if ((scheme.equals("http") && serverPort != 80) || (scheme.equals("https") && serverPort != 443)) {
        domainURL += ":" + serverPort;
    }
    domainURL += contextPath;
%>

<!-- Share Button Styles -->
<style>
    .share-button-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 999;
    }
    
    .share-btn {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 14px 20px;
        border-radius: 50px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .share-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
    }
    
    .share-btn:active {
        transform: translateY(0);
    }
    
    .share-icon {
        font-size: 16px;
    }
    
    /* Share Modal */
    .share-modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        z-index: 1000;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease;
    }
    
    .share-modal.active {
        display: flex;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    .share-modal-content {
        background: white;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        max-width: 500px;
        width: 90%;
        animation: slideUp 0.3s ease;
    }
    
    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .share-modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    
    .share-modal-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: #1a202c;
        margin: 0;
    }
    
    .share-modal-close {
        background: none;
        border: none;
        font-size: 24px;
        color: #718096;
        cursor: pointer;
        padding: 0;
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        transition: all 0.2s;
    }
    
    .share-modal-close:hover {
        background: #f7fafc;
        color: #1a202c;
    }
    
    .share-url-container {
        background: #f7fafc;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .share-url-input {
        flex: 1;
        border: none;
        background: transparent;
        font-size: 14px;
        color: #2d3748;
        font-family: 'Monaco', 'Courier New', monospace;
        outline: none;
    }
    
    .copy-btn {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        white-space: nowrap;
    }
    
    .copy-btn:hover {
        transform: scale(1.05);
    }
    
    .copy-btn.copied {
        background: #48bb78;
    }
    
    .share-options {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
        gap: 10px;
    }
    
    .share-option-btn {
        padding: 12px;
        border: 2px solid #e2e8f0;
        background: white;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.2s;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        font-weight: 600;
        color: #2d3748;
    }
    
    .share-option-btn:hover {
        border-color: #667eea;
        background: #f7fafc;
        transform: translateY(-2px);
    }
    
    .share-option-icon {
        font-size: 24px;
    }
    
    /* Mobile Responsive */
    @media (max-width: 768px) {
        .share-button-container {
            bottom: 15px;
            right: 15px;
        }
        
        .share-btn {
            padding: 12px 16px;
            font-size: 13px;
        }
        
        .share-modal-content {
            padding: 20px;
            max-width: 95%;
        }
        
        .share-modal-title {
            font-size: 1.3rem;
        }
        
        .share-url-container {
            flex-direction: column;
            align-items: stretch;
        }
        
        .copy-btn {
            width: 100%;
            padding: 12px;
        }
        
        .share-options {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    
    @media (max-width: 480px) {
        .share-btn span:not(.share-icon) {
            display: none;
        }
        
        .share-btn {
            width: 50px;
            height: 50px;
            padding: 0;
            justify-content: center;
        }
    }
</style>

<!-- Share Button -->
<div class="share-button-container">
    <button class="share-btn" onclick="openShareModal()">
        <span class="share-icon">🔗</span>
        <span>Share</span>
    </button>
</div>

<!-- Share Modal -->
<div class="share-modal" id="shareModal" onclick="closeShareModal(event)">
    <div class="share-modal-content" onclick="event.stopPropagation()">
        <div class="share-modal-header">
            <h3 class="share-modal-title">Share this Project</h3>
            <button class="share-modal-close" onclick="closeShareModal()">&times;</button>
        </div>
        
        <div class="share-url-container">
            <input type="text" class="share-url-input" id="shareUrlInput" value="<%= domainURL %>" readonly>
            <button class="copy-btn" id="copyBtn" onclick="copyToClipboard()">Copy</button>
        </div>
        
        <div class="share-options">
            <button class="share-option-btn" onclick="shareViaWhatsApp()">
                <span class="share-option-icon">📱</span>
                WhatsApp
            </button>
            <button class="share-option-btn" onclick="shareViaEmail()">
                <span class="share-option-icon">📧</span>
                Email
            </button>
            <button class="share-option-btn" onclick="shareViaSMS()">
                <span class="share-option-icon">💬</span>
                SMS
            </button>
            <button class="share-option-btn" onclick="shareViaFacebook()">
                <span class="share-option-icon">📘</span>
                Facebook
            </button>
        </div>
    </div>
</div>

<!-- Share Button JavaScript -->
<script>
    const shareURL = '<%= domainURL %>';
    const shareTitle = 'Election Expense Management System';
    const shareText = 'Check out this Election Expense Management System: ';
    
    function openShareModal() {
        document.getElementById('shareModal').classList.add('active');
        document.getElementById('shareUrlInput').select();
    }
    
    function closeShareModal(event) {
        if (!event || event.target.id === 'shareModal') {
            document.getElementById('shareModal').classList.remove('active');
        }
    }
    
    function copyToClipboard() {
        const input = document.getElementById('shareUrlInput');
        const btn = document.getElementById('copyBtn');
        
        input.select();
        input.setSelectionRange(0, 99999); // For mobile devices
        
        try {
            document.execCommand('copy');
            btn.textContent = '✓ Copied!';
            btn.classList.add('copied');
            
            setTimeout(() => {
                btn.textContent = 'Copy';
                btn.classList.remove('copied');
            }, 2000);
        } catch (err) {
            alert('Failed to copy. Please copy manually.');
        }
    }
    
    function shareViaWhatsApp() {
        const text = encodeURIComponent(shareText + shareURL);
        const whatsappURL = 'https://wa.me/?text=' + text;
        window.open(whatsappURL, '_blank');
    }
    
    function shareViaEmail() {
        const subject = encodeURIComponent(shareTitle);
        const body = encodeURIComponent(shareText + '\n\n' + shareURL);
        const emailURL = 'mailto:?subject=' + subject + '&body=' + body;
        window.location.href = emailURL;
    }
    
    function shareViaSMS() {
        const text = encodeURIComponent(shareText + shareURL);
        const smsURL = 'sms:?body=' + text;
        window.location.href = smsURL;
    }
    
    function shareViaFacebook() {
        const facebookURL = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(shareURL);
        window.open(facebookURL, '_blank', 'width=600,height=400');
    }
    
    // Close modal on Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeShareModal();
        }
    });
</script>

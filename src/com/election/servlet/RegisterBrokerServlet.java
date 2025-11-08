package com.election.servlet;

import com.election.dao.UserDAO;
import com.election.model.User;
import com.election.util.ValidationUtil;
import com.election.util.SMSUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@MultipartConfig(
    maxFileSize = 5242880,      // 5MB
    maxRequestSize = 10485760,  // 10MB
    fileSizeThreshold = 1048576 // 1MB
)
public class RegisterBrokerServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User admin = (User) session.getAttribute("user");
        if (!"admin".equals(admin.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=" + 
                                java.net.URLEncoder.encode("Unauthorized access", "UTF-8"));
            return;
        }
        
        // Get form parameters - NEW FIELD NAMES
        String firmName = request.getParameter("firmName");
        String ownerName = request.getParameter("ownerName");
        String mobileNumber = request.getParameter("mobileNumber");
        String whatsappNumber = request.getParameter("whatsappNumber");
        String fullAddress = request.getParameter("fullAddress");
        String taluka = request.getParameter("taluka");
        String district = request.getParameter("district");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String gstNumber = request.getParameter("gstNumber");
        String username = request.getParameter("username");
        String referralCode = request.getParameter("referralCode");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Build error redirect URL with all parameters to preserve data
        StringBuilder redirectUrl = new StringBuilder("admin/register-broker.jsp?");
        redirectUrl.append("firmName=").append(java.net.URLEncoder.encode(firmName != null ? firmName : "", "UTF-8"));
        redirectUrl.append("&ownerName=").append(java.net.URLEncoder.encode(ownerName != null ? ownerName : "", "UTF-8"));
        redirectUrl.append("&mobileNumber=").append(java.net.URLEncoder.encode(mobileNumber != null ? mobileNumber : "", "UTF-8"));
        redirectUrl.append("&whatsappNumber=").append(java.net.URLEncoder.encode(whatsappNumber != null ? whatsappNumber : "", "UTF-8"));
        redirectUrl.append("&fullAddress=").append(java.net.URLEncoder.encode(fullAddress != null ? fullAddress : "", "UTF-8"));
        redirectUrl.append("&taluka=").append(java.net.URLEncoder.encode(taluka != null ? taluka : "", "UTF-8"));
        redirectUrl.append("&district=").append(java.net.URLEncoder.encode(district != null ? district : "", "UTF-8"));
        redirectUrl.append("&state=").append(java.net.URLEncoder.encode(state != null ? state : "", "UTF-8"));
        redirectUrl.append("&pincode=").append(java.net.URLEncoder.encode(pincode != null ? pincode : "", "UTF-8"));
        redirectUrl.append("&gstNumber=").append(java.net.URLEncoder.encode(gstNumber != null ? gstNumber : "", "UTF-8"));
        redirectUrl.append("&username=").append(java.net.URLEncoder.encode(username != null ? username : "", "UTF-8"));
        redirectUrl.append("&referralCode=").append(java.net.URLEncoder.encode(referralCode != null ? referralCode : "", "UTF-8"));
        
        // Validation
        if (!ValidationUtil.isNotEmpty(firmName) || !ValidationUtil.isNotEmpty(ownerName) ||
            !ValidationUtil.isNotEmpty(mobileNumber) || !ValidationUtil.isNotEmpty(whatsappNumber) ||
            !ValidationUtil.isNotEmpty(fullAddress) || !ValidationUtil.isNotEmpty(taluka) ||
            !ValidationUtil.isNotEmpty(district) || !ValidationUtil.isNotEmpty(state) ||
            !ValidationUtil.isNotEmpty(pincode) || !ValidationUtil.isNotEmpty(username) || 
            !ValidationUtil.isNotEmpty(password) || !ValidationUtil.isNotEmpty(referralCode)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("All required fields must be filled", "UTF-8"));
            return;
        }
        
        // Validate address length
        if (fullAddress.trim().length() < 10 || fullAddress.trim().length() > 500) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Address must be between 10-500 characters", "UTF-8"));
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Passwords do not match", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Password must be at least 6 characters long", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidMobile(mobileNumber)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Invalid mobile number", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidMobile(whatsappNumber)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Invalid WhatsApp number", "UTF-8"));
            return;
        }
        
        // Validate pincode (6 digits)
        if (!pincode.matches("[0-9]{6}")) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Invalid pincode. Must be 6 digits", "UTF-8"));
            return;
        }
        
        // Validate GST number if provided
        if (ValidationUtil.isNotEmpty(gstNumber)) {
            if (!gstNumber.matches("[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}")) {
                response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                    java.net.URLEncoder.encode("Invalid GST number format", "UTF-8"));
                return;
            }
        }
        
        // Validate referral code format (alphanumeric, 6-20 characters)
        if (!referralCode.matches("[A-Z0-9]{6,20}")) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Referral code must be 6-20 alphanumeric characters (A-Z, 0-9)", "UTF-8"));
            return;
        }
        
        // Check if username exists
        if (userDAO.isUsernameExists(username)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Username already taken", "UTF-8"));
            return;
        }
        
        // Check if mobile exists
        if (userDAO.isMobileExists(mobileNumber)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Mobile number already registered", "UTF-8"));
            return;
        }
        
        // Check if referral code exists
        if (userDAO.isReferralCodeExists(referralCode)) {
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Referral code already exists. Please choose a unique code.", "UTF-8"));
            return;
        }
        
        // Handle file uploads
        String visitingCardPath = null;
        String shopPhotoPath = null;
        
        try {
            Part visitingCardPart = request.getPart("visitingCard");
            Part shopPhotoPart = request.getPart("shopPhoto");
            
            if (visitingCardPart == null || visitingCardPart.getSize() == 0) {
                response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                    java.net.URLEncoder.encode("Visiting card photo is required", "UTF-8"));
                return;
            }
            
            // Create upload directories if they don't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            File visitingCardsDir = new File(uploadPath + File.separator + "visiting-cards");
            if (!visitingCardsDir.exists()) {
                visitingCardsDir.mkdirs();
            }
            
            File shopPhotosDir = new File(uploadPath + File.separator + "shop-photos");
            if (!shopPhotosDir.exists()) {
                shopPhotosDir.mkdirs();
            }
            
            // Save visiting card
            String visitingCardFileName = System.currentTimeMillis() + "_" + getFileName(visitingCardPart);
            visitingCardPath = "uploads/visiting-cards/" + visitingCardFileName;
            File visitingCardFile = new File(visitingCardsDir, visitingCardFileName);
            visitingCardPart.write(visitingCardFile.getAbsolutePath());
            
            // Save shop photo if provided
            if (shopPhotoPart != null && shopPhotoPart.getSize() > 0) {
                String shopPhotoFileName = System.currentTimeMillis() + "_" + getFileName(shopPhotoPart);
                shopPhotoPath = "uploads/shop-photos/" + shopPhotoFileName;
                File shopPhotoFile = new File(shopPhotosDir, shopPhotoFileName);
                shopPhotoPart.write(shopPhotoFile.getAbsolutePath());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Error uploading files: " + e.getMessage(), "UTF-8"));
            return;
        }
        
        // Create broker user with NEW fields
        User broker = new User();
        broker.setFirstName(ownerName);  // Using ownerName as firstName
        broker.setLastName("");  // Empty last name for now
        broker.setMobile(mobileNumber);
        broker.setEmail(mobileNumber + "@broker.temp");  // Temporary email if not collected
        broker.setAddress(fullAddress.trim() + ", " + taluka + ", " + district + ", " + state + " - " + pincode);
        broker.setUsername(username);
        broker.setPassword(password);
        broker.setReferralCode(referralCode.toUpperCase());
        broker.setBrokerId(null);  // No broker assigned, this IS a broker
        broker.setRole("broker");
        broker.setStatus("active");
        
        // Store additional broker info in a custom way (you may need to add these fields to User model or create a Broker model)
        // For now, we'll log them
        System.out.println("Broker Business Info:");
        System.out.println("  Firm Name: " + firmName);
        System.out.println("  Owner Name: " + ownerName);
        System.out.println("  Mobile: " + mobileNumber);
        System.out.println("  WhatsApp: " + whatsappNumber);
        System.out.println("  Address: " + fullAddress);
        System.out.println("  Taluka: " + taluka);
        System.out.println("  District: " + district);
        System.out.println("  State: " + state);
        System.out.println("  Pincode: " + pincode);
        System.out.println("  GST Number: " + (gstNumber != null ? gstNumber : "N/A"));
        System.out.println("  Visiting Card: " + visitingCardPath);
        System.out.println("  Shop Photo: " + (shopPhotoPath != null ? shopPhotoPath : "N/A"));
        
        if (userDAO.registerBroker(broker)) {
            System.out.println("SUCCESS: Broker registered by admin " + admin.getUsername() + 
                             " - Username: " + username + ", Referral Code: " + referralCode);
            
            // Send SMS notification to broker
            try {
                SMSUtil.sendBrokerRegistrationSMS(mobileNumber, ownerName, referralCode);
                System.out.println("SMS sent to broker: " + mobileNumber);
            } catch (Exception e) {
                System.err.println("Failed to send SMS to broker: " + e.getMessage());
            }
            
            response.sendRedirect("admin/register-broker.jsp?success=" + 
                                java.net.URLEncoder.encode("Broker registered successfully! Username: " + username + ", Referral Code: " + referralCode, "UTF-8"));
        } else {
            System.err.println("ERROR: Failed to register broker - Username: " + username);
            response.sendRedirect(redirectUrl.toString() + "&error=" + 
                                java.net.URLEncoder.encode("Registration failed. Please try again.", "UTF-8"));
        }
    }
    
    // Helper method to extract file name from Part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "file_" + System.currentTimeMillis();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin/register-broker.jsp");
    }
}

package com.election.test;

import com.election.dao.CandidateDAO;
import com.election.model.Candidate;

/**
 * Test class to verify candidate update functionality
 * Run this class to test if gender, mobile, and email update correctly
 */
public class TestCandidateUpdate {
    
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("TESTING CANDIDATE UPDATE");
        System.out.println("========================================\n");
        
        // Change this to an actual candidate ID from your database
        int testCandidateId = 1;
        
        CandidateDAO dao = new CandidateDAO();
        
        // Step 1: Get existing candidate
        System.out.println("Step 1: Fetching candidate with ID: " + testCandidateId);
        Candidate candidate = dao.getCandidateById(testCandidateId);
        
        if (candidate == null) {
            System.err.println("ERROR: Candidate not found with ID: " + testCandidateId);
            System.err.println("Please change testCandidateId to a valid candidate ID");
            return;
        }
        
        System.out.println("Found candidate: " + candidate.getCandidateName());
        System.out.println("Current values:");
        System.out.println("  Gender: " + candidate.getGender());
        System.out.println("  Mobile: " + candidate.getMobile());
        System.out.println("  Email: " + candidate.getEmail());
        System.out.println();
        
        // Step 2: Update the values
        System.out.println("Step 2: Setting new values...");
        String newGender = "Male";
        String newMobile = "9876543210";
        String newEmail = "test@example.com";
        
        candidate.setGender(newGender);
        candidate.setMobile(newMobile);
        candidate.setEmail(newEmail);
        
        System.out.println("New values set:");
        System.out.println("  Gender: " + candidate.getGender());
        System.out.println("  Mobile: " + candidate.getMobile());
        System.out.println("  Email: " + candidate.getEmail());
        System.out.println();
        
        // Step 3: Save to database
        System.out.println("Step 3: Saving to database...");
        boolean success = dao.updateCandidate(candidate);
        
        if (success) {
            System.out.println("✓ Update successful!");
        } else {
            System.err.println("✗ Update failed!");
            System.err.println("Check the console for SQL errors above");
            return;
        }
        System.out.println();
        
        // Step 4: Fetch again to verify
        System.out.println("Step 4: Fetching candidate again to verify...");
        Candidate verifyCandidate = dao.getCandidateById(testCandidateId);
        
        if (verifyCandidate == null) {
            System.err.println("ERROR: Could not fetch candidate for verification");
            return;
        }
        
        System.out.println("Values from database after update:");
        System.out.println("  Gender: " + verifyCandidate.getGender());
        System.out.println("  Mobile: " + verifyCandidate.getMobile());
        System.out.println("  Email: " + verifyCandidate.getEmail());
        System.out.println();
        
        // Step 5: Verify results
        System.out.println("Step 5: Verification...");
        boolean genderMatches = newGender.equals(verifyCandidate.getGender());
        boolean mobileMatches = newMobile.equals(verifyCandidate.getMobile());
        boolean emailMatches = newEmail.equals(verifyCandidate.getEmail());
        
        System.out.println("  Gender " + (genderMatches ? "✓" : "✗") + 
                          " (Expected: " + newGender + ", Got: " + verifyCandidate.getGender() + ")");
        System.out.println("  Mobile " + (mobileMatches ? "✓" : "✗") + 
                          " (Expected: " + newMobile + ", Got: " + verifyCandidate.getMobile() + ")");
        System.out.println("  Email " + (emailMatches ? "✓" : "✗") + 
                          " (Expected: " + newEmail + ", Got: " + verifyCandidate.getEmail() + ")");
        System.out.println();
        
        if (genderMatches && mobileMatches && emailMatches) {
            System.out.println("========================================");
            System.out.println("SUCCESS! All fields updated correctly.");
            System.out.println("The database update is working fine.");
            System.out.println("Issue may be in the web form or servlet.");
            System.out.println("========================================");
        } else {
            System.out.println("========================================");
            System.out.println("FAILED! Some fields did not update.");
            System.out.println("Issue is in the database or DAO layer.");
            System.out.println("Check database column names and types.");
            System.out.println("========================================");
        }
    }
}

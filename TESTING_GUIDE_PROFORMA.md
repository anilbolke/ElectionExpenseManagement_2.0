# Testing Guide: Proforma Generation Feature

## Prerequisites
1. Application must be deployed and running on Tomcat
2. MySQL database must be running with candidate data
3. User must be logged in with at least one candidate record

## Step-by-Step Testing

### Test 1: Generate PDF for Valid Candidate
**Steps:**
1. Login to the system as a user
2. Navigate to "Manage Candidates" page
3. Locate any candidate card
4. Click on "📄 Generate Proforma" button

**Expected Result:**
- A PDF file downloads automatically OR opens in a new browser tab
- Filename format: `Candidate_Proforma_[CandidateName].pdf`
- PDF contains all candidate information properly formatted

### Test 2: Verify PDF Content
**Steps:**
1. Open the generated PDF
2. Check all sections are present:
   - Header with system title and generation date
   - Personal Information section
   - Address Details section
   - Identity Documents section
   - Election Program Details section
   - Payment & Account Status section
   - Declaration section
   - Footer with document ID

**Expected Result:**
- All sections visible and properly formatted
- Data matches the candidate's information
- Aadhar number is masked (only last 4 digits visible)
- Watermark "ELECTION PROFORMA" visible in background
- Professional styling with blue accent colors

### Test 3: Security - Unauthorized Access
**Steps:**
1. Login as User A
2. Get a candidate ID from User A's candidates
3. Logout
4. Login as User B
5. Try to access: `/generateProforma?candidateId=[User A's Candidate ID]`

**Expected Result:**
- Should redirect to manage-candidates page
- Error message: "Unauthorized access"
- PDF should NOT be generated

### Test 4: Invalid Candidate ID
**Steps:**
1. Login to the system
2. Navigate to URL: `/generateProforma?candidateId=99999` (non-existent ID)

**Expected Result:**
- Redirect to manage-candidates page
- Error message: "Candidate not found"

### Test 5: Missing Candidate ID
**Steps:**
1. Login to the system
2. Navigate to URL: `/generateProforma` (without candidateId parameter)

**Expected Result:**
- Redirect to manage-candidates page
- Error message: "Invalid candidate ID"

### Test 6: Not Logged In
**Steps:**
1. Logout from the system
2. Try to access: `/generateProforma?candidateId=1`

**Expected Result:**
- Redirect to login page
- No PDF generated

### Test 7: Multiple Candidates
**Steps:**
1. Login to the system
2. Navigate to "Manage Candidates" page
3. Generate proforma for multiple different candidates

**Expected Result:**
- Each PDF downloads successfully
- Each has correct candidate-specific data
- Filenames are different based on candidate names

### Test 8: Special Characters in Name
**Steps:**
1. Find a candidate with special characters in name (e.g., "John O'Brien" or "José García")
2. Click "📄 Generate Proforma"

**Expected Result:**
- PDF generates successfully
- Filename has special characters replaced with underscores
- PDF content displays special characters correctly

### Test 9: Print Functionality
**Steps:**
1. Generate a PDF
2. Open it in browser/PDF viewer
3. Try to print (Ctrl+P or File > Print)

**Expected Result:**
- Print preview shows proper formatting
- All sections fit on pages appropriately
- Colors and layout are print-friendly

### Test 10: Browser Compatibility
**Steps:**
1. Test PDF generation on different browsers:
   - Chrome
   - Firefox
   - Edge
   - Safari (if available)

**Expected Result:**
- PDF generates successfully on all browsers
- Download/open behavior may vary by browser settings
- Content and formatting remain consistent

## Quick URLs for Testing

Replace `[BASE_URL]` with your application URL (e.g., `http://localhost:8080/ElectionExpenseManagement`)

- Manage Candidates: `[BASE_URL]/user/manage-candidates.jsp`
- Generate Proforma: `[BASE_URL]/generateProforma?candidateId=[ID]`

## Sample Test Data Requirements

To fully test, ensure you have:
1. At least 2 user accounts
2. Each user has at least 1 candidate
3. At least one candidate with:
   - Complete profile information
   - Active payment status
   - All optional fields filled

## Validation Checklist

After testing, verify:
- ✅ PDF generation works for all valid candidates
- ✅ Security prevents unauthorized access
- ✅ Error messages display correctly
- ✅ Button appears on all candidate cards
- ✅ PDF content is accurate and complete
- ✅ File naming convention is correct
- ✅ Special characters handled properly
- ✅ Print-friendly formatting
- ✅ No console errors in browser
- ✅ No server errors in logs

## Common Issues & Solutions

### Issue 1: PDF doesn't download
**Solution:** Check browser settings for pop-up blocker and download permissions

### Issue 2: Button not visible
**Solution:** 
- Clear browser cache
- Verify manage-candidates.jsp was updated correctly
- Check if CSS is loading properly

### Issue 3: Servlet not found (404)
**Solution:**
- Verify GenerateProformaServlet.java is compiled
- Check web.xml mapping is correct
- Restart Tomcat server

### Issue 4: Error generating PDF
**Solution:**
- Check server logs for detailed error
- Verify PDFGenerator.java has no syntax errors
- Ensure candidate data is valid in database

### Issue 5: Empty PDF or corrupted file
**Solution:**
- Check if all candidate fields have valid data
- Verify null handling in PDFGenerator
- Check character encoding (should be UTF-8)

## Server Log Monitoring

Monitor these log patterns during testing:
- `GenerateProformaServlet` - servlet execution
- `PDFGenerator` - PDF generation
- Stack traces for any errors

## Database Queries for Testing

Get candidate IDs for testing:
```sql
SELECT candidate_id, candidate_name, user_id FROM candidates LIMIT 10;
```

Get candidates for specific user:
```sql
SELECT candidate_id, candidate_name FROM candidates WHERE user_id = [USER_ID];
```

## Performance Testing

1. Generate PDFs for 10 candidates consecutively
2. Measure time taken for each generation
3. Check memory usage

**Expected Performance:**
- Each PDF should generate in < 2 seconds
- No memory leaks
- Server remains responsive

## Accessibility Testing

1. Test with screen readers
2. Verify keyboard navigation to button
3. Check color contrast in PDF

## Final Verification

Before marking as complete:
1. ✅ All 10 test cases pass
2. ✅ No console errors
3. ✅ No server errors
4. ✅ PDFs are properly formatted
5. ✅ Security works as expected
6. ✅ Documentation is complete
7. ✅ Code is clean and commented
8. ✅ Feature integrated seamlessly

## Deployment Checklist

Before deploying to production:
- [ ] All tests passed
- [ ] Code reviewed
- [ ] Server logs clean
- [ ] Performance acceptable
- [ ] Security verified
- [ ] Documentation updated
- [ ] Backup taken
- [ ] Rollback plan ready

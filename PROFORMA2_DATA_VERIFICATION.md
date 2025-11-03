# ✅ Proforma-2 Data Verification Guide

## 🎯 Expected Output Format

Your Proforma-2 will display expense data in this exact format:

```html
<tr>
  <td>1</td>                           <!-- Serial -->
  <td>प्रचार साहित्य</td>              <!-- Category -->
  <td>पोस्टर छपाई</td>                 <!-- Description -->
  <td>₹5000.00</td>                    <!-- Amount -->
  <td>01/11/2024</td>                  <!-- Date -->
  <td>REC-001</td>                     <!-- Receipt -->
  <td>राजेश कुमार</td>                 <!-- Person (candidate) -->
  <td>₹5000.00</td>                    <!-- Self expense -->
  <td>-</td>                           <!-- Party expense -->
  <td>-</td>                           <!-- Others expense -->
</tr>
```

---

## 🔍 How to Verify

### Step 1: Restart Server
```
1. Stop your Tomcat server
2. Wait 5 seconds
3. Start your Tomcat server
```

### Step 2: Add Test Expense
```
1. Login to your application
2. Select a candidate
3. Go to "Add Expense"
4. Fill in:
   - Category: "प्रचार साहित्य"
   - Description: "पोस्टर छपाई"
   - Amount: 5000
   - Date: 01/11/2024
   - Payment Mode: "Self"
   - Receipt: "REC-001"
5. Save
```

### Step 3: Generate Proforma-2
```
1. Go to Dashboard or Manage Candidates
2. Click "📑 Proforma-2 (Template)" button (orange)
3. Document will open in new tab
```

### Step 4: Verify Data Display
```
Look for:
✓ Serial number: 1
✓ Category: प्रचार साहित्य
✓ Description: पोस्टर छपाई
✓ Amount: ₹5000.00
✓ Date: 01/11/2024
✓ Receipt: REC-001
✓ Person: Your candidate name
✓ Self expense: ₹5000.00
✓ Party expense: -
✓ Others expense: -
```

### Step 5: View Source Code (Optional)
```
1. Right-click on the page
2. Select "View Page Source"
3. Search for "<tr>" in the source
4. Verify HTML matches the format above
```

---

## 📊 Test All Three Expense Types

### Test 1: Self Expense
```
Add Expense:
- Category: "प्रचार साहित्य"
- Description: "पोस्टर छपाई"
- Amount: 5000
- Payment Mode: "Self"

Expected Row:
Serial: 1
Amount appears in: Column 8 (Self expense)
Person Name: Candidate name
```

### Test 2: Party Expense
```
Add Expense:
- Category: "सभा आयोजन"
- Description: "मंच व्यवस्था"
- Amount: 10000
- Payment Mode: "Party"

Expected Row:
Serial: 2
Amount appears in: Column 9 (Party expense)
Person Name: Party name
```

### Test 3: Others Expense (with vendor)
```
Add Expense:
- Category: "छपाई"
- Description: "बॅनर"
- Amount: 3000
- Payment Mode: "Others"
- Vendor Name: "ABC Printers"

Expected Row:
Serial: 3
Amount appears in: Column 10 (Others expense)
Person Name: "ABC Printers"
```

### Test 4: Others Expense (without vendor)
```
Add Expense:
- Category: "वाहन खर्च"
- Description: "पेट्रोल"
- Amount: 2000
- Payment Mode: "Others"
- Vendor Name: (leave empty)

Expected Row:
Serial: 4
Amount appears in: Column 10 (Others expense)
Person Name: "इतर / Others"
```

---

## ✅ Complete Table Should Look Like

```
┌────┬──────────────┬────────────┬──────────┬────────────┬─────────┬──────────────────┬──────────┬──────────┬──────────┐
│ Sr │   Category   │Description │  Amount  │    Date    │ Receipt │  Person Name     │   Self   │  Party   │  Others  │
├────┼──────────────┼────────────┼──────────┼────────────┼─────────┼──────────────────┼──────────┼──────────┼──────────┤
│ 1  │ प्रचार साहित्य│ पोस्टर छपाई│ ₹5000.00 │ 01/11/2024 │ REC-001 │ राजेश कुमार      │ ₹5000.00 │    -     │    -     │
│ 2  │ सभा आयोजन    │ मंच व्यवस्था│ ₹10000.00│ 02/11/2024 │ REC-002 │ भारतीय जनता पक्ष │    -     │ ₹10000.00│    -     │
│ 3  │ छपाई         │ बॅनर       │ ₹3000.00 │ 03/11/2024 │ REC-003 │ ABC Printers     │    -     │    -     │ ₹3000.00 │
│ 4  │ वाहन खर्च    │ पेट्रोल    │ ₹2000.00 │ 04/11/2024 │ REC-004 │ इतर / Others     │    -     │    -     │ ₹2000.00 │
├────┴──────────────┴────────────┴──────────┴────────────┴─────────┴──────────────────┴──────────┴──────────┼──────────┤
│                                                                             एकूण निवडणुकीचा खर्च │ ₹20000.00│
└──────────────────────────────────────────────────────────────────────────────────────────────────┴──────────┘
```

---

## 🎯 Data Source Mapping

| Column | Display Name | Data From | Example |
|--------|-------------|-----------|---------|
| 1 | अ.क्र | Auto-increment | 1, 2, 3... |
| 2 | खर्चीची मुख्य बाब | `expense.getExpenseCategory()` | प्रचार साहित्य |
| 3 | खर्चीची अंतर बाब | `expense.getExpenseDescription()` | पोस्टर छपाई |
| 4 | प्रति दर | `expense.getExpenseAmount()` | ₹5000.00 |
| 5 | दिनांक | `expense.getExpenseDate()` | 01/11/2024 |
| 6 | पावती | `expense.getReceiptNumber()` | REC-001 |
| 7 | व्यक्तीचा नाव | Based on `paymentMode` | राजेश कुमार |
| 8 | स्वतः खर्च | If `paymentMode = "self"` | ₹5000.00 or - |
| 9 | पक्ष खर्च | If `paymentMode = "party"` | ₹10000.00 or - |
| 10 | इतर खर्च | If `paymentMode = "others"` | ₹3000.00 or - |

---

## 🔍 Troubleshooting

### Issue 1: Data Not Showing
**Check:**
- Are expenses added for this candidate?
- Is candidate active and payment verified?
- Did you restart the server after code changes?

### Issue 2: Wrong Format
**Check:**
- View page source to see actual HTML
- Compare with expected format
- Check server console for errors

### Issue 3: Amount Format Wrong
**Expected:** `₹5000.00` (with rupee symbol and 2 decimals)
**If showing:** `5000` or `5000.0`
**Fix:** Restart server (code already formats correctly)

### Issue 4: Vendor Name Not Showing
**Check:**
- Did you enter vendor name in Add Expense form?
- Is payment mode set to "others"?
- Check database: `SELECT vendor_name FROM expenses WHERE expense_id = X`

---

## 📝 Quick Checklist

Before testing, ensure:

- [x] Server restarted after code changes
- [x] Template file exists: `WebContent/Document/proforma2.html`
- [x] Servlet mapped: `/generateProforma2`
- [x] Candidate is active and verified
- [x] At least one expense added
- [x] Button appears (orange "📑 Proforma-2 (Template)")

---

## 🎨 Visual Example

When you click the button, you should see:

```
┌─────────────────────────────────────────────────────┐
│                     नमुना-२                         │
│           उमेदवार - एकूण निवडणूक खर्च              │
├─────────────────────────────────────────────────────┤
│  [Candidate Information Table]                      │
├─────────────────────────────────────────────────────┤
│  [10-Column Expense Table]                          │
│  Row 1: Serial 1, Category, Description...          │
│  Row 2: Serial 2, Category, Description...          │
│  ...                                                 │
│  Total: ₹XX,XXX.XX                                  │
├─────────────────────────────────────────────────────┤
│  [Footer with signature sections]                   │
└─────────────────────────────────────────────────────┘
```

---

## ✅ Success Criteria

Your Proforma-2 is working correctly if:

1. ✅ Document opens when button clicked
2. ✅ Candidate information displays in header
3. ✅ All expenses appear as rows
4. ✅ Serial numbers are 1, 2, 3...
5. ✅ Amounts show with ₹ symbol and .00
6. ✅ Dates formatted as DD/MM/YYYY
7. ✅ Person names correct for each type
8. ✅ Amount appears in correct column (8, 9, or 10)
9. ✅ Other two expense columns show "-"
10. ✅ Total calculates correctly
11. ✅ Marathi text displays properly
12. ✅ Can print to PDF

---

## 🚀 Ready to Test!

**Follow these steps:**

1. **Restart Server** ← Most important!
2. **Add 2-3 test expenses** with different payment modes
3. **Click "📑 Proforma-2 (Template)" button**
4. **Verify data displays** in the format shown above
5. **Try Print to PDF** to ensure it works

---

**All code is ready! Just restart and test!** ✅

---

**Status**: ✅ Implementation Complete
**Next Action**: Restart server → Test with real data
**Expected Result**: Expense data in exact format as specified

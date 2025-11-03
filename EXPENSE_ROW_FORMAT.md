# 📋 Expense Row Format - Exact Output

## ✅ Generated HTML Structure

### Example 1: Self Expense (paymentMode = "self")

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

**Database Record:**
```
expense_category: "प्रचार साहित्य"
expense_description: "पोस्टर छपाई"
expense_amount: 5000.00
expense_date: 2024-11-01
receipt_number: "REC-001"
payment_mode: "self"
```

---

### Example 2: Party Expense (paymentMode = "party")

```html
<tr>
  <td>2</td>                           <!-- Serial -->
  <td>सभा आयोजन</td>                  <!-- Category -->
  <td>मंच व्यवस्था</td>                <!-- Description -->
  <td>₹10000.00</td>                   <!-- Amount -->
  <td>02/11/2024</td>                  <!-- Date -->
  <td>REC-002</td>                     <!-- Receipt -->
  <td>भारतीय जनता पक्ष</td>            <!-- Person (party) -->
  <td>-</td>                           <!-- Self expense -->
  <td>₹10000.00</td>                   <!-- Party expense -->
  <td>-</td>                           <!-- Others expense -->
</tr>
```

**Database Record:**
```
expense_category: "सभा आयोजन"
expense_description: "मंच व्यवस्था"
expense_amount: 10000.00
expense_date: 2024-11-02
receipt_number: "REC-002"
payment_mode: "party"
```

---

### Example 3: Others Expense WITH Vendor (paymentMode = "others", vendorName provided)

```html
<tr>
  <td>3</td>                           <!-- Serial -->
  <td>छपाई</td>                       <!-- Category -->
  <td>बॅनर</td>                        <!-- Description -->
  <td>₹3000.00</td>                    <!-- Amount -->
  <td>03/11/2024</td>                  <!-- Date -->
  <td>REC-003</td>                     <!-- Receipt -->
  <td>ABC Printers</td>                <!-- Person (others) -->
  <td>-</td>                           <!-- Self expense -->
  <td>-</td>                           <!-- Party expense -->
  <td>₹3000.00</td>                    <!-- Others expense -->
</tr>
```

**Database Record:**
```
expense_category: "छपाई"
expense_description: "बॅनर"
expense_amount: 3000.00
expense_date: 2024-11-03
receipt_number: "REC-003"
payment_mode: "others"
vendor_name: "ABC Printers"
```

---

### Example 4: Others Expense WITHOUT Vendor (paymentMode = "others", vendorName = null)

```html
<tr>
  <td>4</td>                           <!-- Serial -->
  <td>वाहन खर्च</td>                  <!-- Category -->
  <td>पेट्रोल</td>                     <!-- Description -->
  <td>₹2000.00</td>                    <!-- Amount -->
  <td>04/11/2024</td>                  <!-- Date -->
  <td>REC-004</td>                     <!-- Receipt -->
  <td>इतर / Others</td>                <!-- Person (others) -->
  <td>-</td>                           <!-- Self expense -->
  <td>-</td>                           <!-- Party expense -->
  <td>₹2000.00</td>                    <!-- Others expense -->
</tr>
```

**Database Record:**
```
expense_category: "वाहन खर्च"
expense_description: "पेट्रोल"
expense_amount: 2000.00
expense_date: 2024-11-04
receipt_number: "REC-004"
payment_mode: "others"
vendor_name: null  (or empty)
```

---

## 📊 Complete Table Example

```html
<!-- Table Header -->
<table class="header-table">
  <tr>
    <th rowspan="2">अ.क्र</th>
    <th rowspan="2">खर्चीची मुख्य बाब</th>
    <th rowspan="2">खर्चीची अंतर बाब</th>
    <th rowspan="2">प्रति दर</th>
    <th rowspan="2">दिनांक</th>
    <th rowspan="2">पावती</th>
    <th colspan="4">खर्ची रक्कम</th>
  </tr>
  <tr>
    <th>पक्षाचा की/इतर व्यक्तीचा नाव</th>
    <th>उमेदवाराने स्वतः केलेला खर्च</th>
    <th>पक्षाने उमेदवारासाठी केलेला खर्च</th>
    <th>इतर व्यक्तीनी उमेदवारासाठी केलेला खर्च</th>
  </tr>
</table>

<!-- Data Rows -->
<table class="data-table">
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
  <tr>
    <td>2</td>                           <!-- Serial -->
    <td>सभा आयोजन</td>                  <!-- Category -->
    <td>मंच व्यवस्था</td>                <!-- Description -->
    <td>₹10000.00</td>                   <!-- Amount -->
    <td>02/11/2024</td>                  <!-- Date -->
    <td>REC-002</td>                     <!-- Receipt -->
    <td>भारतीय जनता पक्ष</td>            <!-- Person (party) -->
    <td>-</td>                           <!-- Self expense -->
    <td>₹10000.00</td>                   <!-- Party expense -->
    <td>-</td>                           <!-- Others expense -->
  </tr>
  <tr>
    <td>3</td>                           <!-- Serial -->
    <td>छपाई</td>                       <!-- Category -->
    <td>बॅनर</td>                        <!-- Description -->
    <td>₹3000.00</td>                    <!-- Amount -->
    <td>03/11/2024</td>                  <!-- Date -->
    <td>REC-003</td>                     <!-- Receipt -->
    <td>ABC Printers</td>                <!-- Person (others) -->
    <td>-</td>                           <!-- Self expense -->
    <td>-</td>                           <!-- Party expense -->
    <td>₹3000.00</td>                    <!-- Others expense -->
  </tr>
  <tr class="total-row">
    <td colspan="9" style="text-align:right; font-weight:bold;">एकूण निवडणुकीचा खर्च</td>
    <td style="font-weight:bold;">₹18000.00</td>
  </tr>
</table>
```

---

## 🎯 Key Features

### 1. **Serial Numbers**
- Auto-incremented: 1, 2, 3, 4...
- Generated in code, not from database

### 2. **Date Format**
- Input: `java.sql.Date`
- Output: `DD/MM/YYYY` (e.g., "01/11/2024")

### 3. **Amount Format**
- Input: `BigDecimal`
- Output: `₹X,XXX.XX` (e.g., "₹5000.00")
- Always shows 2 decimal places

### 4. **Receipt Number**
- Shows actual value or "-" if null

### 5. **Person Name (Column 7)**
- **Self**: Candidate name
- **Party**: Party name
- **Others with vendor**: Vendor name
- **Others without vendor**: "इतर / Others"

### 6. **Expense Columns (8-10)**
- Only ONE column gets the amount
- Other two show "-"
- Based on `payment_mode` field

### 7. **HTML Comments**
- Each `<td>` has a comment explaining its content
- Makes debugging easier
- Doesn't affect display

---

## ✅ Code Location

**File**: `PDFGeneratorProforma2.java`

**Lines**: ~97-143 (Expense row generation)

**Method**: `replaceTemplatePlaceholders()`

---

## 🧪 Testing

To verify the format:

1. Add expenses with different payment modes
2. Generate Proforma-2
3. View page source (Right-click → View Page Source)
4. Look for the `<tr>` elements
5. Verify comments and structure match this document

---

## 📝 Total Row Format

```html
<tr class="total-row">
  <td colspan="9" style="text-align:right; font-weight:bold;">एकूण निवडणुकीचा खर्च</td>
  <td style="font-weight:bold;">₹18000.00</td>
</tr>
```

- Spans columns 1-9
- Column 10 shows grand total
- Bold font weight
- Right-aligned text

---

**Status**: ✅ Implemented
**Format**: Exact match to specification
**Comments**: Included for clarity

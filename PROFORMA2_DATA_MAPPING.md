# 📊 Proforma-2 Data Mapping Guide

## Current Implementation - Data Sources

### 📋 Header Information (Candidate Details)

| Template Placeholder | Data Source | Database Field | Example |
|---------------------|-------------|----------------|---------|
| `{{candidate_name}}` | `candidate.getCandidateName()` | `candidates.candidate_name` | राजेश कुमार |
| `{{party_name}}` | `candidate.getPartyName()` | `candidates.party_name` | भारतीय जनता पक्ष |
| `{{district_name}}` | `candidate.getCity()` | `candidates.city` | पुणे |
| `{{local_body_name}}` | `candidate.getConstituency()` | `candidates.constituency` | पुणे महानगरपालिका |
| `{{ward_number}}` | `candidate.getBoothNumber()` | `candidates.booth_number` | प्रभाग १२ |
| `{{seat_number}}` | `candidate.getNominationId()` | `candidates.nomination_id` | २३४५ |
| `{{public_post_election}}` | `candidate.getElectionType()` | `candidates.election_type` | स्थानिक निवडणूक |
| `{{election_date}}` | `candidate.getElectionDate()` | `candidates.election_date` | 15/11/2024 |
| `{{report_date}}` | `new Date()` | Current date | 03/11/2025 |
| `{{qr_code_src}}` | Generated | Base64 image | data:image/png... |

---

## 📊 Expense Table Columns (From expenses table)

### Template Structure:
```html
<tr>
  <td>{{serial_no}}</td>                  <!-- Column 1 -->
  <td>{{main_item}}</td>                  <!-- Column 2 -->
  <td>{{sub_item}}</td>                   <!-- Column 3 -->
  <td>{{rate_per_unit}}</td>              <!-- Column 4 -->
  <td>{{entry_date}}</td>                 <!-- Column 5 -->
  <td>{{receipt_no}}</td>                 <!-- Column 6 -->
  <td>{{person_name}}</td>                <!-- Column 7 -->
  <td>{{candidate_expense}}</td>          <!-- Column 8 -->
  <td>{{party_expense}}</td>              <!-- Column 9 -->
  <td>{{others_expense}}</td>             <!-- Column 10 -->
</tr>
```

### Data Mapping:

| Column | Template Field | Data Source | Database Field | Example |
|--------|---------------|-------------|----------------|---------|
| 1 | `{{serial_no}}` | Auto-generated | Counter (1,2,3...) | 1 |
| 2 | `{{main_item}}` | `expense.getExpenseCategory()` | `expenses.expense_category` | प्रचार साहित्य |
| 3 | `{{sub_item}}` | `expense.getExpenseDescription()` | `expenses.expense_description` | पोस्टर छपाई |
| 4 | `{{rate_per_unit}}` | `expense.getExpenseAmount()` | `expenses.expense_amount` | ₹5000 |
| 5 | `{{entry_date}}` | `expense.getExpenseDate()` | `expenses.expense_date` | 01/11/2024 |
| 6 | `{{receipt_no}}` | `expense.getReceiptNumber()` | `expenses.receipt_number` | REC-001 |
| 7 | `{{person_name}}` | **Based on paymentMode** | `expenses.payment_mode` + logic | See below |
| 8 | `{{candidate_expense}}` | **If paymentMode='self'** | `expenses.expense_amount` | ₹5000 or - |
| 9 | `{{party_expense}}` | **If paymentMode='party'** | `expenses.expense_amount` | ₹5000 or - |
| 10 | `{{others_expense}}` | **If paymentMode='others'** | `expenses.expense_amount` | ₹5000 or - |

---

## 🔄 Column 7 Logic: "पक्षाचा की/इतर व्यक्तीचा नाव"

This column shows WHO paid for the expense:

```java
if (paymentMode == "party") {
    person_name = candidate.getPartyName();  // e.g., "भारतीय जनता पक्ष"
} else if (paymentMode == "others") {
    person_name = expense.getVendorName() || "इतर / Others";
} else {
    person_name = candidate.getCandidateName();  // e.g., "राजेश कुमार"
}
```

**Current Implementation:**
- **Self** → Shows candidate name
- **Party** → Shows party name
- **Others** → Shows "इतर / Others" (can use vendorName if available)

---

## 💰 Columns 8-10 Logic: Expense Distribution

Only ONE column gets the amount, other two show "-"

### Example Rows:

| Type | Person Name | Candidate Expense | Party Expense | Others Expense |
|------|------------|-------------------|---------------|----------------|
| Self | राजेश कुमार | ₹5,000 | - | - |
| Party | भाजपा | - | ₹10,000 | - |
| Others | विक्रेता नाव | - | - | ₹3,000 |

---

## 📝 Available But Currently Unused Fields

From `expenses` table:

| Field | Getter Method | Current Status | Potential Use |
|-------|--------------|----------------|---------------|
| `vendor_name` | `getVendorName()` | ❌ Not used | Could show in Column 7 for "others" |
| `remarks` | `getRemarks()` | ❌ Not used | Could add as additional info |
| `created_by` | `getCreatedBy()` | ❌ Not used | For audit trail |
| `created_date` | `getCreatedDate()` | ❌ Not used | For audit trail |

---

## 🎯 What You Can Tell Me

Please specify for these fields:

### 1. **Column 7 (Person Name)** - पक्षाचा की/इतर व्यक्तीचा नाव

Currently:
- Self → Candidate name
- Party → Party name
- Others → "इतर / Others"

**Should it be:**
- [ ] Keep as is
- [ ] Use `vendorName` for "others" type
- [ ] Use something else (please specify)

### 2. **VendorName Field** - विक्रेता/पुरवठादार नाव

**Should we:**
- [ ] Add to Column 7 when paymentMode="others"
- [ ] Add as separate column
- [ ] Keep unused

### 3. **Remarks Field** - टिप्पणी

**Should we:**
- [ ] Add as additional column
- [ ] Show in popup/tooltip
- [ ] Keep unused

### 4. **Any Missing Fields?**

Are there any fields from the "Add Expense" form that should appear in the template but are currently missing?

**Please list them:**
- Field 1: _____________
- Field 2: _____________
- Field 3: _____________

---

## 🔧 Current Working Logic

### Expense Row Generation:

```java
for (Expense expense : expenses) {
    // Column 1: Serial number (auto)
    serialNo++;
    
    // Columns 2-6: Direct mapping
    main_item = expense.getExpenseCategory();
    sub_item = expense.getExpenseDescription();
    rate = expense.getExpenseAmount();
    date = expense.getExpenseDate();
    receipt = expense.getReceiptNumber();
    
    // Column 7: Based on payment mode
    String paymentMode = expense.getPaymentMode();
    if ("party".equals(paymentMode)) {
        person_name = candidate.getPartyName();
        party_expense = amount;
        candidate_expense = "-";
        others_expense = "-";
    } else if ("others".equals(paymentMode)) {
        person_name = "इतर / Others";  // Could use vendorName
        others_expense = amount;
        candidate_expense = "-";
        party_expense = "-";
    } else {  // "self" or default
        person_name = candidate.getCandidateName();
        candidate_expense = amount;
        party_expense = "-";
        others_expense = "-";
    }
}
```

---

## 📋 Complete Example Row

### Database Record:
```sql
expense_id: 1
expense_category: "प्रचार साहित्य"
expense_description: "पोस्टर छपाई"
expense_amount: 5000.00
expense_date: 2024-11-01
payment_mode: "self"
receipt_number: "REC-001"
vendor_name: "ABC Printers"
remarks: "First batch"
```

### Generated HTML Row:
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

## ✅ What's Working

- ✅ Header data from candidate table
- ✅ Expense rows from expenses table
- ✅ Serial number auto-generation
- ✅ Date formatting (DD/MM/YYYY)
- ✅ Amount formatting (₹X,XXX.XX)
- ✅ Three-column expense distribution
- ✅ Total calculation
- ✅ Marathi + English labels

---

## 🔍 What Needs Your Input

Please tell me which fields are missing or need changes:

1. **From Add Expense form** - Which fields do you enter that aren't showing?
2. **Column 7** - Should we use vendorName for "others" type?
3. **Additional columns** - Do you need vendor name, remarks, or other fields visible?
4. **Data source** - Are there fields from other tables we should include?

---

**Please review and tell me what's missing!** 🎯

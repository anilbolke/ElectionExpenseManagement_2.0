# 📑 Proforma-2 Template Quick Start

## ⚡ 2-Minute Guide

### What Is This?
Generates **Proforma-2 (नमुना-२)** reports using the template file `proforma2.html` with dynamic data replacement.

---

## 🚀 How to Use

### Option 1: From Dashboard
```
1. Login
2. Select Candidate (📊 View Dashboard)
3. Click "📑 Proforma-2 (Template)" (orange button)
4. Document opens → Print to PDF
```

### Option 2: From Manage Candidates
```
1. Login
2. Go to "Manage Candidates"
3. Find active candidate
4. Click "📑 Proforma-2 (Template)" (orange button)
5. Document opens → Print to PDF
```

---

## 🎯 What Gets Generated

```
नमुना-२
उमेदवार - एकूण निवडणूक खर्च

📌 Candidate Info (Auto-filled)
├─ Name, Party, District
├─ Election Type, Date
└─ Ward Number, Seat Number

📊 Expense Table (From Database)
├─ Serial Number
├─ Expense Category
├─ Description
├─ Amount & Date
└─ Three Columns:
    ├─ Self Expenses
    ├─ Party Expenses
    └─ Others Expenses

💰 Total (Auto-calculated)
└─ Sum of all expenses
```

---

## 🔑 Key Points

✅ **Fully Automatic** - All data from database
✅ **Template-Based** - Uses proforma2.html
✅ **No Manual Entry** - Everything populated
✅ **Print-Ready** - Opens in browser
✅ **Bilingual** - Marathi + English

---

## 🎨 Button Colors

| Button | Color | What It Does |
|--------|-------|--------------|
| 📄 Generate Proforma | Orange | Original format |
| 📋 Form-2 (नमुना-२) | Purple | Manual form |
| 📑 Proforma-2 (Template) | **Orange** | **This one!** |

---

## 🔧 Template Location

```
WebContent/
└── Document/
    └── proforma2.html  ← Template file with {{placeholders}}
```

---

## 📝 Placeholders Used

### Header:
- `{{candidate_name}}` - Candidate's full name
- `{{party_name}}` - Political party
- `{{district_name}}` - District/city
- `{{election_date}}` - Election date
- ... and more

### Expenses:
- `{{#each expense_rows}}` - Loop through all expenses
- `{{serial_no}}` - Auto-numbered
- `{{main_item}}` - Category
- `{{candidate_expense}}` - Self expenses
- `{{party_expense}}` - Party expenses
- `{{others_expense}}` - Others expenses

### Total:
- `{{total_expense}}` - Grand total

---

## 🆚 Quick Comparison

| Feature | Form-2 | Proforma-2 Template |
|---------|--------|---------------------|
| Data | Manual fill | Auto from DB |
| Expenses | Blank fields | Full list |
| Use | Submission | Report generation |
| Button | Purple 📋 | Orange 📑 |

---

## ✅ Requirements

- ✅ User logged in
- ✅ Candidate active & verified
- ✅ Must be candidate owner

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Button not showing | Check candidate is active & verified |
| Template not found | Ensure proforma2.html exists |
| Data missing | Verify candidate has data |
| Marathi broken | Check UTF-8 encoding |

---

## 📚 Full Documentation

For detailed information:
- `PROFORMA2_TEMPLATE_GUIDE.md` - Complete guide
- `PROFORMA2_IMPLEMENTATION_SUMMARY.md` - Technical details

---

## ✨ That's It!

**3 Clicks**: Select Candidate → Click Orange Button → Print PDF

Your Proforma-2 report with all expense data is ready! 🎉

---

**URL**: `/generateProforma2?candidateId=[ID]`
**Template**: `WebContent/Document/proforma2.html`
**Status**: ✅ Production Ready

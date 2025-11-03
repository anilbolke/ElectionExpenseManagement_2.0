# Visual Guide: Proforma Generation Feature

## User Interface Changes

### 1. Manage Candidates Page - Before & After

#### BEFORE (Old Quick Actions):
```
[Candidate Card]
  Name: John Doe
  Status: Active
  ....
  Quick Actions:
  [📊 View Dashboard] [✏️ Edit Details]
```

#### AFTER (New Quick Actions):
```
[Candidate Card]
  Name: John Doe  
  Status: Active
  ....
  Quick Actions:
  [📊 View Dashboard] [📄 Generate Proforma] [✏️ Edit Details]
```

### 2. Button Appearance

The "Generate Proforma" button has:
- **Icon**: 📄 (document emoji)
- **Text**: "Generate Proforma"
- **Color**: Primary gradient (purple-blue)
- **Style**: Modern with hover effects
- **Behavior**: Opens PDF in new tab/downloads

### 3. Button States

#### For Active Candidates:
```
[📊 View Dashboard] [📄 Generate Proforma] [✏️ Edit Details]
```

#### For Pending Payment Candidates:
```
[💳 Complete Payment] [📄 Generate Proforma] [✏️ Edit Details]
```

#### For Inactive Candidates:
```
[📄 Generate Proforma] [✏️ Edit Details]
```

**Note:** Generate Proforma button is available for ALL candidates regardless of status.

## Generated PDF Structure

### PDF Layout Visualization

```
┌─────────────────────────────────────────────────────┐
│         ELECTION EXPENSE MANAGEMENT SYSTEM          │
│      Candidate Registration Proforma & Official     │
│         Document Generated: 02-Nov-2025 12:00 PM    │
└─────────────────────────────────────────────────────┘

             [Watermark: "ELECTION PROFORMA"]

┌─────────────────────────────────────────────────────┐
│ PERSONAL INFORMATION                                │
├─────────────────────────────────────────────────────┤
│                                   ┌───────────────┐ │
│ Candidate ID    : 1001            │  CANDIDATE    │ │
│ Full Name       : John Doe        │  PHOTOGRAPH   │ │
│ Father's Name   : Robert Doe      │               │ │
│ Age             : 45 years        │ (placeholder) │ │
│ Gender          : Male            └───────────────┘ │
│ Mobile Number   : 9876543210                        │
│ Email Address   : john@example.com                  │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ ADDRESS DETAILS                                     │
├─────────────────────────────────────────────────────┤
│ Residential     : 123 Main Street, Apartment 4B     │
│ City            : Mumbai                            │
│ State           : Maharashtra                       │
│ Pin Code        : 400001                            │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ IDENTITY DOCUMENTS                                  │
├─────────────────────────────────────────────────────┤
│ Aadhar Number   : XXXX-XXXX-5678                    │
│ Voter ID        : ABC1234567                        │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ ELECTION PROGRAM DETAILS                            │
├─────────────────────────────────────────────────────┤
│ Constituency    : South Mumbai                      │
│ Nomination ID   : NOM-2025-001                      │
│ Party Name      : Democratic Alliance               │
│ Party Symbol    : Lotus                             │
│ Election Type   : Lok Sabha                         │
│ Election Date   : 15-Mar-2025                       │
│ Booth Number    : B-301                             │
│ Expense Limit   : ₹ 7000000                         │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ PAYMENT & ACCOUNT STATUS                            │
├─────────────────────────────────────────────────────┤
│ Account Status  : ACTIVE                            │
│ Payment Status  : COMPLETED                         │
│ Payment Amount  : ₹ 5000                            │
│ Payment Date    : 01-Nov-2025 10:30 AM              │
│ Transaction ID  : pay_ABC123XYZ789                  │
│ Payment Verified: Yes ✓                             │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ DECLARATION                                         │
├─────────────────────────────────────────────────────┤
│ I, John Doe, hereby declare that the information    │
│ provided above is true and correct to the best of   │
│ my knowledge. I understand that any false           │
│ information may lead to cancellation of my          │
│ candidature and legal action. I agree to abide by   │
│ the election rules and regulations set forth by the │
│ Election Commission.                                │
│                                                     │
│  ___________________           Date: 02-Nov-2025    │
│  Candidate Signature                                │
│                                                     │
│                               ___________________   │
│                               Authorized Officer    │
└─────────────────────────────────────────────────────┘

─────────────────────────────────────────────────────
   This is a computer generated document. No signature required.
   For queries: election@gov.in | Phone: 1800-XXX-XXXX
   Document ID: CAND-1001-1730545200000
─────────────────────────────────────────────────────
```

## Color Scheme

### PDF Colors:
- **Header Background**: `#2c3e50` (Dark Blue-Gray)
- **Section Headers**: `#3498db` (Bright Blue)
- **Section Borders**: `#3498db` (Bright Blue)
- **Text Color**: `#333` (Dark Gray)
- **Label Color**: `#555` (Medium Gray)
- **Background**: White
- **Watermark**: `rgba(0,0,0,0.05)` (Very Light Gray)

### Button Colors (on webpage):
- **Primary (Generate Proforma)**: Purple-Blue Gradient
- **Success (View Dashboard)**: Green
- **Warning (Complete Payment)**: Orange
- **Secondary (Edit Details)**: Light Gray

## User Flow Diagram

```
┌──────────────────┐
│   User logs in   │
└────────┬─────────┘
         │
         ▼
┌────────────────────────┐
│ Navigate to Manage     │
│ Candidates page        │
└────────┬───────────────┘
         │
         ▼
┌────────────────────────────┐
│ See list of candidates     │
│ with action buttons        │
└────────┬───────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ Click "📄 Generate Proforma" │
└────────┬─────────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ Servlet validates request    │
│ - Check session              │
│ - Verify ownership           │
│ - Fetch candidate data       │
└────────┬─────────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ PDFGenerator creates HTML    │
│ with candidate information   │
└────────┬─────────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ Convert to PDF bytes         │
└────────┬─────────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ Send as HTTP response        │
│ Content-Type: application/pdf│
└────────┬─────────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ Browser downloads/opens PDF  │
│ Filename: Candidate_Proforma │
│          _[Name].pdf         │
└──────────────────────────────┘
```

## Security Flow

```
Request → Session Check → User Check → Ownership Check → Generate PDF
   ↓           ↓              ↓             ↓                ↓
  No         No User       No Match     Not Owner        Success
   ↓           ↓              ↓             ↓                ↓
Redirect   Redirect       Redirect      Error Msg        PDF File
to Login   to Login       w/ Error      Redirect         Download
```

## File Naming Examples

| Candidate Name        | Generated Filename                      |
|-----------------------|-----------------------------------------|
| John Doe              | Candidate_Proforma_John_Doe.pdf         |
| María García          | Candidate_Proforma_Mar_a_Garc_a.pdf     |
| O'Brien Patrick       | Candidate_Proforma_O_Brien_Patrick.pdf  |
| राज कुमार (Hindi)     | Candidate_Proforma___________.pdf       |

## Responsive Design

### Desktop View (> 768px):
```
┌────────────────────────────────────────────────────┐
│ [Candidate Card - Full Width]                     │
│ Name: John Doe                Status: Active      │
│ Details...                                        │
│ [📊 Dashboard] [📄 Proforma] [✏️ Edit]            │
└────────────────────────────────────────────────────┘
```

### Mobile View (< 768px):
```
┌─────────────────────────┐
│ [Candidate Card]        │
│ Name: John Doe          │
│ Status: Active          │
│ Details...              │
│                         │
│ [📊 Dashboard]          │
│ [📄 Generate Proforma]  │
│ [✏️ Edit Details]       │
└─────────────────────────┘
```

## Interactive Elements

### Button Hover Effect:
```
Normal State:
[📄 Generate Proforma]

Hover State:
[📄 Generate Proforma]  ← Moves up slightly
       ↑                  ← Shadow appears
   (Shadow)               ← Gradient brightens
```

### PDF Link Behavior:
- **Left Click**: Opens PDF in new tab/downloads
- **Right Click**: Context menu with "Save As" option
- **Ctrl + Click**: Opens in new tab (background)
- **Shift + Click**: Downloads immediately

## Browser Compatibility

| Browser  | PDF Opens | PDF Downloads | Status |
|----------|-----------|---------------|--------|
| Chrome   | ✅ Yes    | ✅ Yes        | ✅ Full |
| Firefox  | ✅ Yes    | ✅ Yes        | ✅ Full |
| Edge     | ✅ Yes    | ✅ Yes        | ✅ Full |
| Safari   | ✅ Yes    | ✅ Yes        | ✅ Full |
| IE 11    | ⚠️ Maybe  | ✅ Yes        | ⚠️ Partial |

## Accessibility Features

- **Keyboard Navigation**: Tab to button, Enter to activate
- **Screen Reader**: Announces "Generate Proforma button"
- **Focus Indicator**: Blue outline when focused
- **Alt Text**: Icon has descriptive text
- **High Contrast**: Works with high contrast modes

## Print Preview

When user opens PDF and clicks Print (Ctrl+P):
```
┌────────────────────────┐
│ Browser Print Dialog   │
├────────────────────────┤
│ Printer: [Select...]   │
│ Pages: All             │
│ Layout: Portrait       │
│ Color: Color/B&W       │
│                        │
│ Preview:               │
│ ┌──────────────────┐   │
│ │ [PDF Preview]    │   │
│ │ Shows formatted  │   │
│ │ proforma with    │   │
│ │ all sections     │   │
│ └──────────────────┘   │
│                        │
│ [Cancel]  [Print]     │
└────────────────────────┘
```

## Success Indicators

### Visual Feedback:
1. **Click Button**: Button press animation
2. **Processing**: Brief loading state (handled by browser)
3. **Success**: 
   - PDF opens in new tab, OR
   - Download notification appears
   - No error message on original page

### Error Feedback:
1. **Click Button**: Normal press
2. **Error Occurs**: Redirected to manage page
3. **Error Message**: Red alert box at top
4. **Message Content**: Specific error description

## Summary

The Proforma Generation feature provides:
- ✅ One-click PDF generation
- ✅ Professional document layout
- ✅ Complete candidate information
- ✅ Security and validation
- ✅ User-friendly interface
- ✅ Cross-browser compatibility
- ✅ Print-ready format
- ✅ Proper error handling
- ✅ Accessibility support
- ✅ Mobile responsive design

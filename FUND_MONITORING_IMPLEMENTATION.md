# Fund Monitoring & Alert System Implementation

## Overview
Implemented a comprehensive fund monitoring system that tracks candidate expenses against available funds and provides real-time notifications when usage exceeds 50%.

## Features Implemented

### 1. Fund Statistics Model (`FundStatistics.java`)
- **Location**: `src/com/election/model/FundStatistics.java`
- **Purpose**: Calculates and stores fund usage statistics
- **Key Features**:
  - Calculates remaining funds
  - Computes usage percentage
  - Determines alert level (SAFE, WARNING, DANGER, CRITICAL)
  - Generates appropriate alert messages

**Alert Thresholds**:
- **SAFE** (0-49%): No alert shown
- **WARNING** (50-74%): Yellow alert with warning icon ⚠️
- **DANGER** (75-89%): Red alert with stop icon ⛔
- **CRITICAL** (90-100%+): Dark red critical alert 🚨

### 2. Fund Monitor Utility (`FundMonitor.java`)
- **Location**: `src/com/election/util/FundMonitor.java`
- **Purpose**: Provides methods to fetch and analyze fund statistics
- **Key Methods**:
  - `getFundStatistics(candidateId, candidateName)`: Returns complete statistics
  - `hasExceededThreshold(candidateId, percentage)`: Checks if threshold exceeded
  - `getAlertMessage(candidateId, candidateName)`: Returns alert message if applicable

### 3. Fund Statistics Servlet (`FundStatisticsServlet.java`)
- **Location**: `src/com/election/servlet/FundStatisticsServlet.java`
- **URL**: `/getFundStatistics`
- **Purpose**: REST endpoint to fetch fund statistics as JSON
- **Response Format**:
```json
{
  "candidateId": 23,
  "candidateName": "John Doe",
  "totalFunds": 100000.00,
  "totalExpenses": 55000.00,
  "remainingFunds": 45000.00,
  "usagePercentage": 55.00,
  "alertLevel": "WARNING",
  "alertMessage": "Warning: 55.00% of funds used. Remaining: ₹45000.00",
  "hasAlert": true
}
```

### 4. Expense Validation Enhancement (`ExpenseServlet.java`)
- **Updated**: Added fund validation before adding expenses
- **Features**:
  - Checks if new expense would exceed available funds
  - Prevents expense addition if funds insufficient
  - Shows remaining funds in success message
  - Displays error message with available amount if exceeded

**Validation Logic**:
```java
if (newTotalExpenses > totalFunds) {
    // Reject expense - show error
} else {
    // Add expense - show remaining funds
}
```

### 5. Dashboard Integration (`dashboard.jsp`)
- **Location**: `WebContent/user/dashboard.jsp`
- **Features**:
  - Real-time fund alert box displayed for selected candidate
  - Shows detailed breakdown: Total, Used, Remaining
  - Visual progress bar with color coding
  - Auto-refresh every 30 seconds
  - Only displays when usage >= 50%

**Alert Appearance**:
```
⚠️ Fund Usage Warning
John Doe has used 55.00% of available funds.

[Total Funds]    [Used]         [Remaining]
₹100,000.00     ₹55,000.00     ₹45,000.00

[===================>-------] 55.0%
```

### 6. Add Expense Page Integration (`add-expense.jsp`)
- **Location**: `WebContent/user/add-expense.jsp`
- **Features**:
  - Shows fund alert at top of form
  - Warns user before adding expense
  - Real-time display of fund status
  - Same styling and functionality as dashboard

## How It Works

### Workflow
1. **User selects candidate** → Session stores selected candidate
2. **Page loads** → JavaScript calls `/getFundStatistics` endpoint
3. **Servlet fetches data** → Queries fund_details and expenses tables
4. **Calculations performed** → FundStatistics model computes percentages
5. **Alert displayed** → If usage >= 50%, alert box shown with color coding
6. **User adds expense** → System validates against available funds
7. **Success/Error** → Shows appropriate message with updated balance

### Alert Level Logic
```
Usage < 50%  → No Alert (SAFE)
Usage 50-74% → Yellow Warning Alert
Usage 75-89% → Red Danger Alert  
Usage >= 90% → Critical Red Alert
```

### Database Queries
**Total Funds**:
```sql
SELECT COALESCE(SUM(amount), 0) as total 
FROM fund_details 
WHERE candidate_id = ?
```

**Total Expenses**:
```sql
SELECT COALESCE(SUM(expense_amount), 0) as total 
FROM expenses 
WHERE candidate_id = ?
```

## User Experience

### Visual Indicators
1. **Progress Bar**: Shows percentage with color coding
2. **Stats Breakdown**: Three boxes showing Total, Used, Remaining
3. **Icons**: Different icons based on severity
4. **Colors**: 
   - Yellow (#f59e0b) for Warning
   - Red (#ef4444) for Danger
   - Dark Red (#dc2626) for Critical

### Notifications
- **Dashboard**: Persistent alert box (refreshes every 30s)
- **Add Expense**: Alert shown when adding new expense
- **Success Message**: Includes remaining funds after adding expense
- **Error Message**: Shows available funds if expense exceeds limit

## Testing

### Test Scenarios
1. **No funds, no expenses**: Should show 0% usage (SAFE)
2. **Funds added, 40% used**: No alert shown
3. **50% used**: Yellow warning alert appears
4. **75% used**: Red danger alert appears
5. **90% used**: Critical alert appears
6. **100% used**: Critical alert, cannot add more expenses
7. **Try to exceed funds**: Error message prevents addition

### Test Case Example
```
Candidate: John Doe (ID: 23)
Total Funds: ₹100,000
Expenses: ₹55,000
Usage: 55%
Expected: Yellow WARNING alert with breakdown
```

## Benefits

1. **Proactive Monitoring**: Users are alerted before running out of funds
2. **Prevents Overspending**: System blocks expenses that exceed available funds
3. **Real-time Updates**: Automatic refresh keeps information current
4. **Visual Clarity**: Color-coded alerts make status immediately clear
5. **Detailed Information**: Shows exact amounts and percentages
6. **User-friendly**: Clear messages in both English and Marathi

## Files Modified/Created

### Created Files
1. `src/com/election/model/FundStatistics.java`
2. `src/com/election/util/FundMonitor.java`
3. `src/com/election/servlet/FundStatisticsServlet.java`

### Modified Files
1. `src/com/election/servlet/ExpenseServlet.java`
2. `WebContent/user/dashboard.jsp`
3. `WebContent/user/add-expense.jsp`
4. `WebContent/Document/proforma2.html` (landscape mode + print button)

## Configuration

### Servlet Mapping
The `FundStatisticsServlet` is annotated with `@WebServlet("/getFundStatistics")` and automatically mapped.

No additional web.xml configuration required.

### Dependencies
- Uses existing `json-20210307.jar` for JSON responses
- No additional libraries needed

## Future Enhancements

1. **Email Notifications**: Send email when threshold exceeded
2. **Custom Thresholds**: Allow users to set their own alert percentages
3. **Historical Tracking**: Show fund usage trends over time
4. **Budget Planning**: Suggest spending limits based on remaining funds
5. **Export Reports**: Generate PDF reports of fund usage

## Support

For issues or questions:
- Check browser console for JavaScript errors
- Verify candidate is selected in session
- Ensure fund_details and expenses tables have data
- Test `/getFundStatistics` endpoint directly

## Conclusion

The fund monitoring system provides comprehensive tracking and alerts for candidate fund management. It helps users stay within budget and prevents accidental overspending through real-time validation and visual notifications.

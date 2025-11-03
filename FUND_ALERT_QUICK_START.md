# Fund Alert System - Quick Start Guide

## What's New? 🎯

Your Election Expense Management system now has a **smart fund monitoring system** that automatically alerts users when they're using too much of their available funds!

## Key Features ✨

### 1. Real-Time Fund Monitoring
- **Automatic alerts** when expenses reach 50% of available funds
- **Color-coded warnings** based on usage levels
- **Live updates** every 30 seconds

### 2. Alert Levels

| Usage | Level | Color | Icon | Description |
|-------|-------|-------|------|-------------|
| 0-49% | SAFE | Green | ✅ | No alert shown |
| 50-74% | WARNING | Yellow | ⚠️ | Moderate usage warning |
| 75-89% | DANGER | Red | ⛔ | High usage alert |
| 90%+ | CRITICAL | Dark Red | 🚨 | Critical - near/over limit |

### 3. Expense Validation
- **Prevents overspending** - System blocks expenses that exceed available funds
- **Shows remaining balance** after each transaction
- **Real-time validation** before saving

## How to Use 📝

### Step 1: Login as User
```
1. Login to your account
2. Go to dashboard
3. Select a candidate
```

### Step 2: Add Funds
```
1. Click "Manage Funds" button
2. Add fund details (amount, source, date)
3. Save fund entry
```

### Step 3: Add Expenses
```
1. Click "Add Expense" button
2. Fill expense details
3. System automatically checks available funds
4. If sufficient → Expense saved + Remaining shown
5. If insufficient → Error message displayed
```

### Step 4: Monitor Usage
```
Dashboard automatically shows:
- Current usage percentage
- Total funds available
- Amount already spent
- Remaining balance
- Visual progress bar
```

## Where to See Alerts 📍

### 1. User Dashboard
- Alert box appears at top of main content area
- Shows when candidate is selected AND usage >= 50%
- Refreshes automatically every 30 seconds

### 2. Add Expense Page
- Alert appears above the expense form
- Warns before adding new expense
- Shows current fund status

## Example Scenarios 💡

### Scenario 1: Safe Usage (30%)
```
Total Funds: ₹100,000
Expenses: ₹30,000
Status: ✅ No alert shown
Action: Can add expenses freely
```

### Scenario 2: Warning (55%)
```
Total Funds: ₹100,000
Expenses: ₹55,000
Alert: ⚠️ WARNING - 55% used
Remaining: ₹45,000
Action: Can add expenses (with caution)
```

### Scenario 3: Danger (80%)
```
Total Funds: ₹100,000
Expenses: ₹80,000
Alert: ⛔ DANGER - 80% used
Remaining: ₹20,000
Action: Can add expenses (use carefully)
```

### Scenario 4: Critical (95%)
```
Total Funds: ₹100,000
Expenses: ₹95,000
Alert: 🚨 CRITICAL - 95% used
Remaining: ₹5,000
Action: Very limited funds remaining
```

### Scenario 5: Overspending Attempt
```
Total Funds: ₹100,000
Current Expenses: ₹95,000
Trying to add: ₹10,000
Result: ❌ ERROR - "Cannot add expense! This would exceed available funds."
```

## Visual Alert Example

```
┌─────────────────────────────────────────────────────────┐
│ ⚠️  Fund Usage Warning                                  │
├─────────────────────────────────────────────────────────┤
│ John Doe has used 55.00% of available funds.           │
│                                                         │
│ ┌───────────┐  ┌───────────┐  ┌───────────┐          │
│ │Total Funds│  │   Used    │  │ Remaining │          │
│ │₹100,000.00│  │₹55,000.00 │  │₹45,000.00 │          │
│ └───────────┘  └───────────┘  └───────────┘          │
│                                                         │
│ [█████████████████═════════] 55.0%                     │
└─────────────────────────────────────────────────────────┘
```

## Testing the System 🧪

### Test 1: Add Funds
1. Login as user
2. Select candidate
3. Go to "Manage Funds"
4. Add ₹100,000 as fund
5. Return to dashboard
6. No alert should appear (0% usage)

### Test 2: Add Small Expense
1. Click "Add Expense"
2. Add expense of ₹40,000
3. Save
4. Return to dashboard
5. No alert (40% usage)

### Test 3: Trigger Warning
1. Add another expense of ₹15,000
2. Total now ₹55,000 (55%)
3. Dashboard shows yellow warning alert
4. All stats displayed correctly

### Test 4: Test Validation
1. Try to add expense of ₹50,000
2. System calculates: 55,000 + 50,000 = 105,000
3. Exceeds available ₹100,000
4. Error message appears
5. Expense not saved

## Troubleshooting 🔧

### Alert Not Showing
**Problem**: No alert appears even when usage > 50%
**Solutions**:
- Refresh the page
- Check browser console for errors
- Verify candidate is selected (green border on card)
- Ensure funds and expenses exist in database

### Wrong Percentage
**Problem**: Percentage doesn't match manual calculation
**Solutions**:
- Check fund_details table for total funds
- Check expenses table for total expenses
- Verify candidateId is correct
- Clear browser cache and refresh

### Cannot Add Expense
**Problem**: System blocks valid expense
**Solutions**:
- Check actual remaining funds in database
- Verify expense amount is not exceeding available funds
- Check for any pending/uncommitted transactions

## Developer Notes 💻

### API Endpoint
```javascript
GET /ElectionExpenseManagement/getFundStatistics
Response: JSON with fund statistics
```

### Database Tables Used
```sql
fund_details - SUM(amount) WHERE candidate_id = ?
expenses - SUM(expense_amount) WHERE candidate_id = ?
```

### Key Classes
- `FundStatistics.java` - Model with calculations
- `FundMonitor.java` - Utility for fetching stats
- `FundStatisticsServlet.java` - REST API endpoint
- `ExpenseServlet.java` - Enhanced with validation

## Benefits 🎁

✅ **Prevents Overspending** - Automatic validation
✅ **Early Warning** - Alerts at 50%, 75%, 90%
✅ **Real-time** - Updates every 30 seconds
✅ **Visual** - Color-coded progress bars
✅ **Informative** - Shows exact amounts
✅ **User-friendly** - Clear messages
✅ **Automatic** - No manual checking needed

## Next Steps 🚀

1. **Deploy** the updated application
2. **Test** with sample data
3. **Train** users on the new feature
4. **Monitor** for any issues
5. **Collect** user feedback

## Support 📞

For issues or questions:
- Check the detailed implementation guide: `FUND_MONITORING_IMPLEMENTATION.md`
- Review browser console for errors
- Verify database has correct data
- Test the `/getFundStatistics` endpoint directly

---

**Remember**: The system is designed to help, not restrict. Users can still manage their funds, but now they have better visibility and protection against accidental overspending! 💪

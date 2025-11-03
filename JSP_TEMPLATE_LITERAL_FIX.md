# JSP Template Literal Fix

## Issue
When using ES6 template literals (backticks) in JSP files, the `${}` syntax conflicts with JSP's Expression Language (EL) syntax, causing errors like:

```
javax.el.ELException: Function [:formatCurrency] not found
```

## Root Cause
JSP processes the file before JavaScript runs, so it tries to evaluate `${formatCurrency(...)}` as an EL expression instead of leaving it for JavaScript.

## Solution
Replace template literals with string concatenation.

### Before (Caused Error)
```javascript
alertBox.innerHTML = `
    <div class="fund-stat-value">${formatCurrency(stats.totalFunds)}</div>
`;
```

### After (Fixed)
```javascript
alertBox.innerHTML = 
    '<div class="fund-stat-value">' + formatCurrency(stats.totalFunds) + '</div>';
```

## Files Fixed
- ✅ `dashboard.jsp` (lines 743-771)
- ✅ `add-expense.jsp` (lines 518-547)

## Prevention
When writing JavaScript in JSP files:
1. Avoid ES6 template literals (backticks)
2. Use string concatenation with `+` operator
3. Or escape `${}` as `\${}`
4. Or use `<![CDATA[` blocks for JavaScript

## Status
✅ Fixed and tested - no more EL errors!

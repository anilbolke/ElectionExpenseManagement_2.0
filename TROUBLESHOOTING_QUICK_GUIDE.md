# 🔍 Proforma-2 Troubleshooting Quick Guide

## 🚨 Error: "Template file not found"

### ✅ Step-by-Step Fix

#### 1️⃣ **Restart Server**
```
Stop your Tomcat/Application Server
Wait 5 seconds
Start it again
```

#### 2️⃣ **Test Again**
- Login to application
- Select a candidate
- Click orange "📑 Proforma-2 (Template)" button

#### 3️⃣ **Check Console Output**

Your server console should now show:
```
Attempting to load template from: C:\full\path\to\proforma2.html
```

**Look for this line!** It tells you exactly where it's looking.

---

## 📊 What the Console Will Show

### ✅ **Success**:
```
Attempting to load template from: C:\...\WebContent\Document\proforma2.html
Template loaded successfully. Size: 5214 bytes
```
→ Template found and loaded!

### ❌ **Failure**:
```
ERROR: Template not found at: C:\...\WebContent\Document\proforma2.html
Context path was: C:\...\WebContent\
Template path constant: WebContent/Document/proforma2.html
```
→ Shows all paths for debugging

---

## 🔧 Common Fixes

### Issue #1: Wrong Path
**Console shows**: Path doesn't match actual file location

**Fix**: Path mismatch - server deployed to different location

**Solution**:
```java
// Edit PDFGeneratorProforma2.java temporarily
// Add at line 40:
System.out.println("Real path: " + contextPath);
```

### Issue #2: File Permissions
**Console shows**: Path is correct but still fails

**Fix**: Server can't read the file

**Solution**:
- Check file permissions
- Ensure server user has read access
- On Windows: Right-click file → Properties → Security

### Issue #3: Deployment Issue
**Console shows**: Path points to wrong directory

**Fix**: Application not fully deployed

**Solution**:
- Clean and rebuild project
- Redeploy application
- Check deployment directory

---

## 💡 Quick Test Commands

### Verify File Exists:
```powershell
Test-Path "C:\Users\Admin\Downloads\-ElectionExpenseManagement-main\-ElectionExpenseManagement-main\WebContent\Document\proforma2.html"
```
Should return: `True`

### Check File Content:
```powershell
Get-Content "C:\Users\Admin\Downloads\-ElectionExpenseManagement-main\-ElectionExpenseManagement-main\WebContent\Document\proforma2.html" -Head 5
```
Should show HTML content starting with `<!DOCTYPE html>`

---

## 🎯 Expected Behavior

### Correct Flow:
```
1. Click Button
   ↓
2. Servlet gets real path to WebContent
   ↓
3. Appends "WebContent/Document/proforma2.html"
   ↓
4. Loads file with UTF-8
   ↓
5. Replaces {{placeholders}}
   ↓
6. Returns HTML to browser
   ↓
7. Opens in new tab
```

---

## 📝 Debug Checklist

- [ ] Server restarted after changes
- [ ] Console shows "Attempting to load..." message
- [ ] Path in console matches actual file location
- [ ] File exists at that location
- [ ] File has read permissions
- [ ] File contains valid HTML
- [ ] UTF-8 encoding correct

---

## 🆘 Still Not Working?

### Share These Details:

1. **Console Output**:
   ```
   Copy the "Attempting to load template from:" line
   ```

2. **Actual File Path**:
   ```
   Where proforma2.html actually is located
   ```

3. **Server Type**:
   ```
   Tomcat version, deployment method, etc.
   ```

4. **Operating System**:
   ```
   Windows/Linux version
   ```

---

## 🚀 Alternative Quick Fix

If you need it working RIGHT NOW:

### Hardcode Path (Temporary):

Edit `PDFGeneratorProforma2.java` line 40:

```java
// REPLACE:
fullPath = contextPath + TEMPLATE_PATH.replace("/", System.getProperty("file.separator"));

// WITH (your actual path):
fullPath = "C:\\Users\\Admin\\Downloads\\-ElectionExpenseManagement-main\\-ElectionExpenseManagement-main\\WebContent\\Document\\proforma2.html";
```

⚠️ **This is temporary** - fixes it immediately but not portable.

---

## ✅ Success Indicators

You'll know it's working when:

1. ✅ No error page appears
2. ✅ Console shows "Template loaded successfully"
3. ✅ Document opens with candidate data
4. ✅ Expense rows populated
5. ✅ Marathi text displays correctly

---

## 📞 Files to Check

1. `PDFGeneratorProforma2.java` - Generator with logging
2. `GenerateProforma2Servlet.java` - Servlet handler
3. `proforma2.html` - Template file
4. `web.xml` - Servlet mapping

---

## 🎓 Understanding the Issue

**Why this happens**:
- Server's real path to WebContent varies by deployment
- Path separators differ between OS (/ vs \)
- Relative paths don't always work in servlets
- Need to use `ServletContext.getRealPath("/")`

**The fix**:
- Use proper path construction
- Add debug logging
- Handle both Unix and Windows paths
- Show exact paths in console

---

**Remember**: The console output is your friend! It will tell you exactly what's happening.

---

**Quick Action**: Restart → Test → Check Console → Share Output if needed

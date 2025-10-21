<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.LocaleManager" %>
<%@ page import="java.util.Locale" %>

<%
    Locale currentLocale = LocaleManager.getLocale(request);
    String currentLang = currentLocale.getLanguage();
%>

<style>
.language-selector {
    display: inline-block;
    margin-left: 15px;
}

.language-selector select {
    padding: 5px 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background-color: white;
    cursor: pointer;
    font-size: 14px;
    font-family: 'Noto Sans', 'Noto Sans Devanagari', Arial, sans-serif;
}

.language-selector select:hover {
    border-color: #007bff;
}

.language-selector select:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
}
</style>

<div class="language-selector">
    <select id="languageSelect" onchange="switchLanguage(this.value)">
        <option value="en" <%= currentLang.equals("en") ? "selected" : "" %>>
            English
        </option>
        <option value="hi" <%= currentLang.equals("hi") ? "selected" : "" %>>
            हिंदी (Hindi)
        </option>
        <option value="mr" <%= currentLang.equals("mr") ? "selected" : "" %>>
            मराठी (Marathi)
        </option>
    </select>
</div>

<script>
function switchLanguage(lang) {
    var currentUrl = window.location.href;
    var contextPath = '<%= request.getContextPath() %>';
    window.location.href = contextPath + '/switchLanguage?lang=' + lang + '&redirect=' + encodeURIComponent(currentUrl);
}
</script>

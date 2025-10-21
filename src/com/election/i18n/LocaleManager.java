package com.election.i18n;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Locale;

/**
 * Manages user locale preferences for multi-language support
 */
public class LocaleManager {
    
    private static final String LOCALE_SESSION_ATTR = "user.locale";
    private static final Locale DEFAULT_LOCALE = new Locale("en", "IN");
    
    /**
     * Get current user's locale from session
     */
    public static Locale getLocale(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Locale locale = (Locale) session.getAttribute(LOCALE_SESSION_ATTR);
        
        if (locale == null) {
            // Check if there's a language preference from login
            String languagePref = (String) session.getAttribute("language");
            if (languagePref != null && !languagePref.isEmpty()) {
                setLocale(request, languagePref);
                return (Locale) session.getAttribute(LOCALE_SESSION_ATTR);
            }
            
            // Try to get from browser
            locale = request.getLocale();
            if (!isSupportedLocale(locale)) {
                locale = DEFAULT_LOCALE;
            }
            setLocale(request, locale);
        }
        
        return locale;
    }
    
    /**
     * Set user's locale in session
     */
    public static void setLocale(HttpServletRequest request, Locale locale) {
        HttpSession session = request.getSession();
        session.setAttribute(LOCALE_SESSION_ATTR, locale);
    }
    
    /**
     * Set user's locale by language code
     */
    public static void setLocale(HttpServletRequest request, String languageCode) {
        Locale locale;
        
        switch (languageCode.toLowerCase()) {
            case "hi":
                locale = new Locale("hi", "IN");
                break;
            case "mr":
                locale = new Locale("mr", "IN");
                break;
            case "ta":
                locale = new Locale("ta", "IN");
                break;
            case "te":
                locale = new Locale("te", "IN");
                break;
            case "bn":
                locale = new Locale("bn", "IN");
                break;
            case "gu":
                locale = new Locale("gu", "IN");
                break;
            default:
                locale = new Locale("en", "IN");
        }
        
        setLocale(request, locale);
    }
    
    /**
     * Check if locale is supported
     */
    private static boolean isSupportedLocale(Locale locale) {
        String[] supportedLanguages = {"en", "hi", "mr", "ta", "te", "bn", "gu"};
        String lang = locale.getLanguage();
        
        for (String supported : supportedLanguages) {
            if (supported.equals(lang)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Get available locales for language selector
     */
    public static Locale[] getAvailableLocales() {
        return new Locale[] {
            new Locale("en", "IN"),  // English
            new Locale("hi", "IN"),  // Hindi
            new Locale("mr", "IN")   // Marathi
        };
    }
    
    /**
     * Get language display name
     */
    public static String getLanguageName(Locale locale) {
        switch (locale.getLanguage()) {
            case "en": return "English";
            case "hi": return "हिंदी (Hindi)";
            case "mr": return "मराठी (Marathi)";
            case "ta": return "தமிழ் (Tamil)";
            case "te": return "తెలుగు (Telugu)";
            case "bn": return "বাংলা (Bengali)";
            case "gu": return "ગુજરાતી (Gujarati)";
            default: return "English";
        }
    }
}

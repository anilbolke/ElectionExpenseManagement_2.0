package com.election.i18n;

import javax.servlet.http.HttpServletRequest;
import java.text.MessageFormat;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * Utility class for retrieving internationalized messages
 */
public class MessageBundle {
    
    private static final String BUNDLE_NAME = "com.election.resources.i18n.messages";
    
    /**
     * Get message for current locale
     */
    public static String getMessage(HttpServletRequest request, String key) {
        Locale locale = LocaleManager.getLocale(request);
        return getMessage(locale, key);
    }
    
    /**
     * Get message with parameters
     */
    public static String getMessage(HttpServletRequest request, String key, Object... params) {
        String message = getMessage(request, key);
        return MessageFormat.format(message, params);
    }
    
    /**
     * Get message for specific locale
     */
    public static String getMessage(Locale locale, String key) {
        try {
            ResourceBundle bundle = ResourceBundle.getBundle(BUNDLE_NAME, locale);
            return bundle.getString(key);
        } catch (MissingResourceException e) {
            // Try default locale
            try {
                ResourceBundle defaultBundle = ResourceBundle.getBundle(BUNDLE_NAME, new Locale("en", "IN"));
                return defaultBundle.getString(key);
            } catch (MissingResourceException ex) {
                return "???" + key + "???";
            }
        }
    }
    
    /**
     * Get message with parameters for specific locale
     */
    public static String getMessage(Locale locale, String key, Object... params) {
        String message = getMessage(locale, key);
        return MessageFormat.format(message, params);
    }
}

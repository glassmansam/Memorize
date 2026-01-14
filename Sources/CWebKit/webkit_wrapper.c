#include "shim.h"
#include <webkit/webkit.h>
#include <gdk/gdk.h>

CWebKitWebView webkit_wrapper_web_view_new(void) {
    GtkWidget *webView = webkit_web_view_new();
    if (webView != NULL) {
        gtk_widget_show(webView);
    }
    return (CWebKitWebView)webView;
}

CWebKitSettings webkit_wrapper_web_view_get_settings(CWebKitWebView web_view) {
    return (CWebKitSettings)webkit_web_view_get_settings((WebKitWebView*)web_view);
}

void webkit_wrapper_settings_set_enable_javascript(CWebKitSettings settings, int enabled) {
    webkit_settings_set_enable_javascript((WebKitSettings*)settings, enabled);
}

void webkit_wrapper_settings_set_enable_developer_extras(CWebKitSettings settings, int enabled) {
    webkit_settings_set_enable_developer_extras((WebKitSettings*)settings, enabled);
}

void webkit_wrapper_web_view_load_html(CWebKitWebView web_view, const char* content, const char* base_uri) {
    if (web_view != NULL && WEBKIT_IS_WEB_VIEW((WebKitWebView*)web_view)) {
        webkit_web_view_load_html((WebKitWebView*)web_view, content, base_uri);
    }
}

void webkit_wrapper_set_transparent(CWebKitWebView web_view) {
    if (web_view != NULL && WEBKIT_IS_WEB_VIEW((WebKitWebView*)web_view)) {
        // Set transparent background
        GdkRGBA transparent = {0.0, 0.0, 0.0, 0.0};
        webkit_web_view_set_background_color((WebKitWebView*)web_view, &transparent);
    }
}

void webkit_wrapper_set_insensitive(CWebKitWebView web_view) {
    if (web_view != NULL) {
        // Make widget non-interactive (clicks pass through)
        gtk_widget_set_can_target((GtkWidget*)web_view, FALSE);
        gtk_widget_set_focusable((GtkWidget*)web_view, FALSE);
    }
}

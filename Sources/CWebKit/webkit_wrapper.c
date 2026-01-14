#include "shim.h"
#include <webkit/webkit.h>

CWebKitWebView webkit_wrapper_web_view_new(void) {
    return (CWebKitWebView)webkit_web_view_new();
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
    webkit_web_view_load_html((WebKitWebView*)web_view, content, base_uri);
}

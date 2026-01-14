#ifndef CWebKit_shim_h
#define CWebKit_shim_h

#include <stdint.h>

// Opaque pointer types to avoid GTK conflicts
typedef void* CWebKitWebView;
typedef void* CWebKitSettings;

// WebKit wrapper functions
CWebKitWebView webkit_wrapper_web_view_new(void);
CWebKitSettings webkit_wrapper_web_view_get_settings(CWebKitWebView web_view);
void webkit_wrapper_settings_set_enable_javascript(CWebKitSettings settings, int enabled);
void webkit_wrapper_settings_set_enable_developer_extras(CWebKitSettings settings, int enabled);
void webkit_wrapper_web_view_load_html(CWebKitWebView web_view, const char* content, const char* base_uri);
void webkit_wrapper_set_transparent(CWebKitWebView web_view);
void webkit_wrapper_set_insensitive(CWebKitWebView web_view);

#endif /* CWebKit_shim_h */

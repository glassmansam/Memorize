//
//  WebView.swift
//  Memorize
//
//  A wrapper for WebKitGTK WebView widget.
//

import Adwaita
import CAdw
import CWebKit

/// A WebView widget for displaying HTML content with KaTeX math rendering.
struct WebView: AdwaitaWidget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, WidgetData, Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, WidgetData) -> Void] = []

    /// The HTML content to display.
    var html: String

    /// The CSS styles to apply.
    var css: String = ""

    /// Whether the content is selectable.
    var selectable: Bool = false

    /// The view storage.
    /// - Parameters:
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
        let webView = webkit_web_view_new()
        let settings = webkit_web_view_get_settings(webView)

        // Enable JavaScript for KaTeX rendering
        webkit_settings_set_enable_javascript(settings, 1)

        // Disable context menu for cleaner UI
        webkit_settings_set_enable_developer_extras(settings, 0)

        let storage = ViewStorage(webView?.opaque())
        for function in appearFunctions {
            function(storage, data)
        }
        update(storage, data: data, updateProperties: true, type: type)
        return storage
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        storage.modify { widget in
            if updateProperties, (storage.previousState as? Self)?.html != html {
                let fullHTML = generateFullHTML()
                webkit_web_view_load_html(widget, fullHTML, nil)
            }
        }
        for function in updateFunctions {
            function(storage, data, updateProperties)
        }
        if updateProperties {
            storage.previousState = self
        }
    }

    /// Generate the full HTML document with KaTeX support.
    private func generateFullHTML() -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
            <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>
            <style>
                body {
                    font-family: 'Cantarell', sans-serif;
                    margin: 0;
                    padding: 8px;
                    background: transparent;
                    color: inherit;
                    font-size: 16px;
                    line-height: 1.5;
                    \(selectable ? "" : "user-select: none;")
                }
                .katex {
                    font-size: 1.1em;
                }
                \(css)
            </style>
        </head>
        <body>
            <div id="content">\(html.escapedForHTML)</div>
            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    renderMathInElement(document.getElementById("content"), {
                        delimiters: [
                            {left: "$$", right: "$$", display: true},
                            {left: "$", right: "$", display: false},
                            {left: "\\\\(", right: "\\\\)", display: false},
                            {left: "\\\\[", right: "\\\\]", display: true}
                        ],
                        throwOnError: false
                    });
                });
            </script>
        </body>
        </html>
        """
    }
}

extension String {
    /// Escape special HTML characters.
    var escapedForHTML: String {
        var result = self
        result = result.replacingOccurrences(of: "&", with: "&amp;")
        result = result.replacingOccurrences(of: "<", with: "&lt;")
        result = result.replacingOccurrences(of: ">", with: "&gt;")
        result = result.replacingOccurrences(of: "\"", with: "&quot;")
        return result
    }
}

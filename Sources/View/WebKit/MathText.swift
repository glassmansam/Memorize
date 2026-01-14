//
//  MathText.swift
//  Memorize
//
//  A text view that can render LaTeX math expressions using KaTeX.
//

import Adwaita

/// A text view that renders content with optional LaTeX math support.
/// When the text contains LaTeX delimiters ($...$, $$...$$, \(...\), \[...\]),
/// it uses a WebView with KaTeX to render the math expressions.
struct MathText: SimpleView {

    /// The text content to display.
    var text: String

    /// Whether to use large text styling (for titles).
    var isTitle: Bool = false

    /// Check if the text contains LaTeX math expressions.
    var containsMath: Bool {
        text.containsLaTeX
    }

    var view: Body {
        if containsMath {
            WebView(
                html: text,
                css: isTitle ? "body { font-size: 20px; text-align: center; }" : ""
            )
            .frame(minHeight: isTitle ? 80 : 50)
        } else {
            Text(text)
        }
    }
}

extension String {
    /// Check if the string contains LaTeX math delimiters.
    /// This is a heuristic check - exact validation happens at render time by KaTeX.
    var containsLaTeX: Bool {
        // Check for display math: $$...$$ (non-greedy match)
        if self.range(of: #"\$\$.+?\$\$"#, options: .regularExpression) != nil {
            return true
        }

        // Check for inline math: $...$ (non-greedy, no nested $)
        if self.range(of: #"\$[^$]+?\$"#, options: .regularExpression) != nil {
            return true
        }

        // Check for LaTeX delimiters: \(...\) (matching pairs)
        if self.range(of: #"\\\(.+?\\\)"#, options: .regularExpression) != nil {
            return true
        }

        // Check for LaTeX delimiters: \[...\] (matching pairs)
        if self.range(of: #"\\\[.+?\\\]"#, options: .regularExpression) != nil {
            return true
        }

        return false
    }
}

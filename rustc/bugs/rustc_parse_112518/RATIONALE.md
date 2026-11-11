# Adapted injection for Detect actual span for getting unexpected token from parsing macros

Fix: https://github.com/rust-lang/rust/commit/0220c0b765e92dcb3565f0a8bd3c422afbd77f88

Hunk: compiler/rustc_parse/src/parser/expr.rs, `error_unexpected_after_dot`.
Removed the `(token::Eof, Some(_)) if let Ok(snippet) = sm.span_to_snippet(sm.next_point(span))` arm
(and the now-unused `sm`), so inside macro subparsers an Eof token reports the Eof span and "unexpected token: `<eof>`"
instead of the real next char at span.shrink_to_hi().
Re-expresses fix hunk `@@ -1013,9 +1013,15 @@ fn error_unexpected_after_dot` (the added `(token::Eof, Some(_)) ... shrink_to_hi()` match).

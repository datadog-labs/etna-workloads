# Adapted injection for diagnostics: wrap fn cast suggestions in parens

Fix: https://github.com/rust-lang/rust/commit/c48b0d4eb404f856f8bf1d305818ce21cc125fc5

# Hunk: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, `suggest_cast_to_fn_pointer`
The logic moved here from fulfillment_errors.rs. Fix hunk `@@ -378,14 +379,34 @@` replaced the plain
`span_suggestion(span.shrink_to_hi(), ..., " as {fnptr}")` with a paren-wrapping multipart suggestion
(`(span.shrink_to_lo(), "(")`, `" as {})"` for method receivers `.` and `&` exprs). I removed the
`parenthesized_cast` closure and the receiver / AddrOf branches, restoring the unconditional ` as fn(..)` suffix suggestion (buggy output: `&f as fn()` / `f as fn().method()`).

# Adapted injection for Also note struct access, and fix macro expansion from foreign crates

Fix: https://github.com/rust-lang/rust/commit/09e584671b439dc8a9d57cc900cc26668a69ddea

Only file changed: compiler/rustc_hir_typeck/src/expr.rs, fn no_such_field_err.
1. Removed `if let Some(within_macro_span) = span.within_macro(expr.span, ..) { err.span_label(.., "due to this macro variable") }`
   — re-expresses fix hunk `@@ -3282,18 +3282,27 @@ fn no_such_field_err` (added that label for struct field access).
2. `if len > 0 && expr.span.eq_ctxt(field.span)` -> `if len > 0` — re-expresses the same hunk series
   (`@@ -3328,7 +3337,9 @@`, "Don't suggest `.field` if the base expr is from a different syntax context").

# Adapted injection for skip `unused_parens`'s suggestion for `Paren` in macro.

Fix: https://github.com/rust-lang/rust/commit/c8490a06085acf60bef4888d8af02c63fa0417d4

Both changes are in compiler/rustc_lint/src/unused.rs and remove the `from_expansion()` guard that the fix added.

1. `UnusedParens::check_unused_parens_pat`: the suggestion spans are computed unconditionally again. This re-expresses the fix hunk `@@ -1074,10 +1074,14 @@ impl UnusedParens` (`let spans = if !value.span.from_expansion() {...} else { None }`). The compiler now builds a removal suggestion for parens that come from a macro expansion.
2. `<UnusedParens as EarlyLintPass>::check_ty`: the same guard is removed. This re-expresses the fix hunk `@@ -1233,11 +1237,13 @@ impl EarlyLintPass for UnusedParens`. In 1.99.1 the code is written as `(!ty.span.from_expansion()).then(...).flatten()`.

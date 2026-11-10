# Adapted injection for Don't suggest wrapping attr in unsafe if it may come from proc macro

Fix: https://github.com/rust-lang/rust/commit/50e9839d4849d932810ebba52a664d39baed5253

# Rationale
compiler/rustc_attr_parsing/src/safety.rs, `check_attribute_safety`: removed the snippet-inspection block
(fix hunk `@@ -62,16 +62,28 @@`, the `let mut not_from_proc_macro = true; if diag_span.from_expansion() && ... snippet.contains("!(") ...`)
and replaced it with `let not_from_proc_macro = true;`. The suggestion is therefore always attached, even for
proc-macro-generated attributes (pre-fix behaviour; the Option plumbing from the fix remains in 1.99.1 and now always yields Some).
This covers the second hunk too (`not_from_proc_macro.then(...)` at `@@ -81,7 +93,8 @@`), which is now always Some.

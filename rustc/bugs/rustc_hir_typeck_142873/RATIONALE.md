# Adapted injection for Don't suggest changing a  method inside a expansion

Fix: https://github.com/rust-lang/rust/commit/188023a93cea7b2516a527aa100581687c15dd89

compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error (similar_candidate block, ~line 1131):
removed `&& !span.from_expansion()` (and its comment) from the condition guarding find_likely_intended_associated_item.
Re-expresses fix hunk `@@ -1723,8 +1723,10 @@` which added `// and if the we aren't in an expansion. && !span.from_expansion()`.

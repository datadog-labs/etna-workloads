# Adapted injection for clean up struct field suggestions

Fix: https://github.com/rust-lang/rust/commit/867cc41b5b2f0e84de6a1fd10099e9383cecc807

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn `is_field_suggestable`.
Fix hunk `@@ -1687,4 +1687,23 @@ ... suggestions.rs` added this helper with the checks
`(field.did.is_local() || !self.tcx.is_doc_hidden(field.did))` and the hygiene check
`def_ident_span(field.did)...normalize_to_macros_2_0().eq_ctxt(span)`. Before the fix, struct field suggestions
(old `suggest_field_name`/`available_field_names`/pattern filters) had no hygiene check and did not handle
doc(hidden) properly for external fields. I removed those two clauses, so all callers (expr.rs, pat.rs, which in 1.99.1 already
use the helper, replacing the failed expr.rs/pat.rs hunks) suggest doc(hidden) and hygienic-mismatched fields again.

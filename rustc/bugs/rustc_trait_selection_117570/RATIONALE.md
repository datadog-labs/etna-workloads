# Adapted injection for fallback for `construct_generic_bound_failure`

Fix: https://github.com/rust-lang/rust/commit/a4768fea3545a799b9c19e65777f6fee7b50a561

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/region.rs, `construct_generic_bound_failure` (moved from rustc_infer).

Fix hunk `@@ -2444,18 +2444,22 @@`: `else { get_generics(..).unwrap() ... }` became `else if let Some(generics) = get_generics(..) {..} else { err.help(..) }`, and the multipart_suggestion became guarded by `if !suggs.is_empty()`.
Re-injected: the final `else` unwraps `hir_get_generics(suggestion_scope)` again (no help fallback), and `multipart_suggestion` is called unconditionally.
Adaptation: 1.99.1 has an extra RPITIT branch (added later) that skips the suggestion and masks the unwrap, so I removed it to restore the pre-fix behaviour (the ICE on `async fn foo() -> &'static impl T` in a trait).

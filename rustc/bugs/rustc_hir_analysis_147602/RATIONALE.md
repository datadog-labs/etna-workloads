# Adapted injection for Deduplicate higher-ranked lifetime capture errors in impl Trait

Fix: https://github.com/rust-lang/rust/commit/e4194c7075ae35d45bdec1b779a2b57c400af60b

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn `BoundVarContext::check_lifetime_capture` (the fn that returns `Result<(), ErrorGuaranteed>` for opaque captures).

Re-expresses the fix hunk `@@ -1424,21 +1442,52 @@ impl<'a, 'tcx> BoundVarContext<'a, 'tcx>` in reverse: instead of accumulating
`capture_spans`/`decl_spans` into `opaque_capture_errors` and deferring the diagnostic to
`emit_opaque_capture_errors` (called once per opaque), the error is emitted immediately per captured
lifetime with `(span, label) = if capture_span != decl_span { (capture_span, None) } else { (opaque_span, Some(opaque_span)) }`.
Result: one E0657 per captured lifetime, with the old span/label layout. The accumulator plumbing
(struct, field, with_scope hunk) is left in place but never populated, so `emit_opaque_capture_errors` returns None.
(The errors.rs `MultiSpan` hunk is already in diagnostics.rs; wrapped single spans with MultiSpan::from_span.)

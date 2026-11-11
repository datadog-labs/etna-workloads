# Adapted injection for wf-check RPITs

Fix: https://github.com/rust-lang/rust/commit/93bc7a428cdf64a822274f7c5647ad46f8ecf122

# Rationale
The fix made RPIT/async-fn opaques wf-checked like TAIT (fixing #114728, #114572). In 1.99.1 that logic moved into the opaque-type machinery.

1. `compiler/rustc_hir_analysis/src/check/check.rs`, `check_opaque_meets_bounds`: re-added an early return for `FnReturn`/`AsyncFn` origins (`take_opaque_types()` then `return Ok(())`) before the implied-bounds region check. This re-expresses the removed arm in fix hunk `@@ -403,16 +403,6 @@ fn check_opaque_meets_bounds`: "Checked when type checking the function containing them. ... let _ = infcx.take_opaque_types(); return Ok(());".
2. `compiler/rustc_infer/src/infer/opaque_types/mod.rs`, `add_item_bounds_for_hidden_type`: removed the `WellFormed(hidden_ty)` goal. This is the 1.99 location of the hidden-type wf requirement that the fix introduced for RPITs. The comment there cites #114728. Without it the hidden type is never wf-checked, which is the pre-fix behaviour.

The implied_bounds.rs hunk was not re-applied, because the fix only changed the wf_tys source there, not the check itself.

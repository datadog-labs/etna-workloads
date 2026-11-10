# Adapted injection for Delegation: fix ICE on `bound_vars` divergence

Fix: https://github.com/rust-lang/rust/commit/d1ba632f4f65051a6230db59e2ed2e1b1e8f12fc

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, `BoundVarContext::visit_fn`.
Removed the block inserting `late_bound_vars` for fns whose output is `TyKind::InferDelegation(Sig(sig_id,_))` (copying the bound vars of `fn_sig(sig_id)`), and restored the unused `_: LocalDefId` param.
Re-expresses fix hunk `@@ -793,12 +793,20 @@ ... fn visit_fn` (`_: LocalDefId` -> `def_id`, plus the `late_bound_vars.insert(hir_id, bound_vars)` block).
The fix's second hunk (hir_ty_lowering/mod.rs, `lower_fn_ty`, now using `tcx.late_bound_vars(hir_id)` in 1.99.1) is already in the post-fix form; the bug comes back from the missing map entry (bound_vars divergence ICE).

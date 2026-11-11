# Adapted injection for Fix ICE in borrowck when recovering `fn_sig` for `-> _`

Fix: https://github.com/rust-lang/rust/commit/7d7b3816607c3f0c5afd4562bb3efca8b6eea777

# Rationale
File compiler/rustc_hir_analysis/src/collect.rs, fn recover_infer_ret_ty.
Fix hunk `@@ -1138,13 +1138,65 @@ fn recover_infer_ret_ty` replaced `ty::Binder::dummy(tcx.mk_fn_sig(...))` with
`late_bound_vars` + `fold_regions` (ReLateParam -> bound) + `Binder::bind_with_vars`.
In 1.99.1 that logic lives in the helper `late_param_regions_to_bound(tcx, scope, bound_vars, fn_sig)`;
I removed the bound_vars/scope computation and call, restoring `ty::Binder::dummy(tcx.mk_fn_sig(..))`.

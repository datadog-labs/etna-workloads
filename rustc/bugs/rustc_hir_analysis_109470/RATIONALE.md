# Adapted injection for Subst gat normalize pred correctly

Fix: https://github.com/rust-lang/rust/commit/08284449a24f28ca9d76b8ccd823bc59ed2b30e3

# Hunk: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, `param_env_with_gat_bounds`
Fix hunk: `@@ -1958,7 +1958,7 @@ check_type_bounds`: `-type_of(..).subst_identity()` / `+type_of(..).subst(tcx, impl_ty_substs)`.
In 1.99.1 that logic moved into `param_env_with_gat_bounds`, where `normalize_impl_ty` is instantiated with `normalize_impl_ty_args`
(the bound-var GAT args). I re-introduced the bug by using `instantiate_identity()` instead, so the GAT's own params are not substituted
in the normalize predicate's value.

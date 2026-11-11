# Adapted injection for Only use normalize_param_env when normalizing predicate in check_item_bounds

Fix: https://github.com/rust-lang/rust/commit/97c9d8f405e1b93bf69334b239f89d92d28847a0

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `check_type_bounds`.

Re-expresses both hunks of the fix in reverse:
- `@@ -2162,7 +2162,7 @@ check_type_bounds`: `-let param_env = param_env_with_gat_bounds(...)` / `+let param_env = tcx.param_env(impl_ty.def_id);`. Buggy version restored: param_env (used for proving obligations, WF types, region resolution) again includes the GAT-normalization assumption.
- `@@ -2217,8 +2217,14 @@`: the fix added a separate `normalize_param_env` used only for normalizing predicates. Removed it; normalization uses `param_env` again (now the GAT-bounds env).

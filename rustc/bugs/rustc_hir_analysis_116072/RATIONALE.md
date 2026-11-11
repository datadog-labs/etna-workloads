# Adapted injection for Need to use hybrid param-env to make sure implication is not circular

Fix: https://github.com/rust-lang/rust/commit/85681219963220bd5e3bea0545b91eb7b340249a

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `collect_return_position_impl_trait_in_trait_tys`.
Re-expresses fix hunk `@@ -689,6 +687,19 @@` (added `hybrid_preds` param-env: impl predicates + trait method own predicates, normalized via `normalize_param_env_or_error`) and `@@ -662,8 +662,6 @@` (removed `let param_env = tcx.param_env(impl_m_def_id);`).
Buggy behaviour restored: the hybrid param-env block (now named `hybrid_clauses`) is removed and `let param_env = tcx.param_env(impl_m_def_id);` is used instead, so the impl method's own env (which implies the circular WF bound) is used.

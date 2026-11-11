# Adapted injection for Use the normalizing param-env always in check_type_bounds

Fix: https://github.com/rust-lang/rust/commit/bb74d7e97d8da904bb6deeb78bafeaa6ad7c11c8

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn check_type_bounds.
Change: `let normalize_param_env = param_env_with_gat_bounds(tcx, impl_ty, impl_trait_ref);` -> `let normalize_param_env = param_env;`

Re-expresses fix hunk `@@ -2336,8 +2218,7 @@` (`ocx.normalize(&normalize_cause, param_env, obligation.predicate)`, where param_env
is the one built by `param_env_with_gat_bounds`) and the `@@ -2162,128 +2162,10 @@` hunk (replacing the plain
`tcx.param_env(impl_ty.def_id)` with the GAT-normalizing env). In 1.99.1 the code already keeps a separate
normalizing env (a later perf change), so the bug is restored by dropping the GAT-projection predicate
from the env used to normalize the item bounds: the GAT no longer normalizes to its definition type
when nested goals are normalized.

# Adapted injection for Elaborate param-env built for checking DispatchFromDyn for dyn compat

Fix: https://github.com/rust-lang/rust/commit/c170d0f12fa9866d39190bc70c8df614083c3d5a

# Hunk: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, receiver_is_dispatchable
Re-expresses fix hunk `@@ -598,10 +600,13 @@ fn receiver_is_dispatchable`: the fix wraps the param-env in
`normalize_param_env_or_error(...)` (which elaborates supertraits of `U: Trait`); the bug is the plain
`ty::ParamEnv::new(...)` without elaboration. In 1.99.1 I replaced the `normalize_param_env_or_error(tcx, ParamEnv::new(mk_clauses(&clauses)), cause)` call with `ty::ParamEnv::new(tcx.mk_clauses(&clauses))`.
The import hunk (unused import warning remains) is left as-is.

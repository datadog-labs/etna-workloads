# Adapted injection for use implied bounds when checking opaque types

Fix: https://github.com/rust-lang/rust/commit/d548747c8531f2f0dfd3921b85aafb09ded27d49

# Rationale
One hunk, in compiler/rustc_hir_analysis/src/check/check.rs, function `check_opaque_meets_bounds` (the 1.99.1 successor, which returns Result).

It re-expresses the fix hunk `@@ -448,9 +450,18 @@ fn check_opaque_meets_bounds` in check.rs. That hunk replaced
`let outlives_env = OutlivesEnvironment::new(param_env);` with
`let wf_tys = ocx.assumed_wf_types(...); let implied_bounds = infcx.implied_bounds_tys(...); OutlivesEnvironment::with_bounds(param_env, implied_bounds)`.

In 1.99.1 the code is `let wf_tys = ocx.assumed_wf_types_and_report_errors(param_env, defining_use_anchor)?; ocx.resolve_regions_and_report_errors(defining_use_anchor, param_env, wf_tys)?;`.
I pass an empty wf-type iterator instead, so region resolution uses no implied bounds. This is the pre-fix behaviour.

The other fix hunks are not re-expressed:
- The `assumed_wf_types` OpaqueTy arm in implied_bounds.rs.
- The nested-opaque skip.
- The identity-args change.

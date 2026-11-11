# Adapted injection for improve the suggestion of generic_bound_failure

Fix: https://github.com/rust-lang/rust/commit/5be0b2283aa26f0fee1e3d1161524a23d65484b7

# Re-injected bug

File: compiler/rustc_trait_selection/src/error_reporting/infer/region.rs, fn construct_generic_bound_failure
(moved from rustc_infer/.../error_reporting/mod.rs in the fix's era).

The fix (hunk `@@ -2625,37 +2372,192 @@`) added a scope check to the new suggestion code:
`if let Some((sp, has_lifetimes)) = type_param_sugg_span && suggestion_scope == type_scope { ... } else { where-clause suggestion }`.
Before the fix the suggestion was always placed on the type parameter's declaration (`T: 'a`), even when the
lifetime is declared in a narrower scope (e.g. a GAT/method), where it is out of scope.
I removed `&& suggestion_scope == type_scope`, so the type-param bound suggestion is used whenever a span exists.

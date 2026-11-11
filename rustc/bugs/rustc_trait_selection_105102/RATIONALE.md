# Adapted injection for copy self type is implied wf

Fix: https://github.com/rust-lang/rust/commit/333c6bf523019fd1565a5236d3c727172ec844f2

# Hunk: compiler/rustc_trait_selection/src/traits/misc.rs, `all_fields_implement_trait`
Region check per field now calls `infcx.resolve_regions(body_def_id, param_env, [])` instead of `[self_type]`,
so the impl's self type is no longer assumed WF (implied bounds).
Re-expresses fix hunk `@@ -85,7 +89,16 @@ type_allowed_to_implement_copy`: the fix replaced
`OutlivesEnvironment::new(param_env)` with `OutlivesEnvironment::with_bounds(..., implied_bounds_tys(..., [self_type]))`
("Check regions assuming the self type of the impl is WF"). In 1.99.1 that is the `[self_type]` argument of resolve_regions.

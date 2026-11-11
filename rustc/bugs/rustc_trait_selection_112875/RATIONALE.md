# Adapted injection for Consider regions

Fix: https://github.com/rust-lang/rust/commit/1d99ddbfe81b7d766c6e6f54dbc722c70d0b6be7

# Rationale
File: compiler/rustc_trait_selection/src/traits/coherence.rs, fn `try_prove_negated_where_clause` (the 1.99.1 successor of the loop body in `impl_intersection_has_negative_obligation`).
Re-expresses the fix hunk `@@ -434,12 +434,19 @@ fn impl_intersection_has_negative_obligation(`, which replaced `// FIXME: regions here too...` with an `OutlivesEnvironment` + `infcx.resolve_regions(&outlives_env)` check, and `continue`d on errors.
In 1.99.1 that check is `ocx.resolve_regions(CRATE_DEF_ID, param_env, [])` followed by `return false` on errors. I removed it and put back the `// FIXME: regions here too...` comment. A negative goal is now accepted even when region constraints fail, so `impl<T> !Foo for &'static T` wrongly disproves `&'a T: Foo` for any lifetime.

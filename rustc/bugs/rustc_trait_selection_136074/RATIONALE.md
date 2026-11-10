# Adapted injection for Deeply normalize args for implied bounds

Fix: https://github.com/rust-lang/rust/commit/ce0c952e968777004fc59f45653be2fda116fee1

# Hunk: compiler/rustc_trait_selection/src/traits/implied_outlives_bounds.rs, compute_implied_outlives_bounds_inner
Changed `let mut wf_args = vec![ty.into(), normalized_ty.into()];` to `vec![ty.into()]` (normalized_ty ignored),
so implied bounds are no longer derived from the normalized arg.
Re-expresses fix hunk `@@ -264,7 +264,7 @@ ... UniversalRegionRelationsBuilder` in free_region_relations.rs
(`-.and(type_op::normalize::Normalize { value: ty })` / `+.and(DeeplyNormalize { value: ty })`): that fix made the
normalized type (deeply normalized) feed implied bounds. In 1.99.1 that code was restructured (Normalize is deep in
the next solver, borrowck uses an implied-bounds query), so the equivalent is dropping the normalized arg from the WF-arg set.

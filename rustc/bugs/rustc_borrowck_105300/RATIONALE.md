# Adapted injection for rework min_choice algorithm of member constraints

Fix: https://github.com/rust-lang/rust/commit/837c1aff0546edca18b43fbfc65b8dacf0b0b699

# Rationale
File: compiler/rustc_borrowck/src/region_infer/opaque_types/member_constraints.rs, fn apply_member_constraint (the code moved here from region_infer/mod.rs).
Re-expresses the single hunk `@@ -739,20 +739,33 @@ impl<'tcx> RegionInferenceContext<'tcx>`: the fix replaced
`choice_regions.iter().find(|&r1| choice_regions.iter().all(|&r2| outlives(r2, *r1)))` (first choice outlived by all others)
with the `totally_ordered_subset` + `reduce` unique-minimum algorithm. I restored the old find-based min_choice (and the early return when empty), removing the new algorithm.

# Adapted injection for Propagate region error for every non-local lower bound

Fix: https://github.com/rust-lang/rust/commit/0627df9151ec49426de114873309521c89f95da7

# Rationale
One hunk, in `compiler/rustc_borrowck/src/type_check/free_region_relations.rs`, `UniversalRegionRelations::non_local_lower_bounds`.
It re-expresses the fix hunk `@@ -94,28 +94,10 @@ impl UniversalRegionRelations<'_>`. The fix replaced the postdominator reduction (`mutual_immediate_postdominator(lower_bounds)`, with a check that the result is non-local) by `self.non_local_bounds(&self.outlives, fr)`, which returns every non-local lower bound.
I restored the reduction to a single postdominating bound. It returns a Vec of 0 or 1 elements so that the 1.99.1 caller in `region_infer/mod.rs` still compiles. That caller already matches the fixed version, and its `is_empty()` check returns an Error. With several competing lower bounds, the old behaviour is a spurious error instead of propagating a requirement for each one.
The `region_infer/mod.rs` hunk is not reverted; the caller's loop over constraints is unchanged and just sees at most one `fr-`.

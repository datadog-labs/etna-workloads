# Adapted injection for Fix ICE in next-solver TransmuteFrom candidate

Fix: https://github.com/rust-lang/rust/commit/ee135be0415aa531339d2a536207f32b15a0acac

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, fn consider_builtin_transmute_candidate.
Removed the block `if goal.has_non_region_infer() { return ecx.forced_ambiguity(MaybeInfo::AMBIGUOUS); }`
(and its comment), re-expressing the fix hunk `@@ -665,6 +665,12 @@` which added it (MaybeCause::Ambiguity in the old
code). Without it, transmutability computes layouts for unresolved inference types.

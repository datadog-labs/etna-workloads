# Adapted injection for normalization: avoid incompletely constraining GAT args

Fix: https://github.com/rust-lang/rust/commit/31ebe11f61dc56018c3919dae140d9e89b2238a5

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs, `NormalizesTo::compute_normalizes_to` closure passed to `assemble_and_merge_candidates` (in 1.99.1 the GAT check lives here instead of `match_assumption`).
Removed the loop over `goal.predicate.alias.own_args(cx)` that structurally normalizes each GAT arg and returns `Certainty::AMBIGUOUS` if it is still an infer var. This re-expresses the fix hunk in normalizes_to/mod.rs `@@ -129,7 +129,40 @@ ... fn match_assumption` which added "If this type is a GAT with currently unconstrained arguments, we do not want to normalize it via a candidate which only applies for a specific instantiation". Without it, candidates incompletely constrain GAT args (#92917 aggressive inference) in the next solver. The closure now just returns `None`.
Other fix hunks (signature refactor of match_assumption, helper `as_term`/`own_args`, comment in select/mod.rs) are refactoring/enablers and were not reversed.

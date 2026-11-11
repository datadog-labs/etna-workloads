# Adapted injection for Don't drop Upcast candidate in intercrate mode

Fix: https://github.com/rust-lang/rust/commit/e485b193d07a77495dcdcb3f52f5976c9c9ca1f4

# Rationale
Fix hunk: `@@ -921,6 +921,12 @@` in candidate_assembly.rs, adding
`if self.infcx.intercrate { return None; }` so no upcast candidate is dropped in intercrate mode.
On 1.99.1 the old-solver function with the `trait_upcasting` feature check no longer exists, and coherence uses the next solver, so the behaviour is re-expressed as: upcast candidates are dropped (not produced) in coherence mode.

1. `compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs`, `assemble_candidates_for_unsizing`: `TraitUpcastingUnsizeCandidate` is no longer pushed when `typing_mode_raw()` is `Coherence`.
2. `compiler/rustc_next_trait_solver/src/solve/trait_goals.rs`, `consider_builtin_dyn_upcast_candidates`: the trait-upcasting branch is skipped in `TypingMode::Coherence`. This is the hunk that makes the oracle test fail, because overlap checking uses the next solver.

# Adapted injection for prioritize param-env candidates

Fix: https://github.com/rust-lang/rust/commit/2b0f5721c190ebb9b738713d578f3780eac46ee6

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, in the merge-candidates function (`has_non_global_where_bounds`).
In 1.99.1 the fix's `merge_candidates` logic (assembly.rs / mod.rs hunks) lives here: non-global `ParamEnv` candidates are prioritized over other candidates. The fix added to `merge_candidates`: "We then check whether we should prioritize `ParamEnv` candidates ... `SolverMode::Coherence => ()`, `Normal => ... try_merge_responses(&param_env_responses)`". The pre-fix code had no prioritization of param-env candidates in this path (`candidate_should_be_dropped_in_favor_of` was a no-op).
The change gates the param-env preference on `is_coherence()`, which inverts the fix's `SolverMode::Coherence => ()` (no prioritization in coherence). In normal mode param-env candidates are no longer preferred, so they are merged with impl candidates and can come back ambiguous.

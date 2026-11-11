# Adapted injection for Track assumptions for canonical response universes

Fix: https://github.com/rust-lang/rust/commit/698320cb956017f77b0e098649116c11de0823f5

# Rationale
File: compiler/rustc_next_trait_solver/src/canonical/mod.rs, fn instantiate_and_apply_query_response (the loop over `universes_created_in_query`).
Re-expresses fix hunk `@@ -162,7 +162,16 @@`: the fix changed `delegate.create_next_universe();` to also call
`delegate.insert_placeholder_assumptions(new_universe, Some(Assumptions::empty()))` under `assumptions_on_binders()`.
In 1.99.1 this was already present (with a FIXME comment); I removed it, restoring the bare `delegate.create_next_universe();`.

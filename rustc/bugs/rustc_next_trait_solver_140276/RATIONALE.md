# Adapted injection for Do not compute type_of for impl item if impl where clauses are unsatisfied

Fix: https://github.com/rust-lang/rust/commit/105d1dcefd9baa520e63830f557d9c472f50d4fd

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs, fn consider_impl_candidate (normalizes-to for impl assoc items).
Removed the `ecx.try_evaluate_added_goals()?;` call (and its comment) placed after `add_goals(GoalSource::ImplWhereBound, ...)`.
Re-expresses fix hunk `@@ -194,6 +194,12 @@` in normalizes_to/mod.rs (file moved to normalizes_to.rs in 1.99.1), which added "Bail if the nested goals don't hold here ... `ecx.try_evaluate_added_goals()?;`".
Without it, type_of of the impl item is computed even when impl where clauses fail, causing RPITIT query cycles.

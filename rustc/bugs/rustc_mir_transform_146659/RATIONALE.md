# Adapted injection for Consider errors in MIR as impossible predicates.

Fix: https://github.com/rust-lang/rust/commit/3934fc9eb29061168327640ba7b9ca8f79ba01e2

# Rationale
File: compiler/rustc_mir_transform/src/impossible_clauses.rs (formerly impossible_predicates.rs), `ImpossibleClauses::run_pass`.
Re-expresses the fix hunk `@@ -35,23 +36,29 @@ ... impl MirPass for ImpossiblePredicates`, which added
`let impossible = body.tainted_by_errors.is_some() || has_impossible_predicates(...)`.
The buggy parent only checked the predicates, so bodies tainted by errors were not treated as impossible; I removed the `tainted_by_errors` check.
(The helper-function extraction already exists as `has_impossible_clauses`.)

# Rationale

Fix: implement `reset_state` for `LazyMemoryExec` so generator state (e.g. `generate_series`) is reset when a plan is reused (recursive CTE).

Changes, both in `datafusion/physical-plan/src/memory.rs`:

1. Removed the `ExecutionPlan::reset_state` override on `LazyMemoryExec` (reverses the fix hunk that added it). The default impl returns `self`, so the generators keep their state.
2. `LazyMemoryExec::execute` shares the stored generator (`Arc::clone`) instead of calling `reset_state()` on it. In 55.2.0 `execute` also reset the generator, which covered the case from another path; this is the pre-fix behaviour where the stream drives the shared generator, so an exhausted generator stays exhausted on re-execution.

## Oracle
`table_functions.slt`: the recursive CTE over `generate_series(1, 1)` returns only 2 rows instead of 10, because the exhausted generator yields nothing on re-execution.

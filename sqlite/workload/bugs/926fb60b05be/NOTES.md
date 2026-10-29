`repro.sql` is upsert5 test 3.0–3.2. It does a REPLACE with two identical `ON CONFLICT(bb)` clauses on a table with a unique index.

- Clean: the redundant clause is ignored. `integrity_check` returns `ok`, and both table scans return `11|33`.
- Buggy: the redundant clause isn't ignored, and the shell aborts with an assertion failure in `resolveP2Values` (exit status -6).

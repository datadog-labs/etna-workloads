# Rationale

Changed hunk: `src/backend/utils/misc/guc_tables.c`, the `stats_fetch_consistency` entry in `ConfigureNamesEnum[]`.
It traces to the guc_tables.c hunk of fix.patch. The assign hook `assign_stats_fetch_consistency` is replaced with `NULL` again.

Why this brings the bug back: changing stats_fetch_consistency inside a transaction no longer sets
`force_stats_snapshot_clear`, so the existing snapshot is not cleared. The snapshot state then no longer
matches the new mode, which triggers the assertion failure. The pgstat.c helpers are left in place but are never triggered.

Failing oracle case: src/test/regress||stats

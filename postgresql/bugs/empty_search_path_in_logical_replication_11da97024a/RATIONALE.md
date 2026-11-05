# Rationale

Reintroduces the bug "Empty search_path in logical replication apply worker and walsender": the logical apply worker and the walreceiver connection used for logical replication no longer set a secure (empty) search_path.

## Hunks

1. `src/backend/replication/libpqwalreceiver/libpqwalreceiver.c`, `libpqrcv_connect()`
   - Traces to the fix.patch hunk adding `if (logical) { ... ALWAYS_SECURE_SEARCH_PATH_SQL ... }` (today's code: `if (!replication || logical)`).
   - Removed that block, so the connection to the publisher (walsender) keeps the default search_path, and user code on the walsender can be redirected by malicious users.

2. `src/backend/replication/logical/worker.c`, `ApplyWorkerMain()` (today `run_apply_worker`/worker startup)
   - Traces to the fix.patch hunk adding `SetConfigOption("search_path", "", PGC_SUSET, PGC_S_OVERRIDE);` after `BackgroundWorkerInitializeConnectionByOid`.
   - Removed it, so the apply worker runs with the default search_path.

## Failing oracle cases
All 38 oracle cases in src/test/subscription/t/001_rep_changes.pl fail (reported as "missing": the TAP script aborts before producing results). With no change they all pass.

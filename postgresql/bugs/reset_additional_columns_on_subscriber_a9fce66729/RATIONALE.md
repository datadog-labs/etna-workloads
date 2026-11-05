# Rationale

Hunk: src/backend/replication/logical/worker.c, `slot_modify_data()`.
Traces to the fix.patch hunk in `slot_modify_cstrings()` that makes columns with
`remoteattnum < 0` (local-only extra columns) be skipped instead of falling through
and being set to NULL. In current code the slot is pre-filled from srcslot, and
columns with `remoteattnum < 0` are skipped with `continue`. The change sets those
columns to NULL before `continue`, so an UPDATE resets additional subscriber columns to NULL.

Failing oracle cases: see the oracle run (008_diff_schema.pl cases about extra columns/local defaults/locally changed data).

Oracle cases that fail (4/5 in the final run):
- check extra columns contain local defaults after apply
- check extra columns contain local defaults after copy
- check extra columns contain locally changed data
- check replicated inserts on subscriber

(An earlier run failed 5/5; "check initial data was copied to subscriber" passed in the last run, so it's flaky/timing-dependent.)
The test aborts early when replication stops catching up (the subscriber's extra columns are NULLed on update).

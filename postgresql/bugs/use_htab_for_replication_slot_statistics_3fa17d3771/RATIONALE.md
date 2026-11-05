# Rationale

The fix replaced the set-returning `pg_stat_get_replication_slots()` with a per-slot `pg_stat_get_replication_slot(name)` and a LATERAL view over pg_replication_slots. In REL_18 the stats are in shared memory, not a pgstat HTAB, so the bug is re-expressed as the old "return all slots" API shape.

- `src/include/catalog/pg_proc.dat` (oid 6169): traces to the pg_proc.dat hunk. Reverts to the SRF `pg_stat_get_replication_slots()` with no args, proretset, prorows=10.
- `src/backend/utils/adt/pgstatfuncs.c`, new `pg_stat_get_replication_slots()`: traces to the pgstatfuncs.c hunk, which turned the SRF over all slots into the per-name function. It iterates the in-use logical slots and fetches their stats.
- `src/backend/catalog/system_views.sql`: traces to the system_views.sql hunk. `pg_stat_replication_slots` goes back to `FROM pg_stat_get_replication_slots() AS s`.

The view definition now differs from the one in expected/rules.out.

Failing oracle case: src/test/regress||rules

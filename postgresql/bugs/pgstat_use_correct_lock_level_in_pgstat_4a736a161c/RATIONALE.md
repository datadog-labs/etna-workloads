# Rationale

Changed hunk: `src/backend/utils/activity/pgstat_shmem.c`, `pgstat_drop_matching_entries()`
(called by `pgstat_drop_all_entries()`, which in REL_18_6 is a thin wrapper).

Traces to fix.patch hunk in `pgstat_drop_all_entries()`: `dshash_seq_init(..., false)` -> `true`.
In current code the scan moved into `pgstat_drop_matching_entries()`, so I reverted the lock arg
there from `true` to `false`. Entries are deleted during the scan, which needs an exclusive lock;
with a shared lock, `dshash_delete_current` trips its exclusive-lock assertion and the stats reset
/ restart paths break.

I did not touch the pgstat.c 'E' end-of-file hunk (the failure is already reproduced by the lock hunk).

Failing oracle cases (24/44), all in src/test/recovery t/029_stats_restart.pl, e.g.
"post ckpt reset & restart: checkpoint still reset", "post wal reset: smaller bytes",
"post restart: increased wal bytes", "post immediate restart: reset timestamp is new", etc.
(full list in logs/oracle.log).

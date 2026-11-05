# Rationale

Reverts fix 2b4f3130382f (pg_rewind on a standby target).

1. `src/bin/pg_rewind/pg_rewind.c`, `main()` (fix.patch hunks for pg_rewind.c): removed `target_wal_endrec` and the
   minRecoveryPoint logic. `rewind_needed` is again decided from `ControlFile_target.checkPoint >= divergerec`
   and the checkpoint end record. `extractPageMap` is again called with `ControlFile_target.checkPoint` as the end point.
2. `src/bin/pg_rewind/parsexlog.c`, `extractPageMap()` (parsexlog.c hunk): loop condition is `ReadRecPtr != endpoint`
   instead of `EndRecPtr < endpoint`, and the end-point sanity check is removed.

Effect: for a standby target, WAL after the last checkpoint up to minRecoveryPoint is not scanned, so pages modified there
are not copied and the rewound server is missing data.

Failing oracle case: `src/bin/pg_rewind|t/008_min_recovery_point.pl|table bar after rewind`

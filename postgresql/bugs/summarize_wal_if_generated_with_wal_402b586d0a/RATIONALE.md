# Rationale

Hunk: src/backend/postmaster/walsummarizer.c, `SummarizeXlogRecord()`.

Traces to the fix.patch walsummarizer.c hunk that sets
`*new_fast_forward = (record_wal_level == WAL_LEVEL_MINIMAL)`. The reverse sets
`*new_fast_forward = false`, so the summarizer never enters fast-forward mode and
summarizes WAL generated with wal_level=minimal. An incremental backup spanning
such WAL is then wrongly allowed instead of failing.

Failing oracle cases:
- src/bin/pg_combinebackup|t/007_wal_level_minimal.pl|incremental backup fails: exit code not 0
- src/bin/pg_combinebackup|t/007_wal_level_minimal.pl|incremental backup fails: matches

# Rationale

Changed hunk: `src/bin/pg_dump/pg_backup_archiver.c`, `_getObjectDescription()`. I removed `strcmp(type, "STATISTICS") == 0` from the list of "objects that don't require special decoration".

Traces to: the first `pg_backup_archiver.c` hunk of fix.patch, which added `"STATISTICS"` to that same list. The fix's other hunks are not reversed. In the current code `_printTocEntry` handles ownership differently, and the `getExtendedStatistics` rewrite is no longer a minimal change.

Why it brings the bug back: `_getObjectDescription` can no longer build the `STATISTICS schema.name` description for a statistics TOC entry. The `ALTER STATISTICS ... OWNER TO` statement therefore cannot be produced correctly. The `002_pg_dump.pl` runs are the oracle cases that fail.

Failing oracle cases: 12501 of 13808, almost all in `src/bin/pg_dump|t/002_pg_dump.pl`. These are the runs and per-run checks, such as `test_schema_plus_large_objects: should not dump ...`.
I did not open the logs to find the exact error. I'm assuming the runs fail outright, because a failed run would make every check in it report as missing.

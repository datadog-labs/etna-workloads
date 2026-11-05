# Rationale
Changed hunk: src/bin/pg_dump/pg_backup_archiver.c, `_tocEntryRequired()`.
Traces to the sole fix.patch hunk, which added the COMMENT check for PUBLICATION/SUBSCRIPTION tags under --no-publications / --no-subscriptions. In the current code that check was merged into the "COMMENT on policy" block. I removed the no_publications and no_subscriptions branches from it, leaving only the policy branch. pg_restore therefore emits COMMENT ON PUBLICATION/SUBSCRIPTION even when those objects are skipped.

Oracle: 10039 of 13808 cases fail, all in src/bin/pg_dump|t/002_pg_dump.pl (e.g. the no_publications/no_subscriptions runs, and many "missing" cases from tests that abort). I did not break down the individual causes beyond that.

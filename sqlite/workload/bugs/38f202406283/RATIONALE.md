# Rationale

Fix hunk reversed: `ext/fts3/fts3.c`, `fts3SegReaderCursor()`:
`sqlite3Fts3SegReaderPending(..., isPrefix||isScan, ...)` -> `isPrefix`.
This line is unchanged from the fix in 3.54.1, so reverting it restores the
pre-fix code exactly. Without `isScan`, a full-scan segment reader (used by the
integrity check) does not include pending-terms entries, so the check fails
when run inside a transaction with uncommitted data.

The other fix hunks (SQL_SELECT_ALL_LANGID statement, FTS_CORRUPT_VTAB) were
not touched; the fts3_write.c code has since been restructured.

Oracle result: fts4check-5.1 (integrity-check inside a transaction) fails and
the run aborts (crash/assert), so 5.2-5.4 fail as well.

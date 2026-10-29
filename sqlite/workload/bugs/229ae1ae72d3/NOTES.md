Calls an fts5 auxiliary function (highlight) on "special" queries ('*', '*id', '*reads').
Clean: reports "unknown special query" / "no such cursor" errors.
Buggy: '*' is treated as a prefix match of "reads" (wrong error), and '*id' makes the
aux function run on a SPECIAL cursor, hitting assertion `pCsr->ePlan!=FTS5_PLAN_SPECIAL` (abort, exit 134).

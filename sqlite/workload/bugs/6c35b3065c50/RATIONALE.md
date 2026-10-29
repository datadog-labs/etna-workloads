# Rationale

## Changed hunk
`tree/src/pragma.c`, `PRAGMA journal_mode` handling in `sqlite3Pragma()`: removed the
block that downgrades `eMode` from `PAGER_JOURNALMODE_OFF` to `PAGER_JOURNALMODE_QUERY`
when `SQLITE_Defensive` is set.

This reverses the `src/pragma.c` hunk of the fix exactly. The code around it is unchanged
since 2019, so the hunk reverses cleanly. The `sqlite.h.in` doc hunk is documentation only
and was not touched.

## Oracle failure
`jrnlmode-1.4a` fails. With DEFENSIVE on, `PRAGMA journal_mode=off` now switches the journal
off and returns `off`. The expected result is `persist`.

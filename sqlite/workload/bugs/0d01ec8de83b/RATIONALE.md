# Rationale

Fix hunk reversed: `sqlite3Fts3Dequote()` in ext/fts3/fts3.c — the fix changed
`while( ALWAYS(z[iIn]) )` to `while( z[iIn] )`. The fix's other hunks (the
`sqlite3Fts3Always/Never` debug helpers) already exist in 3.54.1 as the
`ALWAYS`/`NEVER` macros in fts3Int.h, which assert in debug builds, so only the
loop condition needed restoring (ext/fts3/fts3.c line 475).

The ALWAYS() assumption is wrong for an unterminated quoted string
(e.g. `tokenize=simple""` gives `"` handled by the dequote of a string with no closing quote).

Oracle failures: fts3tok1-2.2 (assertion `0` failed in sqlite3Fts3Dequote, crashing the run), and
fts3tok1-2.3 (never reached due to the crash).

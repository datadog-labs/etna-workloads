# Rationale

Fix hunk: `sqlite3CreateView()` in src/build.c gained `p->tabFlags |= TF_NoVisibleRowid;`,
so views have no visible "rowid".

In 3.54.1 that line sits in a `#ifdef SQLITE_ALLOW_ROWID_IN_VIEW ... #else
p->tabFlags |= TF_NoVisibleRowid; #endif` block, with a comment. I removed the whole
block, so views are again created without TF_NoVisibleRowid. The code is equivalent to
the pre-fix `sqlite3CreateView()`, which never set the flag.

Oracle failures: trigger9-4.2 and 4.3 (`DELETE/UPDATE ... v1 WHERE rowid=...`) hit
assertion `iColumn>=0` in substExpr instead of "no such column: rowid". The misc2 and
returning1 cases that expect "no such column: rowid" on a view also fail.

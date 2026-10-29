# Rationale

Fix hunk (src/walker.c, sqlite3WalkSelectExpr): removed `assert( rc==WRC_Continue )`
after walking the window definition list in the rename-object case, since
walkWindowList may return WRC_Abort for unresolvable symbols.

In 3.54.1 the code moved to the `p->pWinDefn` block (src/walker.c, ~line 151). I
re-added `assert( rc==WRC_Continue );` after `walkWindowList(...)` and dropped the
explanatory comment the fix added. The manifest/test hunks are not implementation.

Oracle: altertab3-11.2 fails (the testfixture aborts with
`Assertion rc==WRC_Continue failed` in sqlite3WalkSelectExpr) on
ALTER TABLE ... RENAME with a trigger whose WINDOW refers to a missing table.

# Rationale

## src/walker.c, walkWindowList()
Reverses the fix's only implementation hunk, which added
`sqlite3WalkExpr(pWalker, pWin->pStart)` and `...pEnd` to the window walker.
In 3.54.1 the function has a different shape (`rc` variable, `bOneOnly`), but
the two walks are the same ones; I removed them. Window frame expressions
(PRECEDING/FOLLOWING) are again not visited by walkers, so ALTER TABLE RENAME
(renameTableSelectCb / renameTokenCheckAll) misses tokens in them.

## Oracle failure
altertab3-12.2 (ALTER TABLE t1 RENAME TO t1x on a schema whose trigger has a
WINDOW with a non-numeric expression in a frame clause) aborts with
`renameTokenCheckAll: Assertion p->p!=pPtr failed`. All other cases pass.

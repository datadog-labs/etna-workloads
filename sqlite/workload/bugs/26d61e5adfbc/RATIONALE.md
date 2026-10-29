# Rationale

Fix hunk reversed: `renameWalkWith` in src/alter.c (the only behavioural hunk; the
expr.c/sqliteInt.h hunks only export `sqlite3WithDup`, which is still used elsewhere).

In 3.54.1 the function pushed a duplicate of the WITH object onto the parser's
with-stack (`sqlite3WithDup` + `sqlite3WithPush`), ran `sqlite3SelectPrep` only
when it had pushed, and popped the copy afterwards. I restored the pre-fix
behaviour: no copy/push/pop, and `sqlite3SelectPrep` is always called on each CTE.
The existing mallocFailed check is left as is. Without the with-stack, CTEs that
reference earlier CTEs or recursive CTEs cannot be resolved during RENAME,
and already-prepared Selects are prepped again.

Oracle failures (test/altertab.test): altertab-28.4, 28.5, 29.2, 29.3, 29.4, 29.5
(RENAME TABLE leaves views with CTEs unrenamed or errors), 7 failures in total.

# Rationale

The fix made REPLACE on a NOT NULL column fall through to the ABORT check when
the DEFAULT value is itself NULL. In 3.54.1 the same guarantee comes from a
second pass over the columns in `sqlite3GenerateConstraintChecks()`
(src/insert.c): on pass 2, `b2ndPass` turns `OE_Replace` into `OE_Abort`, which
emits `OP_HaltIfNull`.

Change: removed the `b2ndPass ||` term from the `if( onError==OE_Replace )`
condition. REPLACE is now converted to ABORT only when there is no DEFAULT
(`pCol->iDflt==0`). This reverses the fix's hunk in `insert.c` that added the
re-check of the default value and the ABORT fallthrough. The pass-2 REPLACE
case just copies the NULL default again and nothing halts, as before the fix.
The `sqlite3ExprCanBeNull` hunk in the fix was whitespace only.

Oracle: `conflict-14.1` fails. `REPLACE INTO t1 DEFAULT VALUES` on
`t1(x NOT NULL DEFAULT NULL)` succeeds (got `0 {}`) instead of raising
`NOT NULL constraint failed: t1.x`.

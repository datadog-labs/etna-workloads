# Rationale

Fix: in sqlite3WhereRightJoinLoop(), a viaCoroutine term got OP_Null on its
result registers plus a new `OP_OpenPseudo` for its cursor, so OP_Column from
the sub-WHERE reads NULLs. Pre-fix, the viaCoroutine branch did only the
OP_Null and the OP_NullRow(iTabCur/iIdxCur) was in an `else` branch.

In 3.54.1 the `OP_OpenPseudo` is gone: OP_NullRow now lazily creates the
always-NULL pseudo-cursor when the cursor is not open (vdbe.c OP_NullRow), and
wherecode.c applies OP_NullRow to every term. That is the equivalent coverage.

Change (src/wherecode.c, sqlite3WhereRightJoinLoop): move the
OP_NullRow(iTabCur)/OP_NullRow(iIdxCur) emission into an `else` of
`if( pRight->fg.viaCoroutine )`, so coroutine terms get no always-NULL
pseudo-cursor, as before the fix. This removes what the fix's
OpenPseudo provided (via the NullRow path).

Oracle: values-19.9 fails with `Assertion 'pC!=0' failed` in sqlite3VdbeExec
(OP_Column on the unopened cursor); the test file aborts there.

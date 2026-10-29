# Rationale

Fix: in sqlite3GenerateConstraintChecks, a NOT NULL violation on a generated column under REPLACE
must not try to substitute the "default" (the generated expression) and must abort.

In 3.54.1 the check was restructured (two passes; generated columns on the 2nd pass). The
equivalent guard is in tree/src/insert.c, in the `onError==OE_Replace` branch:
`if( b2ndPass || pCol->iDflt==0 ) onError = OE_Abort; else assert(!isGenerated);`
Generated columns keep their expression in iDflt, so this is the equivalent of the fix's
`(colFlags & COLFLAG_GENERATED)==0` guard around the default-substitution code.

Changes (all in src/insert.c):
- Changed the condition to `(b2ndPass && !isGenerated) || iDflt==0`, so generated columns are no
  longer demoted to OE_Abort on the 2nd pass and take the OE_Replace path (pre-fix behaviour:
  default/generated expression coded into the register, then NotNull re-tested).
- Removed the `assert(!isGenerated)` / `assert(GENERATED==0)` that encoded the fixed invariant.

Oracle: gencol1-6.10 (`REPLACE INTO t0(c1) VALUES(NULL)` with `c0 NOT NULL AS(c1)`) fails with the
assertion `pOp->p1>=0 && pOp->p1<p->nCursor` in sqlite3VdbeExec (the generated expression is coded
at the wrong point) instead of returning "NOT NULL constraint failed: t0.c0".

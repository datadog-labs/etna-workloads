# Rationale

Single hunk, in `sqlite3WhereEnd()` in `src/where.c` (the DISTINCT skip-ahead block).

The fix added an `OP_IfNullRow` guard before the skip-ahead `OP_Column`/`OP_SeekGT/LT` code
when `pLevel->iLeftJoin` is set, plus a matching `sqlite3VdbeJumpHere()` after the `OP_Goto`.
Version 3.54.1 already had this code, with an added `= 0` initialiser on `addrIfNull`. I
removed the declaration, the `OP_IfNullRow` emission and the `JumpHere`. This restores the
pre-fix code: a null-row on the RHS of a LEFT JOIN gets skipped ahead using garbage NULL
column values.

## Oracle
`distinct2-6040` fails (`ANALYZE; SELECT DISTINCT * FROM t1 LEFT OUTER JOIN t0 ON c0>c1`).
Expected `1 {}`, got `1 {} 1 0`. Skip-ahead needs the stat1 data from ANALYZE, so only
the post-ANALYZE case fails.

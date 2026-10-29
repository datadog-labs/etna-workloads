# Rationale

Mechanism in 3.54.1: the pre-fix `WHERE_ORDERBY_MIN` seek-past-NULL block was
replaced by the `KEYINFO_ORDER_BIGNULL` / `WHERE_BIGNULL_SORT` design, so the
fix's hunks cannot be reversed directly. The fix's defect was: for min()
queries, seek past NULLs based on `nOBSat>0 && nKeyCol>nEq` rather than on
whether index column nEq is the actual min() expression (the
`WHERE_MIN_ORDERED` flag set in wherePathSatisfiesOrderBy).

Change (src/wherecode.c, sqlite3WhereCodeOneLoopStart): re-added the old
condition `(wctrlFlags&WHERE_ORDERBY_MIN) && nOBSat>0 && nKeyCol>nEq` ->
`bSeekPastNull=1; nExtraReg=1`. It reverses the fix's wherecode.c hunk
(WHERE_MIN_ORDERED test replaced the old condition). It is limited to loops
with no range limit and no BIGNULL_SORT so that the existing BIGNULL branch's
asserts still hold. The where.c / whereInt.h hunks (setting the flag) are
simply not reintroduced.

Effect: when the min() column is satisfied by an equality constraint
(`WHERE a=123`, `c1 ISNULL`), the next index column wrongly causes the
scan to seek past NULLs, skipping qualifying rows.

Failing oracle cases: minmax4-4.1 (got `{} {}`, expected `{} 1`) and
minmax4-5.1 (got `{}`, expected `123`).

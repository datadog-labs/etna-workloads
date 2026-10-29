# Rationale

Fix hunk reversed: `parse.y` rule `seltablist ::= stl_prefix LP seltablist RP as on_using`.
The fix changed the guard from `if( X==0 )` (discard ON/USING, return the inner list, ignoring the alias)
to `if( X==0 && Z.n==0 && N==0 && U==0 )`.

In 3.54.1 the guard is `A==0 && Z.n==0 && N.pOn==0 && N.pUsing==0`. I restored the old form:
`if( A==0 ){ sqlite3ClearOnOrUsing(pParse->db, &N); A = F; }`. The clear call is the modern equivalent of the
old `sqlite3ExprDelete`/`sqlite3IdListDelete` pair, so nothing leaks.
The `build.c` hunk (`nSrc>1` guard in SrcListAppendFromTerm) is not reverted. The ON/USING cleanup is
handled by the parser rule here.

## Oracle failures (test/tkt3935.test)
- tkt3935.3: `SELECT j1.b FROM (t1 INNER JOIN t2 ON a=c) AS j1` gives "no such column: j1.b" because the alias is dropped.
- tkt3935.5: `SELECT a FROM (t1) AS t ON b` succeeds instead of reporting "a JOIN clause is required before ON", because ON is discarded.

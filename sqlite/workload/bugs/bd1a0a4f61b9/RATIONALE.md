# Rationale

Changed only `sqlite3SrcListAppendFromTerm` in `tree/src/build.c`, reversing the fix's single implementation hunk (#3846):

1. Removed the early `if( !p && (pOn||pUsing) )` check that raised "a JOIN clause is required before ON/USING" (adapted to `OnOrUsing *pOnUsing`).
2. Restored the pre-fix behaviour that only keeps ON/USING when `p->nSrc>1`; otherwise the clause is silently discarded (`sqlite3ClearOnOrUsing`, the equivalent of the old ExprDelete/IdListDelete), instead of being attached unconditionally.

The `append_from_error` path remains since the current code already used it for other failures.

Failing oracle cases: `vtab6-3.5` (`SELECT * FROM t1 USING(a)` now returns rows instead of the error). The other new-test cases (join-3.5, tkt3935.4–10) are in the oracle lists only if present there. Only vtab6-3.5 was reported failing by check.sh.

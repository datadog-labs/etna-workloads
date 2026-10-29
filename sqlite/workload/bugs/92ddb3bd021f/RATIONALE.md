# Rationale

Fix hunk (src/select.c, substExpr): when a column reference carrying EP_FromJoin
(an ON-clause term) is replaced by the subquery's expression during flattening,
the copy gets the join flag and iRightJoinTable back.

In 3.54.1 the same step is the `sqlite3SetJoinExpr(pNew, pExpr->w.iJoin, flags & (EP_OuterON|EP_InnerON))`
call in substExpr (EP_FromJoin became EP_OuterON/EP_InnerON, iRightJoinTable became w.iJoin).
I removed that block, so the substituted expression loses its ON-clause marking, as before the fix.

Failing oracle cases: join5-5.2, 5.3, 5.4, 5.5 (the flattened `LEFT JOIN ... ON x`
with a subquery/view on the left; the ON term is treated as a WHERE term, giving wrong results).

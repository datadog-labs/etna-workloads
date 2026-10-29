# Ticket #2403 reintroduced: constant ON-clause terms of a LEFT JOIN treated as constant WHERE terms

Fix hunk (where.c): `sqlite3ExprIsConstant(pWhere)` -> `sqlite3ExprIsConstantNotJoin(pWhere)`, so a
constant term that comes from a LEFT JOIN's ON clause is NOT hoisted out of the loop nest
(where it would skip all loops instead of just NULL-extending the row).
The expr.c hunks (exprNodeIsConstant, EP_FromJoin check) only back that helper; in 3.54.1 that helper
still exists (`eCode==2`, EP_OuterON) but is used only for constant factoring, not for this hoisting.

In 3.54.1 the equivalent hoisting is the loop at the end of sqlite3WhereBegin (where.c, "pT->prereqAll==0"
-> sqlite3ExprIfFalse(..., iBreak)). ON-clause terms are kept out of it because whereexpr.c
exprAnalyze() does `prereqAll |= x` for EP_OuterON terms (x = mask of the right table), so they never
have prereqAll==0.

Change: src/whereexpr.c, exprAnalyze(): removed `prereqAll |= x;` for EP_OuterON terms. A constant ON
term (ON 0, ON 1, ON NULL) now has prereqAll==0 and is hoisted as if it were a WHERE term, the pre-fix behaviour.

Oracle result: join5.test fails — 50 of 52 cases (e.g. join5-1.2/1.4/1.5 return missing LEFT JOIN rows;
join5-2.1 hits the assert `pT->prereqAll!=0 || !ExprHasProperty(pX, EP_OuterON)` in sqlite3WhereBegin).

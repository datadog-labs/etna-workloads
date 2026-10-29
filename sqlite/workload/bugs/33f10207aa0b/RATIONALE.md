# Rationale

Fix hunk (src/where.c, sqlite3WhereBegin): added `if( pT->wtFlags & TERM_VIRTUAL ) continue;`
to the loop that codes terms with `prereqAll==0` up front, so virtual terms
(e.g. from OR-clause factoring) are not coded as if they were real constraints.

In 3.54.1 the same loop (src/where.c, ~line 7031) iterates `ii<pWC->nBase`, which
already excludes virtual terms (they are appended after nBase). I reverted that
to `ii<pWC->nTerm` with no TERM_VIRTUAL skip, which is the pre-fix behaviour:
virtual terms get coded with sqlite3ExprIfFalse and marked TERM_CODED.

Oracle failures: whereF-7.1 and whereF-7.3 (the ticket's OR-factoring queries)
return wrong results.

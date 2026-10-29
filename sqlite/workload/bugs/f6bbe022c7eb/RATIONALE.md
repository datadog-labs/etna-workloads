# Ticket #2018 reintroduced

Fix hunk (src/select.c, sqlite3SelectResolve): added `if( p->pPrior ) return sqlite3SelectResolve(pParse, p->pPrior, pOuterNC);`
so every SELECT of a compound subquery gets its names resolved.

In 3.54.1 that logic lives in `resolveSelectStep()` (src/resolve.c), which walks the compound
with `p = p->pPrior`. Changed that advance (src/resolve.c ~line 2134) to
`p = pOuterNC ? 0 : p->pPrior;`, so when resolving a subquery that has an outer name context
(e.g. a correlated EXISTS subquery) only the first SELECT is resolved and the prior arms of the
compound are left unresolved, as before the fix.

Oracle: select7-4.1 fails (assertion `p->selFlags & SF_Resolved` in selectAddSubqueryTypeInfo);
the run aborts there, so 4.2 and all later cases fail too (incomplete run). 1.1-3.1 still pass.

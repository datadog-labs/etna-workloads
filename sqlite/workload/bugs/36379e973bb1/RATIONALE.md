# Rationale

## Change: tree/src/resolve.c (resolveLookup/lookupName alias branch)

Fix hunk reversed: the `src/expr.c` hunk in `lookupName` that added the check
`if( !pNC->allowAgg && ExprHasProperty(pOrig, EP_Agg) )` raising
"misuse of aliased aggregate %s" when an AS-alias resolves to an aggregate
expression in a context where aggregates are not allowed.

In 3.54.1 the same logic lives in `sqlite3ResolveExprNames`' `lookupName()` in
`src/resolve.c`, as `(pNC->ncFlags&NC_AllowAgg)==0 && ExprHasProperty(pOrig, EP_Agg)`.
I removed that check (the `pOrig` variable stays, still used by the later checks).
Without it the alias is silently expanded into the aggregate, so nested
aggregates like `max(m+5)` where `m` aliases `min(f1)` are not detected.

## Oracle failures

`./check.sh`: select1-2.21, select1-2.22, select1-2.23 fail (expected
"misuse of aliased aggregate ..." error is no longer produced). All other
cases pass.

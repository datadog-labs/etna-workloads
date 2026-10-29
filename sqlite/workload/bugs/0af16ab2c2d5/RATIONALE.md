# Rationale

## Change: src/resolve.c, resolveOrderGroupBy()
Reverses the single implementation hunk of the fix. The fix wrapped the
`resolveAsName()` lookup (AS-name match against the result set) in
`if( zType[0]!='G' )` so GROUP BY terms never bind to output aliases first.
In 3.54.1 the same guard exists in the same loop; I removed it, so GROUP BY
terms again try result-set AS-names before input columns, as before the fix.

## Oracle failure
resolver01-5.1 (`SELECT count(*), substr(m,2,1) AS m FROM t5 GROUP BY m`)
returns `1 y 2 x` (grouped by the alias) instead of `1 x 1 x 1 y` (grouped by
input column m). All other cases still pass.

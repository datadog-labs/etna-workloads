# Rationale

## Changed hunk
`tree/src/select.c`, push-down check in `sqlite3Select()` (tag-select-0420).

Reverses the fix's only implementation hunk: the fix tightened the condition to
`eM10d!=M10d_Yes && nUse<2`, so CTEs used more than once are not pushed down into.
I restored the pre-fix condition `pItem->fg.isCte==0 || pItem->u2.pCteUse->eM10d!=M10d_Yes`,
dropping the `nUse<2` term. The surrounding code has changed since (new pushDownWhereTerms
signature), but the condition is the same expression, so this is equivalent to the old code.

## Oracle failure
`with2-13.1` fails: expected `111 222`, got an empty result. The WHERE term from
the join is pushed into the multiply-used CTE `t3`, which corrupts the shared `t2`.
All other with2 cases pass.

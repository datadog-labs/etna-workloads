# Rationale

In 3.54.1 the fix's aggregate/recursive loop no longer exists: aggregate
subqueries are pushed into (per-arm) HAVING instead of being rejected. The
equivalent defect is deciding from only one term of the compound whether the
subquery is an aggregate.

Change (src/select.c, pushDownWhereTerms): capture `isAgg` from the
first-visited term `pSubq` (the last SELECT of the compound) before the
`while( pSubq )` loop, and use it instead of the per-arm
`pSubq->selFlags & SF_Aggregate` to choose HAVING vs WHERE. This reverses the
fix hunk, which replaced a check of only the last term's selFlags with a
loop over all compound terms.

Oracle failure: select4-17.2 (aggregate arm first, non-aggregate last) now
errors with "misuse of aggregate: sum()", because the term is pushed into the
aggregate arm's WHERE rather than HAVING.

# Rationale

Fix hunk (src/func.c, groupConcatStep): `if( pAccum->nChar )` -> `if( sqlite3_aggregate_count(context)>1 )`,
so the separator is emitted based on term count rather than on whether accumulated text is non-empty.

In 3.54.1 the "is this the first term" decision is `int firstTerm = pGCC->str.mxAlloc==0;`
(src/func.c groupConcatStep). I reverted it to `pGCC->str.nChar==0`, i.e. the pre-fix
behaviour: the separator is skipped whenever the accumulated string is empty, so a leading
empty value swallows the following separator (Ticket #3806).

Oracle failures (test/func.test): func-24.8, func-24.9 (the tests added by the fix) and
func-24.12 (a later variant of the same check). E.g. group_concat of ('', 'program', ...) gives
`programisfree...`-style output without the leading comma.

# Rationale

Fix (ticket #3623): `matchQuality()` in src/callback.c decided whether a
function "exists with some other arity" (the probe used to report "wrong
number of arguments" instead of "no such function"). The fix made the probe
depend on the function having an implementation, so `coalesce()` and
`coalesce(1)` give "wrong number of arguments to function coalesce()".

In 3.54.1 the probe is `nArg==(-2)` in `matchQuality()` (src/callback.c) and
coalesce is registered with nArg=-4 ("2 or more"). The one changed line makes
the probe miss variable-minimum-arity builtins (`p->nArg<(-2)`), so
`sqlite3FindFunction(..., -2, ...)` returns 0 for coalesce and resolve.c
reports "no such function: coalesce" for too few arguments - the pre-fix
symptom the fix's tests guard against. The implementation test
(`xSFunc==0`) from the fix is retained.

Failing oracle cases: func-27.1 (`SELECT coalesce()`) and func-27.2
(`SELECT coalesce(1)`) get "no such function: coalesce" instead of
"wrong number of arguments to function coalesce()". func-27.3 still passes.

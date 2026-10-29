# Rationale

## Change: `groupConcatValue()` in tree/src/func.c
Reverses the fix hunk adding `else if( pGCC->nAccum>0 && pAccum->nChar==0 )` -> return "".
In 3.54.1 the code was restructured: `groupConcatValue` calls `sqlite3_result_str()`, which
already returns "" for a zero-length string. I restored the pre-fix behaviour by only
producing a result when `pGCC->str.nChar>0`; with nAccum>0 but nChar==0 (all inputs are
empty strings) no result is set, so the window-function value is NULL instead of ''.
This is the same observable pre-fix behaviour (sqlite3_str_value() returned NULL for an empty accumulator).

## Oracle failure
test/window1.test `window1-78.1`: `SELECT quote(group_concat(x) OVER ()) FROM (SELECT '' AS x)`
expected `''`, got `NULL`. (78.2 still passes: NULL for empty frame.)

# Rationale

All changes are in `tree/src/json.c` (json1.c's code now lives there).

1. `jsonArrayStep` / `jsonObjectStep`: `else if( pStr->nUsed>1 )` -> `else`.
   Reverses the fix's first and third hunks. A comma is again appended even when
   the accumulated string is empty (just `[` or `{`), as happens after the inverse
   removed every element, giving `[,x]`-style output.
2. `jsonGroupInverse`: removed the `nNest` counter and the `{`/`[` / `}`/`]` nesting
   tracking, so the first-element search stops at the first comma outside a string,
   even one inside a nested object or array. Reverses the second hunk's nesting part.
   The current code's `i<pStr->nUsed` bound (the replacement for the old assert) is kept.

## Oracle failures
windowB-3.5c, 3.5d, 3.7c, 3.7d fail: the window inverse on json_group_array /
json_group_object with elements containing nested commas (`{"b":2,"e":9}`) cuts the
first element at the inner comma, leaving corrupt JSON.

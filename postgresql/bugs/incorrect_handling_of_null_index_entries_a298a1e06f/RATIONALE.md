# Rationale

## Hunk: src/backend/access/nbtree/nbtpreprocesskeys.c, `_bt_mark_scankey_required()`
Traces to the nbtutils.c hunk of fix.patch (the function has since moved to nbtpreprocesskeys.c).
The original fix stopped marking subsidiary row-compare keys beyond the first as required.
Today's code instead marks later subkeys only while they are on adjacent columns with the same
sort direction. I removed those two `break` guards (attno adjacency, strategy match), so every
subsidiary key up to SK_ROW_END is again marked required. A NULL index entry in a lower-order
column (e.g. "b" in ROW(a,b) > ROW(x,y)) then ends the scan early, skipping later matches with
larger "a" — the original bug.

## Failing oracle cases
- src/test/regress||rowtypes

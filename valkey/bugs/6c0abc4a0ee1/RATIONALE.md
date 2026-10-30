# Rationale

## Changed: tree/src/sort.c (forced-ALPHA condition in sortCommand)
Reverses the single fix hunk in src/sort.c. The fix narrowed the forced-sort
condition to `dontsort && type == SET`. 9.0.7 had it as
`dontsort && type == OBJ_SET && (storekey || c->flag.script)`. I restored the
pre-fix condition `dontsort && type != OBJ_ZSET && (storekey || c->flag.script)`
(and the old comment), so lists are again treated as an unordered bag and
force-sorted ALPHA with STORE or from scripts when `BY nosort` is used.

## Oracle failures (tests/unit/sort.tcl)
- "SORT by nosort plus store retains native order for lists": got `1 2 3 4 5`, expected `5 3 4 1 2`.
- "SORT by nosort with limit returns based on original list order": got `1 2 3`, expected `5 3 4`.

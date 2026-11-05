# Rationale

## src/backend/executor/execReplication.c, tuples_equal()
Traces to the fix.patch hunks in tuple_equals_slot() (the include additions and the comparison change).
The fix replaced the binary `datumIsEqual()` comparison with a type-cache equality operator
(`lookup_type_cache(TYPECACHE_EQ_OPR_FINFO)` + `FunctionCall2`). In today's code that is `tuples_equal()`
with a per-column cache `eq[]`. I reverted the loop to `datumIsEqual(..., att->attbyval, att->attlen)`
and dropped the typentry lookup and the unused local. With REPLICA IDENTITY FULL, values that are
equal by operator but differ in binary representation (e.g. toasted/compressed or numeric
scale variants) are no longer matched, so the tuple to update/delete is not found.

## Failing oracle cases
- src/test/subscription|t/001_rep_changes.pl|update works with REPLICA IDENTITY FULL and text datums

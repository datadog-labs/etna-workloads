# Rationale

## src/backend/parser/parse_collate.c, assign_collations_walker (case T_Query)

Traces to the single hunk of fix_impl.patch. The fix added a `targetList == NIL`
early return and replaced `Assert(!tent->resjunk)` with an `if (tent->resjunk) return false`.
I removed both checks and restored the Assert. For `EXISTS (SELECT FROM ...)`, the
Query has an empty target list, so `linitial_node` is applied to NIL and the code
dereferences a NULL pointer. That is the original crash. In the same way, a resjunk
first entry now trips the Assert instead of being skipped.

## Failing oracle cases
- src/test/regress||subselect (confirmed FAIL with the oracle)

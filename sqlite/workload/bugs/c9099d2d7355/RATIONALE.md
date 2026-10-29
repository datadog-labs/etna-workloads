# Rationale

The fix commit is a merge of many unrelated changes. The part covered by the
oracle (test/join.test, join-27.* and join-28.*) is the select.c hunk that
**removes flattening restriction (29)**: that restriction had been added to fix
join-27.x wrong results, but it caused a performance regression (forum post
96b9e5709cf47cda) because queries like join-28 no longer got flattened. The
real fix was done elsewhere (constraintCompatibleWithOuterJoin, OP_NullRow).

## Change
- `src/select.c` flattenSubquery(): re-added the "Restriction (29)" block
  (verbatim from the removed hunk) right after the restriction (28) assert.
  It reverses the fix's select.c hunk at `@@ -4315,35 +4300,6 @@`. The
  SQLITE_EXTRA_IFNULLROW and comment-only hunks were not reverted.
  Result: subqueries whose right-most FROM term is an outer join, used as the
  right operand of a join with ON/USING/NATURAL, are no longer flattened.

## Not reverted
The where.c refactor (already equivalent, constraintCompatibleWithOuterJoin is
present), and OP_IfNotOpen (opcode no longer exists in 3.54.1; the expr.c
OP_NullRow line is left intact since removing it changes no oracle result).

## Oracle failure
`join-28.2` (do_eqp_test): the query plan now shows MATERIALIZE t3 plus an
AUTOMATIC COVERING INDEX instead of the flattened `SCAN t4 / SEARCH t1`.
Query results (join-27.*, join-28.1) stay correct.

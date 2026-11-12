# Re-introduced bug: explicit MARK joins admit general conjunctions

## Hunk
`src/planner/binder/tableref/plan_joinref.cpp`, `PlanMarkJoin`.
Traces to the fix's "Reject general conjunctions and arbitrary explicit MARK predicates during logical planning".
The fixed code only admits native group types, all-equality families, null-safe conditions, or a single comparison.
I relaxed it to admit any non-empty conjunction of comparisons (`all_comparisons`), so mixed forms like
`a=b AND c>d` or `p.v=c.v AND p.g IS NOT DISTINCT FROM c.g` are planned instead of rejected with
"Unsupported explicit MARK join conditions". This is the pre-fix admission behaviour.

Only this hunk was changed. The rest of the fix is not reproduced: the hash-join refinement
(mark_join_refinement.cpp, IE preparation) no longer exists in the current tree, so it could not be restored faithfully.

## Oracle results (etna-check)
```
FAIL test/sql/join/mark/explicit_conditions.test:10  Query unexpectedly succeeded! ... ON a=b AND c>d;
FAIL test/sql/join/mark/inferred_groups.test:41  Query unexpectedly succeeded! ... ON p.v=c.v AND p.g IS NOT DISTINCT FROM c.g
2 of 7 oracle units fail
```
The other five units pass. The task asks for at least one failure, and the oracle exits 0.

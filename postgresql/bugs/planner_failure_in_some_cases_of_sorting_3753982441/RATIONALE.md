# Rationale

## src/backend/optimizer/path/equivclass.c, `relation_can_be_sorted_early`
(today's name for `find_em_expr_usable_for_sorting_rel`)

Traces to the fix.patch equivclass.c hunk that rewrote
`find_em_expr_usable_for_sorting_rel`. The fix made it require an EC member that
matches a reltarget expression (`find_ec_member_matching_expr`) or is computable
from the reltarget (`find_computable_ec_member`), so it agrees with
`prepare_sort_from_pathkeys`. I restored the old logic: any non-constant,
non-volatile, non-SRF, parallel-safe EC member whose `em_relids` is a subset of
the rel's relids counts as sortable early. An EC containing an aggregate that
the scan/join target can't supply then looks sortable early. The planner builds
a sort that `prepare_sort_from_pathkeys` can't satisfy, and it fails with
"could not find pathkey item to sort" or produces a wrong plan.

The helpers (`find_ec_member_matching_expr`, `find_computable_ec_member`) are
left in place because they are still used by createplan.c.

## Oracle cases expected to fail
- src/test/regress||incremental_sort

Confirmed: oracle run reports FAIL for src/test/regress||incremental_sort (1/1 failing).

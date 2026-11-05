# Re-introducing the bug fixed by 3c90dcd03914

The bug: the relid set of a partitionwise child join was computed as
`bms_union(child rels) + add_outer_joins_to_relids(root, ..., child_sjinfo)`.
`add_outer_joins_to_relids()` checks the child relids against the
`min_lefthand`/`min_righthand` of entries in the *parent* `root->join_info_list`,
and those contain only parent relids. So when joins can be reordered under OJ
identity 3, the pushed-down OJ relids are never added for the child join. The
fix computes the child relids as `adjust_child_relids(parent_joinrel->relids, appinfos)`.

Since 2023 the code has been refactored. `build_child_join_rel()` now receives
`appinfos` from its caller, and the `child_joinrelids` variable in
`try_partitionwise_join()` was folded into the sanity Assert. Reversing
fix_impl.patch as-is therefore doesn't apply. I re-expressed it like this:

## Hunk 1: src/backend/optimizer/path/joinrels.c, `try_partitionwise_join()`
Traces to fix.patch hunk `@@ -1640,13 +1640,15 @@ try_partitionwise_join`.
- The child join relids are computed again with
  `bms_union(child_rel1->relids, child_rel2->relids)` followed by
  `add_outer_joins_to_relids(root, ..., child_sjinfo, NULL)`. This set is stored
  in `child_relids` (the current name for the old `child_joinrelids`). As
  before the fix, it is also what gets passed to `find_appinfos_by_relids`.
- The "Assert we got the right one" check now compares against this computed
  set again, not against `adjust_child_relids(joinrel->relids, ...)`.
  That `adjust_child_relids` expression is the "correct join relids"
  computation the fix introduced (`child_joinrelids = adjust_child_relids(...)`).
  A later refactoring inlined it into the Assert. Swapping it back brings
  back the pre-fix relid calculation.

What goes wrong: for `t1 LEFT JOIN t2 ON .. LEFT JOIN t3 ON t2.a = t3.a`, the
pair `t1_child + (t2 t3)_child` computes relids that lack the relid of the
second outer join. (I checked this with a debug trace: the computed set was
`(b 3 6 8 10)` when it should have been `(b 3 5 6 8 10)`.)

## Hunk 2: src/backend/optimizer/util/relnode.c, `build_child_join_rel()`
Traces to fix.patch hunk `@@ -871,10 +871,19 @@ build_child_join_rel`
(together with `@@ -935,9 +944,6 @@`, which only moved the appinfos lookup.
That lookup now lives in the caller, so nothing needed changing there).
`joinrel->relids` is set again to `bms_union(outer_rel->relids, inner_rel->relids)`
plus `add_outer_joins_to_relids(root, ..., sjinfo, NULL)`, replacing
`adjust_child_relids(parent_joinrel->relids, ...)`. If the first input pair
that builds a child join is one where identity-3 OJ relids need adding, the
child RelOptInfo gets an incomplete relid set.

## Failing oracle cases
- `src/test/regress||partition_join`: the new 3-way left-join test query hits
  `TRAP: failed Assert("bms_equal(child_joinrel->relids, child_relids)")` in
  joinrels.c (backend crash). This is the mismatch the original report hit.


<!-- produced on retry with opus -->

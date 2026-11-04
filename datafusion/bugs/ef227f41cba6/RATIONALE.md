# Rationale

Fix (#12571): grouping sets lost the distinction between a real NULL and a
column excluded from the set, because the final aggregate keyed only on the
group expressions. The fix added `__grouping_id` to the group key
(physical_planner `final_grouping_set`, `PhysicalGroupBy` changes).

In 55.2.0 the mechanism exists in full (`__grouping_id` in logical schema,
`PhysicalGroupBy::as_final`), and the fix's hunks no longer apply directly.

## Change
`datafusion/physical-plan/src/aggregates/mod.rs`, `PhysicalGroupBy::as_final`.
This reverses the physical_planner hunk that replaced the old `final_group`
construction (grouping columns only) with `initial_aggr.group_expr().as_final()`.
The final-stage key no longer contains the real grouping id. Its slot is
replaced by a constant zero literal, which keeps the partial-output column
layout so state columns still line up. Rows from different grouping sets that
agree on their (NULL-substituted) values merge again, as before the fix.

## Oracle
`group_by.slt` fails. The visible failures are the `grouping()` queries over
`duplicate_grouping_sets`: duplicate sets are merged and grouping() always
returns 0. I did not check whether the NULL-merging case
(`select a, b, count(*) ... grouping sets ((a, b), (a), (b))`) also fails.

Side effect: because the id is now constant, the output `__grouping_id`
column and `grouping()` results are also wrong. That goes beyond the original
bug and comes from keeping the column layout.

`aggregate.slt` reports a failure before and after this change (a tdigest
assertion panic in `approx_percentile_cont_with_weight`). It is unrelated.

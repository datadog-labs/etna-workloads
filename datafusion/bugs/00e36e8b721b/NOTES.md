repro.sql copies the new joins.slt test (issue #20669): t1 has 100 rows, t2 has one row, and
`count(*)` runs over a LEFT ANTI JOIN and a LEFT SEMI JOIN. The planner turns these into
RightAnti/RightSemi hash joins with an empty output schema.

The anti-join count differs. df-clean returns 99. df-buggy returns 1, because the empty-schema
batch is sized from build_indices.len() instead of probe_indices.len(). The semi-join count is
1 in both builds.

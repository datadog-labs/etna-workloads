# Rationale

File: src/backend/optimizer/util/placeholder.c, function add_placeholders_to_joinrel().

Traces to the fix_impl.patch hunk that moves the `direct_lateral_relids`
update out of the "needed above this joinrel" check. In the current code the
`bms_add_members(joinrel->direct_lateral_relids, phinfo->ph_lateral)` call sits
after the "needed" block, directly under the "computable here" check. I moved
it back inside the `bms_nonempty_difference(ph_needed, relids)` block and
dropped the explanatory comment. The code is again as before the fix.

This brings the bug back. A PHV that is computable at this join but not needed
above it no longer contributes its lateral refs to direct_lateral_relids. As a
result, join_is_legal() can reject valid join orders, and the planner can
choose different plans or fail.

Failing oracle case: src/regress||join (src/test/regress, test `join`).

# Rationale

File: src/backend/optimizer/path/joinrels.c, function join_is_legal().

Traces to the fix_impl.patch hunk in join_is_legal() that adds the check on
`min_join_parameterization()`. In current code this check sits inside the
`if (root->hasLateralRTEs)` block, and has the "join_plus_rhs" form. I removed
the whole block, along with the now-unused `join_lateral_rels` variable. The
join is therefore accepted even when its minimum LATERAL parameterization
includes rels that must be on the inside of an outer join with this join rel.
That brings back the bug: the planner builds unusable joins, and the
clauseless-join heuristics can then fail to find any plan.

The other fix hunks (the helper in relnode.c and its declaration in pathnode.h)
are left alone. Only the check that calls the helper is removed.

Failing oracle case: src/test/regress||join

# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function add_non_redundant_clauses
(the current-code equivalent of the two duplicate-detection loops in remove_self_join_rel).
Traces to fix.patch hunks that replaced `equal(rinfo->clause, src->clause)` with
`restrict_infos_logically_equal(rinfo, src)`, plus the hunk adding that helper.
Reverted: the helper is removed and the comparison is back to `equal(rinfo->clause, src->clause)`.
That comparison looks only at the clause, ignoring other RestrictInfo fields (e.g. is_pushed_down,
outer-join and security info). A qual that differs in those fields but has the same clause text is
treated as a duplicate and dropped during self-join elimination.

Failing oracle case: src/test/regress||join

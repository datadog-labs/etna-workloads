# Rationale

Only part of fix_impl.patch could be re-expressed: the rest of the patch
(commute_below_l/r, add_outer_joins_to_relids, pushed_down_joins) is still in
the current code, so I reverted a single hunk from it.

## Changed hunk
- File: src/backend/optimizer/util/relnode.c, function build_joinrel_tlist (two places: the PlaceHolderVar branch and the Var branch).
- Traces to the fix.patch hunks in build_joinrel_tlist that add `bms_is_member(sjinfo->ojrelid, relids) &&` to the condition for adding sjinfo->ojrelid to nullingrels.
- I removed that condition. A join that has been pushed down into the RHS of another outer join (identity 3) then marks its own Vars and PHVs as nulled before the join is completed. These nullingrels no longer match the Vars higher in the query tree, so the outer join clauses are placed wrongly.

## Failing oracle cases
- src/test/regress||join

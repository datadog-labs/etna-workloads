# Rationale

Changed hunk: `src/backend/optimizer/util/restrictinfo.c`, `join_clause_is_movable_into()`.

Traces to the fix.patch hunk that adds the extra "Target rel(s) must not be nullable below the clause"
test (approximate, in the safe direction) to `join_clause_is_movable_into()`. That approximation is
why the upstream fix removed the Assert in `get_joinrel_parampathinfo()`.

In REL_18_6 the `nullable_relids` field is gone and the Assert is enabled again, because the function is
now exact. I re-added an approximate test: `!bms_is_subset(currentrelids, rinfo->required_relids)`
returns false. This is stricter than the true movability rules. The Assert that every
`generate_join_implied_equalities()` clause is movable into the joinrel (`relnode.c`,
`get_joinrel_parampathinfo`) is therefore no longer safe, and it fires on join clauses
for joinrels with 3 or more rels. The Assert itself is unchanged.

Oracle failing: `src/test/regress||join`. The regression run dies earlier (create_index), so join is
reported as failed.

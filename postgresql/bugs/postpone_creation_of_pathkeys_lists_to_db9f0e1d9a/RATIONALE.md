# Rationale

Reverts the core of db9f0e1d9a4a: pathkeys (query_pathkeys etc.) are again created
*before* equivalence classes are fully built and merged, instead of being postponed.

Only the part of fix_impl.patch that still maps onto the current code is reverted. The rest
(non-canonical PathKeys, canonicalize_pathkeys, the equalfuncs ec_merged chase) has been
rewritten in current code, so I did not re-introduce it.

## Hunks
1. `src/backend/optimizer/plan/planmain.c`, `query_planner()`
   - Traces to the planmain.c hunk of fix.patch, which moved the qp_callback call to after
     EC merging; the callback is now called right before `deconstruct_jointree()`.
   - The sort/group ECs are now created before the join-clause ECs, so they miss
     correct em_nullable_relids (bug #8049), and pathkeys can go stale after EC merges.
2. `src/backend/optimizer/path/pathkeys.c`, `make_canonical_pathkey()`
   - Traces to the pathkeys.c hunks that removed the canonicalization infrastructure.
   - Removes the `ec_merging_done` "too soon to build canonical pathkeys" guard, which
     otherwise stops pathkeys from being built early.

## Failing oracle cases
- src/test/regress||join

The regress run also shows plan diffs in other tests, for example inherit and select_distinct.
They are the same breakage seen in wider tests: a sort is no longer recognized as redundant.

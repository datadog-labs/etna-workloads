# Rationale

## src/backend/optimizer/path/pathkeys.c, trim_mergeclauses_for_inner_pathkeys()
Traces to the fix.patch hunks that add `trim_mergeclauses_for_inner_pathkeys` (replacing
`find_mergeclauses_for_pathkeys(..., outer_keys=false, ...)` calls in joinpath.c).
The body is replaced with the pre-fix inner-keys logic: for each inner pathkey, collect all
mergeclauses whose inner-side EC matches and append them in inner-pathkey order, stopping at the
first pathkey with no match. The result is no longer a prefix of the outer-ordered mergeclause
list, so with overlapping mergeclauses in an outer join the trimmed clause list no longer matches the
outer ordering. Observed: the expected Merge Left Join plan in join.out (Merge Cond on
x.thousand = y.unique2) is no longer produced.

Oracle case expected to fail: src/test/regress||join

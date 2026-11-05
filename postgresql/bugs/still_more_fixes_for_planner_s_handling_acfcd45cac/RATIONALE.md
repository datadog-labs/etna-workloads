# Rationale

## src/backend/optimizer/path/joinrels.c, join_is_legal()
Traces to the fix.patch hunk `@@ -527,75 +524,126 @@ join_is_legal`. That hunk added the check that rejects a
join when its minimum lateral parameterization (`min_join_parameterization`) overlaps
rels that would sit on the inner side of an outer join with the joinrel, including
indirect ones. I removed that check and the `join_lateral_rels` variable that goes with it.
The planner now accepts joins that can never be completed. This changes plans or causes
planning failures for LATERAL queries combined with outer joins.

Only this hunk is changed. The other fix hunks are not reverted because the surrounding
code has changed substantially since the fix.

## Failing oracle cases
- src/test/regress||join

# Re-introduced bug: join removal uses syntactic relid sets instead of minimal ones

File: src/backend/optimizer/plan/analyzejoins.c. Both hunks reverse the fix's relid-set change, from min_lefthand/min_righthand back to syn_lefthand/syn_righthand.

1. `join_is_removable()` (about line 214). This traces to fix hunk 2. `inputrelids` and `joinrelids` are again built from `syn_lefthand ∪ syn_righthand`. The pushed-down-clause check (`RINFO_IS_PUSHED_DOWN`) and the needed-above-join check then use the wrong relid set.
2. `remove_leftjoinrel_from_query()` (about line 606). This traces to fix hunk 1. In the original, that code sat in `remove_useless_joins`. It has since moved into this function. `joinrelids` is again built from the syn sets, so it is inconsistent with the set used when deciding removability.

The syntactic sets can include relations that the minimal sets don't. Join removal can then be decided wrongly or processed with the wrong relid set.

Failing oracle case: src/test/regress||join

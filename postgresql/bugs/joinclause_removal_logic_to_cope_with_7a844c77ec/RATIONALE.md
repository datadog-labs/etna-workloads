# Rationale
File: src/backend/optimizer/plan/analyzejoins.c, function remove_leftjoinrel_from_query (today's equivalent of remove_rel_from_query).
Traces to the fix.patch hunk that adds join_plus_commute (union of joinrelids, commute_above_r, commute_below_l) and uses it in RINFO_IS_PUSHED_DOWN.
Change: removed join_plus_commute computation; the test uses plain joinrelids again. Cloned quals (with extra OJ relids) are no longer recognised as pushed-down, so they are kept/re-distributed instead of dropped, referencing the removed join.

Failing oracle case: src/test/regress||join (see results below)

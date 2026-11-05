# Rationale
File: src/backend/optimizer/plan/planner.c, function make_sort_input_target.
Traces to the fix hunk computing `postpone_srfs = (have_srf && !have_srf_sortcols);`.
Reverted to `postpone_srfs = have_srf;`, so SRFs are postponed even when other SRFs sit in
sortgroupref (ORDER BY) columns. The SRFs are then split across plan steps and no longer run in
sync, giving wrong output. The other fix hunks are left in place; they become inert.

Failing oracle case: src/test/regress||limit

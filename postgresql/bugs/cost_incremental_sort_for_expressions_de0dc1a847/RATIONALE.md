# Rationale

File: src/backend/optimizer/path/costsize.c, function cost_incremental_sort.

Traces to the fix.patch hunks that add the "varno 0" handling. I removed the `unknown_varno` flag and the `bms_is_member(0, pull_varnos(...))` check in the pathkey loop. `estimate_num_groups` is now always called on the presorted expressions.
Expressions containing Vars with varno 0 (from generate_append_tlist, in set operations) reach `estimate_num_groups` again, which fails for them.
I left the `input_groups` default assignment and the explanatory comment in place. They are harmless once the check is gone.

Failing oracle case: src/test/regress||incremental_sort

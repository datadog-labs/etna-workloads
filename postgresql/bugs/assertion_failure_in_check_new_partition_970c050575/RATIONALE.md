# Rationale

File: src/backend/partitioning/partbounds.c, function check_new_partition_bound() (range case). Both hunks trace to the check_new_partition_bound hunks in fix.patch.

1. Lower-bound overlap branch (after partition_range_bsearch): the fix replaced `Assert(cmpval >= 0)` and `cmpval - 1` with `Abs(cmpval) - 1`. The change restores `Assert(cmpval >= 0)` and `list_nth(..., cmpval - 1)`. partition_range_bsearch() can return a negative cmpval, so the assertion fails (without assertions, list_nth gets a bad index).
2. Empty-range check: the fix changed `if (cmpval >= 0)` to `Assert(cmpval != 0); if (cmpval > 0)`. The change restores `if (cmpval >= 0)`.

Failing oracle case: src/test/regress||create_table

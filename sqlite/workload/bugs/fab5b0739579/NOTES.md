Reproducer (`repro.sql`): runs json_group_array / json_group_object as window functions
(ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING, and a FILTER variant) over rows whose JSON
values contain several keys (`{"a":1,"e":9}`).

The bug is in the aggregates' inverse function, which stops at the first comma even
when it is nested inside `{}`/`[]`. The buggy shell therefore returns corrupted
output such as `["e":9},{"b":2,"e":9},...]` and rows that should have dropped
an element keep or lose the wrong data. The clean shell returns well-formed results.

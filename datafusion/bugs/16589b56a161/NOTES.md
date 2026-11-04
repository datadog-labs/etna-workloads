repro.sql runs NTH_VALUE(x, NULL) OVER (PARTITION BY ... ORDER BY ...) (the query from the fix's slt test) plus NTH_VALUE(x, 0).
Clean: all-NULL results, exit 0. Buggy: panics ('attempt to subtract with overflow' in nth_value.rs), exit 101.

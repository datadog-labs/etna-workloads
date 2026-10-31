repro.py feeds HeatmapCollector three samples of `my_func` at lines 12, 15, 10 (called from caller.py:100),
registers caller.py in file_index, and prints `_build_navigation_buttons('mod.py', 15)` for an interior line.
Clean: prints the caller (▲) button HTML ("Go to caller: caller (3 samples)").
Buggy: callers are looked up by the line itself rather than the function's definition line, so it prints an empty string.

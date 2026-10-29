`repro.sql` uses `sha3_agg()`, which is a built-in aggregate with no window support (no xValue), as a window function.
Clean: `Parse error: sha3_agg() may not be used as a window function`.
Buggy: the check is skipped for aggregates, so it fails the assertion `pFunc->xValue!=0` in sqlite3VdbeMemAggValue. Without assert() it would segfault.

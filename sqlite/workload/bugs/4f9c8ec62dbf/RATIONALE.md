# Rationale

Changed `src/pcache.c`, `sqlite3PcacheSetSpillsize()`: for a negative (KiB) argument the
page count is computed from `p->szCache` (the cache_size) instead of `mxPage` (the requested
spill size). This reverses the fix's pcache.c hunk. The pragma.c hunks (`size` default of 1,
`setAllPagerFlags`) are already present in 3.54.1 and were left alone.

Effect: `PRAGMA cache_spill(-51)` uses the cache_size (2 pages) rather than -51 KiB.

Failing oracle case: pragma2-5.3 (expected 3, got 2). The test does not fail on
pragma2-4.5.4 because there the unchanged path still yields a small spill size.

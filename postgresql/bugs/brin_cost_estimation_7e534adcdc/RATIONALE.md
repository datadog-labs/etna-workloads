# Rationale

## src/backend/utils/adt/selfuncs.c, brincostestimate()
Traces to the selfuncs.c hunk of fix.patch (reversed). The fix made BRIN costing use index stats
(`brinGetStats`: pagesPerRange, revmapNumPages), index correlation from pg_statistic, an estimated
range-based selectivity, a revmap-only startup cost, and a per-range bitmap charge. I restored the
old logic: startup = seq_page_cost * all index pages, total = random_page_cost * all pages,
selectivity = plain clauselist_selectivity, correlation fixed at 1, and a per-tuple cpu charge.
Plans and costs for BRIN scans therefore change, which the brin regression test notices.
The brinGetStats/BrinStatsData additions are left in place (still used elsewhere); they are
harmless, and only the cost estimator is reverted.

## Failing oracle cases
- src/test/regress||brin

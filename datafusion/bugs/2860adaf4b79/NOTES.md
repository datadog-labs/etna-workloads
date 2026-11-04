Reproducer: EXPLAIN of the union.slt query (UNION ALL of an aggregate, a constant and a window, with LIMIT 3), 4 partitions, indent format.

Clean build keeps `GlobalLimitExec: skip=0, fetch=3` above the Final aggregate and the BoundedWindowAggExec inside the union branches. The buggy build drops them, because `satisfied` is not reset after a nested limit is removed.

The difference is only in the physical plan. I did not find a SQL query whose results differ (the limit.slt query returned the same rows on both builds).

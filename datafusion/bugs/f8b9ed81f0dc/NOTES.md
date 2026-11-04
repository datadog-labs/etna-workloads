repro.sql builds small tables with groups whose MIN/MAX input is all NULL (and a NULL group key),
then runs `GROUP BY ... ORDER BY max/min(...) LIMIT n` queries, plus an EXPLAIN.

Clean: all groups are returned, with NULL aggregates where appropriate (e.g. a/b -> NULL).
Buggy: TopK aggregation pushdown drops groups whose aggregate is all NULL, so rows are missing
from the results. The nullable MIN/MAX NULLS FIRST case is also pushed down (`limit: 2` on the
AggregateExec in EXPLAIN), which the clean build does not do.

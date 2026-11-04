`repro.sql` creates a nullable varchar table and runs `SELECT DISTINCT v ... ORDER BY v ... LIMIT n` (NULLS FIRST/LAST, ASC/DESC) with 4 partitions and TopK aggregation enabled.
Clean build keeps the NULL group (e.g. `NULL` first for NULLS FIRST LIMIT 1). Buggy build drops NULL groups: it returns the empty string instead of NULL and omits NULL from the full result.

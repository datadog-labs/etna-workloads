# Rationale

File/function: src/backend/catalog/system_views.sql, view pg_statio_all_tables.
Traces to the single fix.patch hunk in system_views.sql.

The current code uses LATERAL subqueries for per-table index sums. I restored the
pre-fix shape: plain LEFT JOINs of pg_index I and pg_index X, sum() aggregates, and
GROUP BY C.oid, N.nspname, C.relname, T.oid, X.indrelid. The toast-index join
multiplies with the table-index join, so tidx_blks_read/hit are multiplied by the
number of indexes on the table (and idx_* by the number of toast indexes).
The fix removed this grouping error.

Oracle case expected to fail: src/test/regress||rules (the pg_statio_all_tables view definition differs).

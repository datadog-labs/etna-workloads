# Rationale
File: src/backend/catalog/system_views.sql, view pg_statio_all_tables.
Traces to the system_views.sql hunk of fix.patch. I reverted the LATERAL subqueries to the old direct
LEFT JOINs on pg_index (I and X) with GROUP BY C.oid, N.nspname, C.relname, T.oid, X.indexrelid.
A table whose TOAST table has several indexes now gets one output row per TOAST index (duplicate rows),
and the idx_blks sums are computed per group instead of per table.
(The catversion hunk is not reverted.)

Failing oracle case: src/test/regress||rules

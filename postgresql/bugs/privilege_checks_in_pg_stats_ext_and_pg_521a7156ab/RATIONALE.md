# Rationale

File: src/backend/catalog/system_views.sql (views pg_stats_ext and pg_stats_ext_exprs). Both hunks trace to the system_views.sql hunks of fix_impl.patch. The catversion hunk was not reverted.

1. pg_stats_ext: the `WHERE pg_has_role(c.relowner, 'USAGE')` clause is put back to the old per-column `NOT EXISTS (... has_column_privilege(...))` check. That check covers only the plain columns in stxkeys, so expression statistics are exposed to users who cannot read the table.
2. pg_stats_ext_exprs: the `WHERE pg_has_role(...) AND (relrowsecurity = false OR NOT row_security_active(...))` clause is removed. The view then applies no privilege or RLS filtering.

Failing oracle cases: src/test/regress||rules, src/test/regress||stats_ext

# Rationale

Changed hunk: `src/backend/catalog/system_views.sql`, view `pg_stats`.
Traces to the fix_impl.patch hunk that adds `AND (c.relrowsecurity = false OR NOT row_security_active(c.oid))` to the view's WHERE clause. I removed that condition from `pg_stats`, so the view once more exposes statistics (most common values, histograms) for tables with active RLS. That is the information leak the fix closed.

In today's code the `security_barrier` option on `pg_stats` was already present, and I left it alone. The other views that use the same filter (`pg_stats_ext` and similar) are unchanged.

Oracle cases that fail: `src/test/regress||rowsecurity` and `src/test/regress||rules`. The rules test fails because the dumped `pg_stats` definition no longer matches. I did not open the diff files to confirm why rowsecurity fails.

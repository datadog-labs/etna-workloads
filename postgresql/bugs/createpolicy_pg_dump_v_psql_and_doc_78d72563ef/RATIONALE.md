# Rationale

Changed hunk: `src/backend/catalog/system_views.sql`, view `pg_policies`.
Traces to the `system_views.sql` hunks of fix_impl.patch. The fix added `schemaname` (JOIN pg_class/pg_namespace), put `tablename` second, and removed `ORDER BY 1`.
The reverted version removes `schemaname` and the joins, restores `policyname` as the first column, computes `tablename` with a scalar subselect, and restores `ORDER BY 1`.
The view's columns and definition therefore differ from what is expected, and policies from different schemas can't be told apart.

The other fix hunks (policy.c namein, pg_dump -v messages, psql describe) were not reverted. Those code paths have since changed, and the oracle only covers the view.

Failing oracle case: `src/test/regress||rules`

# properly_transform_qualified_columns_rename_93331f2344

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 93331f234498fe367e3c8b82bfd62dc5b261602d ("Properly transform qualified columns in rename/exclude"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/projection/select_star_exclude.test
- test/sql/projection/select_star_rename.test

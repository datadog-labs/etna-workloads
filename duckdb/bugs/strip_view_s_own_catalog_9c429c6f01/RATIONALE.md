# strip_view_s_own_catalog_9c429c6f01

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9c429c6f016c9de43a33701db1523db7132303d6 ("Strip the view's own catalog qualifier from stored view queries"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/view/view_catalog_alias.test

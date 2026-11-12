# show_scan_count_secure_views_f65c6829fb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f65c6829fb384471bd4ea64e3d03c6001d06ea1b ("Show scan count of secure views in explain analyze"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/secure_view_explain.test
- test/sql/optimizer/secure_view_pushdown.test

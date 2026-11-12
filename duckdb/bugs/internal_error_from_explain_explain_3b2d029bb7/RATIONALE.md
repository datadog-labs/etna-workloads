# internal_error_from_explain_explain_3b2d029bb7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3b2d029bb755a3449876515368060389dfc6c54e ("Fix INTERNAL error from EXPLAIN (FORMAT) and EXPLAIN (FORMAT default)"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/explain/explain_formats.test

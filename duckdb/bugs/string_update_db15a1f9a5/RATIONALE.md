# string_update_db15a1f9a5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit db15a1f9a5e6d30d78a8db930eac124a3253ac19 ("Fix string update"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/update/string_update_null_heap.test

# bug_98bb3e2f4a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 98bb3e2f4a3b0aa53e9d5b5741be37aaee3ee9f4 ("Fix"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pushdown/table_filter_pushdown.test

# ci_f76106e5d6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f76106e5d6ce899dd3a03bc425da14d5a83eb595 ("CI fixes"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/barrier_row_group_pruning.test

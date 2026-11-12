# reverse_order_reverting_failed_commits_a1a07a9be1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a1a07a9be18c6caa5382d120ef48202c8c0961bb ("Fix reverse order when reverting failed commits"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/transactions/commit_revert_failure.test

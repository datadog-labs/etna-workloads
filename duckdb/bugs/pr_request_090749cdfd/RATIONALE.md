# pr_request_090749cdfd

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 090749cdfd877b6df608f4d7320e5acbf22b3aa4 ("PR request"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/auto/test_normalize_names.test

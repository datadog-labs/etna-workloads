# check_size_strptime_cf3e790c5e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cf3e790c5e7e0934ffdc4b8382aa574078162204 ("Check size for strptime"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/timestamp/test_strptime.test

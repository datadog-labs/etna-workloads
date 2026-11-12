# don_t_pullup_through_distinct_7a4b519a85

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7a4b519a85baf3ca9e839fc56fb5048667ae7f01 ("don't pullup through DISTINCT ON"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_19327.test

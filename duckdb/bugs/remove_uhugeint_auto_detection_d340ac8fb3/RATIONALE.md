# remove_uhugeint_auto_detection_d340ac8fb3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d340ac8fb30c95d1c6288c8eb8dbc8a3bffb76c0 ("remove UHUGEINT auto detection"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/auto/test_large_integer_detection.test

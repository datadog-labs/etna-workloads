# glob_handling_trailing_hyphens_9bd4dd1509

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9bd4dd150912a05e3de5d69fbbe3b3be4d8257d1 ("Fix GLOB handling of trailing hyphens"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/string/test_glob.test

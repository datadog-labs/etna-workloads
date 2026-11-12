# between_7f8c192ac2

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7f8c192ac2d8b81bc3f4ff3e397199d4493a2aa4 ("Fix BETWEEN"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/generic/test_between.test

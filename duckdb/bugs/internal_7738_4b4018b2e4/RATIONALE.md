# internal_7738_4b4018b2e4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4b4018b2e486a8f9f0b09a785d2358cdbfa3be5b ("fix internal issue 7738"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/internal/test_7738.test

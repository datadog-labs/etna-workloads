# refactor_ensure_we_can_still_3a94fc1950

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3a94fc195056db20d30e952142d266d926a04344 ("refactor: ensure we can still use fsspec with ATTACH"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/attach/attach_fsspec.test

# report_progress_update_delete_returning_5d36b913ed

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5d36b913ed0cf8f6529be264d10c0e079f89e4a5 ("Report progress for update and delete with returning"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/progress/test_verify_progress.test

# keep_accepting_legacy_boolean_spellings_9ca3f7b56f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9ca3f7b56f2a0dc5d6f074b81496b3ed0bf6450f ("Keep accepting legacy BOOLEAN spellings for preserve_identifier_case"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/settings/setting_preserve_identifier_case.test

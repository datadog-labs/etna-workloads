# temporary_file_truncation_5beb1c926c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5beb1c926c219279e1c0a6a58943e2e97cfd0461 ("Fix temporary file truncation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/temp_directory/temp_file_truncation.test

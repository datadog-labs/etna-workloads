# temporary_file_spill_a54875d36c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a54875d36c0d48278a7045a72265cfd939ab9bdd ("Fix temporary file spill"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/temp_directory/offload_failure_accounting.test

# lost_logs_after_truncate_duckdb_ed0d34409e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ed0d34409ebe1dbf4323ff60c7823a2c2cfea628 ("Fix the issue of lost LOGs after truncate duckdb_logs"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/logging/logging_memory_after_truncate.test

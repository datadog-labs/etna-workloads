# assertion_failure_non_overwriting_existing_31cc651799

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 31cc6517992bee4e652124c1da934ec2d4b4d836 ("Fix assertion failure for non-overwriting existing parquet directory when FILE_SIZE_BYTES involved"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/file_size_bytes_existing_target.test

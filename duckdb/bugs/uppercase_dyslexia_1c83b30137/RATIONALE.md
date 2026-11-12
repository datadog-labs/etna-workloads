# uppercase_dyslexia_1c83b30137

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1c83b3013755137c5cd99c0e15ce7f8d352f9c6e ("Uppercase dyslexia"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/code_cov/csv_dialect_detection.test
- test/sql/copy/csv/null_padding_big.test
- test/sql/copy/csv/test_copy.test
- test/sql/copy/csv/test_copy_null.test
- test/sql/copy/csv/test_ignore_errors.test
- test/sql/copy/csv/test_ignore_errors_end_of_chunk.test
- test/sql/copy/csv/test_sniff_csv_options.test

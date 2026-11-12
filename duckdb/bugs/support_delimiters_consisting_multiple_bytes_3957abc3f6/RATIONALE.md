# support_delimiters_consisting_multiple_bytes_3957abc3f6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3957abc3f6c0aae62aa9721ba3270037ed2b5305 ("Support delimiters consisting of multiple bytes, and non-ASCII delimiter, quote and comment characters in COPY TO CSV"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_copy_csv_multibyte_delimiter.test

# incorrect_utf8_after_truncation_79db3c3548

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 79db3c354867fd6fefa0752a0d2d4b959caefcfe ("Fix for incorrect UTF8 after truncation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/rejects/csv_rejects_truncate_line_invalid_utf8.test

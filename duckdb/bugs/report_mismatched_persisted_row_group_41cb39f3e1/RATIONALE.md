# report_mismatched_persisted_row_group_41cb39f3e1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 41cb39f3e10ece21364a7d5e8723a10fdeadd70b ("Report mismatched persisted row group counts as corruption"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/corrupt/row_group_count_mismatch.test

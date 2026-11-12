# add_handling_also_copy_format_07118d0023

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 07118d00232f93b3bb8d38c593930c82a2a08308 ("Add handling also for COPY TO FORMAT 'XXX'"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/statement_tostring_roundtrip.test

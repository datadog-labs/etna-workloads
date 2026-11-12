# batch_oss_fuzz_findings_parser_03d48cc9dc

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 03d48cc9dc348d648647c5d30f8a005b7dfac522 ("Fix a batch of oss-fuzz findings in the parser, binder, cast and join order optimizer"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/nested_join_backtracking.test
- test/sql/show_select/show_settings.test
- test/sql/types/decimal/decimal_zero_to_float.test

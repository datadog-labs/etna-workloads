# fixing_csv_fuzzer_issues_f017e443d4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f017e443d43b580a9e029dcc9fb69f3d9e8203df ("Fixing CSV Fuzzer issues"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/afl/test_fuzz_5194.test

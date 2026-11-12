# utc_nn00_cannot_be_parsed_9102b009a0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9102b009a0d7ffa74c82d3a2d3b6f7b499183bba ("Fix UTC±NN00 cannot be parsed in SQL"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/timezone/test_icu_timezone.test

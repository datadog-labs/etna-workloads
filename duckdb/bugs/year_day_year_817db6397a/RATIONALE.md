# year_day_year_817db6397a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 817db6397aa4f1cd798cc05b0b34b57a6789b768 ("Issue #14618: Year Day Year"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/timestamp/test_strptime.test

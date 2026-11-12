# internal_iso_year_week_bd4d427c1c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bd4d427c1ca6df975abea4fd1fe0f603d5f1b586 ("Internal #4347: ISO Year Week"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/timestamp/test_strptime.test
- test/sql/function/timestamp/test_try_strptime.test

# but_need_better_test_3c772672be

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3c772672be2d97336fed72a54018ef1559655e79 ("fix, but need a better test"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/joins/asof_join_adds_rows.test

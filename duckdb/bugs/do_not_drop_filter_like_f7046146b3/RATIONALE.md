# do_not_drop_filter_like_f7046146b3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f7046146b3b803a37e341ac0d73e2057cf112bf0 ("Fix #26433: Do not drop filter when LIKE/ILIKE pattern is NULL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/filter/test_like_null.test

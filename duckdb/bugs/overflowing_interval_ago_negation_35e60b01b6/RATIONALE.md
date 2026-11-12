# overflowing_interval_ago_negation_35e60b01b6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 35e60b01b6bc2df6a6b4be2f4e2c8c8cf7ea38b3 ("Fix overflowing interval ago negation"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/interval/interval_try_cast.test
- test/sql/types/interval/test_interval.test

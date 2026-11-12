# bug_e97ae51e12

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e97ae51e1256da9b99f3d1a70d454f82e356deb7 ("Fix #24794"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/order/top_n_limit_zero.test

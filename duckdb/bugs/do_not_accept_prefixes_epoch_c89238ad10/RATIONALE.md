# do_not_accept_prefixes_epoch_c89238ad10

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c89238ad109151a9f32e45c4d402f89f88e6a70d ("Do not accept prefixes of "epoch" and "infinity" for date/timestamp cast"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/timestamp/test_infinite_time.test

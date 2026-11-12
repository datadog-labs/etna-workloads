# bug_cea927552c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cea927552ca701b2379c442dcbb029d080f2b89a ("fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/alter/add_pk/test_add_pk_wal_generated.test

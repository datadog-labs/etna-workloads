# deadlock_between_checkpoint_binding_indexes_033d086418

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 033d086418086df2d1404c4c09f52c98c36b261d ("Fix deadlock between CHECKPOINT binding indexes and FORCE CHECKPOINT"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parallelism/interquery/concurrent_force_checkpoint_unbound_index.test_slow

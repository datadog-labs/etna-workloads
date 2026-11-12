# old_transition_table_recomputation_interdependent_16492dcf91

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 16492dcf9132b3316a0b1671d4e60d300789d48e ("Fix OLD transition table recomputation of interdependent generated columns"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/trigger/trigger_after_update_old_new.test

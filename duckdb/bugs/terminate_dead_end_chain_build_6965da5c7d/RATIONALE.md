# terminate_dead_end_chain_build_6965da5c7d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6965da5c7d865085be8960f876e7f23be5dde0a5 ("Terminate the dead end chain when the build side uses dictionary emission"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/inner/right_semi_dict_emission_dead_end.test

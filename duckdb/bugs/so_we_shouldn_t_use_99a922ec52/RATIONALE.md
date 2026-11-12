# so_we_shouldn_t_use_99a922ec52

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 99a922ec52345261ad178449d0e86b833ee1f546 ("fix #19984 so we shouldn't use outer table distinct info"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/join_elimination.test

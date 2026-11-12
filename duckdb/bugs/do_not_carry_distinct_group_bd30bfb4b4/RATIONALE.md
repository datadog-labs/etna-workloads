# do_not_carry_distinct_group_bd30bfb4b4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bd30bfb4b439dc6d864e33fcf490b4597977e453 ("Do not carry a distinct group across UNNEST in join_elimination"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/join_elimination.test

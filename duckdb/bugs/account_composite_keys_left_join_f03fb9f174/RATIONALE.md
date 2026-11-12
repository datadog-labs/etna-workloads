# account_composite_keys_left_join_f03fb9f174

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f03fb9f174110c02b2138ab10e5a54f6720cff4f ("Account for composite keys in LEFT join cardinality estimates"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/joins/left_join_reordering/left_join_composite_domain.test

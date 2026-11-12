# enable_pruning_through_floating_identities_a0b7c44e24

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a0b7c44e246043fd52f133543e816355d3e89760 ("Enable pruning through floating identities"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/bloom_filters.test
- test/sql/optimizer/expression/test_float_identity.test

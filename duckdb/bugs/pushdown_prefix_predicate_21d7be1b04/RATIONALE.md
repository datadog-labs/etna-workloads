# pushdown_prefix_predicate_21d7be1b04

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 21d7be1b04be81836e9fe983d81e0e8f794c587f ("Pushdown prefix predicate"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pushdown/starts_with_pushdown.test

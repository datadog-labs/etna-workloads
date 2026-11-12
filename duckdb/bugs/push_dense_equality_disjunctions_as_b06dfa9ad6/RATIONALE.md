# push_dense_equality_disjunctions_as_b06dfa9ad6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b06dfa9ad6e58ea68506359c094586b0d1d3ca16 ("Push dense equality disjunctions as exact scan ranges"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/plan/dense_or_filter_pushdown.test

# allow_one_sided_eager_aggregation_77c38354c6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 77c38354c6a94ae8541a779ffbdc352018989807 ("allow one-sided eager aggregation through LEFT/RIGHT"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/partial_aggregate_pushdown.test

# keep_fallible_predicates_below_projections_298f22cd7c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 298f22cd7c18b964e33434fbd6996dfcf2a10966 ("Keep fallible predicates below projections during filter pullup"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pullup_join_expression_semantics.test

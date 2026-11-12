# join_order_reconstruction_cross_products_ea9c771c46

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ea9c771c46fe819a2d5c603b6a8684335ceaeecb ("Fix join order reconstruction for cross products spanning 3+ relations"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/joins/single_sided_predicate_reconstruction.test

# create_logicalaggregate_even_if_we_56f6ef050f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 56f6ef050f4aec0828dfed09f495552a25663a40 ("create a LogicalAggregate even if we only have a having clause, without a groupby"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/aggregate/having/having_without_groupby.test

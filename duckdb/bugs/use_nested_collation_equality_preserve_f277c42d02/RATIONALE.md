# use_nested_collation_equality_preserve_f277c42d02

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f277c42d021ac4d701b4a2005188c62a3f4a1d58 ("Use nested collation equality and preserve bound DISTINCT keys"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/collate/collate_distinct_aggregate.test
- test/sql/collate/collate_distinct_aggregate_icu.test

# compare_nested_children_distinct_semantics_89b3888759

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 89b38887590e1ba4ad2276d4ba83a3da3321e321 ("Compare nested children with distinct semantics for = and <>"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/nested/list/nested_comparison_null_children.test

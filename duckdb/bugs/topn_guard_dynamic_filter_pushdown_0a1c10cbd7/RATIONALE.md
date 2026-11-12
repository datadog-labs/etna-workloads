# topn_guard_dynamic_filter_pushdown_0a1c10cbd7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0a1c10cbd7b2cdb20651b67c3ea3890c54948d37 ("topn: guard dynamic filter pushdown against type-changing casts"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/topn/topn_dynamic_filter_cast.test

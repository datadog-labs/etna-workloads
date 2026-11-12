# cast_size_array_list_unnest_346d26c0ce

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 346d26c0ce6603b81e48ce38041479a5a99a15a8 ("Cast a fixed-size ARRAY to LIST when the unnest rewriter builds a LogicalUnnest"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/nested/array/array_lateral_unnest.test

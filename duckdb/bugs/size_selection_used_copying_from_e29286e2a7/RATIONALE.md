# size_selection_used_copying_from_e29286e2a7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e29286e2a7da8ce3533822f2fc0f43744b6aa0c0 ("Size the selection used when copying from a constant or dictionary vector to cover the source offset"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/test_copy_constant_vector_offset.test

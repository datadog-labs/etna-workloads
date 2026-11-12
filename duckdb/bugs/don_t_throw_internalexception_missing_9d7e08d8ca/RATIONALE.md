# don_t_throw_internalexception_missing_9d7e08d8ca

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9d7e08d8ca6620d0238f8e50b97e35d39015439b ("don't throw an InternalException for missing default, default should be optional because it doesn't make sense in all cases (i.e map keys)"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_multi_file_column_mapper.cpp::Field-id mapping requires a match or an explicit default

# arrow_size_extension_storage_vector_cbbbe06223

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cbbbe06223a812d7bdcc92cb420a1f3b5c656481 ("arrow: size the extension storage vector for nested children"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_roundtrip.cpp::Test Arrow VARIANT roundtrip

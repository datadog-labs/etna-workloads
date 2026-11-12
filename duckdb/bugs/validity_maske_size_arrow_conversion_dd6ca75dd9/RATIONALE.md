# validity_maske_size_arrow_conversion_dd6ca75dd9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit dd6ca75dd968aaefb3e6fe2be3063439c3e759ab ("Fix validity maske size for arrow conversion"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_dict_nested_offset.cpp::Arrow scan of LIST(STRUCT(dict int32)) with nonzero leading child offset
- cpp:test/arrow/arrow_dict_nested_offset.cpp::Arrow scan of LIST(dict int32) across chunks with leading offset
- cpp:test/arrow/arrow_dict_nested_offset.cpp::Arrow scan of LIST(dict int32) with more child slots than rows per chunk
- cpp:test/arrow/arrow_dict_nested_offset.cpp::Arrow scan of LIST(dict int32) with nonzero leading child offset
- cpp:test/arrow/arrow_dict_nested_offset.cpp::Arrow scan of fixed-size ARRAY(dict int32) with nonzero array offset

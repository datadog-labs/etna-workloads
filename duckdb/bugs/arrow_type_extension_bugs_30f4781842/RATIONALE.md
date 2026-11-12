# arrow_type_extension_bugs_30f4781842

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 30f4781842486dadfe281b8d5d786658b5a32054 ("Fix arrow type extension bugs"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_output_version_buffers.cpp::BIT lossless arrow_output_version buffer consistency
- cpp:test/arrow/arrow_output_version_buffers.cpp::BIT lossless arrow_output_version roundtrip
- cpp:test/arrow/arrow_output_version_buffers.cpp::ENUM string_view arrow_output_version buffer consistency
- cpp:test/arrow/arrow_output_version_buffers.cpp::GEOMETRY arrow_output_version buffer consistency
- cpp:test/arrow/arrow_output_version_buffers.cpp::GEOMETRY arrow_output_version roundtrip
- cpp:test/arrow/arrow_output_version_buffers.cpp::UUID string_view arrow_output_version export is regular string
- cpp:test/arrow/arrow_output_version_buffers.cpp::VARINT arrow_output_version buffer consistency
- cpp:test/arrow/arrow_output_version_buffers.cpp::VARINT arrow_output_version roundtrip

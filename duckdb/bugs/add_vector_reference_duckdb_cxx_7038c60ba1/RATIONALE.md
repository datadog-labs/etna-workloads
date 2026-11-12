# Rationale
Hunk: src/src/main/capi/v2/capi_v2_vector.cpp, duckdb_v2_vector_reference. Reverts the fix's hunk: removed the logical-type equality check
(InvalidInputException) so the call goes straight to Vector::Reference, which reports a mismatch as an INTERNAL error / doesn't return INPUT_INVALID.
(The header doc hunk was not changed; only implementation files are editable.)

Result: 1 of 42 oracle units fail:
FAIL     cpp:test/api/capi/v2/test_capi_v2_vector_write.cpp::V2: vector_reference rejects a type mismatch

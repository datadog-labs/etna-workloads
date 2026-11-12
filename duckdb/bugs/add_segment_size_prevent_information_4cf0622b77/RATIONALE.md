# Rationale

In today's code the fix's field is named `byte_size` on DataPointer (reader uses `GetDataSize()` on the segment), and most of the fix's plumbing exists. I re-introduced the bug by undoing the serialization hunk.

## Hunk changed
- `src/storage/serialization/serialize_storage.cpp`, `DataPointer::Serialize`: removed the
  `if (serializer.ShouldSerialize(StorageVersion::V2_0_0)) { WritePropertyWithDefault<optional<uint32_t>>(106, "byte_size", byte_size); }` block.
  This traces to the fix's hunk in the same function that added that write. Without it the segment byte size is never persisted, so reloaded segments lack a size and readers fall back to the legacy "remaining block bytes" bound, which allows the information leak the fix addressed.

## Oracle result (etna-check)
```
PASS     Test default values
PASS     Test deleted values
FAIL     Test DataPointer byte size storage version compatibility
         serialization_test.cpp:291 :: current.byte_size == pointer.byte_size {?} == {?}
PASS     Test window expression type survives serialization
1 of 4 oracle units fail
```
Only 1 of the 4 listed units fails. The other three passed with this change, so they apparently do not depend on the DataPointer byte_size serialization.

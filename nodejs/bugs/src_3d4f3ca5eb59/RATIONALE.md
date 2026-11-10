# Re-introduced bug: revoke_data_object aborts on unknown UUID

**Bug:** `URL.revokeObjectURL(id)` on an id that is not registered (e.g. revoking twice) hits a
`CHECK` in `BlobBindingData::revoke_data_object` and aborts the process, instead of doing nothing.

**Hunk (src/node_blob.cc, `BlobBindingData::revoke_data_object`):** corresponds to the fix's single
implementation hunk. The fix replaced `CHECK_NE(find(uuid), end())` with an early `return` when the
uuid is absent. Today's code uses `contains()`, so I replaced the early-return `if` with
`CHECK(data_objects_.contains(uuid));`, which restores the pre-fix assertion.

**Failing test:** `parallel/test-blob-createobjecturl` (not ok, stable across 2 runs):
`Assertion failed: data_objects_.contains(uuid)` (process abort on second `URL.revokeObjectURL(id)`).

# Re-introduced bug: --snapshot-blob crashes on empty/foreign/truncated files

`BlobDeserializer` trusts every length field and `FromBlob()` uses CHECKs, so an empty file
(`ReadFileSync` CHECK_EQ(num_read,1)), a non-snapshot file (`CHECK_EQ(magic, kMagic)`), a zero-length
startup blob (`CHECK_GT`) abort, and truncated blobs are read past the buffer end.

Hunks (all reversions of the fix, adapted to current code):
- src/blob_serializer_deserializer-inl.h: removed the bounds checks in `ReadVector`, `ReadStringView`, `ReadArithmetic` (fix's three hunks there). The `ok` member in the .h was left (unused, harmless).
- src/node_file_utils.cc: removed `if (size == 0) return contents;` in `ReadFileSync`.
- src/node_snapshotable.cc: `ReadV8StartupData` back to `CHECK_GT(raw_size, 0)` with no size bound; `FromBlob` back to `CHECK_EQ(magic, kMagic)`, dropped the "truncated" messages / `r.ok` checks. The missing-space message fix was not reverted (cosmetic).

Failing test: parallel/test-snapshot-invalid-blob ("not ok", stable over 2 runs) — the empty-file
case aborts with a CHECK failure instead of status 14 with "not a Node.js snapshot blob".

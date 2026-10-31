# Rationale

Fix hunk reversed: `Modules/_sqlite/blob.c`, `subscript_slice()`, which added
`if (len == 0) return PyBytes_FromStringAndSize(NULL, 0);`.

In v3.15.2 the early return existed, but it was placed before the negative-step
check. I removed that block, so an empty slice (e.g. `blob[5:-5]` on a 3-byte blob,
where `PySlice_AdjustIndices` gives `len == 0` with `start > stop`) falls through
to `read_multiple(self, len, start)` or the step path. It then trips the
assertion on the length/offset bounds.

Oracle: `BlobTests.test_blob_get_empty_slice_oob_indices` hits the assertion and
aborts the run. Because the process aborts, the remaining BlobTests cases are
reported as incomplete too (200 of 206).

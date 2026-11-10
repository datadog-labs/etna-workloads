# Re-introduced bug: wrong range for sliced `openAsBlob` (file-backed) Blobs

**Bug:** `FdEntry::slice` in `src/dataqueue/queue.cc` mishandled offsets. The end of a slice was treated as relative to the original entry's start (not absolute), and the reader passed the absolute end offset where `FileHandle::New` expects a length. A sliced file-backed Blob therefore read the wrong number of bytes (e.g. `blob.slice(10, 20).arrayBuffer()` returned 10 bytes instead of... mismatching `size`).

## Hunks
1. `FdEntry::slice`: `std::min(end.value() + start_, end_)` -> `std::min(end.value(), end_)`. Corresponds to fix hunk 1 (the fix's old line was `end.value() + start`; today's code uses `start_`, so the reverse was re-expressed). Restores the old end computation.
2. `ReaderImpl::Create`: `FileHandle::New(..., entry->start_, entry->end_ - entry->start_)` -> `entry->end_`. Corresponds to fix hunk 2; the length argument is again the absolute end, so reads are too long.

## Failing test
`parallel/test-blob-file-backed` fails (stable across 3 runs):
`AssertionError [ERR_ASSERTION]: Expected values to be strictly equal: actual: 10, expected: 20` (slice size vs. arrayBuffer byteLength).

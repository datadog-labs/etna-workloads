# Rationale

**Bug:** File-backed Blobs (from `fs.openAsBlob`) were cloneable via structuredClone / postMessage. The underlying FdEntry is bound to the creating Environment/Realm, so transferring across workers fails. The fix made `[kClone]` throw `ERR_INVALID_STATE` for such blobs.

**Changes (lib/internal/blob.js only):**
- Removed the `kNotCloneable` check at the top of `Blob.prototype[kClone]` (fix hunk 2) so file-backed blobs clone again.
- Removed `res[kNotCloneable] = true` in `createBlobFromFilePath` (fix hunk 3), so the flag is never set; it now returns `createBlob(...)` directly.
- Removed the now-unused `kNotCloneable` symbol (fix hunk 1, the symbol declaration). The `ERR_INVALID_STATE` import was left alone, since it is still used elsewhere in the file.

**Failing test:** `parallel/test-blob-file-backed` reports `not ok`. The new assertion expects `structuredClone(blob)` to throw `ERR_INVALID_STATE` with message 'Invalid state: File-backed Blobs are not cloneable'. It no longer throws. The failure was stable across two runs.

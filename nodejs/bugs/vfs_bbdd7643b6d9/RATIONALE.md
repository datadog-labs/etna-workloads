# RATIONALE

Bug: RealFileHandle.readFileSync()/readFile() reopened the original real path
instead of reading the already-open fd, so after the backing file was renamed
(or removed) reading an open VFS fd failed with ENOENT, and the read ignored
the handle's fd/offset semantics.

Changes (lib/internal/vfs/providers/real.js only):
- readFileSync/readFile hunks: replaced the fstat + positioned-read loops with
  `fs.readFileSync(this.#realPath, options)` / `fs.promises.readFile(this.#realPath, options)`
  (reverse of the fix's main hunks).
- Removed helpers `#readFileResult`, `#readFileUnknownSizeResult`, the
  `kReadFileUnknownBufferLength` constant and the `ArrayPrototypePush` import
  (added by the fix, now unused). `Buffer` import is still used elsewhere.
- Added `#realPath` field, a 5th constructor arg `realPath`, and passed it from
  openSync/open (needed so the handle can reopen the path, as pre-fix).

Failing tests: parallel/test-vfs-real-provider-handle fails with
`ENOENT: no such file or directory, open '.../real-handle/rename-read.txt'`
(rename-after-open section). test-vfs-fs-readFileSync also reports not ok in this
sandbox, but only because it mkdirs under /tmp (not writable here), so it is not
a reliable signal.

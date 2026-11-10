# Re-introduced bug: vfs fs.promises.open returns provider handle, not FileHandle

**Bug:** For mounted VFS paths, `fs.promises.open()` resolved with the provider's internal
handle (e.g. `MemoryFileHandle`) rather than a public `FileHandle`, so `handle.constructor.name`
was wrong and `fd`/`createReadStream` etc. were missing.

**Change (lib/internal/vfs/setup.js, 2 hunks):**
- In the `open` promise handler (corresponds to the fix's setup.js `PromiseResolve(createVfsFileHandle(getVirtualFd(fd)))` hunk), restored `const vfd = getVirtualFd(fd); return PromiseResolve(vfd.entry);`, the pre-fix behavior.
- Import hunk: dropped the now-unused `createVfsFileHandle` from the `internal/vfs/fd` import. The fix's fd.js hunks are left in place as dead helpers; they're harmless, and the effective bug is in setup.js.

**Failing test:** `parallel/test-vfs-fs-promises` — `AssertionError: Expected values to be strictly equal: 'MemoryFileHandle' !== 'FileHandle'` (test line 94).

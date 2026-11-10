# Re-introduced bug: fs.writev/writevSync with an empty buffer array

**Bug:** Calling `fs.writev(fd, [], cb)` or `fs.writevSync(fd, [])` passes the empty array to the native `writeBuffers` binding. The underlying `writev(2)` call then fails with `EINVAL`. The expected behaviour is 0 bytes written, with the callback invoked asynchronously as `(null, 0, buffers)`.

**Hunks (both in lib/fs.js, matching the two hunks of the fix):**
1. `writev()`: removed the `if (buffers.length === 0) { process.nextTick(callback, null, 0, buffers); return; }` early return. This corresponds to the fix's first hunk. The surrounding code has changed since the fix (VFS handlers, `validateFunction`), but the guard's position is the same.
2. `writevSync()`: removed the `if (buffers.length === 0) { return 0; }` early return. This corresponds to the fix's second hunk.

**Failing tests:**
- `parallel/test-fs-writev-sync`: `Error: EINVAL: invalid argument, write`
- `parallel/test-fs-writev`: `AssertionError [ERR_ASSERTION]: ifError got unwanted exception: EINVAL: invalid argument, write`

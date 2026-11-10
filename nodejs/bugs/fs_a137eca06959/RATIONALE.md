# Bug
`filehandle.writev([])` (lib/internal/fs/promises.js `writev`) passed an empty array to `binding.writeBuffers`, which fails with `EINVAL: invalid argument, write` instead of resolving with `{ bytesWritten: 0, buffers: [] }`.

# Change
One hunk in `lib/internal/fs/promises.js`, function `writev`: removed the `if (buffers.length === 0) return { __proto__: null, bytesWritten: 0, buffers };` early return. This is the reverse of the fix's only implementation hunk (re-expressed for today's code, which has `__proto__: null` and `handleErrorFromBinding`). Without it the empty array reaches the binding and errors.

# Failing test
`parallel/test-fs-writev-promises`: `not ok` with `Error: EINVAL: invalid argument, write` (stable across 2 runs).

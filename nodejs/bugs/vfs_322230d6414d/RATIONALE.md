# Rationale

## Bug
`fs.writeFileSync(fd, ...)` and `fs.appendFileSync(fd, ...)` with a VFS-owned virtual fd were not
routed through the virtual file handle. The VFS handlers treated the first argument only as a path,
so a numeric fd fell through to the native fs binding, which does not know the virtual fd and fails
with `EBADF`.

## Change (lib/internal/vfs/setup.js)
- Removed the `isArrayBufferView` import, `toWriteBuffer()` and `writeFileSyncFd()`. They correspond to the
  fix hunks that added these helpers.
- `writeFileSync` / `appendFileSync` handlers are back to the path-only arrow forms
  (`vfsOpVoid(path, ...)`). This corresponds to the fix hunk that added the `typeof path === 'number'`
  fd dispatch. Without it the fd is not handled by VFS.

## Failing test
`parallel/test-vfs-fs-writeFileSync` fails (stable over 2 runs):
`Error: EBADF: bad file descriptor, write`

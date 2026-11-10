# Re-introduced bug (CVE-2025-55130): symlink APIs only blocked relative targets

Bug: with the permission model enabled, fs.symlink/symlinkSync/promises.symlink were
allowed with partial fs permissions as long as the target was absolute. Symlink edge
cases could then bypass the read/write restrictions. The fix requires full
fs.read + fs.write (`permission.has('fs')`).

Hunks (each is the reverse of a fix hunk, adapted to current code, audit mode check kept):
- lib/fs.js `symlink` (fix hunk 2): replaced the `!permission.has('fs')` check with the old
  relative-target check (callback with ERR_ACCESS_DENIED 'relative symbolic link target').
- lib/fs.js `symlinkSync` (fix hunk 3): same, throwing.
- lib/internal/fs/promises.js `symlink` (promises hunk): same, throwing; re-added the
  `toPathIfFileURL` import from internal/url (uses `pathModule.isAbsolute`, and the
  already present BufferIsBuffer/BufferToString).

Failing tests:
- parallel/test-permission-fs-symlink-relative: expected message /symlink API requires full
  fs.read and fs.write permissions/, got 'relative symbolic link target' (and absolute targets are allowed).
- parallel/test-permission-fs-symlink: expected 'fs.symlink API requires full fs.read and
  fs.write permissions.', got 'Access to this API has been restricted. Use --allow-fs-write ...'.

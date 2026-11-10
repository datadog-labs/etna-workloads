# Re-introduced bug: vfs lchmod follows symlinks

**Bug:** `fsp.lchmod()` on a VFS mounted filesystem called the provider's following `chmodSync`, so it changed the mode of the symlink target instead of the symlink itself.

**Change:** `lib/internal/vfs/file_system.js`, promises `lchmod`: `provider.lchmodSync(providerPath, mode)` -> `provider.chmodSync(providerPath, mode)`. This corresponds to the fix's file_system.js hunk. The fix's provider hunks (memory.js, real.js) add `lchmodSync`. In this release those already exist, so they were left in place. They are just no longer called from this path.

**Failing test:** `parallel/test-vfs-fs-promises` fails (`not ok`, stable across 2 runs). The assertion that `lstat(src/hello.txt).mode & 0o777` is 0o644 fails with `actual: 448 (0o700), expected: 420 (0o644)`, because the target was chmod'ed.

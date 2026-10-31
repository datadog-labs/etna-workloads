# Rationale

Fix (gh-91133) made TemporaryDirectory cleanup stop following symlinks when
resetting mode bits/flags (`_dont_follow_symlinks`, `_resetperms`). In v3.15.2
that logic was rewritten, so the old behaviour is restored in Lib/tempfile.py:

- `_dont_follow_symlinks()`: now calls `func(path, *args)` unconditionally (the
  pre-fix `_os.chflags(path, 0)` / `_os.chmod(path, 0o700)` calls, which follow
  symlinks). This reverses the fix's added helper and covers chflags and the
  non-dir_fd fallback.
- `_resetperms_at()`: the dir_fd-based path (used on Linux) is the same defect,
  covering the case a second time; it now does `_os.chmod(name, 0o700,
  dir_fd=dir_fd)` without `follow_symlinks=False`/O_NOFOLLOW/lstat handling.

Oracle: `test_cleanup_with_symlink_modes` fails (subtests 'existing file' and
'existing dir'): the symlink target's mode is changed to 0o700 during cleanup
(e.g. `100700 != 100600`). Other failures/errors in the run are consequences of
the same change (other symlink cleanup tests).

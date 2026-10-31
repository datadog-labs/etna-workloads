# Rationale

Fix hunk: `fd_and_follow_symlinks_invalid` in Modules/posixmodule.c changed `(fd > 0)` to `(fd >= 0)`.

In v3.15.2 the helper takes `path->is_fd` (a bool), so reversing the hunk does not apply. I restored the old form:
the helper takes `int fd` again and tests `(fd > 0) && !follow_symlinks`. All eight callers (stat, statx, chown,
utime, getxattr, setxattr, removexattr, listxattr) now pass `path->fd` instead of `path->is_fd`.
With fd 0 the check is skipped, so `posix.stat(0, follow_symlinks=False)` no longer raises ValueError.

Oracle: `test_stat_fd_zero_follow_symlinks` in test_os.test_posix fails (1 failure).
